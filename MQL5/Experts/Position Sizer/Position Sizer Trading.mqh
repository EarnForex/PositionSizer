//+------------------------------------------------------------------+
//|                                       Position Sizer Trading.mqh |
//|                                  Copyright © 2025, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+

#include "errordescription.mqh"

//+------------------------------------------------------------------+
//| Main trading function.                                           |
//+------------------------------------------------------------------+
void Trade()
{
    CTrade *Trade;
    
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

    if (sets.Commentary != "") Commentary = sets.Commentary;

    if (sets.CommentAutoSuffix) Commentary += IntegerToString((int)TimeLocal());


    if ((sets.TakeProfitsNumber == 1) || (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_NETTING))
    {
        if (sets.TakeProfitsNumber > 1)
        {
            Print(TRANSLATION_MESSAGE_NETTING_MODE_DETECTED);
        }
        // No multiple TPs, use single TP for 100% of volume.
        TP[0] = sets.TakeProfitLevel;
        TPShare[0] = 100;
    }

    if ((sets.DisableTradingWhenLinesAreHidden) && (!sets.ShowLines))
    {
        Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_LINES);
        return;
    }

    if (sets.MaxSpread > 0)
    {
        int spread = (int)SymbolInfoInteger(SymbolForTrading, SYMBOL_SPREAD);
        if (spread > sets.MaxSpread)
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_SPREAD + " (", spread, ") > " + TRANSLATION_MESSAGE_MAXIMUM_SPREAD + " (", sets.MaxSpread, ").");
            return;
        }
    }

    if (sets.MaxEntrySLDistance > 0)
    {
        int CurrentEntrySLDistance = (int)(MathAbs(sets.StopLossLevel - sets.EntryLevel) / Point());
        if (CurrentEntrySLDistance > sets.MaxEntrySLDistance)
        {
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_ENTRY_SL_DISTANCE + " (", CurrentEntrySLDistance, ") > " + TRANSLATION_LABEL_MAX_ENTRY_SL_DISTANCE + " (", sets.MaxEntrySLDistance, ").");
            return;
        }
    }

    if (sets.MinEntrySLDistance > 0)
    {
        int CurrentEntrySLDistance = (int)(MathAbs(sets.StopLossLevel - sets.EntryLevel) / Point());
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
        int total = PositionsTotal();
        int cnt = 0, persymbol_cnt = 0;
        if (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING) // Makes sense in a hedging mode.
        {
            for (int i = 0; i < total; i++)
            {
                if (!PositionSelectByTicket(PositionGetTicket(i))) continue;
                if ((sets.MagicNumber != 0) && (PositionGetInteger(POSITION_MAGIC) != sets.MagicNumber)) continue;
                if (PositionGetString(POSITION_SYMBOL) == SymbolForTrading) persymbol_cnt++;
                cnt++;
            }
        }
        else // In netting, it can only count positions on different symbols.
        {
            // Need to remember that it might be so that the current trade won't increase the counter if there is already a position in this symbol. Unless it is a pending order being opened.
            for (int i = 0; i < total; i++)
            {
                if (!PositionSelectByTicket(PositionGetTicket(i))) continue;
                if ((sets.MagicNumber != 0) && (PositionGetInteger(POSITION_MAGIC) != sets.MagicNumber)) continue;
                if ((PositionGetString(POSITION_SYMBOL) == SymbolForTrading) && (sets.EntryType == Instant)) continue; // Skip current symbol, because in netting mode, new trade won't create another position, but will rather add/subtract from the existing one.
                cnt++;
            }
        }
        
        // Count pending orders.
        total = OrdersTotal();
        for (int i = 0; i < total; i++)
        {
            if (!OrderSelect(OrderGetTicket(i))) continue;
            if ((sets.MagicNumber != 0) && (OrderGetInteger(ORDER_MAGIC) != sets.MagicNumber)) continue;
            if (OrderGetString(ORDER_SYMBOL) == SymbolForTrading) persymbol_cnt++;
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
    
    double PositionSize = OutputPositionSize;
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
            Alert(TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_INFINITE_PER_SYMBOL_POTENTIAL_RISK + ".");
            return;
        }
    }

    datetime expiry = 0;
    if ((sets.EntryType != Instant) && (sets.ExpiryMinutes > 0))
    {
        expiry = TimeCurrent() + sets.ExpiryMinutes * 60;
    }

    Trade = new CTrade;
    Trade.SetDeviationInPoints(sets.MaxSlippage);
    if (sets.MagicNumber > 0) Trade.SetExpertMagicNumber(sets.MagicNumber);

    ENUM_SYMBOL_TRADE_EXECUTION Execution_Mode = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(SymbolForTrading, SYMBOL_TRADE_EXEMODE);
    string warning_suffix = "";
    if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (IgnoreMarketExecutionMode) && (sets.EntryType == Instant)) warning_suffix = TRANSLATION_MESSAGE_IGNORE_MARKET_EXECUTION_MODE_WARNING;
    Print(TRANSLATION_MESSAGE_EXECUTION_MODE + ": ", EnumToString(Execution_Mode), warning_suffix);

    if (SymbolInfoInteger(SymbolForTrading, SYMBOL_FILLING_MODE) == SYMBOL_FILLING_FOK)
    {
        Print(TRANSLATION_MESSAGE_ORDER_FILLING_MODE + ": " + TRANSLATION_MESSAGE_FILL_OR_KILL + ".");
        Trade.SetTypeFilling(ORDER_FILLING_FOK);
    }
    else if (SymbolInfoInteger(SymbolForTrading, SYMBOL_FILLING_MODE) == SYMBOL_FILLING_IOC)
    {
        Print(TRANSLATION_MESSAGE_ORDER_FILLING_MODE + ": " + TRANSLATION_MESSAGE_IMMEDIATE_OR_CANCEL + ".");
        Trade.SetTypeFilling(ORDER_FILLING_IOC);
    }

    double existing_volume_buy = 0, existing_volume_sell = 0;
    if ((sets.SubtractPendingOrders) || (sets.SubtractPositions))
    {
        CalculateOpenVolume(existing_volume_buy, existing_volume_sell);
        Print(TRANSLATION_MESSAGE_FOUND_EXISTING_BUY_VOLUME + " = ", DoubleToString(existing_volume_buy, LotStep_digits));
        Print(TRANSLATION_MESSAGE_FOUND_EXISTING_SELL_VOLUME + " = ", DoubleToString(existing_volume_sell, LotStep_digits));
    }

    bool isOrderPlacementFailing = false; // Track if any of the order-operations fail.
    bool AtLeastOneOrderExecuted = false; // Track if at least one order got executed. Required for cases when some of the multiple TP orders have volume < minimum volume and don't get executed.

    ENUM_ORDER_TYPE ot;
    if ((sets.EntryType == Pending) || (sets.EntryType == StopLimit))
    {
        // Sell
        if (sets.TradeDirection == Short)
        {
            // Stop
            if (sets.EntryLevel < SymbolInfoDouble(SymbolForTrading, SYMBOL_BID)) ot = ORDER_TYPE_SELL_STOP;
            // Limit
            else ot = ORDER_TYPE_SELL_LIMIT;
            // Stop Limit
            if (sets.EntryType == StopLimit) ot = ORDER_TYPE_SELL_STOP_LIMIT;
        }
        // Buy
        else
        {
            // Stop
            if (sets.EntryLevel > SymbolInfoDouble(SymbolForTrading, SYMBOL_ASK)) ot = ORDER_TYPE_BUY_STOP;
            // Limit
            else ot = ORDER_TYPE_BUY_LIMIT;
            // Stop Limit
            if (sets.EntryType == StopLimit) ot = ORDER_TYPE_BUY_STOP_LIMIT;
        }

        if ((sets.SubtractPendingOrders) || (sets.SubtractPositions))
        {
            if ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_STOP_LIMIT)) PositionSize -= existing_volume_buy;
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

        double new_ps = MaxVolumeCheck(PositionSize);
        if (new_ps < 0) return; // Doesn't conform restrictions and cannot be reduced.
        if (PositionSize != new_ps)
        {
            PositionSize = new_ps;
            PositionSizeToArray(PositionSize);
        }
       
        if ((sets.AskForConfirmation) && (!CheckConfirmation(ot, PositionSize, sets.StopLossLevel, sets.TakeProfitLevel, expiry)))
        {
            delete Trade;
            return;
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
        
        // Going through a cycle to execute multiple TP trades.
        for (int j = 0; j < sets.TakeProfitsNumber; j++)
        {
            if (ArrayPositionSize[j] == 0) continue; // Calculated PS < broker's minimum.
            double tp = NormalizeDouble(TP[j], _Digits);
            double position_size = NormalizeDouble(ArrayPositionSize[j], LotStep_digits);
            double sl = sets.StopLossLevel;

            if (sets.DoNotApplyStopLoss) sl = 0;
            if (sets.DoNotApplyTakeProfit) tp = 0;

            if ((tp != 0) && (((tp <= sets.EntryLevel) && ((ot == ORDER_TYPE_BUY_STOP_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_LIMIT))) || ((tp >= sets.EntryLevel) && ((ot == ORDER_TYPE_SELL_STOP_LIMIT) || (ot == ORDER_TYPE_SELL_STOP) || (ot == ORDER_TYPE_SELL_LIMIT))))) tp = 0; // Do not apply TP if it is invald. SL will still be applied.
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
                ENUM_ORDER_TYPE_TIME expiry_type = ORDER_TIME_GTC;
                if (expiry > 0)
                {
                    expiry_type = ORDER_TIME_SPECIFIED;
                }
                if (!Trade.OrderOpen(SymbolForTrading, ot, sub_position_size, sets.EntryType == StopLimit ? sets.EntryLevel : 0, sets.EntryType == StopLimit ? sets.StopPriceLevel : sets.EntryLevel, sl, tp, expiry_type, expiry, Commentary))
                {
                    Print(TRANSLATION_MESSAGE_ERROR_SENDING_ORDER + ": ", Trade.ResultRetcodeDescription() + ".");
                    isOrderPlacementFailing = true;
                }
                else
                {
                    if (sets.TakeProfitsNumber == 1) Print(TRANSLATION_MESSAGE_ORDER_EXECUTED + " " + TRANSLATION_MESSAGE_TICKET + ": ", Trade.ResultOrder(), ".");
                    else Print(TRANSLATION_MESSAGE_ORDER + " #", j, " " + TRANSLATION_MESSAGE_EXECUTED + ". " + TRANSLATION_MESSAGE_TICKET + ": ", Trade.ResultOrder(), ".");
                    AtLeastOneOrderExecuted = true;
                }
            }
        }
    }
    // Instant
    else
    {
        // Sell
        if (sets.StopLossLevel > sets.EntryLevel) ot = ORDER_TYPE_SELL;
        // Buy
        else ot = ORDER_TYPE_BUY;

        if ((sets.SubtractPendingOrders) || (sets.SubtractPositions))
        {
            if (ot == ORDER_TYPE_BUY) PositionSize -= existing_volume_buy;
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

        double new_ps = MaxVolumeCheck(PositionSize);
        if (new_ps < 0) return; // Doesn't conform restrictions and cannot be reduced.
        if (PositionSize != new_ps)
        {
            PositionSize = new_ps;
            PositionSizeToArray(PositionSize);
        }
        
        if ((sets.AskForConfirmation) && (!CheckConfirmation(ot, PositionSize, sets.StopLossLevel, sets.TakeProfitLevel)))
        {
            delete Trade;
            return;
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

        // Will be used if MarketModeApplySLTPAfterAllTradesExecuted == true.
        ulong array_of_deals[], array_of_orders[];
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

            if ((order_tp != 0) && (((order_tp <= sets.EntryLevel) && (ot == ORDER_TYPE_BUY)) || ((order_tp >= sets.EntryLevel) && (ot == ORDER_TYPE_SELL)))) order_tp = 0; // Do not apply TP if it is invald. SL will still be applied.

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
            
                if (!Trade.PositionOpen(SymbolForTrading, ot, sub_position_size, sets.EntryLevel, order_sl, order_tp, Commentary))
                {
                    Print(TRANSLATION_MESSAGE_ERROR_SENDING_ORDER + ": ", Trade.ResultRetcodeDescription() + ".");
                    isOrderPlacementFailing = true;
                }
                else
                {
                    MqlTradeResult result;
                    Trade.Result(result);
                    if ((Trade.ResultRetcode() != 10008) && (Trade.ResultRetcode() != 10009) && (Trade.ResultRetcode() != 10010))
                    {
                        Print(TRANSLATION_MESSAGE_ERROR_OPENING_POSITION + ". " + TRANSLATION_MESSAGE_RETURN_CODE + ": ", Trade.ResultRetcodeDescription());
                        isOrderPlacementFailing = true;
                        break;
                    }
    
                    Print(TRANSLATION_MESSAGE_INITIAL_RETURN_CODE + ": ", Trade.ResultRetcodeDescription());
    
                    ulong order = result.order;
                    Print(TRANSLATION_MESSAGE_ORDER_ID + ": ", order);
    
                    ulong deal = result.deal;
                    Print(TRANSLATION_MESSAGE_DEAL_ID + ": ", deal);
                    AtLeastOneOrderExecuted = true;
                    if (!sets.DoNotApplyTakeProfit) tp = TP[j];
                    // Market execution mode - application of SL/TP.
                    if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (sets.EntryType == Instant) && (!IgnoreMarketExecutionMode) && ((sl != 0) || (tp != 0)))
                    {
                        if (MarketModeApplySLTPAfterAllTradesExecuted) // Finish opening all trades, then apply all SLs and TPs.
                        {
                            array_cnt++;
                            ArrayResize(array_of_deals, array_cnt);
                            ArrayResize(array_of_orders, array_cnt);
                            ArrayResize(array_of_sl, array_cnt);
                            ArrayResize(array_of_tp, array_cnt);
                            ArrayResize(array_of_ot, array_cnt);
                            array_of_deals[array_cnt - 1] = deal;
                            array_of_orders[array_cnt - 1] = order;
                            array_of_sl[array_cnt - 1] = sl;
                            array_of_tp[array_cnt - 1] = tp;
                            array_of_ot[array_cnt - 1] = ot;
                        }
                        else
                        {
                            if (!ApplySLTPToOrder(Trade, deal, order, sl, tp, ot))
                            {
                                isOrderPlacementFailing = true;
                            }
                        }
                    }
                }
            } // Cycle for splitting up trade/subtrade into more subtrades ends here.
        }
        // Run position adjustment if necessary.
        for (int j = 0; j < array_cnt; j++)
        {
            if (!ApplySLTPToOrder(Trade, array_of_deals[j], array_of_orders[j], array_of_sl[j], array_of_tp[j], array_of_ot[j]))
            {
                isOrderPlacementFailing = true;
            }
        }
    }    
        
    if (!DisableTradingSounds) PlaySound((isOrderPlacementFailing) || (!AtLeastOneOrderExecuted) ? "timeout.wav" : "ok.wav");

    delete Trade;
}

