//+------------------------------------------------------------------+
//|                                       Position Sizer Trading.mqh |
//|                                  Copyright © 2024, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#include <stdlib.mqh>

//+------------------------------------------------------------------+
//| Main trading function.                                           |
//+------------------------------------------------------------------+
void Trade()
{
    string Commentary = "";

    if (!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
    {
        Alert(TRANSLATION_MESSAGE_ALGO_TRADING_DISABLED_1);
        return;
    }

    if (!MQLInfoInteger(MQL_TRADE_ALLOWED))
    {
        Alert(TRANSLATION_MESSAGE_ALGO_TRADING_DISABLED_2);
        return;
    }

    if ((WarningSL != "") && (!sets.DoNotApplyStopLoss)) // Too close or wrong value.
    {
        Alert(TRANSLATION_MESSAGE_STOPLOSS_PROBLEM + ": " + WarningSL);
        return;
    }

    if (OutputPositionSize <= 0)
    {
        Alert(TRANSLATION_MESSAGE_WRONG_POSITION_SIZE_VALUE);
        return;
    }

    double TP[], TPShare[]; // Mimics sets.TP[] and sets.TPShare[], but always includes the main TP too.

    ArrayResize(TP, sets.TakeProfitsNumber);
    ArrayResize(TPShare, sets.TakeProfitsNumber);

    if (sets.TakeProfitsNumber > 1)
    {
        Print(TRANSLATION_MESSAGE_MULTIPLE_TP_VOLUME_SHARE_SUM + " = ", TotalVolumeShare, ".");
        if ((TotalVolumeShare < 99) || (TotalVolumeShare > 100))
        {
            Alert(TRANSLATION_MESSAGE_INCORRECT_VOLUME_SUM);
            return;
        }
        for (int i = 0; i < sets.TakeProfitsNumber; i++)
        {
            TP[i] = sets.TP[i];
            TPShare[i] = sets.TPShare[i];
        }
    }
    else
    {
        // No multiple TPs, use single TP for 100% of volume.
        TP[0] = sets.TakeProfitLevel;
        TPShare[0] = 100;
    }

    if (sets.Commentary != "") Commentary = sets.Commentary;

    if (sets.CommentAutoSuffix) Commentary += IntegerToString((int)TimeLocal());

    if ((sets.DisableTradingWhenLinesAreHidden) && (!sets.ShowLines))
    {
        Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_LINES);
        return;
    }

    RefreshRates();

    if (sets.MaxSpread > 0)
    {
        int spread = (int)((Ask - Bid) / Point);
        if (spread > sets.MaxSpread)
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_SPREAD + " (", spread, ") > " + TRANSLATION_MESSAGE_MAXIMUM_SPREAD + " (", sets.MaxSpread, ").");
            return;
        }
    }

    if (sets.MaxEntrySLDistance > 0)
    {
        int CurrentEntrySLDistance = (int)(MathAbs(sets.StopLossLevel - sets.EntryLevel) / Point);
        if (CurrentEntrySLDistance > sets.MaxEntrySLDistance)
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_ENTRY_SL_DISTANCE + " (", CurrentEntrySLDistance, ") > " + TRANSLATION_LABEL_MAX_ENTRY_SL_DISTANCE + " (", sets.MaxEntrySLDistance, ").");
            return;
        }
    }

    if (sets.MinEntrySLDistance > 0)
    {
        int CurrentEntrySLDistance = (int)(MathAbs(sets.StopLossLevel - sets.EntryLevel) / Point);
        if (CurrentEntrySLDistance < sets.MinEntrySLDistance)
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_ENTRY_SL_DISTANCE + " (", CurrentEntrySLDistance, ") < " + TRANSLATION_LABEL_MIN_ENTRY_SL_DISTANCE + " (", sets.MinEntrySLDistance, ").");
            return;
        }
    }

    if (sets.MaxRiskPercentage > 0)
    {
        double risk_percentage_output = 100; // In case AccSize = 0;
        if (AccSize != 0)
        {
            risk_percentage_output = Round(OutputRiskMoney / AccSize * 100, 2); // Not stored anywhere. Have to recalculate each time.
        }        
        if (risk_percentage_output > sets.MaxRiskPercentage)
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_CURRENT_RISK + " (", risk_percentage_output, "%) > " + TRANSLATION_MESSAGE_NTAT_MAX_RISK + " (", sets.MaxRiskPercentage, "%).");
            return;
        }
    }

    if ((sets.MaxNumberOfTradesTotal > 0) || (sets.MaxNumberOfTradesPerSymbol > 0))
    {
        int total = OrdersTotal();
        int cnt = 0, persymbol_cnt = 0;
        for (int i = 0; i < total; i++)
        {
            if (!OrderSelect(i, SELECT_BY_POS)) continue;
            if ((sets.MagicNumber != 0) && (OrderMagicNumber() != sets.MagicNumber)) continue;
            if (OrderSymbol() == Symbol()) persymbol_cnt++;
            cnt++;
        }
        if ((cnt + sets.TakeProfitsNumber > sets.MaxNumberOfTradesTotal) && (sets.MaxNumberOfTradesTotal > 0))
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_TOTAL_NUMBER + " (", cnt, ") + " + TRANSLATION_MESSAGE_NUMBER_OF_TRADES_IN_EXECUTION + " (", sets.TakeProfitsNumber, ") > " + TRANSLATION_MESSAGE_MAXIMUM_TOTAL_NUMBER_OF_TRADES_ALLOWED + " (", sets.MaxNumberOfTradesTotal, ").");
            return;
        }
        if ((persymbol_cnt + sets.TakeProfitsNumber > sets.MaxNumberOfTradesPerSymbol) && (sets.MaxNumberOfTradesPerSymbol > 0))
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_PER_SYMBOL_NUMBER + " (", persymbol_cnt, ") + " + TRANSLATION_MESSAGE_NUMBER_OF_TRADES_IN_EXECUTION + " (", sets.TakeProfitsNumber, ") > " + TRANSLATION_MESSAGE_MAXIMUM_PER_SYMBOL_NUMBER_OF_TRADES_ALLOWED + " (", sets.MaxNumberOfTradesPerSymbol, ").");
            return;
        }
    }

    ENUM_SYMBOL_TRADE_EXECUTION Execution_Mode = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(Symbol(), SYMBOL_TRADE_EXEMODE);
    string warning_suffix = "";
    if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (IgnoreMarketExecutionMode) && (sets.EntryType == Instant)) warning_suffix = TRANSLATION_MESSAGE_IGNORE_MARKET_EXECUTION_MODE_WARNING;
    Print(TRANSLATION_MESSAGE_EXECUTION_MODE + ": ", EnumToString(Execution_Mode), warning_suffix);

    ENUM_ORDER_TYPE ot;
    if (sets.EntryType == Pending)
    {
        // Sell
        if (sets.TradeDirection == Short)
        {
            // Stop
            if (sets.EntryLevel < Bid) ot = OP_SELLSTOP;
            // Limit
            else ot = OP_SELLLIMIT;
        }
        // Buy
        else
        {
            // Stop
            if (sets.EntryLevel > Ask) ot = OP_BUYSTOP;
            // Limit
            else ot = OP_BUYLIMIT;
        }
    }
    // Instant
    else
    {
        // Sell
        if (sets.TradeDirection == Short) ot = OP_SELL;
        // Buy
        else ot = OP_BUY;
    }

    double PositionSize = OutputPositionSize;
    
    if ((sets.SubtractPendingOrders) || (sets.SubtractPositions))
    {
        double existing_volume_buy = 0, existing_volume_sell = 0;
        CalculateOpenVolume(existing_volume_buy, existing_volume_sell);
        Print(TRANSLATION_MESSAGE_FOUND_EXISTING_BUY_VOLUME + " = ", DoubleToString(existing_volume_buy, LotStep_digits));
        Print(TRANSLATION_MESSAGE_FOUND_EXISTING_SELL_VOLUME + " = ", DoubleToString(existing_volume_sell, LotStep_digits));
        if ((ot == OP_BUY) || (ot == OP_BUYLIMIT) || (ot == OP_BUYSTOP)) PositionSize -= existing_volume_buy;
        else PositionSize -= existing_volume_sell;
        Print(TRANSLATION_MESSAGE_ADJUSTED_POSITION_SIZE + " = ", DoubleToString(PositionSize, LotStep_digits));
        if (PositionSize <= 0)
        {
            Alert(TRANSLATION_MESSAGE_ADJUSTED_POSITION_SIZE_LESS_THAN_ZERO);
            return;
        }
        if (PositionSize != OutputPositionSize) // If changed, recalculate the array of position sizes.
        {
            PositionSizeToArray(PositionSize); // Re-fills ArrayPositionSize[].
        }
    }

    if ((sets.MaxPositionSizeTotal > 0) || (sets.MaxPositionSizePerSymbol > 0))
    {
        int total = OrdersTotal();
        double volume = 0, volume_persymbol = 0;
        for (int i = 0; i < total; i++)
        {
            if (!OrderSelect(i, SELECT_BY_POS)) continue;
            if ((sets.MagicNumber != 0) && (OrderMagicNumber() != sets.MagicNumber)) continue;
            if (OrderSymbol() == Symbol()) volume_persymbol += OrderLots();
            volume += OrderLots();
        }
        if ((volume + PositionSize > sets.MaxPositionSizeTotal) && (sets.MaxPositionSizeTotal > 0))
        {
            string alert_text = TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_TOTAL_VOLUME + " (" + DoubleToString(volume, LotStep_digits) + ") + " + TRANSLATION_MESSAGE_NTAT_NEW_POSITION_VOLUME + " (" + DoubleToString(PositionSize, LotStep_digits) + ") >= " + TRANSLATION_MESSAGE_NTAT_MAXIMUM_TOTAL_VOLUME + " (" + DoubleToString(sets.MaxPositionSizeTotal, LotStep_digits) + ").";
            if (!LessRestrictiveMaxLimits)
            {
                Alert(alert_text);
                return;
            }
            else
            {
                double new_ps = sets.MaxPositionSizeTotal - volume;
                if (new_ps >= MinLot)
                {
                    new_ps = AdjustPositionSizeByMinMaxStep(new_ps);
                    Alert(TRANSLATION_MESSAGE_TAKING_SMALLER_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_TOTAL_VOLUME + " (" + DoubleToString(volume, LotStep_digits) + ") + " + TRANSLATION_MESSAGE_NTAT_NEW_POSITION_VOLUME + " (" + DoubleToString(PositionSize, LotStep_digits) + ") >= " + TRANSLATION_MESSAGE_NTAT_MAXIMUM_TOTAL_VOLUME + " (" + DoubleToString(sets.MaxPositionSizeTotal, LotStep_digits) + "). " + TRANSLATION_MESSAGE_NEW_POSITION_SIZE + " = " + DoubleToString(new_ps, LotStep_digits));
                    PositionSize = new_ps;
                    PositionSizeToArray(PositionSize); // Re-fills ArrayPositionSize[].
                }
                else
                {
                    Alert(alert_text + " " + TRANSLATION_MESSAGE_CANNOT_TAKE_SMALLER_TRADE);
                    return;
                }
            }
        }
        if ((volume_persymbol + PositionSize > sets.MaxPositionSizePerSymbol) && (sets.MaxPositionSizePerSymbol > 0))
        {
            string alert_text = TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_PER_SYMBOL_VOLUME + " (" + DoubleToString(volume, LotStep_digits) + ") + " + TRANSLATION_MESSAGE_NTAT_NEW_POSITION_VOLUME + " (" + DoubleToString(PositionSize, LotStep_digits) + ") >= " + TRANSLATION_MESSAGE_NTAT_MAXIMUM_PER_SYMBOL_VOLUME + " (" + DoubleToString(sets.MaxPositionSizePerSymbol, LotStep_digits) + ").";
            if (!LessRestrictiveMaxLimits)
            {
                Alert(alert_text);
                return;
            }
            else
            {
                double new_ps = sets.MaxPositionSizePerSymbol - volume_persymbol;
                if (new_ps >= MinLot)
                {
                    new_ps = AdjustPositionSizeByMinMaxStep(new_ps);
                    Alert(TRANSLATION_MESSAGE_TAKING_SMALLER_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_PER_SYMBOL_VOLUME + " (" + DoubleToString(volume, LotStep_digits) + ") + " + TRANSLATION_MESSAGE_NTAT_NEW_POSITION_VOLUME + " (" + DoubleToString(PositionSize, LotStep_digits) + ") >= " + TRANSLATION_MESSAGE_NTAT_MAXIMUM_PER_SYMBOL_VOLUME + " (" + DoubleToString(sets.MaxPositionSizePerSymbol, LotStep_digits) + ")." + TRANSLATION_MESSAGE_NEW_POSITION_SIZE + " = " + DoubleToString(new_ps, LotStep_digits));
                    PositionSize = new_ps;
                    PositionSizeToArray(PositionSize); // Re-fills ArrayPositionSize[].
                }
                else
                {
                    Alert(alert_text + " " + TRANSLATION_MESSAGE_CANNOT_TAKE_SMALLER_TRADE);
                    return;
                }
            }
        }
    }

    if (sets.MaxRiskTotal > 0)
    {
        CalculatePortfolioRisk(CALCULATE_RISK_FOR_TRADING_TAB_TOTAL);
        double risk;
        if (PortfolioLossMoney != DBL_MAX)
        {
            risk = (PortfolioLossMoney + OutputRiskMoney) / AccSize * 100;
            if (risk > sets.MaxRiskTotal)
            {
                string alert_text = TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_TOTAL_POTENTIAL_RISK + " (" + DoubleToString(risk, 2) + ") >= " + TRANSLATION_MESSAGE_MAXIUMUM_TOTAL_RISK + " (" + DoubleToString(sets.MaxRiskTotal, 2) + ").";
                if (!LessRestrictiveMaxLimits)
                {
                    Alert(alert_text);
                    return;
                }
                else
                {
                    double new_ps = (sets.MaxRiskTotal / 100 * AccSize - PortfolioLossMoney) * (OutputPositionSize / OutputRiskMoney);
                    if (new_ps >= MinLot)
                    {
                        PositionSize = Round(new_ps, LotStep_digits, RoundDown);
                        PositionSize = AdjustPositionSizeByMinMaxStep(PositionSize);
                        PositionSizeToArray(PositionSize); // Re-fills ArrayPositionSize[].
                        Alert(TRANSLATION_MESSAGE_TAKING_SMALLER_TRADE + " - " + TRANSLATION_MESSAGE_TOTAL_POTENTIAL_RISK + " (" + DoubleToString(risk, 2) + ") >= " + TRANSLATION_MESSAGE_MAXIUMUM_TOTAL_RISK + " (" + DoubleToString(sets.MaxRiskTotal, 2) + "). " + TRANSLATION_MESSAGE_NEW_POSITION_SIZE + " = " + DoubleToString(PositionSize, LotStep_digits));
                    }
                    else
                    {
                        Alert(alert_text + " " + TRANSLATION_MESSAGE_CANNOT_TAKE_SMALLER_TRADE);
                        return;
                    }
                }
            }
        }
        else
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_INFINITE_TOTAL_POTENTIAL_RISK + ".");
            return;
        }
    }
    if (sets.MaxRiskPerSymbol > 0)
    {
        CalculatePortfolioRisk(CALCULATE_RISK_FOR_TRADING_TAB_PER_SYMBOL);
        double risk;
        if (PortfolioLossMoney != DBL_MAX)
        {
            risk = (PortfolioLossMoney + OutputRiskMoney) / AccSize * 100;
            if (risk > sets.MaxRiskPerSymbol)
            {
                string alert_text = TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_PER_SYMBOL_POTENTIAL_RISK + " (" + DoubleToString(risk, 2) + ") >= " + TRANSLATION_MESSAGE_MAXIMUM_PER_SYMBOL_RISK + " (" + DoubleToString(sets.MaxRiskPerSymbol, 2) + ").";
                if (!LessRestrictiveMaxLimits)
                {
                    Alert(alert_text);
                    return;
                }
                else
                {
                    double new_ps = (sets.MaxRiskPerSymbol / 100 * AccSize - PortfolioLossMoney) * (OutputPositionSize / OutputRiskMoney);
                    if (new_ps >= MinLot)
                    {
                        PositionSize = Round(new_ps, LotStep_digits, RoundDown);
                        PositionSize = AdjustPositionSizeByMinMaxStep(PositionSize);
                        PositionSizeToArray(PositionSize); // Re-fills ArrayPositionSize[].
                        Alert(TRANSLATION_MESSAGE_TAKING_SMALLER_TRADE + " - " + TRANSLATION_MESSAGE_PER_SYMBOL_POTENTIAL_RISK + " (" + DoubleToString(risk, 2) + ") >= " + TRANSLATION_MESSAGE_MAXIMUM_PER_SYMBOL_RISK + " (" + DoubleToString(sets.MaxRiskPerSymbol, 2) + "). " + TRANSLATION_MESSAGE_NEW_POSITION_SIZE + " = " + DoubleToString(PositionSize, LotStep_digits));
                    }
                    else
                    {
                        Alert(alert_text + " " + TRANSLATION_MESSAGE_CANNOT_TAKE_SMALLER_TRADE);
                        return;
                    }
                }
            }
        }
        else
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_INFINITE_TOTAL_POTENTIAL_RISK + ".");
            return;
        }
    }

    datetime expiry = 0;
    if ((sets.EntryType == Pending) && (sets.ExpiryMinutes > 0))
    {
        expiry = TimeCurrent() + sets.ExpiryMinutes * 60;
    }

    if (sets.AskForConfirmation)
    {
        // Evoke confirmation modal window.
        string caption = TRANSLATION_MESSAGE_POSITION_SIZER_ON + Symbol() + " @ " + StringSubstr(EnumToString((ENUM_TIMEFRAMES)Period()), 7) + ": " + TRANSLATION_MESSAGE_EXECUTE_TRADE;
        string message;
        string order_type_text = OrderTypeToString(ot);
        string currency = AccountInfoString(ACCOUNT_CURRENCY);
        message = TRANSLATION_MESSAGE_ORDER + ": " + order_type_text + "\n";
        message += TRANSLATION_MESSAGE_SIZE + ": " + DoubleToString(PositionSize, LotStep_digits);
        if (sets.TakeProfitsNumber > 1) message += " (" + TRANSLATION_MESSAGE_MULTIPLE + ")";
        message += "\n";
        message += EnumToString(sets.AccountButton);
        message += ": " + FormatDouble(DoubleToString(AccSize, 2)) + " " + account_currency + "\n";
        message += TRANSLATION_LABEL_RISK + ": " + FormatDouble(DoubleToString(OutputRiskMoney)) + " " + account_currency + "\n";
        if (PositionMargin != 0) message += TRANSLATION_TAB_BUTTON_MARGIN + ": " + FormatDouble(DoubleToString(PositionMargin, 2)) + " " + account_currency + "\n";
        message += TRANSLATION_LABEL_ENTRY + ": " + DoubleToString(sets.EntryLevel, _Digits) + "\n";
        if (!sets.DoNotApplyStopLoss) message += TRANSLATION_LABEL_STOPLOSS + ": " + DoubleToString(sets.StopLossLevel, _Digits) + "\n";
        if ((sets.TakeProfitLevel > 0) && (!sets.DoNotApplyTakeProfit))
        {
            message += TRANSLATION_LABEL_TAKEPROFIT + ": " + DoubleToString(sets.TakeProfitLevel, _Digits);
            if (sets.TakeProfitsNumber > 1) message += " (" + TRANSLATION_MESSAGE_MULTIPLE + ")";
            message += "\n";
        }
        if (expiry > 0) message += TRANSLATION_LABEL_EXPIRY + ": " + TimeToString(expiry, TIME_DATE|TIME_MINUTES|TIME_SECONDS);

        int ret = MessageBox(message, caption, MB_OKCANCEL | MB_ICONWARNING);
        if (ret == IDCANCEL)
        {
            Print(TRANSLATION_MESSAGE_TRADE_CANCELED);
            return;
        }
    }

    if (sets.DoNotApplyStopLoss)
    {
        Print(TRANSLATION_MESSAGE_DONOTAPPLLYSL_SET);
    }
    if (sets.DoNotApplyTakeProfit)
    {
        Print(TRANSLATION_MESSAGE_DONOTAPPLLYTP_SET);
    }

    // Use ArrayPositionSize that has already been calculated in CalculateRiskAndPositionSize().
    // Check if they are OK.
    for (int j = sets.TakeProfitsNumber - 1; j >= 0; j--)
    {
        if (ArrayPositionSize[j] < MinLot)
        {
            Print(TRANSLATION_LABEL_POSITION_SIZE + " ", ArrayPositionSize[j], " < " + TRANSLATION_MESSAGE_BROKER_MINIMUM);
            ArrayPositionSize[j] = 0;
            continue;
        }
        else if ((ArrayPositionSize[j] > MaxLot) && (!SurpassBrokerMaxPositionSize))
        {
            Print(TRANSLATION_LABEL_POSITION_SIZE + " ", ArrayPositionSize[j], " > " + TRANSLATION_MESSAGE_BROKER_MAXIMUM);
            ArrayPositionSize[j] = MaxLot;
        }
    }

    bool isOrderPlacementFailing = false; // Track if any of the order-operations fail.
    bool AtLeastOneOrderExecuted = false; // Track if at least one order got executed. Required for cases when some of the multiple TP orders have volume < minimum volume and don't get executed.

    // Will be used if MarketModeApplySLTPAfterAllTradesExecuted == true. 
    int array_of_tickets[];
    double array_of_sl[], array_of_tp[];
    ENUM_ORDER_TYPE array_of_ot[];
    int array_cnt = 0;
    
    // Going through a cycle to execute multiple TP trades.
    for (int j = 0; j < sets.TakeProfitsNumber; j++)
    {
        if (ArrayPositionSize[j] == 0) continue; // Calculated PS < broker's minimum.
        double order_sl = sets.StopLossLevel;
        double sl = order_sl;
        double order_tp = NormalizeDouble(TP[j], _Digits);
        double tp = order_tp;
        double position_size = NormalizeDouble(ArrayPositionSize[j], LotStep_digits);

        // Market execution mode - preparation.
        if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (sets.EntryType == Instant) && (!IgnoreMarketExecutionMode))
        {
            // No SL/TP allowed on instant orders.
            order_sl = 0;
            order_tp = 0;
        }
        if (sets.DoNotApplyStopLoss)
        {
            sl = 0;
            order_sl = 0;
        }
        if (sets.DoNotApplyTakeProfit)
        {
            tp = 0;
            order_tp = 0;
        }

        if ((order_tp != 0) && (((order_tp <= sets.EntryLevel) && ((ot == OP_BUY) || (ot == OP_BUYLIMIT) || (ot == OP_BUYSTOP))) || ((order_tp >= sets.EntryLevel) && ((ot == OP_SELL) || (ot == OP_SELLLIMIT) || (ot == OP_SELLSTOP))))) order_tp = 0; // Do not apply TP if it is invald. SL will still be applied.

        // Cycle for splitting up trade/subtrade into more subtrades starts here.
        while (position_size > 0)
        {
            double sub_position_size;
            if (position_size > MaxLot)
            {
                sub_position_size = MaxLot;
                position_size = NormalizeDouble(position_size - MaxLot, LotStep_digits);
            }
            else
            {
                sub_position_size = position_size;
                position_size = 0; // End the cycle;
            }
            int ticket = OrderSend(Symbol(), ot, sub_position_size, sets.EntryLevel, sets.MaxSlippage, order_sl, order_tp, Commentary, sets.MagicNumber, expiry);
            if (ticket == -1)
            {
                int error = GetLastError();
                Print(TRANSLATION_MESSAGE_EXECUTION_FAILED + " " + TRANSLATION_MESSAGE_ERROR + ": ", IntegerToString(error), " - ", ErrorDescription(error), ".");
                isOrderPlacementFailing = true;
            }
            else
            {
                if (sets.TakeProfitsNumber == 1) Print(TRANSLATION_MESSAGE_ORDER_EXECUTED + " " + TRANSLATION_MESSAGE_TICKET + ": ", ticket, ".");
                else Print(TRANSLATION_MESSAGE_ORDER + " #", j, " " + TRANSLATION_MESSAGE_EXECUTED + ". " + TRANSLATION_MESSAGE_TICKET + ": ", ticket, ".");
                AtLeastOneOrderExecuted = true;
                if (IsVisualMode()) ExtDialog.CreateOutsideCloseButton(ticket);
            }
            if (!sets.DoNotApplyTakeProfit) tp = TP[j];
            // Market execution mode - applying SL/TP.
            if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (sets.EntryType == Instant) && (!IgnoreMarketExecutionMode) && (ticket != -1) && ((sl != 0) || (tp != 0)))
            {
                if (MarketModeApplySLTPAfterAllTradesExecuted) // Finish opening all trades, then apply all SLs and TPs.
                {
                    array_cnt++;
                    ArrayResize(array_of_tickets, array_cnt);
                    ArrayResize(array_of_sl, array_cnt);
                    ArrayResize(array_of_tp, array_cnt);
                    ArrayResize(array_of_ot, array_cnt);
                    array_of_tickets[array_cnt - 1] = ticket;
                    array_of_sl[array_cnt - 1] = sl;
                    array_of_tp[array_cnt - 1] = tp;
                    array_of_ot[array_cnt - 1] = ot;
                }
                else
                {
                    if (!ApplySLTPToOrder(ticket, sl, tp, ot))
                    {
                        isOrderPlacementFailing = true;
                        break;
                    }
                }
            }
        } // Cycle for splitting up trade/subtrade into more subtrades ends here.
    }
    
    // Run position adjustment if necessary.
    for (int j = 0; j < array_cnt; j++)
    {
        if (!ApplySLTPToOrder(array_of_tickets[j], array_of_sl[j], array_of_tp[j], array_of_ot[j]))
        {
            isOrderPlacementFailing = true;
        }
    }
    
    if (!DisableTradingSounds) PlaySound((isOrderPlacementFailing) || (!AtLeastOneOrderExecuted) ? "timeout.wav" : "ok.wav");
}

