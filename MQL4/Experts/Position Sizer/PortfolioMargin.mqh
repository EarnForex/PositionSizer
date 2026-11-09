//+------------------------------------------------------------------+
//|                                              PortfolioMargin.mqh |
//|                                  Copyright © 2026, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
// Portfolio margin calculation. Requires PortfolioRisk.mqh.
// For each symbol, the open positions and the pending orders (with their SL/TP) are simulated along all possible price paths the same way
// the portfolio risk is: a pending order is executed when the price reaches it, an SL/TP closes its position. The margin used by the open
// positions is evaluated at every point of every path, and the maximum is the margin the symbol's trades can require. Hedged positions use
// the hedged margin, so an opposite order can lower it.
// Unlike the risk, the margin has no unlimited case: beyond the last order the positions do not change, so neither does the margin.
// Known issues:
// 1. The margin per lot is taken at the current price (MODE_MARGINREQUIRED) and assumed constant along the price paths.
// 2. Same as the portfolio risk: too many pending orders with SL/TP on one symbol may be too slow to process (PR_MAX_ITERATIONS).

//+------------------------------------------------------------------+
//| Structure PM_SymbolContext.                                      |
//| Purpose: Symbol data used by the margin iterator.                |
//+------------------------------------------------------------------+
struct PM_SymbolContext
{
    double margin1lot;         // Margin per lot in the account currency (the broker's).
    double margin1lot_planned; // Margin per lot of the planned trade (at the custom leverage, if set).
    double hedged_ratio;       // Hedged margin per lot relative to the normal one.
};
PM_SymbolContext PM_Ctx;

//+------------------------------------------------------------------+
//| Class CMarginIterator                                            |
//| Purpose: The portfolio risk's path walk (COrderIterator) with the|
//|          used margin evaluated at every node instead of profit.  |
//+------------------------------------------------------------------+
class CMarginIterator : public COrderIterator
{
public:
    static double    max_margin; // Same value across all instances. The maximum margin found so far.

                     CMarginIterator(COrderMap &input_Status, COrderMap &input_RO, double input_current_price, PR_MODE input_mode): COrderIterator(input_Status, input_RO, input_current_price, 0, 0, input_mode) {}
                     CMarginIterator(void): COrderIterator() {}

    virtual COrderIterator *NewChild();
    virtual void     Evaluate();
    // Beyond the last order the positions do not change, so the margin has already been recorded.
    virtual void     CalculateMaxUp() {}
    virtual void     CalculateMaxDown() {}
    double           StatusMargin();
};

double CMarginIterator::max_margin = 0;

// Creates the iterator for a recursion branch with the current state.
COrderIterator *CMarginIterator::NewChild()
{
    return new CMarginIterator(Status, RO, current_price, mode);
}

// Records the margin of the current open positions. The profit is kept up to date too - CheckPairedOrders() decides by it which of the paired
// exits to walk (either is fine for the margin: the positions are the same after either exit).
void CMarginIterator::Evaluate()
{
    CalculateUnrealizedProfit();
    double margin = StatusMargin();
    if (margin > max_margin) max_margin = margin;
}

// Margin used by the open positions (Status), in the account currency. MT4 rules: with the hedged margin below the normal one, the hedged part
// of the volume (the smaller of the buy and sell volumes) is charged at the hedged rate and only the rest at the normal rate.
// The planned trade's orders (negative tickets) have their own margin per lot (custom leverage); their share of the volume is charged at it.
double CMarginIterator::StatusMargin()
{
    double buy_volume = 0, sell_volume = 0, planned_volume = 0;
    for (CStatusObject *Status_order = Status.GetFirstNode(); Status_order != NULL; Status_order = Status.GetNextNode())
    {
        if (Status_order.Type() == PR_Buy) buy_volume += Status_order.Vol();
        else sell_volume += Status_order.Vol();
        if (Status_order.Ticket() < 0) planned_volume += Status_order.Vol();
    }
    double volume = buy_volume + sell_volume;
    if (volume <= 0) return 0;

    double lots; // Lots charged with margin after the hedging discount.
    if (NormalizeDouble(PM_Ctx.hedged_ratio, 2) < 1.00) lots = MathAbs(buy_volume - sell_volume) + MathMin(buy_volume, sell_volume) * PM_Ctx.hedged_ratio; // Hedging on partial or no margin.
    else lots = volume; // Hedged trades use full amount of margin.

    double margin1lot = PM_Ctx.margin1lot;
    if (planned_volume > 0) margin1lot = (PM_Ctx.margin1lot * (volume - planned_volume) + PM_Ctx.margin1lot_planned * planned_volume) / volume;
    return lots * margin1lot;
}

//+------------------------------------------------------------------+
//| Feeding the Position Sizer's orders in.                          |
//+------------------------------------------------------------------+