// Applies SL/TP to a single position (used in the Market execution mode).
// Returns false in case of a failure, true - in case of a success.
bool ApplySLTPToOrder(CTrade& trade_object, ulong deal, ulong order, double sl, double tp, ENUM_ORDER_TYPE ot)
{
    bool isOrderPlacementFailing = false;
    if ((tp != 0) && (((tp <= sets.EntryLevel) && (ot == ORDER_TYPE_BUY)) || ((tp >= sets.EntryLevel) && (ot == ORDER_TYPE_SELL)))) tp = 0; // Do not apply TP if it is invald. SL will still be applied.
    // Not all brokers return deal.
    if (deal != 0)
    {
        if (HistoryDealSelect(deal))
        {
            long position = HistoryDealGetInteger(deal, DEAL_POSITION_ID);
            Print(TRANSLATION_MESSAGE_POSITION_ID + ": ", position);

            if (!trade_object.PositionModify(position, sl, tp))
            {
                int error = GetLastError();
                Print(TRANSLATION_MESSAGE_ERROR_MODIFYING_POSITION + ": ", IntegerToString(error), " - ", ErrorDescription(error), ".");
                isOrderPlacementFailing = true;
            }
            else Print(TRANSLATION_MESSAGE_SL_TP_APPLIED);
        }
        else
        {
            int error = GetLastError();
            Print(TRANSLATION_MESSAGE_ERROR_SELECTING_DEAL + ": ", IntegerToString(error), " - ", ErrorDescription(error), ".");
            isOrderPlacementFailing = true;
        }
    }
    // Wait for position to open then find it using the order ID.
    else
    {
        // Run a waiting cycle until the order becomes a positoin.
        for (int i = 0; i < 10; i++)
        {
            Print(TRANSLATION_MESSAGE_WAITING);
            Sleep(1000);
            if (PositionSelectByTicket(order)) break;
        }
        if (!PositionSelectByTicket(order))
        {
            int error = GetLastError();
            Print(TRANSLATION_MESSAGE_ERROR_SELECTING_POSITIONS + ": ", IntegerToString(error), " - ", ErrorDescription(error), ".");
            isOrderPlacementFailing = true;
        }
        else
        {
            if (!trade_object.PositionModify(order, sl, tp))
            {
                int error = GetLastError();
                Print(TRANSLATION_MESSAGE_ERROR_MODIFYING_POSITION + ": ", IntegerToString(error), " - ", ErrorDescription(error), ".");
                isOrderPlacementFailing = true;
            }
            else Print(TRANSLATION_MESSAGE_SL_TP_APPLIED);
        }
    }

    if (!isOrderPlacementFailing) return true;
    else return false;
}                    

