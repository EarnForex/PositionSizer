//+------------------------------------------------------------------+
//|                                                   PSC-Trader.mq5 |
//|                               Copyright 2015-2022, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015-2022, EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/Position-Size-Calculator/#Trading_script"
#property version   "1.15"
#include <Trade/Trade.mqh>

/*

This script works with Position Size Calculator indicator:
https://www.earnforex.com/metatrader-indicators/Position-Size-Calculator/
It works both with the new version (graphical panel) and legacy version (text labels).

It can open pending or instant orders using the position size calculated by PSC.

Works with Market Execution (ECN) too - first opens the order, then sets SL/TP.

You can control script settings via Position Size Calculator panel (Script tab).

*/

bool DisableTradingWhenLinesAreHidden = false, SubtractPositions = false, SubtractPendingOrders = false, DoNotApplyStopLoss = false, DoNotApplyTakeProfit = false, AskForConfirmation = false, ScriptCommentAutoSuffix = false;
int MaxSlippage = 0, MaxSpread, MaxEntrySLDistance, MinEntrySLDistance, MagicNumber = 0;
double MaxPositionSize;

string Commentary = "PSC-Trader";
string m_name = ""; // Panel object prefix.

enum ENTRY_TYPE
{
    Instant,
    Pending,
    StopLimit
};

CTrade *Trade;

