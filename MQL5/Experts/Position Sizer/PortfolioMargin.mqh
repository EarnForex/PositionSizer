//+------------------------------------------------------------------+
//|                                              PortfolioMargin.mqh |
//|                                  Copyright © 2026, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
// Portfolio margin calculation. Requires PortfolioRisk.mqh.
// For each symbol, the open positions and the pending orders (with their SL/TP) are simulated along all possible price paths the same way
// the portfolio risk is: a pending order is executed when the price reaches it, an SL/TP closes its position. The margin used by the open
// positions and reserved by the remaining pending orders is evaluated at every point of every path, and the maximum is the margin the
// symbol's trades can require.
// MT5 margin rules (see the terminal's help, "Margin calculation"):
// - Open positions are charged the maintenance margin at their open price (price-based symbols) or at the current rate (Forex).
// - Pending orders reserve margin by their own rates (limit, stop, stop-limit) - zero at many brokers.
// - Netting: the buy side (position + buy limit orders) and the sell side are charged the larger of the two; stop and stop-limit orders
//   are charged on top of that.
// - Hedging: the covered volume (the smaller leg) is charged the hedged margin, the uncovered volume - the full margin of the larger leg,
//   pending orders on top; or, with the "use larger leg" setting, the larger of the buy leg and the sell leg (positions and orders).
// Unlike the risk, the margin has no unlimited case: beyond the last order the positions do not change, so neither does the margin.
// Known issues:
// 1. The margin per lot is taken from OrderCalcMargin() at the current prices and is assumed constant along the price paths - the
//    conversion to the account currency does not follow the price.
// 2. Same as the portfolio risk: too many pending orders with SL/TP on one symbol may be too slow to process (PR_MAX_ITERATIONS).

//+------------------------------------------------------------------+
//| Structure PM_SymbolContext.                                      |
//| Purpose: Symbol data used by the margin iterator.                |
//+------------------------------------------------------------------+
struct PM_SymbolContext
{
    bool   netting;          // One position per symbol; opposite orders net.
    bool   use_leg;          // Hedging: the margin is the larger of the buy and the sell legs (SYMBOL_MARGIN_HEDGED_USE_LEG).
    double hedged_ratio;     // Hedging: the hedged margin per lot relative to the normal one.
    bool   price_based;      // The margin grows with the price (CFDs, stocks...): positions are charged at their open prices, orders at their prices.
    double ref_price_buy;    // The prices the per-lot margins are taken at (Ask for buys, Bid for sells).
    double ref_price_sell;
    double position_buy;     // Margin per lot of an open position (maintenance), in the account currency.
    double position_sell;
    double limit_buy;        // Margin per lot reserved by a pending order of each type (initial), in the account currency.
    double limit_sell;
    double stop_buy;
    double stop_sell;
    double stop_limit_buy;
    double stop_limit_sell;
    double custom_factor;    // The planned trade's margin relative to the broker's one (custom leverage). 1 = no custom leverage.
    // The planned trade's volume in the simulation (0 - not included) and direction. In netting mode, the position has no tickets, so the
    // planned trade's part of it is found by the planned orders that have executed.
    double planned_volume;
    PR_ORDER_TYPE planned_type;
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

                     CMarginIterator(CStatusObject *input_Status, COrderMap &input_RO, double input_current_price, PR_MODE input_mode): COrderIterator(input_Status, input_RO, input_current_price, 0, 0, input_mode) {}
                     CMarginIterator(COrderMap *input_Status, COrderMap &input_RO, double input_current_price, PR_MODE input_mode): COrderIterator(input_Status, input_RO, input_current_price, 0, 0, input_mode) {}
                     CMarginIterator(void): COrderIterator() {}

    virtual COrderIterator *NewChild();
    virtual void     Evaluate();
    // Beyond the last order the positions do not change, so the margin has already been recorded.
    virtual void     CalculateMaxUp() {}
    virtual void     CalculateMaxDown() {}
    double           StatusMargin();
    double           LegMargin(const PR_ORDER_TYPE type, const double volume, const double price, const double planned_volume);
    double           OrderMargin(CRemainingOrderObject &RO_order);
};