// Calculate volume of open positions and/or pending orders.
// Counts volumes separately for buy and sell trades and writes them into parameterss.
void CalculateOpenVolume(double &volume_buy, double &volume_sell)
{
    if (sets.SubtractPendingOrders)
    {
        int total = OrdersTotal();
        for (int i = 0; i < total; i++)
        {
            // Select an order.
            if (!OrderSelect(OrderGetTicket(i))) continue;
            // Skip orders with a different trading instrument.
            if (OrderGetString(ORDER_SYMBOL) != SymbolForTrading) continue;
            // If magic number is given via PS panel and order's magic number is different - skip.
            if ((sets.MagicNumber != 0) && (OrderGetInteger(ORDER_MAGIC) != sets.MagicNumber)) continue;

            // Buy orders
            if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP)) volume_buy += OrderGetDouble(ORDER_VOLUME_CURRENT);
            // Sell orders
            else if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP)) volume_sell += OrderGetDouble(ORDER_VOLUME_CURRENT);
        }
    }

    if (sets.SubtractPositions)
    {
        int total = PositionsTotal();
        for (int i = 0; i < total; i++)
        {
            // Works with hedging and netting.
            if (!PositionSelectByTicket(PositionGetTicket(i))) continue;
            // Skip positions with a different trading instrument.
            if (PositionGetString(POSITION_SYMBOL) != SymbolForTrading) continue;
            // If magic number is given via PS panel and position's magic number is different - skip.
            if ((sets.MagicNumber != 0) && (PositionGetInteger(POSITION_MAGIC) != sets.MagicNumber)) continue;

            // Long positions
            if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) volume_buy += PositionGetDouble(POSITION_VOLUME);
            // Short positions
            else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) volume_sell += PositionGetDouble(POSITION_VOLUME);
        }
    }
}