// Applies SL/TP to a single order (used in the Market execution mode).
// Returns false in case of a failure, true - in case of a success.
bool ApplySLTPToOrder(int ticket, double sl, double tp, ENUM_ORDER_TYPE ot)
{
    if (!OrderSelect(ticket, SELECT_BY_TICKET))
    {
        Print(TRANSLATION_MESSAGE_FAILED_TO_FIND_ORDER);
        return false;
    }
    for (int i = 0; i < 10; i++)
    {
        if ((tp != 0) && (((tp <= OrderOpenPrice()) && (ot == OP_BUY)) || ((tp >= OrderOpenPrice()) && (ot == OP_SELL)))) tp = 0; // Do not apply TP if it is invald. SL will still be applied.
        bool result = OrderModify(ticket, OrderOpenPrice(), sl, tp, OrderExpiration());
        if (result)
        {
            return true;
        }
        else
        {
            Print(TRANSLATION_MESSAGE_ERROR_MODIFYING_ORDER + ": ", GetLastError());
        }
    }
    return false;
}

// Calculate volume of open positions and/or pending orders.
// Counts volumes separately for buy and sell trades and writes them into parameterss.
void CalculateOpenVolume(double &volume_buy, double &volume_sell)
{
    int total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        // Select an order.
        if (!OrderSelect(i, SELECT_BY_POS)) continue;
        // Skip orders with a different trading instrument.
        if (OrderSymbol() != _Symbol) continue;
        // If magic number is given via PS panel and order's magic number is different - skip.
        if ((sets.MagicNumber != 0) && (OrderMagicNumber() != sets.MagicNumber)) continue;

        if (sets.SubtractPositions)
        {
            // Buy orders
            if (OrderType() == ORDER_TYPE_BUY) volume_buy += OrderLots();
            // Sell orders
            else if (OrderType() == ORDER_TYPE_SELL) volume_sell += OrderLots();
        }
        if (sets.SubtractPendingOrders)
        {
            // Buy orders
            if ((OrderType() == ORDER_TYPE_BUY_LIMIT) || (OrderType() == ORDER_TYPE_BUY_STOP)) volume_buy += OrderLots();
            // Sell orders
            else if ((OrderType() == ORDER_TYPE_SELL_LIMIT) || (OrderType() == ORDER_TYPE_SELL_STOP)) volume_sell += OrderLots();
        }
    }
}

