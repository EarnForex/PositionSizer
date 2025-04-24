//+------------------------------------------------------------------+
//|                                                TesterSupport.mqh |
//|                                  Copyright © 2025, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+

// Checks chart objects and generates events if required:
// - Buttons: check OBJPROP_STATE.
// - Edits: check vs. previous registered value.
// - Checkbox: simply check state.
void ListenToChartEvents(string panel_id)
{
   int panel_id_length = StringLen(panel_id);
    
    // Standard chart event parameters to pass to the handler:
    long   lparam = 0;
    double dparam = 0.0;
    string sparam = "";
    
    // Start with the buttons:
    int buttons_total = ObjectsTotal(0, -1, OBJ_BUTTON);
    for (int i = 0; i < buttons_total; i++)
    {
        string object_name = ObjectName(0, i, -1, OBJ_BUTTON);
        // Looking for 12345m_BtnABCDE object names.
        if (StringSubstr(object_name, 0, panel_id_length + 2) != panel_id + "m_") continue;
        
        if ((bool)ObjectGetInteger(0, object_name, OBJPROP_STATE) == true) // Pressed button.
        {
            lparam = ExtDialog.FindControlId(object_name);
            if (lparam == -1)
            {
                // If no control id, this is likely some external button or there is an error.
                // Try to process it as a standard click chart event (non-custom).
                OnChartEvent(CHARTEVENT_OBJECT_CLICK, lparam, dparam, object_name);
                // It can also be additional panel buttons that don't have id.
                OnChartEvent(CHARTEVENT_CUSTOM + ON_CLICK, lparam, dparam, object_name);
            }
            else
            {
                OnChartEvent(CHARTEVENT_CUSTOM + ON_CLICK, lparam, dparam, object_name);
            }
            ObjectSetInteger(0, object_name, OBJPROP_STATE, false); // Unpress it.
            return; // No need to check anything else.
        }
    }

    // Do edits:
    int edits_total = ObjectsTotal(0, -1, OBJ_EDIT);
    for (int i = 0; i < edits_total; i++)
    {
        string object_name = ObjectName(0, i, -1, OBJ_EDIT);
        // Looking for 12345m_EdtABCDE object names.
        if (StringSubstr(object_name, 0, panel_id_length + 5) == panel_id + "m_Edt")
        {

            string text = StringTrimRight(StringTrimLeft(ObjectGetString(0, object_name, OBJPROP_TEXT)));
            double double_from_text = StringToDouble(text);

            // Prepare the same for the balance/commission fields. Need to strip it out of formatting:
            string text_stripped = text;
            // Try to swap , for . in the "normal" decimal separator positions only. Other commas will be simply removed.
            if (StringGetCharacter(text_stripped, StringLen(text_stripped) - 2) == ',') StringSetCharacter(text_stripped, StringLen(text_stripped) - 2, '.');
            if (StringGetCharacter(text_stripped, StringLen(text_stripped) - 3) == ',') StringSetCharacter(text_stripped, StringLen(text_stripped) - 3, '.');
            StringReplace(text_stripped, ",", ""); // Remove commas that might appear as the thousands separator due to number formatting.
            double double_from_stripped_text = StringToDouble(text_stripped);

            // The checkbox part has "Button" added to its name.
            if (((object_name == panel_id + "m_EdtEntryLevel") && (CompareDoubles(double_from_text, sets.EntryLevel))) ||
                ((!sets.SLDistanceInPoints) && (object_name == panel_id + "m_EdtSL") && (CompareDoubles(double_from_text, sets.StopLossLevel))) ||
                ((sets.SLDistanceInPoints) && (object_name == panel_id + "m_EdtSL") && (text != IntegerToString(sets.StopLoss))) ||
                ((!sets.TPDistanceInPoints) && (object_name == panel_id + "m_EdtTP") && (CompareDoubles(double_from_text, sets.TakeProfitLevel))) ||
                ((sets.TPDistanceInPoints) && (object_name == panel_id + "m_EdtTP") && (text != IntegerToString(sets.TakeProfit))) ||
                // Account size is editable only when it's set to Balance. If different from the actual account balance, a custom value has been entered.
                ((sets.AccountButton == Balance) && (object_name == panel_id + "m_EdtAccount") && (CompareDoubles(double_from_stripped_text, AccountBalance() + AdditionalFunds)) && (CompareDoubles(double_from_stripped_text, sets.CustomBalance))) ||
                ((object_name == panel_id + "m_EdtCommissionSize") && (CompareDoubles(double_from_text, sets.CommissionPerLot, 3))) ||
                ((object_name == panel_id + "m_EdtRiskPIn") && (CompareDoubles(double_from_text, sets.Risk))) ||
                ((object_name == panel_id + "m_EdtRiskMIn") && (CompareDoubles(double_from_stripped_text, sets.MoneyRisk, 2))) ||
                ((object_name == panel_id + "m_EdtPosSize") && (CompareDoubles(double_from_text, OutputPositionSize, 2))) ||
                ((object_name == panel_id + "m_EdtATRPeriod") && (text != IntegerToString(sets.ATRPeriod))) ||
                ((object_name == panel_id + "m_EdtATRMultiplierSL") && (CompareDoubles(double_from_text, sets.ATRMultiplierSL, 2))) ||
                ((object_name == panel_id + "m_EdtATRMultiplierTP") && (CompareDoubles(double_from_text, sets.ATRMultiplierTP, 2))) ||
                ((object_name == panel_id + "m_EdtCustomLeverage") && (CompareDoubles(double_from_text, sets.CustomLeverage))) ||
                ((object_name == panel_id + "m_EdtMagicNumber") && (text != IntegerToString(sets.MagicNumber))) ||
                ((object_name == panel_id + "m_EdtExpiry") && (text != IntegerToString(sets.ExpiryMinutes))) ||
                ((object_name == panel_id + "m_EdtCommentary") && (text != sets.Commentary)) ||
                ((object_name == panel_id + "m_EdtMaxSlippage") && (text != IntegerToString(sets.MaxSlippage))) ||
                ((object_name == panel_id + "m_EdtMaxSpread") && (text != IntegerToString(sets.MaxSpread))) ||
                ((object_name == panel_id + "m_EdtMaxEntrySLDistance") && (text != IntegerToString(sets.MaxEntrySLDistance))) ||
                ((object_name == panel_id + "m_EdtMinEntrySLDistance") && (text != IntegerToString(sets.MinEntrySLDistance))) ||
                ((object_name == panel_id + "m_EdtMaxPositionSizeTotal") && (CompareDoubles(double_from_text, sets.MaxPositionSizeTotal, 2))) ||
                ((object_name == panel_id + "m_EdtMaxPositionSizePerSymbol") && (CompareDoubles(double_from_text, sets.MaxPositionSizePerSymbol, 2))) ||
                ((object_name == panel_id + "m_EdtTrailingStopPoints") && (text != IntegerToString(sets.TrailingStopPoints))) ||
                ((object_name == panel_id + "m_EdtBreakEvenPoints") && (text != IntegerToString(sets.BreakEvenPoints))) ||
                ((object_name == panel_id + "m_EdtMaxNumberOfTradesTotal") && (text != IntegerToString(sets.MaxNumberOfTradesTotal))) ||
                ((object_name == panel_id + "m_EdtMaxNumberOfTradesPerSymbol") && (text != IntegerToString(sets.MaxNumberOfTradesPerSymbol))) ||
                ((object_name == panel_id + "m_EdtMaxRiskTotal") && (CompareDoubles(double_from_text, sets.MaxRiskTotal, 2))) ||
                ((object_name == panel_id + "m_EdtMaxRiskPerSymbol") && (CompareDoubles(double_from_text, sets.MaxRiskPerSymbol, 2))) ||
                ((object_name == panel_id + "m_EdtMaxRiskPercentage") && (CompareDoubles(double_from_text, sets.MaxRiskPercentage, 2)))
            )
            {
                lparam = ExtDialog.FindControlId(object_name);
                if (lparam != -1)
                {
                    OnChartEvent(CHARTEVENT_CUSTOM + ON_END_EDIT, lparam, dparam, object_name);
                    return; // No need to check anything else.
                }
            }
            
            // These edits have numbers at the end because there can be multiple of them.
            if (StringSubstr(object_name, 0, StringLen(panel_id + "m_EdtTradingTPEdit")) == panel_id + "m_EdtTradingTPEdit")
            {
                int num = (int)StringToInteger(StringSubstr(object_name, StringLen(panel_id + "m_EdtTradingTPEdit"))) - 1;
                if (CompareDoubles(double_from_text, sets.TP[num]))
                {
                    OnChartEvent(CHARTEVENT_CUSTOM + ON_END_EDIT, lparam, dparam, object_name);
                    return;
                }
            }
            else if (StringSubstr(object_name, 0, StringLen(panel_id + "m_EdtTradingTPShareEdit")) == panel_id + "m_EdtTradingTPShareEdit")
            {
                int num = (int)StringToInteger(StringSubstr(object_name, StringLen(panel_id + "m_EdtTradingTPShareEdit"))) - 1;
                if (text != IntegerToString(sets.TPShare[num]))
                {
                    OnChartEvent(CHARTEVENT_CUSTOM + ON_END_EDIT, lparam, dparam, object_name);
                    return;
                }
            }
            else if (StringSubstr(object_name, 0, StringLen(panel_id + "m_EdtAdditionalTPEdits")) == panel_id + "m_EdtAdditionalTPEdits")
            {
                int num = (int)StringToInteger(StringSubstr(object_name, StringLen(panel_id + "m_EdtAdditionalTPEdits"))) - 2; // -2 because, there is no 1st additional TP edit, there is a normal TP edit in its place. So, the chart object numbering starts at 2, which should be translated to 0th array element.
                
                if (((!sets.TPDistanceInPoints) && (CompareDoubles(double_from_text, sets.TP[num + 1]))) ||
                    ((sets.TPDistanceInPoints) && (text != IntegerToString((int)MathRound(MathAbs(sets.TP[num + 1] - sets.EntryLevel) / _Point)))))
                {
                    OnChartEvent(CHARTEVENT_CUSTOM + ON_END_EDIT, lparam, dparam, object_name);
                    return;
                }
            }
        }
    }

    // Do checkboxes (bitmap buttons/labels):
    int checkboxes_total = ObjectsTotal(0, -1, OBJ_BITMAP_LABEL);
    for (int i = 0; i < checkboxes_total; i++)
    {
        string object_name = ObjectName(0, i, -1, OBJ_BITMAP_LABEL);

        // Special case: Min/Max and Close (X):
        if (object_name == panel_id + "MinMax")
        {
            lparam = ExtDialog.MinMaxButtonId;
            if (((bool)ObjectGetInteger(0, object_name, OBJPROP_STATE)) && (!ExtDialog.IsMinimized()))
                OnChartEvent(CHARTEVENT_CUSTOM + ON_CLICK, lparam, dparam, object_name);
            else if ((!(bool)ObjectGetInteger(0, object_name, OBJPROP_STATE)) && (ExtDialog.IsMinimized()))
                OnChartEvent(CHARTEVENT_CUSTOM + ON_CLICK, lparam, dparam, object_name);
            return;
        }
        else if ((object_name == panel_id + "Close") && ((bool)ObjectGetInteger(0, object_name, OBJPROP_STATE)))
        {
            lparam = 4;
            OnChartEvent(CHARTEVENT_CUSTOM + ON_CLICK, lparam, dparam, object_name);
            return;
        }

        // Looking for 12345m_ChkABCDE object names.
        if (StringSubstr(object_name, 0, panel_id_length + 5) != panel_id + "m_Chk") continue;
        
        bool state = (bool)ObjectGetInteger(0, object_name, OBJPROP_STATE); // Ticked checkbox?

        // The checkbox part has "Button" added to its name.
        if (((object_name == panel_id + "m_ChkTPLockedOnSL" + "Button") && (state != sets.TPLockedOnSL)) ||
            ((object_name == panel_id + "m_ChkSpreadAdjustmentSL" + "Button") && (state != sets.SpreadAdjustmentSL)) ||
            ((object_name == panel_id + "m_ChkSpreadAdjustmentTP" + "Button") && (state != sets.SpreadAdjustmentTP)) ||
            ((object_name == panel_id + "m_ChkDisableTradingWhenLinesAreHidden" + "Button") && (state != sets.DisableTradingWhenLinesAreHidden)) ||
            ((object_name == panel_id + "m_ChkIgnoreOrdersWithoutSL" + "Button") && (state != sets.IgnoreOrdersWithoutSL)) ||
            ((object_name == panel_id + "m_ChkIgnoreOrdersWithoutTP" + "Button") && (state != sets.IgnoreOrdersWithoutTP)) ||
            ((object_name == panel_id + "m_ChkSubtractPositions" + "Button") && (state != sets.SubtractPositions)) ||
            ((object_name == panel_id + "m_ChkSubtractPendingOrders" + "Button") && (state != sets.SubtractPendingOrders)) ||
            ((object_name == panel_id + "m_ChkDoNotApplyStopLoss" + "Button") && (state != sets.DoNotApplyStopLoss)) ||
            ((object_name == panel_id + "m_ChkDoNotApplyTakeProfit" + "Button") && (state != sets.DoNotApplyTakeProfit)) ||
            ((object_name == panel_id + "m_ChkCommentAutoSuffix" + "Button") && (state != sets.CommentAutoSuffix)) ||
            ((object_name == panel_id + "m_ChkAskForConfirmation" + "Button") && (state != sets.AskForConfirmation))
        )
        {
            object_name = StringSubstr(object_name, 0, StringLen(object_name) - 6); // Remove the "Button" ending.
            lparam = ExtDialog.FindControlId(object_name);
            if (lparam != -1)
            {
                OnChartEvent(CHARTEVENT_CUSTOM + ON_CHANGE, lparam, dparam, object_name);
                return; // No need to check anything else.
            }
        }
    }
}

// Safe double comparison.
// Returns true if different. False if equal.
inline bool CompareDoubles(double d1, double d2, int precision = 0)
{
    double min_diff = _Point / 2;
    if (precision > 0) min_diff = MathPow(0.1, precision);
    if (MathAbs(d1 - d2) < min_diff) return false;
    return true;
}
//+------------------------------------------------------------------+