//+------------------------------------------------------------------+
//| Check confirmation for order opening via dialog window.          |
//+------------------------------------------------------------------+
bool CheckConfirmation(const ENUM_ORDER_TYPE ot, const double PositionSize, const double sl, const double tp, const datetime expiry = 0)
{
    // Evoke confirmation modal window.
    string caption = TRANSLATION_MESSAGE_POSITION_SIZER_ON + SymbolForTrading + " @ " + StringSubstr(EnumToString((ENUM_TIMEFRAMES)Period()), 7) + ": " + TRANSLATION_MESSAGE_EXECUTE_TRADE;
    string message;
    string order_type_text = OrderTypeToString(ot);
    string currency = AccountInfoString(ACCOUNT_CURRENCY);

    message = TRANSLATION_MESSAGE_ORDER + ": " + order_type_text + "\n";
    message += TRANSLATION_MESSAGE_SIZE + ": " + DoubleToString(PositionSize, LotStep_digits);
    if (sets.TakeProfitsNumber > 1) message += " (" + TRANSLATION_MESSAGE_MULTIPLE + ")";
    message += "\n";
    if (sets.AccountButton == Balance) message += TRANSLATION_BUTTON_ACCOUNT_BALANCE;
    else if (sets.AccountButton == Equity) message += TRANSLATION_BUTTON_ACCOUNT_EQUITY;
    else if (sets.AccountButton == Balance_minus_Risk) message += TRANSLATION_BUTTON_BALANCE_MINUS_CPR;
    message += ": " + FormatDouble(DoubleToString(AccSize, 2)) + " " + AccountCurrency + "\n";
    message += TRANSLATION_LABEL_RISK + ": " + FormatDouble(DoubleToString(OutputRiskMoney)) + " " + AccountCurrency + "\n";
    if (PositionMargin != 0) message += TRANSLATION_TAB_BUTTON_MARGIN + ": " + FormatDouble(DoubleToString(PositionMargin, 2)) + " " + AccountCurrency + "\n";
    if (sets.StopPriceLevel > 0) message += TRANSLATION_LABEL_STOPPRICE + ": " + DoubleToString(sets.StopPriceLevel, _Digits) + "\n";
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
        return false;
    }
    return true;
}