double CMarginIterator::max_margin = 0;

// Creates the iterator for a recursion branch with the current state.
COrderIterator *CMarginIterator::NewChild()
{
    if (!hedging) return new CMarginIterator(Status, RO, current_price, mode);
    return new CMarginIterator(StatusHedging, RO, current_price, mode);
}

// Records the margin of the current state. The profit is kept up to date too - CheckPairedOrders() decides by it which of the paired
// exits to walk (either is fine for the margin: the positions and orders are the same after either exit).
void CMarginIterator::Evaluate()
{
    CalculateUnrealizedProfit();
    double margin = StatusMargin();
    if (margin > max_margin) max_margin = margin;
}

// Price factor of the per-lot margin for price-based symbols.
double PM_PriceFactor(const PR_ORDER_TYPE type, const double price)
{
    if (!PM_Ctx.price_based) return 1;
    double ref_price = (type == PR_Buy) ? PM_Ctx.ref_price_buy : PM_Ctx.ref_price_sell;
    if ((ref_price <= 0) || (price <= 0)) return 1;
    return price / ref_price;
}

// Margin of open positions of one direction: volume lots at the volume-weighted open price. planned_volume - the part of it that belongs
// to the planned trade (charged at the custom factor).
double CMarginIterator::LegMargin(const PR_ORDER_TYPE type, const double volume, const double price, const double planned_volume)
{
    if (volume <= 0) return 0;
    double margin1lot = (type == PR_Buy) ? PM_Ctx.position_buy : PM_Ctx.position_sell;
    return margin1lot * PM_PriceFactor(type, price) * ((volume - planned_volume) + planned_volume * PM_Ctx.custom_factor);
}

// Margin reserved by a pending order (a pending, a stop-limit, or an activated limit order) by its kind, at its own price.
double CMarginIterator::OrderMargin(CRemainingOrderObject &RO_order)
{
    double margin1lot;
    if (RO_order.Type() == PR_Buy)
    {
        if (RO_order.Kind() == PR_KIND_LIMIT) margin1lot = PM_Ctx.limit_buy;
        else if (RO_order.Kind() == PR_KIND_STOP) margin1lot = PM_Ctx.stop_buy;
        else margin1lot = PM_Ctx.stop_limit_buy;
    }
    else
    {
        if (RO_order.Kind() == PR_KIND_LIMIT) margin1lot = PM_Ctx.limit_sell;
        else if (RO_order.Kind() == PR_KIND_STOP) margin1lot = PM_Ctx.stop_sell;
        else margin1lot = PM_Ctx.stop_limit_sell;
    }
    double margin = margin1lot * PM_PriceFactor(RO_order.Type(), OpenPrice(RO_order)) * RO_order.Vol(); // The order's own price: a Buy's is kept one spread below.
    if (RO_order.Ticket() >= PR_PLANNED_TICKET) margin *= PM_Ctx.custom_factor; // The planned trade's order.
    return margin;
}