// Does trailing based on the Magic number and symbol.
void DoTrailingStop()
{
    if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!TerminalInfoInteger(TERMINAL_CONNECTED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED))) return;

    for (int i = 0; i < OrdersTotal(); i++)
    {
        if (!OrderSelect(i, SELECT_BY_POS)) Print(TRANSLATION_MESSAGE_ORDERSELECT_FAILED + ": " + ErrorDescription(GetLastError()) + ".");
        else if (SymbolInfoInteger(OrderSymbol(), SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED) continue;
        else
        {
            if ((OrderSymbol() != Symbol()) || (OrderMagicNumber() != sets.MagicNumber)) continue;
            if (OrderType() == OP_BUY)
            {
                double SL = NormalizeDouble(Bid - sets.TrailingStopPoints * _Point, _Digits);
                if (SL > OrderStopLoss())
                {
                    if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, OrderTakeProfit(), OrderExpiration()))
                        Print(TRANSLATION_MESSAGE_FAILED_TO_SET_TRAILING_STOP_FOR_BUY + ": " + ErrorDescription(GetLastError()) + ".");
                    else
                        Print(TRANSLATION_MESSAGE_TSL_APPLIED + " - " + Symbol() + " " + TRANSLATION_MESSAGE_BUY + " #" + IntegerToString(OrderTicket()) + " " + TRANSLATION_LABEL_POSITION_SIZE + " = " + DoubleToString(OrderLots(), LotStep_digits) + ", " + TRANSLATION_LABEL_ENTRY + " = " + DoubleToString(OrderOpenPrice(), _Digits) + ", " + TRANSLATION_MESSAGE_SL_WAS_MOVED_FROM + " " + DoubleToString(OrderStopLoss(), _Digits) + " " + TRANSLATION_MESSAGE_SL_WAS_MOVED_TO + " " + DoubleToString(SL, _Digits) + ".");
                }
            }
            else if (OrderType() == OP_SELL)
            {
                double SL = NormalizeDouble(Ask + sets.TrailingStopPoints * _Point, _Digits);
                if ((SL < OrderStopLoss()) || (OrderStopLoss() == 0))
                {
                    if (!OrderModify(OrderTicket(), OrderOpenPrice(), SL, OrderTakeProfit(), OrderExpiration()))
                        Print(TRANSLATION_MESSAGE_FAILED_TO_SET_TRAILING_STOP_FOR_SELL + ": " + ErrorDescription(GetLastError()) + ".");
                    else
                        Print(TRANSLATION_MESSAGE_TSL_APPLIED + " - " + Symbol() + " " + TRANSLATION_MESSAGE_SELL + " #" + IntegerToString(OrderTicket()) + " " + TRANSLATION_LABEL_POSITION_SIZE + " = " + DoubleToString(OrderLots(), LotStep_digits) + ", " + TRANSLATION_LABEL_ENTRY + " = " + DoubleToString(OrderOpenPrice(), _Digits) + ", " + TRANSLATION_MESSAGE_SL_WAS_MOVED_FROM + " " + DoubleToString(OrderStopLoss(), _Digits) + " " + TRANSLATION_MESSAGE_SL_WAS_MOVED_TO + " " + DoubleToString(SL, _Digits) + ".");
                }
            }
        }
    }
}