// Does trailing based on the Magic number and symbol.
void DoTrailingStop()
{
    CTrade *Trade;
    Trade = new CTrade;
    Trade.SetDeviationInPoints(sets.MaxSlippage);
    if (sets.MagicNumber > 0) Trade.SetExpertMagicNumber(sets.MagicNumber);

    if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!TerminalInfoInteger(TERMINAL_CONNECTED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED))) return;

    for (int i = 0; i < PositionsTotal(); i++)
    {
        ulong ticket = PositionGetTicket(i);
        if (ticket <= 0) Print(TRANSLATION_MESSAGE_POSITIONGETTICKET_FAILED + ": " + ErrorDescription(GetLastError()) + ".");
        else if (SymbolInfoInteger(PositionGetString(POSITION_SYMBOL), SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED) continue;
        else
        {
            if ((PositionGetString(POSITION_SYMBOL) != SymbolForTrading) || (PositionGetInteger(POSITION_MAGIC) != sets.MagicNumber)) continue;
            if ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
                double SL = NormalizeDouble(SymbolInfoDouble(SymbolForTrading, SYMBOL_BID) - sets.TrailingStopPoints * _Point, _Digits);
                if (SL > PositionGetDouble(POSITION_SL))
                {
                    double prev_sl = PositionGetDouble(POSITION_SL); // Remember old SL for reporting.
                    if (!Trade.PositionModify(ticket, SL, PositionGetDouble(POSITION_TP)))
                        Print(TRANSLATION_MESSAGE_POSITIONMODIFY_FAILED_BUY_TSL + ": " + ErrorDescription(GetLastError()) + ".");
                    else
                        Print(TRANSLATION_MESSAGE_TSL_APPLIED + " - " + SymbolForTrading + " " + TRANSLATION_MESSAGE_BUY + " #" + IntegerToString(ticket) + " " + TRANSLATION_LABEL_POSITION_SIZE + " = " + DoubleToString(PositionGetDouble(POSITION_VOLUME), LotStep_digits) + ", " + TRANSLATION_LABEL_ENTRY + " = " + DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), _Digits) + ", " + TRANSLATION_MESSAGE_SL_WAS_MOVED_FROM + " " + DoubleToString(prev_sl, _Digits) + " " + TRANSLATION_MESSAGE_SL_WAS_MOVED_TO + " " + DoubleToString(SL, _Digits) + ".");
                }
            }
            else if ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            {
                double SL = NormalizeDouble(SymbolInfoDouble(SymbolForTrading, SYMBOL_ASK) + sets.TrailingStopPoints * _Point, _Digits);
                if ((SL < PositionGetDouble(POSITION_SL)) || (PositionGetDouble(POSITION_SL) == 0))
                {
                    double prev_sl = PositionGetDouble(POSITION_SL); // Remember old SL for reporting.
                    if (!Trade.PositionModify(ticket, SL, PositionGetDouble(POSITION_TP)))
                        Print(TRANSLATION_MESSAGE_POSITIONMODIFY_FAILED_SELL_TSL + ": " + ErrorDescription(GetLastError()) + ".");
                    else
                        Print(TRANSLATION_MESSAGE_TSL_APPLIED + " - " + SymbolForTrading + " " + TRANSLATION_MESSAGE_SELL + " #" + IntegerToString(ticket) + " " + TRANSLATION_LABEL_POSITION_SIZE + " = " + DoubleToString(PositionGetDouble(POSITION_VOLUME), LotStep_digits) + ", " + TRANSLATION_LABEL_ENTRY + " = " + DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), _Digits) + ", " + TRANSLATION_MESSAGE_SL_WAS_MOVED_FROM + " " + DoubleToString(prev_sl, _Digits) + " " + TRANSLATION_MESSAGE_SL_WAS_MOVED_TO + " " + DoubleToString(SL, _Digits) + ".");
                }
            }
        }
    }
    
    delete Trade;
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
            ulong ticket = StringToInteger(StringSubstr(obj_name, StringLen(ObjectPrefix + "BE")));
            if (!PositionSelectByTicket(ticket)) // No longer exists.
            {
                ObjectDelete(ChartID(), obj_name); // Delete the line.
                if (ShowMainLineLabels) ObjectDelete(ChartID(), ObjectPrefix + "BEL" + IntegerToString(ticket)); // Delete the label.
            }
            else // Check if already triggered. Position selected.
            {
                double be_price = NormalizeDouble(StringToDouble(ObjectGetString(ChartID(), obj_name, OBJPROP_TOOLTIP)), _Digits);
                if (((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) && (PositionGetDouble(POSITION_SL) >= be_price)) // Already triggered.
                 || ((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) && (PositionGetDouble(POSITION_SL) <= be_price) && (PositionGetDouble(POSITION_SL) != 0)))
                {
                    ObjectDelete(ChartID(), obj_name); // Delete the line.
                    if (ShowMainLineLabels) ObjectDelete(ChartID(), ObjectPrefix + "BEL" + IntegerToString(ticket)); // Delete the label.
                }
            }
        }
    }
    
    if (sets.BreakEvenPoints <= 0) return;
    
    if ((!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) || (!MQLInfoInteger(MQL_TRADE_ALLOWED))) return;
    
    CTrade *Trade;
    Trade = new CTrade;
    Trade.SetDeviationInPoints(sets.MaxSlippage);
    if (sets.MagicNumber > 0) Trade.SetExpertMagicNumber(sets.MagicNumber);

    for (int i = 0; i < PositionsTotal(); i++)
    {
        ulong ticket = PositionGetTicket(i);
        if (ticket <= 0) Print(TRANSLATION_MESSAGE_POSITIONGETTICKET_FAILED + ": " + ErrorDescription(GetLastError()) + ".");
        else if (SymbolInfoInteger(PositionGetString(POSITION_SYMBOL), SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED) continue;
        else
        {
            if ((PositionGetString(POSITION_SYMBOL) != SymbolForTrading) || (PositionGetInteger(POSITION_MAGIC) != sets.MagicNumber)) continue;

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

            if ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
                double BE_threshold = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN) + sets.BreakEvenPoints * _Point, _Digits);
                double BE_price = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN) + extra_be_distance, _Digits);
                if ((be_line_color != clrNONE) && (BE_price > PositionGetDouble(POSITION_SL))) DrawBELine((int)PositionGetInteger(POSITION_TICKET), BE_threshold, BE_price); // Only draw if not triggered yet.
                double Bid = SymbolInfoDouble(SymbolForTrading, SYMBOL_BID);

                if ((Bid >= BE_threshold) && (Bid >= BE_price) && (BE_price > PositionGetDouble(POSITION_SL))) // Only move to BE if the price reached the necessary threshold, the price is above the calculated BE price, and the current stop-loss is lower.
                {
                    double prev_sl = PositionGetDouble(POSITION_SL); // Remember old SL for reporting.
                    // Write Open price to the SL field.
                    if (!Trade.PositionModify(ticket, BE_price, PositionGetDouble(POSITION_TP)))
                        Print(TRANSLATION_MESSAGE_POSITIONMODIFY_FAILED_BUY_BE + ": " + ErrorDescription(GetLastError()) + ".");
                    else
                        Print(TRANSLATION_MESSAGE_BE_APPLIED + " - " + SymbolForTrading + " " + TRANSLATION_MESSAGE_BUY + " #" + IntegerToString(ticket) + " " + TRANSLATION_LABEL_POSITION_SIZE + " = " + DoubleToString(PositionGetDouble(POSITION_VOLUME), LotStep_digits) + ", " + TRANSLATION_LABEL_ENTRY + " = " + DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), _Digits) + ", " + TRANSLATION_MESSAGE_SL_WAS_MOVED_FROM + " " + DoubleToString(prev_sl, _Digits) + ".");
                }
            }
            else if ((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            {
                double BE_threshold = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN) - sets.BreakEvenPoints * _Point, _Digits);
                double BE_price = NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN) - extra_be_distance, _Digits);
                if ((be_line_color != clrNONE) && ((BE_price < PositionGetDouble(POSITION_SL)) || (PositionGetDouble(POSITION_SL) == 0))) DrawBELine(PositionGetInteger(POSITION_TICKET), BE_threshold, BE_price);
                double Ask = SymbolInfoDouble(SymbolForTrading, SYMBOL_ASK);

                if ((Ask <= BE_threshold) && (Ask <= BE_price) && ((BE_price < PositionGetDouble(POSITION_SL)) || (PositionGetDouble(POSITION_SL) == 0))) // Only move to BE if the price reached the necessary threshold, the price below the calculated BE price, and the current stop-loss is higher (or zero).
                {
                    double prev_sl = PositionGetDouble(POSITION_SL); // Remember old SL for reporting.
                    // Write Open price to the SL field.
                    if (!Trade.PositionModify(ticket, BE_price, PositionGetDouble(POSITION_TP)))
                        Print(TRANSLATION_MESSAGE_POSITIONMODIFY_FAILED_SELL_BE + ": " + ErrorDescription(GetLastError()) + ".");
                    else
                        Print(TRANSLATION_MESSAGE_BE_APPLIED + " - " + SymbolForTrading + " " + TRANSLATION_MESSAGE_SELL + " #" + IntegerToString(ticket) + " " + TRANSLATION_LABEL_POSITION_SIZE + " = " + DoubleToString(PositionGetDouble(POSITION_VOLUME), LotStep_digits) + ", " + TRANSLATION_LABEL_ENTRY + " = " + DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), _Digits) + ", " + TRANSLATION_MESSAGE_SL_WAS_MOVED_FROM + " " + DoubleToString(prev_sl, _Digits) + ".");
                }
            }
        }
    }
    
    delete Trade;
}