// Checks whether the currently selected order should be included: the Risk tab's filters except the "ignore orders without SL/TP" ones.
bool PM_OrderIncluded(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab)
{
    return PR_OrderIncluded(calculate_risk_for_trading_tab, false);
}

// Margin per lot of the planned trade. The custom leverage, if given, replaces the broker's one - same as in CalculateMargin().
double PM_PlannedMargin1Lot()
{
    double margin1lot = MarketInfo(Symbol(), MODE_MARGINREQUIRED);
    if ((CustomLeverage > 0) && (TickSize > 0))
    {
        double symbol_cost_1_lot;
        if (sets.EntryType == Pending) symbol_cost_1_lot = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * sets.EntryLevel / TickSize;
        else symbol_cost_1_lot = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE) * SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize;
        margin1lot = symbol_cost_1_lot / CustomLeverage;
    }
    return margin1lot;
}

// Prepares the symbol context for the margin iterator (and the risk one's, which the path walk needs). Returns false if the symbol's data cannot be retrieved.
bool PM_PrepareSymbol(const string cp)
{
    if (!PR_PrepareSymbol(cp, PR_Risk)) return false;
    PM_Ctx.margin1lot = MarketInfo(cp, MODE_MARGINREQUIRED);
    PM_Ctx.margin1lot_planned = PM_Ctx.margin1lot;
    if (cp == Symbol()) PM_Ctx.margin1lot_planned = PM_PlannedMargin1Lot();
    double contract_size = MarketInfo(cp, MODE_LOTSIZE);
    if (contract_size > 0) PM_Ctx.hedged_ratio = MarketInfo(cp, MODE_MARGINHEDGED) / contract_size;
    else PM_Ctx.hedged_ratio = 1; // Hedged trades use full amount of margin.
    return true;
}

// Fallback for a symbol whose order set is too entangled for the exact simulation: the margin of all the included positions and orders
// as if all of them were open at once, without the hedging discount - an upper bound of the exact value.
double PM_SimpleSymbol(const string cp, const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const bool include_planned)
{
    double result = 0;
    int total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (!OrderSelect(i, SELECT_BY_POS)) continue;
        if (OrderSymbol() != cp) continue;
        if (!PM_OrderIncluded(calculate_risk_for_trading_tab)) continue;
        result += OrderLots() * PM_Ctx.margin1lot;
    }
    if (include_planned)
    {
        for (int j = 0; j < PR_PlannedTotal; j++)
            result += PR_Planned[j].volume * PM_Ctx.margin1lot_planned;
    }
    return result;
}

// Runs the simulation for one symbol. Returns the maximum margin its included orders can require, in the account currency,
// or 0 if there are no included orders on the symbol.
// include_planned - add the planned trade (PR_Planned[]) to the symbol's orders. Only makes sense for the chart's symbol.
double PM_ProcessSymbol(const string cp, const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const bool include_planned)
{
    if (!PM_PrepareSymbol(cp)) return 0;

    COrderIterator::min_profit = PR_UNDEFINED;
    COrderIterator::iterations = 0;
    COrderIterator::overflow = false;
    CMarginIterator::max_margin = 0;
    CMarginIterator *OrderIterator = new CMarginIterator();
    OrderIterator.mode = PR_Risk;
    int included = 0;
    string key = "M|" + cp + "|"; // Identifies the order set in the overflow memory (shared with the risk calculation).

    int total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (!OrderSelect(i, SELECT_BY_POS)) continue;
        if (OrderSymbol() != cp) continue;
        if (!PM_OrderIncluded(calculate_risk_for_trading_tab)) continue;
        included++;

        double volume = OrderLots();
        double sl = OrderStopLoss();
        double tp = OrderTakeProfit();
        key += IntegerToString(OrderTicket()) + ":" + DoubleToString(OrderOpenPrice(), 8) + ":" + DoubleToString(sl, 8) + ":" + DoubleToString(tp, 8) + ":" + DoubleToString(volume, 8) + ";";

        bool is_position = ((OrderType() == ORDER_TYPE_BUY) || (OrderType() == ORDER_TYPE_SELL));
        bool is_buy = ((OrderType() == ORDER_TYPE_BUY) || (OrderType() == ORDER_TYPE_BUY_LIMIT) || (OrderType() == ORDER_TYPE_BUY_STOP));
        PR_AddOrder(OrderIterator, OrderTicket(), is_position, is_buy ? PR_Buy : PR_Sell, OrderOpenPrice(), volume, sl, tp);
    }

    if (include_planned)
    {
        // Negative tickets tell the planned orders from the real ones.
        for (int j = 0; j < PR_PlannedTotal; j++)
            PR_AddOrder(OrderIterator, -(j + 1), PR_Planned[j].is_position, PR_Planned[j].type, PR_Planned[j].price, PR_Planned[j].volume, PR_Planned[j].sl, PR_Planned[j].tp);
        included += PR_PlannedTotal;
        key += PR_PlannedKey;
    }

    if (included == 0)
    {
        delete OrderIterator;
        return 0;
    }

    // This order set is already known to exceed PR_MAX_ITERATIONS.
    if (PR_IsKnownOverflow(key))
    {
        delete OrderIterator;
        return PM_SimpleSymbol(cp, calculate_risk_for_trading_tab, include_planned);
    }

    OrderIterator.current_price = MarketInfo(cp, MODE_BID);
    OrderIterator.Iterate(PR_UNDEFINED);
    delete OrderIterator;

    if (COrderIterator::overflow)
    {
        PR_RememberOverflow(key);
        Print(__FUNCTION__, ": ", cp, " - too many order combinations for the exact margin calculation (more than ", PR_MAX_ITERATIONS, " price paths). Using the simple sum until the orders change.");
        return PM_SimpleSymbol(cp, calculate_risk_for_trading_tab, include_planned);
    }
    return CMarginIterator::max_margin;
}