// Sets SL to breakeven based on the Magic number and symbol.
void DoBreakEven()
{
    if (!TerminalInfoInteger(TERMINAL_CONNECTED)) return;
    
    // Delete old BE lines if necessary.
    if (be_line_color != clrNONE)
    {
        int obj_total = ObjectsTotal(ChartID(), -1, OBJ_HLINE);
        for (int i = obj_total - 1; i >= 0; i--)
        {
            string obj_name = ObjectName(ChartID(), i, -1, OBJ_HLINE);
            if (StringFind(obj_name, ObjectPrefix + "BE") == -1) continue; // Skip all other horizontal lines.
            int ticket = (int)StringToInteger(StringSubstr(obj_name, StringLen(ObjectPrefix + "BE")));
            if (!OrderSelect(ticket, SELECT_BY_TICKET)) // No longer exists.
            {
                ObjectDelete(ChartID(), obj_name); // Delete the line.
                if (ShowLineLabels) ObjectDelete(ChartID(), ObjectPrefix + "BEL" + IntegerToString(ticket)); // Delete the label.
            }
            else // Check if already triggered. Order selected.
            {
                double be_price = NormalizeDouble(StringToDouble(ObjectGetString(ChartID(), obj_name, OBJPROP_TOOLTIP)), _Digits);
                if (((OrderType() == OP_BUY) && (OrderStopLoss() >= be_price)) // Already triggered.
                 || ((OrderType() == OP_SELL) && (OrderStopLoss() <= be_price) && (OrderStopLoss() != 0)))
                {
                    ObjectDelete(ChartID(), obj_name); // Delete the line.
                    if (ShowLineLabels) ObjectDelete(ChartID(), ObjectPrefix + "BEL" + IntegerToString(ticket)); // Delete the label.
                }
            }
        }
    }
    
    if (sets.BreakEvenPoints <= 0) return;
    
    if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED))) return;

    for (int i = 0; i < OrdersTotal(); i++)
    {
        if (!OrderSelect(i, SELECT_BY_POS)) Print(TRANSLATION_MESSAGE_ORDERSELECT_FAILED + ": " + ErrorDescription(GetLastError()) + ".");
        else if (SymbolInfoInteger(OrderSymbol(), SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED) continue;
        else
        {
            if ((OrderSymbol() != Symbol()) || (OrderMagicNumber() != sets.MagicNumber)) continue;

            // Based on the commission if UseCommissionToSetTPDistance is set to true.
            double extra_be_distance = 0;
            if ((UseCommissionToSetTPDistance) && (sets.CommissionPerLot != 0))
            {
                // Calculate real commission in currency units.
                double commission = CalculateCommission();

                // Extra BE Distance = Commission Size / Point_value.
                // Commission Size = Commission * 2.
                // Extra BE Distance = Commission * 2 / Point_value.
                if ((UnitCost_reward != 0) && (TickSize != 0))
                    extra_be_distance = commission * 2 / (UnitCost_reward / TickSize);
            }

            if (OrderType() == OP_BUY)
            {
                double BE_threshold = NormalizeDouble(OrderOpenPrice() + sets.BreakEvenPoints * _Point, _Digits);
                double BE_price = NormalizeDouble(OrderOpenPrice() + extra_be_distance, _Digits);
                if ((be_line_color != clrNONE) && (BE_price > OrderStopLoss())) DrawBELine(OrderTicket(), BE_threshold, BE_price); // Only draw if not triggered yet.
                if ((Bid >= BE_threshold) && (Bid >= BE_price) && (BE_price > OrderStopLoss())) // Only move to BE if the price reached the necessary threshold, the price is above the calculated BE price, and the current stop-loss is lower.
                {
                    double prev_sl = OrderStopLoss(); // Remember old SL for reporting.
                    // Write Open price to the SL field.
                    if (!OrderModify(OrderTicket(), OrderOpenPrice(), BE_price, OrderTakeProfit(), OrderExpiration()))
                        Print(TRANSLATION_MESSAGE_ERROR_MODIFYING_ORDER + ": " + ErrorDescription(GetLastError()) + ".");
                    else
                        Print(TRANSLATION_MESSAGE_BE_APPLIED + " - " + Symbol() + " " + TRANSLATION_MESSAGE_BUY + " #" + IntegerToString(OrderTicket()) + " " + TRANSLATION_LABEL_POSITION_SIZE + " = " + DoubleToString(OrderLots(), LotStep_digits) + ", " + TRANSLATION_LABEL_ENTRY + " = " + DoubleToString(OrderOpenPrice(), _Digits) + ", " + TRANSLATION_MESSAGE_SL_WAS_MOVED_FROM + " " + DoubleToString(OrderStopLoss(), _Digits) + " " + TRANSLATION_MESSAGE_SL_WAS_MOVED_TO + " " + DoubleToString(BE_price, _Digits) + ".");
                }
            }
            else if (OrderType() == OP_SELL)
            {
                double BE_threshold = NormalizeDouble(OrderOpenPrice() - sets.BreakEvenPoints * _Point, _Digits);
                double BE_price = NormalizeDouble(OrderOpenPrice() - extra_be_distance, _Digits);
                if ((be_line_color != clrNONE) && ((BE_price < OrderStopLoss()) || (OrderStopLoss() == 0))) DrawBELine(OrderTicket(), BE_threshold, BE_price);
                if ((Ask <= BE_threshold) && (Ask <= BE_price) && ((BE_price < OrderStopLoss()) || (OrderStopLoss() == 0))) // Only move to BE if the price reached the necessary threshold, the price below the calculated BE price, and the current stop-loss is higher (or zero).
                {
                    double prev_sl = OrderStopLoss(); // Remember old SL for reporting.
                    // Write Open price to the SL field.
                    if (!OrderModify(OrderTicket(), OrderOpenPrice(), BE_price, OrderTakeProfit(), OrderExpiration()))
                        Print(TRANSLATION_MESSAGE_ERROR_MODIFYING_ORDER + ": " + ErrorDescription(GetLastError()) + ".");
                    else
                        Print(TRANSLATION_MESSAGE_BE_APPLIED + " - " + Symbol() + " " + TRANSLATION_MESSAGE_SELL + " #" + IntegerToString(OrderTicket()) + " " + TRANSLATION_LABEL_POSITION_SIZE + " = " + DoubleToString(OrderLots(), LotStep_digits) + ", " + TRANSLATION_LABEL_ENTRY + " = " + DoubleToString(OrderOpenPrice(), _Digits) + ", " + TRANSLATION_MESSAGE_SL_WAS_MOVED_FROM + " " + DoubleToString(OrderStopLoss(), _Digits) + " " + TRANSLATION_MESSAGE_SL_WAS_MOVED_TO + " " + DoubleToString(BE_price, _Digits) + ".");
                }
            }
        }
    }
}