// Returns existing volume: positions + orders combined.
// all_symbols = true - for all symbols.
// all_symbols = false - for the current symbol only.
double CalculateExistingVolume(bool all_symbols = true)
{
    int total = PositionsTotal();
    double volume = 0;
    if (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING) // Makes sense in a hedging mode.
    {
        for (int i = 0; i < total; i++)
        {
            if (!PositionSelectByTicket(PositionGetTicket(i))) continue;
            if ((sets.MagicNumber != 0) && (PositionGetInteger(POSITION_MAGIC) != sets.MagicNumber)) continue;
            if ((!all_symbols) && (PositionGetString(POSITION_SYMBOL) != SymbolForTrading)) continue;
            volume += PositionGetDouble(POSITION_VOLUME);
        }
    }
    else // Netting. Volume will only be increased if trade direction is the same or it is a different symbol. Or else if it is a pending order being opened.
    {
        for (int i = 0; i < total; i++)
        {
            if (!PositionSelectByTicket(PositionGetTicket(i))) continue;
            if ((sets.MagicNumber != 0) && (PositionGetInteger(POSITION_MAGIC) != sets.MagicNumber)) continue;
            if ((!all_symbols) && (PositionGetString(POSITION_SYMBOL) != SymbolForTrading)) continue;
            if ((sets.EntryType == Pending) || (sets.EntryType == StopLimit) ||
                // Total case only - always add volume from other symbols:
                (PositionGetString(POSITION_SYMBOL) != SymbolForTrading) || 
                // Total and per symbol - add volume for market orders only if the position is in the same direction. Otherwise, the volume will be decreased:
                ((PositionGetString(POSITION_SYMBOL) == SymbolForTrading) && (((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) && (sets.TradeDirection == Long)) || ((PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) && (sets.TradeDirection == Short)))))
            {
                volume += PositionGetDouble(POSITION_VOLUME);
            }
        }
    }
    
    // Count pending orders' volume as well.
    total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (!OrderSelect(OrderGetTicket(i))) continue;
        if ((sets.MagicNumber != 0) && (OrderGetInteger(ORDER_MAGIC) != sets.MagicNumber)) continue;
        if ((!all_symbols) && (OrderGetString(ORDER_SYMBOL) != SymbolForTrading)) continue;
        volume += OrderGetDouble(ORDER_VOLUME_CURRENT);
    }
    return volume;
}