//+------------------------------------------------------------------+
//| Script execution function.                                       |
//+------------------------------------------------------------------+
void OnStart()
{
    double Window;

    string ps = ""; // Position size string.
    double el = 0, sl = 0, tp = 0, sp = 0; // Entry level, stop-loss, take-profit, and stop price.
    ENUM_ORDER_TYPE ot; // Order type.
    ENTRY_TYPE entry_type = Instant;

    if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
    {
        Alert("Algo Trading disabled! Please enable Algo Trading.");
        return;
    }

    Window = ChartWindowFind(0, "Position Size Calculator" + IntegerToString(ChartID()));

    if (Window == -1)
    {
        Alert("Position Size Calculator not found!");
        return;
    }

    // Find panel object prefix.
    m_name = FindObjectPrefix("m_EdtPosSize", OBJ_EDIT);
    // Trying to find the position size object.
    ps = m_name + "m_EdtPosSize";
    ps = ObjectGetString(0, ps, OBJPROP_TEXT);
    if (StringLen(ps) == 0)
    {
        Alert("Position Size object not found!");
        return;
    }

    string sl_warning = m_name + "m_LblSLWarning";
    sl_warning = ObjectGetString(0, sl_warning, OBJPROP_TEXT);
    StringTrimRight(sl_warning);
    StringTrimLeft(sl_warning);
    if (sl_warning != "") // Too close or wrong value.
    {
        Alert("Stop-loss problem " + sl_warning);
        return;
    }
    
    // Replace thousand separators.
    StringReplace(ps, ",", "");

    double PositionSize = StringToDouble(ps);
    int ps_decimals = CountDecimalPlaces(PositionSize);

    Print("Detected position size: ", DoubleToString(PositionSize, ps_decimals), ".");

    double MinLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
    double MaxLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
    double LotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);

    if (PositionSize <= 0)
    {
        Print("Wrong position size value!");
        return;
    }

    string ObjectPrefix = ""; // Line object prefix.
    // Find line object prefix.
    ObjectPrefix = FindObjectPrefix("EntryLine", OBJ_HLINE);
    // Entry line.
    string el_name = ObjectPrefix + "EntryLine";
    el = ObjectGetDouble(0, el_name, OBJPROP_PRICE);
    if (el <= 0)
    {
        Alert("Entry Line not found!");
        return;
    }

    el = NormalizeDouble(el, _Digits);
    Print("Detected entry level: ", DoubleToString(el, _Digits), ".");

    double Ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
    double Bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);

    string et = m_name + "m_BtnOrderType";
    et = ObjectGetString(0, et, OBJPROP_TEXT);
    if (et == "Instant") entry_type = Instant;
    else if (et == "Pending") entry_type = Pending;
    else if (et == "Stop Limit") entry_type = StopLimit;

    Print("Detected entry type: ", EnumToString(entry_type), ".");

    sl = ObjectGetDouble(0, ObjectPrefix + "StopLossLine", OBJPROP_PRICE);
    if (sl <= 0)
    {
        Alert("Stop-Loss Line not found!");
        return;
    }
    sl = NormalizeDouble(sl, _Digits);
    Print("Detected stop-loss level: ", DoubleToString(sl, _Digits), ".");


    tp = ObjectGetDouble(0, ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE);
    if (tp > 0)
    {
        tp = NormalizeDouble(tp, _Digits);
        Print("Detected take-profit level: ", DoubleToString(tp, _Digits), ".");
    }
    else Print("No take-profit detected.");

    if (entry_type == StopLimit)
    {
        sp = ObjectGetDouble(0, ObjectPrefix + "StopPriceLine", OBJPROP_PRICE);
        if (sp > 0)
        {
            sp = NormalizeDouble(sp, _Digits);
            Print("Detected stop price level: ", DoubleToString(sp, _Digits), ".");
        }
        else
        {
            Alert("No stop price line detected for Stop Limit order!");
            return;
        }
    }

    // Try reading multiple TP levels.
    int n = 0;
    double ScriptTPValue[];
    int ScriptTPShareValue[];
    double volume_share_sum = 0;
    while (true)
    {
        ArrayResize(ScriptTPValue, n + 1);
        ArrayResize(ScriptTPShareValue, n + 1);
        ScriptTPValue[n] = 0;
        string ScriptTPObjectName = m_name + "m_EdtScriptTPEdit" + IntegerToString(n + 1);
        if (ObjectFind(ChartID(), ScriptTPObjectName) < 0) break;
        ScriptTPValue[n] = NormalizeDouble(StringToDouble(ObjectGetString(0, ScriptTPObjectName, OBJPROP_TEXT)), _Digits);
        Print("Detected Multiple TP #", n + 1, " = ", ScriptTPValue[n]);

        ScriptTPShareValue[n] = 0;
        string ScriptTPShareObjectName = m_name + "m_EdtScriptTPShareEdit" + IntegerToString(n + 1);
        ScriptTPShareValue[n] = (int)StringToInteger(ObjectGetString(0, ScriptTPShareObjectName, OBJPROP_TEXT));
        Print("Detected Multiple TP Share #", n + 1, " = ", ScriptTPShareValue[n]);

        volume_share_sum += ScriptTPShareValue[n];

        n++;
    }
    if (n > 0)
    {
        Print("Multiple TP volume share sum = ", volume_share_sum, ".");
        if ((volume_share_sum < 99) || (volume_share_sum > 100))
        {
            Print("Incorrect volume sum for multiple TPs - not taking any trades.");
            return;
        }
    }

    if ((n == 0) || (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING))
    {
        if (n > 0)
        {
            Print("Netting mode detected. Multiple TPs won't work. Setting one TP at 100% volume.");
        }
        // No multiple TPs, use single TP for 100% of volume.
        n = 1;
        ScriptTPValue[0] = tp;
        ScriptTPShareValue[0] = 100;
    }

    // Magic number
    string EdtMagicNumber = m_name + "m_EdtMagicNumber";
    MagicNumber = (int)StringToInteger(ObjectGetString(0, EdtMagicNumber, OBJPROP_TEXT));
    Print("Magic number = ", MagicNumber);

    // Order commentary
    string EdtScriptCommentary = m_name + "m_EdtScriptCommentary";
    Commentary = ObjectGetString(0, EdtScriptCommentary, OBJPROP_TEXT);
    Print("Order commentary = ", Commentary);

    // Checkbox for automatic order commentary suffix
    string ChkScriptCommentAutoSuffix = m_name + "m_ChkScriptCommentAutoSuffixButton";
    ScriptCommentAutoSuffix = ObjectGetInteger(0, ChkScriptCommentAutoSuffix, OBJPROP_STATE);
    Print("Automatic order commentary suffix = ", ScriptCommentAutoSuffix);
    if (ScriptCommentAutoSuffix) Commentary += IntegerToString((int)TimeLocal());

    // Checkbox for disabling trading when hidden lines
    string ChkDisableTradingWhenLinesAreHidden = m_name + "m_ChkDisableTradingWhenLinesAreHiddenButton";
    DisableTradingWhenLinesAreHidden = ObjectGetInteger(0, ChkDisableTradingWhenLinesAreHidden, OBJPROP_STATE);
    Print("Disable trading when lines are hidden = ", DisableTradingWhenLinesAreHidden);

    // Entry line
    bool EntryLineHidden = false;
    int EL_Hidden = (int)ObjectGetInteger(0, ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES);
    if (EL_Hidden == OBJ_NO_PERIODS) EntryLineHidden = true;
    Print("Entry line hidden = ", EntryLineHidden);

    if ((DisableTradingWhenLinesAreHidden) && (EntryLineHidden))
    {
        Print("Not taking a trade - lines are hidden, and indicator says not to trade when they are hidden.");
        return;
    }

    // Edits
    string EdtMaxSlippage = m_name + "m_EdtMaxSlippage";
    MaxSlippage = (int)StringToInteger(ObjectGetString(0, EdtMaxSlippage, OBJPROP_TEXT));
    Print("Max slippage = ", MaxSlippage);

    string EdtMaxSpread = m_name + "m_EdtMaxSpread";
    MaxSpread = (int)StringToInteger(ObjectGetString(0, EdtMaxSpread, OBJPROP_TEXT));
    Print("Max spread = ", MaxSpread);

    if (MaxSpread > 0)
    {
        int spread = (int)SymbolInfoInteger(Symbol(), SYMBOL_SPREAD);
        if (spread > MaxSpread)
        {
            Print("Not taking a trade - current spread (", spread, ") > maximum spread (", MaxSpread, ").");
            return;
        }
    }

    string EdtMaxEntrySLDistance = m_name + "m_EdtMaxEntrySLDistance";
    MaxEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMaxEntrySLDistance, OBJPROP_TEXT));
    Print("Max Entry/SL distance = ", MaxEntrySLDistance);

    if (MaxEntrySLDistance > 0)
    {
        int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point());
        if (CurrentEntrySLDistance > MaxEntrySLDistance)
        {
            Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") > maximum Entry/SL distance (", MaxEntrySLDistance, ").");
            return;
        }
    }

    string EdtMinEntrySLDistance = m_name + "m_EdtMinEntrySLDistance";
    MinEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMinEntrySLDistance, OBJPROP_TEXT));
    Print("Min Entry/SL distance = ", MinEntrySLDistance);

    if (MinEntrySLDistance > 0)
    {
        int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point());
        if (CurrentEntrySLDistance < MinEntrySLDistance)
        {
            Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") < minimum Entry/SL distance (", MinEntrySLDistance, ").");
            return;
        }
    }

    string EdtMaxPositionSize = m_name + "m_EdtMaxPositionSize";
    MaxPositionSize = StringToDouble(ObjectGetString(0, EdtMaxPositionSize, OBJPROP_TEXT));
    Print("Max position size = ", DoubleToString(MaxPositionSize, ps_decimals));

    // Checkbox for subtracting open positions volume from the position size.
    string ChkSubtractPositions = m_name + "m_ChkSubtractPositionsButton";
    SubtractPositions = ObjectGetInteger(0, ChkSubtractPositions, OBJPROP_STATE);
    Print("Subtract open positions volume = ", SubtractPositions);

    // Checkbox for subtracting pending orders volume from the position size.
    string ChkSubtractPendingOrders = m_name + "m_ChkSubtractPendingOrdersButton";
    SubtractPendingOrders = ObjectGetInteger(0, ChkSubtractPendingOrders, OBJPROP_STATE);
    Print("Subtract pending orders volume = ", SubtractPendingOrders);

    // Checkbox for not applying stop-loss to the position.
    string ChkDoNotApplyStopLoss = m_name + "m_ChkDoNotApplyStopLossButton";
    DoNotApplyStopLoss = ObjectGetInteger(0, ChkDoNotApplyStopLoss, OBJPROP_STATE);
    Print("Do not apply stop-loss = ", DoNotApplyStopLoss);

    // Checkbox for not applying take-profit to the position.
    string ChkDoNotApplyTakeProfit = m_name + "m_ChkDoNotApplyTakeProfitButton";
    DoNotApplyTakeProfit = ObjectGetInteger(0, ChkDoNotApplyTakeProfit, OBJPROP_STATE);
    Print("Do not apply take-profit = ", DoNotApplyTakeProfit);

    // Checkbox for asking for confirmation.
    string ChkAskForConfirmation = m_name + "m_ChkAskForConfirmationButton";
    AskForConfirmation = ObjectGetInteger(0, ChkAskForConfirmation, OBJPROP_STATE);
    Print("Ask for confirmation = ", AskForConfirmation);

    Trade = new CTrade;
    Trade.SetDeviationInPoints(MaxSlippage);
    if (MagicNumber > 0) Trade.SetExpertMagicNumber(MagicNumber);

    ENUM_SYMBOL_TRADE_EXECUTION Execution_Mode = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(Symbol(), SYMBOL_TRADE_EXEMODE);
    Print("Execution mode: ", EnumToString(Execution_Mode));

    if (SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE) == SYMBOL_FILLING_FOK)
    {
        Print("Order filling mode: Fill or Kill.");
        Trade.SetTypeFilling(ORDER_FILLING_FOK);
    }
    else if (SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE) == SYMBOL_FILLING_IOC)
    {
        Print("Order filling mode: Immediate or Cancel.");
        Trade.SetTypeFilling(ORDER_FILLING_IOC);
    }

    double existing_volume_buy = 0, existing_volume_sell = 0;
    if ((SubtractPendingOrders) || (SubtractPositions))
    {
        CalculateOpenVolume(existing_volume_buy, existing_volume_sell);
        Print("Found existing buy volume = ", DoubleToString(existing_volume_buy, ps_decimals));
        Print("Found existing sell volume = ", DoubleToString(existing_volume_sell, ps_decimals));
    }

    bool isOrderPlacementFailing = false; // Track if any of the order-operations fail.
    bool AtLeastOneOrderExecuted = false; // Track if at least one order got executed. Required for cases when some of the multiple TP orders have volume < minimum volume and don't get executed.

    if ((entry_type == Pending) || (entry_type == StopLimit))
    {
        // Sell
        if (sl > el)
        {
            // Stop
            if (el < Bid) ot = ORDER_TYPE_SELL_STOP;
            // Limit
            else ot = ORDER_TYPE_SELL_LIMIT;
            // Stop Limit
            if (entry_type == StopLimit) ot = ORDER_TYPE_SELL_STOP_LIMIT;
        }
        // Buy
        else
        {
            // Stop
            if (el > Ask) ot = ORDER_TYPE_BUY_STOP;
            // Limit
            else ot = ORDER_TYPE_BUY_LIMIT;
            // Stop Limit
            if (entry_type == StopLimit) ot = ORDER_TYPE_BUY_STOP_LIMIT;
        }

        if ((SubtractPendingOrders) || (SubtractPositions))
        {
            if ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_STOP_LIMIT)) PositionSize -= existing_volume_buy;
            else PositionSize -= existing_volume_sell;
            Print("Adjusted position size = ", DoubleToString(PositionSize, 2));
            if (PositionSize < 0)
            {
                Print("Adjusted position size is less than zero. Not executing any trade.");
                return;
            }
        }

        if (MaxPositionSize > 0)
        {
            if (PositionSize > MaxPositionSize)
            {
                Print("Position size (", DoubleToString(PositionSize, ps_decimals), ") > maximum position size (", DoubleToString(MaxPositionSize, ps_decimals), "). Setting position size to ", DoubleToString(MaxPositionSize, ps_decimals), ".");
                PositionSize = MaxPositionSize;
            }
        }

        if ((AskForConfirmation) && (!CheckConfirmation(ot, PositionSize, ps_decimals, sp, el, sl, tp, n)))
        {
            delete Trade;
            return;
        }

        double AccumulatedPositionSize = 0; // Total PS used by additional TPs.
        double ArrayPositionSize[]; // PS for each trade.
        ArrayResize(ArrayPositionSize, n);

        // Cycle to calculate volume for each partial trade.
        // The goal is to use normal rounded down values for additional TPs and then throw the remainder to the main TP.
        for (int j = n - 1; j >= 0; j--)
        {
            double position_size = PositionSize * ScriptTPShareValue[j] / 100.0;

            if (position_size < MinLot)
            {
                Print("Position size ", position_size, " < broker's minimum position size. Not executing the trade.");
                ArrayPositionSize[j] = 0;
                continue;
            }
            else if (position_size > MaxLot)
            {
                Print("Position size ", position_size, " > broker's maximum position size. Reducing it.");
                position_size = MaxLot;
            }
            double steps = 0;
            if (LotStep != 0) steps = position_size / LotStep;
            if (MathFloor(steps) < steps)
            {
                position_size = MathFloor(steps) * LotStep;
                Print("Adjusting position size to the broker's Lot Step parameter.");
            }

            // If this is one of the additional TPs, then count its PS towards total PS that will be open for additional TPs.
            if (j > 0)
            {
                AccumulatedPositionSize += position_size;
            }
            else // For the main TP, use the remaining part of the total PS.
            {
                position_size = PositionSize - AccumulatedPositionSize;
            }
            ArrayPositionSize[j] = position_size;
        }
        int LotStep_digits = CountDecimalPlaces(LotStep); // Required for proper volume normalization.

        // Going through a cycle to execute multiple TP trades.
        for (int j = 0; j < n; j++)
        {
            if (ArrayPositionSize[j] == 0) continue; // Calculated PS < broker's minimum.
            tp = NormalizeDouble(ScriptTPValue[j], _Digits);
            double position_size = NormalizeDouble(ArrayPositionSize[j], LotStep_digits);

            if (DoNotApplyStopLoss) sl = 0;
            if (DoNotApplyTakeProfit) tp = 0;

            if ((tp != 0) && (((tp <= el) && ((ot == ORDER_TYPE_BUY_STOP_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_LIMIT))) || ((tp >= el) && ((ot == ORDER_TYPE_SELL_STOP_LIMIT) || (ot == ORDER_TYPE_SELL_STOP) || (ot == ORDER_TYPE_SELL_LIMIT))))) tp = 0; // Do not apply TP if it is invald. SL will still be applied.
            if (!Trade.OrderOpen(Symbol(), ot, position_size, entry_type == StopLimit ? el : 0, entry_type == StopLimit ? sp : el, sl, tp, 0, 0, Commentary))
            {
                Print("Error sending order: ", Trade.ResultRetcodeDescription() + ".");
                isOrderPlacementFailing = true;
            }
            else
            {
                if (n == 1) Print("Order executed. Ticket: ", Trade.ResultOrder(), ".");
                else Print("Order #", j, " executed. Ticket: ", Trade.ResultOrder(), ".");
                AtLeastOneOrderExecuted = true;
            }
        }
    }
    // Instant
    else
    {
        // Sell
        if (sl > el) ot = ORDER_TYPE_SELL;
        // Buy
        else ot = ORDER_TYPE_BUY;

        if ((SubtractPendingOrders) || (SubtractPositions))
        {
            if (ot == ORDER_TYPE_BUY) PositionSize -= existing_volume_buy;
            else PositionSize -= existing_volume_sell;
            Print("Adjusted position size = ", DoubleToString(PositionSize, ps_decimals));
            if (PositionSize < 0)
            {
                Print("Adjusted position size is less than zero. Not executing any trade.");
                return;
            }
        }

        if (MaxPositionSize > 0)
        {
            if (PositionSize > MaxPositionSize)
            {
                Print("Position size (", DoubleToString(PositionSize, ps_decimals), ") > maximum position size (", DoubleToString(MaxPositionSize, ps_decimals), "). Setting position size to ", DoubleToString(MaxPositionSize, ps_decimals), ".");
                PositionSize = MaxPositionSize;
            }
        }

        if ((AskForConfirmation) && (!CheckConfirmation(ot, PositionSize, ps_decimals, sp, el, sl, tp, n)))
        {
            delete Trade;
            return;
        }

        double AccumulatedPositionSize = 0; // Total PS used by additional TPs.
        double ArrayPositionSize[]; // PS for each trade.
        ArrayResize(ArrayPositionSize, n);

        // Cycle to calculate volume for each partial trade.
        // The goal is to use normal rounded down values for additional TPs and then throw the remainder to the main TP.
        for (int j = n - 1; j >= 0; j--)
        {
            double position_size = PositionSize * ScriptTPShareValue[j] / 100.0;

            if (position_size < MinLot)
            {
                Print("Position size ", position_size, " < broker's minimum position size. Not executing the trade.");
                ArrayPositionSize[j] = 0;
                continue;
            }
            else if (position_size > MaxLot)
            {
                Print("Position size ", position_size, " > broker's maximum position size. Reducing it.");
                position_size = MaxLot;
            }
            double steps = 0;
            if (LotStep != 0) steps = position_size / LotStep;
            if (MathFloor(steps) < steps)
            {
                position_size = MathFloor(steps) * LotStep;
                Print("Adjusting position size to the broker's Lot Step parameter.");
            }

            // If this is one of the additional TPs, then count its PS towards total PS that will be open for additional TPs.
            if (j > 0)
            {
                AccumulatedPositionSize += position_size;
            }
            else // For the main TP, use the remaining part of the total PS.
            {
                position_size = PositionSize - AccumulatedPositionSize;
            }
            ArrayPositionSize[j] = position_size;
        }
        int LotStep_digits = CountDecimalPlaces(LotStep); // Required for proper volume normalization.

        // Going through a cycle to execute multiple TP trades.
        for (int j = 0; j < n; j++)
        {
            if (ArrayPositionSize[j] == 0) continue; // Calculated PS < broker's minimum.
            double order_sl = sl;
            double order_tp = NormalizeDouble(ScriptTPValue[j], _Digits);
            double position_size = NormalizeDouble(ArrayPositionSize[j], LotStep_digits);

            // Market execution mode - preparation.
            if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant))
            {
                // No SL/TP allowed on instant orders.
                order_sl = 0;
                order_tp = 0;
            }
            if (DoNotApplyStopLoss)
            {
                sl = 0;
                order_sl = 0;
            }
            if (DoNotApplyTakeProfit)
            {
                tp = 0;
                order_tp = 0;
            }

            if ((order_tp != 0) && (((order_tp <= el) && (ot == ORDER_TYPE_BUY)) || ((order_tp >= el) && (ot == ORDER_TYPE_SELL)))) order_tp = 0; // Do not apply TP if it is invald. SL will still be applied.
            if (!Trade.PositionOpen(Symbol(), ot, position_size, el, order_sl, order_tp, Commentary))
            {
                Print("Error sending order: ", Trade.ResultRetcodeDescription() + ".");
                isOrderPlacementFailing = true;
            }
            else
            {
                MqlTradeResult result;
                Trade.Result(result);
                if ((Trade.ResultRetcode() != 10008) && (Trade.ResultRetcode() != 10009) && (Trade.ResultRetcode() != 10010))
                {
                    Print("Error opening a position. Return code: ", Trade.ResultRetcodeDescription());
                    isOrderPlacementFailing = true;
                    break;
                }

                Print("Initial return code: ", Trade.ResultRetcodeDescription());

                ulong order = result.order;
                Print("Order ID: ", order);

                ulong deal = result.deal;
                Print("Deal ID: ", deal);
                AtLeastOneOrderExecuted = true;
                if (!DoNotApplyTakeProfit) tp = ScriptTPValue[j];
                // Market execution mode - application of SL/TP.
                if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant) && ((sl != 0) || (tp != 0)))
                {
                    if ((tp != 0) && (((tp <= el) && (ot == ORDER_TYPE_BUY)) || ((tp >= el) && (ot == ORDER_TYPE_SELL)))) tp = 0; // Do not apply TP if it is invald. SL will still be applied.
                    // Not all brokers return deal.
                    if (deal != 0)
                    {
                        if (HistorySelect(TimeCurrent() - 60, TimeCurrent()))
                        {
                            if (HistoryDealSelect(deal))
                            {
                                long position = HistoryDealGetInteger(deal, DEAL_POSITION_ID);
                                Print("Position ID: ", position);

                                if (!Trade.PositionModify(position, sl, tp))
                                {
                                    Print("Error modifying position: ", GetLastError());
                                    isOrderPlacementFailing = true;
                                }
                                else Print("SL/TP applied successfully.");
                            }
                            else
                            {
                                Print("Error selecting deal: ", GetLastError());
                                isOrderPlacementFailing = true;
                            }
                        }
                        else
                        {
                            Print("Error selecting deal history: ", GetLastError());
                            isOrderPlacementFailing = true;
                        }
                    }
                    // Wait for position to open then find it using the order ID.
                    else
                    {
                        // Run a waiting cycle until the order becomes a positoin.
                        for (int i = 0; i < 10; i++)
                        {
                            Print("Waiting...");
                            Sleep(1000);
                            if (PositionSelectByTicket(order)) break;
                        }
                        if (!PositionSelectByTicket(order))
                        {
                            Print("Error selecting position: ", GetLastError());
                            isOrderPlacementFailing = true;
                        }
                        else
                        {
                            if (!Trade.PositionModify(order, sl, tp))
                            {
                                Print("Error modifying position: ", GetLastError());
                                isOrderPlacementFailing = true;
                            }
                            else Print("SL/TP applied successfully.");
                        }
                    }
                }
            }
        }
    }
    if (n > 0) PlaySound((isOrderPlacementFailing) || (!AtLeastOneOrderExecuted) ? "timeout.wav" : "ok.wav");

    delete Trade;
}