void DrawBELine(int ticket, double be_threshold, double be_price)
{
    string obj_name = ObjectPrefix + "BE" + IntegerToString(ticket); // Line.
    ObjectCreate(ChartID(), obj_name, OBJ_HLINE, 0, TimeCurrent(), be_threshold);
    ObjectSetDouble(ChartID(), obj_name, OBJPROP_PRICE, be_threshold);
    ObjectSetInteger(ChartID(), obj_name, OBJPROP_STYLE, be_line_style);
    ObjectSetInteger(ChartID(), obj_name, OBJPROP_COLOR, be_line_color);
    ObjectSetInteger(ChartID(), obj_name, OBJPROP_WIDTH, be_line_width);
    ObjectSetInteger(ChartID(), obj_name, OBJPROP_SELECTABLE, false);
    ObjectSetInteger(ChartID(), obj_name, OBJPROP_BACK, true);
    ObjectSetString(ChartID(), obj_name, OBJPROP_TOOLTIP, DoubleToString(be_price, _Digits)); // Store BE price in the tooltip.

    if (sets.ShowLines) ObjectSetInteger(ChartID(), obj_name, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
    else ObjectSetInteger(ChartID(), obj_name, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);

    if (ShowLineLabels)
    {
        obj_name = ObjectPrefix + "BEL" + IntegerToString(ticket); // Label.
        ObjectCreate(ChartID(), obj_name, OBJ_LABEL, 0, 0, 0);
        if (sets.ShowLines) ObjectSetInteger(ChartID(), obj_name, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), obj_name, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), obj_name, OBJPROP_COLOR, clrNONE);
        ObjectSetInteger(ChartID(), obj_name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(ChartID(), obj_name, OBJPROP_HIDDEN, false);
        ObjectSetInteger(ChartID(), obj_name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(ChartID(), obj_name, OBJPROP_BACK, DrawTextAsBackground);
        ObjectSetString(ChartID(), obj_name, OBJPROP_TOOLTIP, "");
        string text = TRANSLATION_MESSAGE_BE_FOR;
        if (OrderType() == OP_BUY) text += TRANSLATION_MESSAGE_BUY;
        else if (OrderType() == OP_SELL) text += TRANSLATION_MESSAGE_SELL;
        text += " #" + IntegerToString(ticket);
        DrawLineLabel(obj_name, text, be_threshold, be_line_color, false, -6);
    }
}

// Returns a normal name for a given order type.
string OrderTypeToString(int ot)
{
    switch(ot)
    {
    case OP_BUY:
        return TRANSLATION_MESSAGE_BUY;
    case OP_BUYSTOP:
        return TRANSLATION_MESSAGE_BUY_STOP;
    case OP_BUYLIMIT:
        return TRANSLATION_MESSAGE_BUY_LIMIT;
    case OP_SELL:
        return TRANSLATION_MESSAGE_SELL;
    case OP_SELLSTOP:
        return TRANSLATION_MESSAGE_SELL_STOP;
    case OP_SELLLIMIT:
        return TRANSLATION_MESSAGE_SELL_LIMIT;
    default:
        return TRANSLATION_LABEL_UNKNOWN;
    }
}
//+------------------------------------------------------------------+