// Margin of the current state - the open positions and the remaining pending orders - in the account currency, by the MT5 rules.
double CMarginIterator::StatusMargin()
{
    // The remaining pending orders: by direction, the limit orders apart (netting nets them against the position, stops are charged anyway).
    double buy_orders = 0, sell_orders = 0, buy_limits = 0, sell_limits = 0, stops = 0, planned_remaining = 0;
    for (CRemainingOrderObject *RO_order = RO.GetFirstNode(); RO_order != NULL; RO_order = RO.GetNextNode())
    {
        if ((RO_order.Status() != PR_Pending) && (RO_order.Status() != PR_StopLimit)) continue; // SL/TP levels and not yet placed limit orders reserve nothing.
        if (RO_order.Ticket() >= PR_PLANNED_TICKET) planned_remaining += RO_order.Vol();
        double margin = OrderMargin(RO_order);
        if (RO_order.Type() == PR_Buy) buy_orders += margin;
        else sell_orders += margin;
        if (RO_order.Kind() == PR_KIND_LIMIT)
        {
            if (RO_order.Type() == PR_Buy) buy_limits += margin;
            else sell_limits += margin;
        }
        else stops += margin;
    }

    // Open positions: the volumes, the volume-weighted open prices, and the planned trade's part of them.
    double buy_volume = 0, sell_volume = 0, buy_price_volume = 0, sell_price_volume = 0, planned_buy = 0, planned_sell = 0;
    if (!hedging)
    {
        if (CheckPointer(Status) != POINTER_INVALID)
        {
            // The planned orders that have executed have merged into the position (if it goes their way): that part is charged at the custom leverage.
            double planned_executed = MathMax(PM_Ctx.planned_volume - planned_remaining, 0);
            if (Status.Type() != PM_Ctx.planned_type) planned_executed = 0;
            planned_executed = MathMin(planned_executed, Status.Vol());
            if (Status.Type() == PR_Buy)
            {
                buy_volume = Status.Vol();
                buy_price_volume = Status.Vol() * Status.Price();
                planned_buy = planned_executed;
            }
            else
            {
                sell_volume = Status.Vol();
                sell_price_volume = Status.Vol() * Status.Price();
                planned_sell = planned_executed;
            }
        }
    }
    else
    {
        for (CStatusObject *Status_order = StatusHedging.GetFirstNode(); Status_order != NULL; Status_order = StatusHedging.GetNextNode())
        {
            if (Status_order.Type() == PR_Buy)
            {
                buy_volume += Status_order.Vol();
                buy_price_volume += Status_order.Vol() * Status_order.Price();
                if (Status_order.Ticket() >= PR_PLANNED_TICKET) planned_buy += Status_order.Vol();
            }
            else
            {
                sell_volume += Status_order.Vol();
                sell_price_volume += Status_order.Vol() * Status_order.Price();
                if (Status_order.Ticket() >= PR_PLANNED_TICKET) planned_sell += Status_order.Vol();
            }
        }
    }
    double buy_price = (buy_volume > 0) ? buy_price_volume / buy_volume : 0;
    double sell_price = (sell_volume > 0) ? sell_price_volume / sell_volume : 0;
    double buy_margin = LegMargin(PR_Buy, buy_volume, buy_price, planned_buy);
    double sell_margin = LegMargin(PR_Sell, sell_volume, sell_price, planned_sell);

    if (PM_Ctx.netting) return MathMax(buy_margin + buy_limits, sell_margin + sell_limits) + stops;

    // Hedging.
    if (PM_Ctx.use_leg) return MathMax(buy_margin + buy_orders, sell_margin + sell_orders);
    // The covered volume at the hedged margin (the average of the buy and the sell rates, at the average price of all the positions),
    // the uncovered volume at the larger leg's margin, the orders on top.
    double covered = MathMin(buy_volume, sell_volume);
    double covered_margin = 0, uncovered_margin = 0;
    if (covered > 0)
    {
        double total_volume = buy_volume + sell_volume;
        double hedged1lot = PM_Ctx.hedged_ratio * (PM_Ctx.position_buy + PM_Ctx.position_sell) / 2;
        double price_factor = 1;
        if (PM_Ctx.price_based)
        {
            double ref_price = (PM_Ctx.ref_price_buy + PM_Ctx.ref_price_sell) / 2;
            double avg_price = (buy_price_volume + sell_price_volume) / total_volume;
            if ((ref_price > 0) && (avg_price > 0)) price_factor = avg_price / ref_price;
        }
        double planned_share = (planned_buy + planned_sell) / total_volume; // The planned trade's part of the positions is at the custom leverage.
        covered_margin = covered * hedged1lot * price_factor * (1 + planned_share * (PM_Ctx.custom_factor - 1));
    }
    if (buy_volume > sell_volume) uncovered_margin = buy_margin * (buy_volume - covered) / buy_volume;
    else if (sell_volume > buy_volume) uncovered_margin = sell_margin * (sell_volume - covered) / sell_volume;
    return covered_margin + uncovered_margin + buy_orders + sell_orders;
}