//+------------------------------------------------------------------+
//| Finds and returns object's prefix by a given postfix and type.   |
//+------------------------------------------------------------------+
string FindObjectPrefix(const string postfix, const ENUM_OBJECT object_type)
{
    int obj_total = ObjectsTotal(0, 0, object_type);
					 
					   
    for (int i = 0; i < obj_total; i++)
    {
        string name = ObjectName(0, i, 0, object_type);
        string pattern = StringSubstr(name, StringLen(name) - StringLen(postfix));
        if (StringCompare(pattern, postfix) == 0) return StringSubstr(name, 0, StringLen(name) - StringLen(postfix));
    }
    return "";
}

// Calculate volume of open positions and/or pending orders.
// Counts volumes separately for buy and sell trades and writes them into parameterss.
void CalculateOpenVolume(double &volume_buy, double &volume_sell)
{
    if (SubtractPendingOrders)
    {
        int total = OrdersTotal();
        for (int i = 0; i < total; i++)
        {
            // Select an order.
            if (!OrderSelect(OrderGetTicket(i))) continue;
            // Skip orders with a different trading instrument.
            if (OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
            // If magic number is given via PSC panel and order's magic number is different - skip.
            if ((MagicNumber != 0) && (OrderGetInteger(ORDER_MAGIC) != MagicNumber)) continue;

            // Buy orders
            if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP)) volume_buy += OrderGetDouble(ORDER_VOLUME_CURRENT);
            // Sell orders
            else if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP)) volume_sell += OrderGetDouble(ORDER_VOLUME_CURRENT);
        }
    }

    if (SubtractPositions)
    {
        int total = PositionsTotal();
        for (int i = 0; i < total; i++)
        {
            // Works with hedging and netting.
            if (!PositionSelectByTicket(PositionGetTicket(i))) continue;
            // Skip positions with a different trading instrument.
            if (PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
            // If magic number is given via PSC panel and position's magic number is different - skip.
            if ((MagicNumber != 0) && (PositionGetInteger(POSITION_MAGIC) != MagicNumber)) continue;

            // Long positions
            if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) volume_buy += PositionGetDouble(POSITION_VOLUME);
            // Short positions
            else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) volume_sell += PositionGetDouble(POSITION_VOLUME);
        }
    }
}