void DrawBELine(ulong ticket, double be_threshold, double be_price)
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

    if (ShowMainLineLabels)
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
        if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) text += TRANSLATION_MESSAGE_BUY;
        else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) text += TRANSLATION_MESSAGE_SELL;
        text += " #" + IntegerToString(ticket);
        DrawLineLabel(obj_name, text, be_threshold, be_line_color, false, -6);
    }
}

// Checks if the position size conforms to max volume restrictions and adjusts it accordingly if possible. Returns old position size, new position size, or the error (-1).
double MaxVolumeCheck(double ps)
{
    if (sets.MaxPositionSizeTotal > 0)
    {
        double volume = CalculateExistingVolume(); // Total
        if (volume + ps > sets.MaxPositionSizeTotal)
        {
            string alert_text = TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_TOTAL_VOLUME + " (" + DoubleToString(volume, LotStep_digits) + ") + " + TRANSLATION_MESSAGE_NTAT_NEW_POSITION_VOLUME + " (" + DoubleToString(ps, LotStep_digits) + ") >= " + TRANSLATION_MESSAGE_NTAT_MAXIMUM_TOTAL_VOLUME + " (" + DoubleToString(sets.MaxPositionSizeTotal, LotStep_digits) + ").";
            if (!LessRestrictiveMaxLimits)
            {
                Alert(alert_text);
                return -1;
            }
            else
            {
                double new_ps = sets.MaxPositionSizeTotal - volume;
                if (new_ps >= MinLot)
                {
                    new_ps = AdjustPositionSizeByMinMaxStep(new_ps);
                    Alert(TRANSLATION_MESSAGE_TAKING_SMALLER_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_TOTAL_VOLUME + " (" + DoubleToString(volume, LotStep_digits) + ") + " + TRANSLATION_MESSAGE_NTAT_NEW_POSITION_VOLUME + " (" + DoubleToString(ps, LotStep_digits) + ") >= " + TRANSLATION_MESSAGE_NTAT_MAXIMUM_TOTAL_VOLUME + " (" + DoubleToString(sets.MaxPositionSizeTotal, LotStep_digits) + "). " + TRANSLATION_MESSAGE_NEW_POSITION_SIZE + " = " + DoubleToString(new_ps, LotStep_digits));
                    return new_ps;
                }
                else
                {
                    Alert(alert_text + " " + TRANSLATION_MESSAGE_CANNOT_TAKE_SMALLER_TRADE);
                    return -1;
                }
            }
        }
    }
    if (sets.MaxPositionSizePerSymbol > 0)
    {
        double volume = CalculateExistingVolume(false); // Per symbol
        if (volume + ps > sets.MaxPositionSizePerSymbol)
        {
            string alert_text = TRANSLATION_MESSAGE_NOT_TAKING_A_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_PER_SYMBOL_VOLUME + " (" + DoubleToString(volume, LotStep_digits) + ") + " + TRANSLATION_MESSAGE_NTAT_NEW_POSITION_VOLUME + " (" + DoubleToString(ps, LotStep_digits) + ") >= " + TRANSLATION_MESSAGE_NTAT_MAXIMUM_PER_SYMBOL_VOLUME + " (" + DoubleToString(sets.MaxPositionSizePerSymbol, LotStep_digits) + ").";
            if (!LessRestrictiveMaxLimits)
            {
                Alert(alert_text);
                return - 1;
            }
            else
            {
                double new_ps = sets.MaxPositionSizePerSymbol - volume;
                if (new_ps >= MinLot)
                {
                    new_ps = AdjustPositionSizeByMinMaxStep(new_ps);
                    Alert(TRANSLATION_MESSAGE_TAKING_SMALLER_TRADE + " - " + TRANSLATION_MESSAGE_NTAT_PER_SYMBOL_VOLUME + " (" + DoubleToString(volume, LotStep_digits) + ") + " + TRANSLATION_MESSAGE_NTAT_NEW_POSITION_VOLUME + " (" + DoubleToString(ps, LotStep_digits) + ") >= " + TRANSLATION_MESSAGE_NTAT_MAXIMUM_PER_SYMBOL_VOLUME + " (" + DoubleToString(sets.MaxPositionSizePerSymbol, LotStep_digits) + ")." + TRANSLATION_MESSAGE_NEW_POSITION_SIZE + " = " + DoubleToString(new_ps, LotStep_digits));
                    return new_ps;
                }
                else
                {
                    Alert(alert_text + " " + TRANSLATION_MESSAGE_CANNOT_TAKE_SMALLER_TRADE);
                    return -1;
                }
            }
        }
    }
    return ps;
}