//+------------------------------------------------------------------+
//| Feeding the Position Sizer's positions and orders in.            |
//+------------------------------------------------------------------+

// Margin per lot of an order of the given type at the given price, in the account currency, by the broker's rules. 0 if it cannot be calculated.
string PM_WarnedSymbol = ""; // To warn about a failed calculation only once per symbol.
double PM_Margin1Lot(const string cp, const ENUM_ORDER_TYPE type, const double price)
{
    double margin = 0;
    if (!OrderCalcMargin(type, cp, 1.0, price, margin))
    {
        if (PM_WarnedSymbol != cp)
        {
            Print(__FUNCTION__, ": OrderCalcMargin() failed for ", cp, ". Error: ", GetLastError(), ".");
            PM_WarnedSymbol = cp;
        }
        return 0;
    }
    return margin;
}

// Prepares the symbol context for the margin iterator (and the risk one's, which the path walk needs). Returns false if the symbol's data cannot be retrieved.
bool PM_PrepareSymbol(const string cp)
{
    if (!PR_PrepareSymbol(cp, PR_Risk)) return false;
    PM_Ctx.netting = !PR_IsHedging();
    PM_Ctx.use_leg = (bool)SymbolInfoInteger(cp, SYMBOL_MARGIN_HEDGED_USE_LEG);
    PM_Ctx.ref_price_buy = SymbolInfoDouble(cp, SYMBOL_ASK);
    PM_Ctx.ref_price_sell = SymbolInfoDouble(cp, SYMBOL_BID);
    PM_Ctx.planned_volume = 0;
    PM_Ctx.planned_type = PR_Buy;

    // The broker's margin per lot for each kind of trade - OrderCalcMargin() applies the symbol's margin rates, the leverage, and the conversion to the account currency.
    double initial_buy = PM_Margin1Lot(cp, ORDER_TYPE_BUY, PM_Ctx.ref_price_buy);
    double initial_sell = PM_Margin1Lot(cp, ORDER_TYPE_SELL, PM_Ctx.ref_price_sell);
    PM_Ctx.limit_buy = PM_Margin1Lot(cp, ORDER_TYPE_BUY_LIMIT, PM_Ctx.ref_price_buy);
    PM_Ctx.limit_sell = PM_Margin1Lot(cp, ORDER_TYPE_SELL_LIMIT, PM_Ctx.ref_price_sell);
    PM_Ctx.stop_buy = PM_Margin1Lot(cp, ORDER_TYPE_BUY_STOP, PM_Ctx.ref_price_buy);
    PM_Ctx.stop_sell = PM_Margin1Lot(cp, ORDER_TYPE_SELL_STOP, PM_Ctx.ref_price_sell);
    PM_Ctx.stop_limit_buy = PM_Margin1Lot(cp, ORDER_TYPE_BUY_STOP_LIMIT, PM_Ctx.ref_price_buy);
    PM_Ctx.stop_limit_sell = PM_Margin1Lot(cp, ORDER_TYPE_SELL_STOP_LIMIT, PM_Ctx.ref_price_sell);

    // Price-based margin (CFDs, stocks...) grows with the price; a doubled price doubles the margin.
    PM_Ctx.price_based = false;
    if ((initial_buy > 0) && (PM_Ctx.ref_price_buy > 0)) PM_Ctx.price_based = (PM_Margin1Lot(cp, ORDER_TYPE_BUY, 2 * PM_Ctx.ref_price_buy) > 1.5 * initial_buy);

    // Open positions are held at the maintenance margin, which can be lower than the initial one OrderCalcMargin() gives.
    double initial_rate = 0, maintenance_rate = 0;
    double maintenance_factor_buy = 1, maintenance_factor_sell = 1;
    if ((SymbolInfoMarginRate(cp, ORDER_TYPE_BUY, initial_rate, maintenance_rate)) && (initial_rate > 0) && (maintenance_rate > 0)) maintenance_factor_buy = maintenance_rate / initial_rate;
    if ((SymbolInfoMarginRate(cp, ORDER_TYPE_SELL, initial_rate, maintenance_rate)) && (initial_rate > 0) && (maintenance_rate > 0)) maintenance_factor_sell = maintenance_rate / initial_rate;
    double initial_money = SymbolInfoDouble(cp, SYMBOL_MARGIN_INITIAL); // Fixed margin per lot, if set.
    double maintenance_money = SymbolInfoDouble(cp, SYMBOL_MARGIN_MAINTENANCE);
    if ((initial_money > 0) && (maintenance_money > 0))
    {
        maintenance_factor_buy *= maintenance_money / initial_money;
        maintenance_factor_sell *= maintenance_money / initial_money;
    }
    PM_Ctx.position_buy = initial_buy * maintenance_factor_buy;
    PM_Ctx.position_sell = initial_sell * maintenance_factor_sell;

    // The hedged margin relative to the normal one: given as money per lot when the margin is fixed, as a contract size otherwise.
    double hedged_base = SymbolInfoDouble(cp, SYMBOL_TRADE_CONTRACT_SIZE);
    if (initial_money > 0) hedged_base = (maintenance_money > 0) ? maintenance_money : initial_money;
    if (hedged_base > 0) PM_Ctx.hedged_ratio = SymbolInfoDouble(cp, SYMBOL_MARGIN_HEDGED) / hedged_base;
    else PM_Ctx.hedged_ratio = 1; // Hedged trades use full amount of margin.

    // The custom leverage, if given, replaces the broker's one for the planned trade - same as in CalculateMargin().
    PM_Ctx.custom_factor = 1;
    if ((cp == SymbolForTrading) && (CustomLeverage > 0))
    {
        double leverage = 1;
        if ((CalcMode == SYMBOL_CALC_MODE_FOREX) || (CalcMode == SYMBOL_CALC_MODE_CFDLEVERAGE)) leverage = (double)AccountInfoInteger(ACCOUNT_LEVERAGE);
        else if ((CalcMode == SYMBOL_CALC_MODE_CFDINDEX) && (TickValue > 0)) leverage = TickSize / TickValue;
        if (leverage > 0) PM_Ctx.custom_factor = leverage / CustomLeverage;
    }
    return true;
}