//+------------------------------------------------------------------+
//| Counts decimal places.                                           |
//+------------------------------------------------------------------+
int CountDecimalPlaces(double number)
{
    // 100 as maximum length of number.
    for (int i = 0; i < 100; i++)
    {
        double pwr = MathPow(10, i);
        if (MathRound(number * pwr) / pwr == number) return i;
    }
    return -1;
}

//+------------------------------------------------------------------+
//| Check confirmation for order opening via dialog window.          |
//+------------------------------------------------------------------+
bool CheckConfirmation(const ENUM_ORDER_TYPE ot, const double PositionSize, const int ps_decimals, const double sp, const double el, const double sl, const double tp, const int n)
{
    // Evoke confirmation modal window.
    string caption = "PSC-Trader on " + Symbol() + " @ " + StringSubstr(EnumToString((ENUM_TIMEFRAMES)Period()), 7) + ": Execute the trade?";
    string message;
    string order_type_text = "";
    string currency = AccountInfoString(ACCOUNT_CURRENCY);
    switch(ot)
    {
    case ORDER_TYPE_BUY:
        order_type_text = "Buy";
        break;
    case ORDER_TYPE_BUY_STOP:
        order_type_text = "Buy Stop";
        break;
    case ORDER_TYPE_BUY_LIMIT:
        order_type_text = "Buy Limit";
        break;
    case ORDER_TYPE_BUY_STOP_LIMIT:
        order_type_text = "Buy Stop Limit";
        break;
    case ORDER_TYPE_SELL:
        order_type_text = "Sell";
        break;
    case ORDER_TYPE_SELL_STOP:
        order_type_text = "Sell Stop";
        break;
    case ORDER_TYPE_SELL_LIMIT:
        order_type_text = "Sell Limit";
        break;
    case ORDER_TYPE_SELL_STOP_LIMIT:
        order_type_text = "Sell Stop Limit";
        break;
    default:
        break;
    }

    message = "Order: " + order_type_text + "\n";
    message += "Size: " + DoubleToString(PositionSize, ps_decimals);
    if (n > 1) message += " (multiple)";
    message += "\n";
    // Find Account Size button and edit.
    string account_button = m_name + "m_BtnAccount";
    account_button = ObjectGetString(0, account_button, OBJPROP_TEXT);
    message += account_button;
    string account_value = m_name + "m_EdtAccount";
    account_value = ObjectGetString(0, account_value, OBJPROP_TEXT);
    message += ": " + account_value + " " + currency + "\n";
    string risk = m_name + "m_EdtRiskMRes";
    risk = ObjectGetString(0, risk, OBJPROP_TEXT);
    message += "Risk: " + risk + " " + currency + "\n";
    string margin = m_name + "m_EdtPosMargin";
    margin = ObjectGetString(0, margin, OBJPROP_TEXT); // Might be unavailable when Margin isn't calculated.
    if (StringToDouble(margin) != 0) message += "Margin: " + margin + " " + currency + "\n";

    if (sp > 0) message += "Stop price: " + DoubleToString(sp, _Digits) + "\n";
    message += "Entry: " + DoubleToString(el, _Digits) + "\n";
    if (!DoNotApplyStopLoss) message += "Stop-loss: " + DoubleToString(sl, _Digits) + "\n";
    if ((tp > 0) && (!DoNotApplyTakeProfit)) message += "Take-profit: " + DoubleToString(tp, _Digits);
    if (n > 1) message += " (multiple)";
    message += "\n";

    int ret = MessageBox(message, caption, MB_OKCANCEL | MB_ICONWARNING);
    if (ret == IDCANCEL)
    {
        Print("Trade canceled.");
        return false;
    }
    return true;
}
//+------------------------------------------------------------------+