// Returns a normal name for a given order type.
string OrderTypeToString(ENUM_ORDER_TYPE ot)
{
    switch(ot)
    {
    case ORDER_TYPE_BUY:
        return TRANSLATION_MESSAGE_BUY;
    case ORDER_TYPE_BUY_STOP:
        return TRANSLATION_MESSAGE_BUY_STOP;
    case ORDER_TYPE_BUY_LIMIT:
        return TRANSLATION_MESSAGE_BUY_LIMIT;
    case ORDER_TYPE_BUY_STOP_LIMIT:
        return TRANSLATION_MESSAGE_BUY_STOP_LIMIT;
    case ORDER_TYPE_SELL:
        return TRANSLATION_MESSAGE_SELL;
    case ORDER_TYPE_SELL_STOP:
        return TRANSLATION_MESSAGE_SELL_STOP;
    case ORDER_TYPE_SELL_LIMIT:
        return TRANSLATION_MESSAGE_SELL_LIMIT;
    case ORDER_TYPE_SELL_STOP_LIMIT:
        return TRANSLATION_MESSAGE_SELL_STOP_LIMIT;
    default:
        return TRANSLATION_LABEL_UNKNOWN;
    }
}

// Returns a normal name for a given position type.
string PositionTypeToString(ENUM_POSITION_TYPE pt)
{
    switch(pt)
    {
    case POSITION_TYPE_BUY:
        return TRANSLATION_MESSAGE_BUY;
    case POSITION_TYPE_SELL:
        return TRANSLATION_MESSAGE_SELL;
    default:
        return TRANSLATION_LABEL_UNKNOWN;
    }
}
//+------------------------------------------------------------------+