// Fallback for a symbol whose order set is too entangled for the exact simulation: every included position and order charged as a position,
// without the hedging discount and the netting of the sides - an upper bound of the exact value.
double PM_SimpleSymbol(const string cp, const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const bool include_planned)
{
    double result = 0;
    int total = PositionsTotal();
    for (int i = 0; i < total; i++)
    {
        if (PositionGetTicket(i) == 0) continue;
        if (PositionGetString(POSITION_SYMBOL) != cp) continue;
        if (!PR_PositionIncluded(calculate_risk_for_trading_tab, false)) continue;
        PR_ORDER_TYPE type = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? PR_Buy : PR_Sell;
        result += PositionGetDouble(POSITION_VOLUME) * ((type == PR_Buy) ? PM_Ctx.position_buy : PM_Ctx.position_sell) * PM_PriceFactor(type, PositionGetDouble(POSITION_PRICE_OPEN));
    }
    total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (OrderGetTicket(i) == 0) continue;
        if (OrderGetString(ORDER_SYMBOL) != cp) continue;
        if (!PR_PendingIncluded(calculate_risk_for_trading_tab, false)) continue;
        ENUM_ORDER_TYPE ot = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
        PR_ORDER_TYPE type = ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_STOP_LIMIT)) ? PR_Buy : PR_Sell;
        double margin1lot = MathMax(PM_Ctx.position_buy, MathMax(PM_Ctx.limit_buy, MathMax(PM_Ctx.stop_buy, PM_Ctx.stop_limit_buy)));
        if (type == PR_Sell) margin1lot = MathMax(PM_Ctx.position_sell, MathMax(PM_Ctx.limit_sell, MathMax(PM_Ctx.stop_sell, PM_Ctx.stop_limit_sell)));
        result += OrderGetDouble(ORDER_VOLUME_CURRENT) * margin1lot * PM_PriceFactor(type, OrderGetDouble(ORDER_PRICE_OPEN));
    }
    if (include_planned)
    {
        for (int j = 0; j < PR_PlannedTotal; j++)
        {
            double margin1lot = MathMax(PM_Ctx.position_buy, MathMax(PM_Ctx.limit_buy, MathMax(PM_Ctx.stop_buy, PM_Ctx.stop_limit_buy)));
            if (PR_Planned[j].type == PR_Sell) margin1lot = MathMax(PM_Ctx.position_sell, MathMax(PM_Ctx.limit_sell, MathMax(PM_Ctx.stop_sell, PM_Ctx.stop_limit_sell)));
            result += PR_Planned[j].volume * margin1lot * PM_PriceFactor(PR_Planned[j].type, PR_Planned[j].price) * PM_Ctx.custom_factor;
        }
    }
    return result;
}