// Calculates the portfolio margin over all included orders. Outputs the maximum margin in the account currency that the current orders
// can require (margin_money) and that the current orders together with the planned trade can require (potential_margin_money).
void PM_CalculatePortfolio(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, double &margin_money, double &potential_margin_money)
{
    string symbols[];

    int total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (!OrderSelect(i, SELECT_BY_POS)) continue;
        if (!PM_OrderIncluded(calculate_risk_for_trading_tab)) continue;
        // Add the symbol to the list if it is new.
        int n = ArraySize(symbols);
        bool found = false;
        for (int j = 0; j < n; j++)
        {
            if (symbols[j] == OrderSymbol())
            {
                found = true;
                break;
            }
        }
        if (!found)
        {
            ArrayResize(symbols, n + 1, 10);
            symbols[n] = OrderSymbol();
        }
    }

    double planned_volume = PR_BuildPlannedTrade();

    // Symbols are treated as independent, so their worst cases add up. The chart's symbol is kept apart because the planned trade is added to it.
    double others_margin = 0, chart_margin = 0;
    int symbols_total = ArraySize(symbols);
    for (int i = 0; i < symbols_total; i++)
    {
        double margin = PM_ProcessSymbol(symbols[i], calculate_risk_for_trading_tab, false);
        if (symbols[i] == Symbol()) chart_margin = margin;
        else others_margin += margin;
    }
    margin_money = others_margin + chart_margin;

    if (planned_volume > 0) potential_margin_money = others_margin + PM_ProcessSymbol(Symbol(), calculate_risk_for_trading_tab, true);
    else potential_margin_money = margin_money;
}

// Potential margin of the chart's symbol with the planned trade at the current ArrayPositionSize[], in the account currency.
// The only part of the portfolio that depends on the planned volume - see PM_FindMaxVolume().
double PM_ChartPotentialMargin(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab)
{
    double planned_volume = PR_BuildPlannedTrade();
    return PM_ProcessSymbol(Symbol(), calculate_risk_for_trading_tab, planned_volume > 0);
}

// Finds the largest position size, a multiple of the lot step not above max_volume, whose potential portfolio margin doesn't exceed limit_money.
// Used by the Trading tab's margin fuses when LessRestrictiveMaxLimits is on. current_margin_money - the current portfolio margin (has to be
// within the limit, which the caller checks). Only the chart's symbol is re-simulated for each probed size; the rest of the portfolio
// is taken from current_margin_money once.
// The potential margin is a convex function of the planned volume (hedging can lower it at first, then it grows), so it crosses the limit
// only once and a bisection finds the boundary. Fills ArrayPositionSize[] for the returned size. Returns 0 if no size fits.
double PM_FindMaxVolume(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const double limit_money, const double max_volume, const double current_margin_money)
{
    if (LotStep <= 0) return 0;
    double base = current_margin_money - PM_ProcessSymbol(Symbol(), calculate_risk_for_trading_tab, false); // The other symbols.
    int lo = 0; // Fits.
    int hi = (int)MathRound(max_volume / LotStep); // Doesn't fit.
    while (hi - lo > 1)
    {
        int mid = (lo + hi) / 2;
        PositionSizeToArray(NormalizeDouble(mid * LotStep, LotStep_digits)); // Re-fills ArrayPositionSize[], which the planned trade is built from.
        if (base + PM_ChartPotentialMargin(calculate_risk_for_trading_tab) <= limit_money) lo = mid;
        else hi = mid;
    }
    double result = NormalizeDouble(lo * LotStep, LotStep_digits);
    PositionSizeToArray(result);
    return result;
}
//+------------------------------------------------------------------+