// Runs the simulation for one symbol. Returns the maximum margin its included positions and orders can require, in the account currency,
// or 0 if there are none on the symbol.
// include_planned - add the planned trade (PR_Planned[]) to the symbol's orders. Only makes sense for the trading symbol.
double PM_ProcessSymbol(const string cp, const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const bool include_planned)
{
    if (!PM_PrepareSymbol(cp)) return 0;

    COrderIterator::min_profit = PR_UNDEFINED;
    COrderIterator::iterations = 0;
    COrderIterator::overflow = false;
    COrderIterator::hedging = PR_IsHedging();
    CMarginIterator::max_margin = 0;
    CMarginIterator *OrderIterator = new CMarginIterator();
    OrderIterator.mode = PR_Risk;
    int included = 0;
    string key = "M|" + cp + "|"; // Identifies the order set in the overflow memory (shared with the risk calculation).

    // Positions first: in netting mode, pending orders merge into the position.
    int total = PositionsTotal();
    for (int i = 0; i < total; i++)
    {
        if (PositionGetTicket(i) == 0) continue;
        if (PositionGetString(POSITION_SYMBOL) != cp) continue;
        if (!PR_PositionIncluded(calculate_risk_for_trading_tab, false)) continue;
        included++;
        key += IntegerToString(PositionGetInteger(POSITION_TICKET)) + ":" + DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), 8) + ":" + DoubleToString(PositionGetDouble(POSITION_SL), 8) + ":" + DoubleToString(PositionGetDouble(POSITION_TP), 8) + ":" + DoubleToString(PositionGetDouble(POSITION_VOLUME), 8) + ";";
        PR_AddSelectedPosition(OrderIterator);
    }

    total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (OrderGetTicket(i) == 0) continue;
        if (OrderGetString(ORDER_SYMBOL) != cp) continue;
        if (!PR_PendingIncluded(calculate_risk_for_trading_tab, false)) continue;
        included++;
        key += IntegerToString(OrderGetInteger(ORDER_TICKET)) + ":" + DoubleToString(OrderGetDouble(ORDER_PRICE_OPEN), 8) + ":" + DoubleToString(OrderGetDouble(ORDER_PRICE_STOPLIMIT), 8) + ":" + DoubleToString(OrderGetDouble(ORDER_SL), 8) + ":" + DoubleToString(OrderGetDouble(ORDER_TP), 8) + ":" + DoubleToString(OrderGetDouble(ORDER_VOLUME_CURRENT), 8) + ";";
        PR_AddSelectedOrder(OrderIterator);
    }

    if (include_planned)
    {
        for (int j = 0; j < PR_PlannedTotal; j++)
            PR_AddOrder(OrderIterator, PR_PLANNED_TICKET + j, PR_Planned[j].entry_type, PR_Planned[j].type, PR_Planned[j].price, PR_Planned[j].stop_price, PR_Planned[j].volume, PR_Planned[j].sl, PR_Planned[j].tp, PR_Planned[j].is_stop);
        included += PR_PlannedTotal;
        key += PR_PlannedKey;
        for (int j = 0; j < PR_PlannedTotal; j++) PM_Ctx.planned_volume += PR_Planned[j].volume;
        if (PR_PlannedTotal > 0) PM_Ctx.planned_type = PR_Planned[0].type; // All of the planned orders go the same way.
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

    OrderIterator.current_price = SymbolInfoDouble(cp, SYMBOL_BID);
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

// Calculates the portfolio margin over all included positions and orders. Outputs the maximum margin in the account currency that the
// current trades can require (margin_money) and that the current trades together with the planned trade can require (potential_margin_money).
void PM_CalculatePortfolio(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, double &margin_money, double &potential_margin_money)
{
    string symbols[];

    int total = PositionsTotal();
    for (int i = 0; i < total; i++)
    {
        if (PositionGetTicket(i) == 0) continue;
        if (!PR_PositionIncluded(calculate_risk_for_trading_tab, false)) continue;
        PR_AddSymbol(symbols, PositionGetString(POSITION_SYMBOL));
    }
    total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (OrderGetTicket(i) == 0) continue;
        if (!PR_PendingIncluded(calculate_risk_for_trading_tab, false)) continue;
        PR_AddSymbol(symbols, OrderGetString(ORDER_SYMBOL));
    }

    double planned_volume = PR_BuildPlannedTrade();

    // Symbols are treated as independent, so their worst cases add up. The trading symbol is kept apart because the planned trade is added to it.
    double others_margin = 0, chart_margin = 0;
    int symbols_total = ArraySize(symbols);
    for (int i = 0; i < symbols_total; i++)
    {
        double margin = PM_ProcessSymbol(symbols[i], calculate_risk_for_trading_tab, false);
        if (symbols[i] == SymbolForTrading) chart_margin = margin;
        else others_margin += margin;
    }
    margin_money = others_margin + chart_margin;

    if (planned_volume > 0) potential_margin_money = others_margin + PM_ProcessSymbol(SymbolForTrading, calculate_risk_for_trading_tab, true);
    else potential_margin_money = margin_money;
}

// Potential margin of the trading symbol with the planned trade at the current ArrayPositionSize[], in the account currency.
// The only part of the portfolio that depends on the planned volume - see PM_FindMaxVolume().
double PM_ChartPotentialMargin(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab)
{
    double planned_volume = PR_BuildPlannedTrade();
    return PM_ProcessSymbol(SymbolForTrading, calculate_risk_for_trading_tab, planned_volume > 0);
}

// Finds the largest position size, a multiple of the lot step not above max_volume, whose potential portfolio margin doesn't exceed limit_money.
// Used by the Trading tab's margin fuses when LessRestrictiveMaxLimits is on. current_margin_money - the current portfolio margin (has to be
// within the limit, which the caller checks). Only the trading symbol is re-simulated for each probed size; the rest of the portfolio
// is taken from current_margin_money once.
// The potential margin is a convex function of the planned volume (hedging or netting can lower it at first, then it grows), so it crosses
// the limit only once and a bisection finds the boundary. Fills ArrayPositionSize[] for the returned size. Returns 0 if no size fits.
double PM_FindMaxVolume(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const double limit_money, const double max_volume, const double current_margin_money)
{
    if (LotStep <= 0) return 0;
    double base = current_margin_money - PM_ProcessSymbol(SymbolForTrading, calculate_risk_for_trading_tab, false); // The other symbols.
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
