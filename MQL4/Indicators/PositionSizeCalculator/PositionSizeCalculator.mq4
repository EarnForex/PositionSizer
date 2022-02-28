//+------------------------------------------------------------------+
//|                                       PositionSizeCalculator.mq4 |
//|                             Copyright © 2012-2022, EarnForex.com |
//|                                     Based on panel by qubbit.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/Position-Size-Calculator/"
#property version   "2.42"
string    Version = "2.42";
#property strict
#property indicator_chart_window
#property indicator_plots 0

#property description "Calculates position size based on account balance/equity,"
#property description "currency, currency pair, given entry level, stop-loss level,"
#property description "and risk tolerance (set either in percentage points or in base currency)."
#property description "Displays reward/risk ratio based on take-profit."
#property description "Shows total portfolio risk based on open trades and pending orders."
#property description "Calculates margin required for new position, allows custom leverage.\r\n"
#property description "WARNING: There is no guarantee that the output of this indicator is correct. Use at your own risk."

#include "PositionSizeCalculator.mqh";

input group "Compactness"
input bool ShowLineLabels = true; // ShowLineLabels: Show point distance for TP/SL near lines?
input bool ShowAdditionalSLLabel = false; // ShowAdditionalSLLabel: Show SL $/% label?
input bool ShowAdditionalTPLabel = false; // ShowAdditionalTPLabel: Show TP $/% + R/R label?
input bool DrawTextAsBackground = false; // DrawTextAsBackground: Draw label objects as background?
input bool PanelOnTopOfChart = true; // PanelOnTopOfChart: Draw chart as background?
input bool HideAccSize = false; // HideAccSize: Hide account size?
input bool ShowPointValue = false; // ShowPointValue: Show point value?
input bool ShowMaxPSButton = false; // ShowMaxPSButton: Show Max Position Size button?
input bool StartPanelMinimized = false; // StartPanelMinimized: Start the panel minimized?
input group "Fonts"
input color sl_label_font_color = clrLime; // SL Label  Color
input color tp_label_font_color = clrYellow; // TP Label Font Color
input uint font_size = 13; // Labels Font Size
input string font_face = "Courier"; // Labels Font Face
input group "Lines"
input color entry_line_color = clrBlue; // Entry Line Color
input color stoploss_line_color = clrLime; // Stop-Loss Line Color
input color takeprofit_line_color = clrYellow; // Take-Profit Line Color
input ENUM_LINE_STYLE entry_line_style = STYLE_SOLID; // Entry Line Style
input ENUM_LINE_STYLE stoploss_line_style = STYLE_SOLID; // Stop-Loss Line Style
input ENUM_LINE_STYLE takeprofit_line_style = STYLE_SOLID; // Take-Profit Line Style
input uint entry_line_width = 1; // Entry Line Width
input uint stoploss_line_width = 1; // Stop-Loss Line Width
input uint takeprofit_line_width = 1; // Take-Profit Line Width
input group "Defaults"
input TRADE_DIRECTION DefaultTradeDirection = Long; // TradeDirection: Default trade direction.
input int DefaultSL = 0; // SL: Default stop-loss value, in broker's points.
input int DefaultTP = 0; // TP: Default take-profit value, in broker's points.
input ENTRY_TYPE DefaultEntryType = Instant; // EntryType: Instant or Pending.
input bool DefaultShowLines = true; // ShowLines: Show the lines by default?
input bool DefaultLinesSelected = true; // LinesSelected: SL/TP (Entry in Pending) lines selected.
input int DefaultATRPeriod = 14; // ATRPeriod: Default ATR period.
input double DefaultATRMultiplierSL = 0; // ATRMultiplierSL: Default ATR multiplier for SL.
input double DefaultATRMultiplierTP = 0; // ATRMultiplierTP: Default ATR multiplier for TP.
input ENUM_TIMEFRAMES DefaultATRTimeframe = PERIOD_CURRENT; // ATRTimeframe: Default timeframe for ATR.
input double DefaultCommission = 0; // Commission: Default one-way commission per 1 lot.
input ACCOUNT_BUTTON DefaultAccountButton = Balance; // AccountButton: Balance/Equity/Balance-CPR
input double DefaultRisk = 1; // Risk: Initial risk tolerance in percentage points
input double DefaultMoneyRisk = 0; // MoneyRisk: If > 0, money risk tolerance in currency.
input bool DefaultCountPendingOrders = false; // CountPendingOrders: Count pending orders for portfolio risk.
input bool DefaultIgnoreOrdersWithoutStopLoss = false; // IgnoreOrdersWithoutStopLoss: Ignore orders w/o SL in portfolio risk.
input bool DefaultIgnoreOtherSymbols = false; // IgnoreOtherSymbols: Ignore other symbols' orders in portfolio risk.
input int DefaultCustomLeverage = 0; // CustomLeverage: Default custom leverage for Margin tab.
input int DefaultMagicNumber = 0; // MagicNumber: Default magic number for Script tab.
input string DefaultCommentary = ""; // Commentary: Default order comment for Script tab.
input bool DefaultScriptCommentAutoSuffix = false; // AutoSuffix: Automatic suffix for order commentary in Script tab.
input bool DefaultDisableTradingWhenLinesAreHidden = false; // DisableTradingWhenLinesAreHidden: for Script tab.
input int DefaultMaxSlippage = 0; // MaxSlippage: Maximum slippage for Script tab.
input int DefaultMaxSpread = 0; // MaxSpread: Maximum spread for Script tab.
input int DefaultMaxEntrySLDistance = 0; // MaxEntrySLDistance: Maximum entry/SL distance for Script tab.
input int DefaultMinEntrySLDistance = 0; // MinEntrySLDistance: Minimum entry/SL distance for Script tab.
input double DefaultMaxPositionSize = 0; // MaxPositionSize: Maximum position size for Script tab.
input bool DefaultSubtractOPV = false; // SubtractOPV: Subtract open positions volume (Script tab).
input bool DefaultSubtractPOV = false; // SubtractPOV: Subtract pending orders volume (Script tab).
input bool DefaultDoNotApplyStopLoss = false; // DoNotApplyStopLoss: Don't apply SL for Script tab.
input bool DefaultDoNotApplyTakeProfit = false; // DoNotApplyTakeProfit: Don't apply TP for Script tab.
input bool DefaultAskForConfirmation = false; // AskForConfirmation: Ask for confirmation for Script tab.
input int DefaultPanelPositionX = 0; // PanelPositionX: Panel's X coordinate.
input int DefaultPanelPositionY = 15; // PanelPositionY: Panel's Y coordinate.
input ENUM_BASE_CORNER DefaultPanelPositionCorner = CORNER_LEFT_UPPER; // PanelPositionCorner: Panel's corner.
input bool DefaultTPLockedOnSL = false; // TPLockedOnSL: Lock TP to (multiplied) SL distance.
input group "Miscellaneous"
input double TP_Multiplier = 1; // TP Multiplier for SL value, appears in Take-profit button.
input bool UseCommissionToSetTPDistance = false; // UseCommissionToSetTPDistance: For TP button.
input bool ShowSpread = false; // ShowSpread: If true, shows current spread in window caption.
input double AdditionalFunds = 0; // AdditionalFunds: Added to account balance for risk calculation.
input double CustomBalance = 0; // CustomBalance: Overrides AdditionalFunds value.
input bool SLDistanceInPoints = false; // SLDistanceInPoints: SL distance in points instead of a level.
input bool TPDistanceInPoints = false; // TPDistanceInPoints: TP distance in points instead of a level.
input bool ShowATROptions = false; // ShowATROptions: If true, SL and TP can be set via ATR.
input CANDLE_NUMBER ATRCandle = Current_Candle; // ATRCandle: Candle to get ATR value from.
input int ScriptTakeProfitsNumber = 1; // ScriptTakeProfitsNumber: More than 1 target for script to split trades.
input bool CalculateUnadjustedPositionSize = false; // CalculateUnadjustedPositionSize: Ignore broker's restrictions.
input bool RoundDown = true; // RoundDown: Position size and potential reward are rounded down.
input double QuickRisk1 = 0; // QuickRisk1: First quick risk button, in percentage points.
input double QuickRisk2 = 0; // QuickRisk2: Second quick risk button, in percentage points.
input string ObjectPrefix = "PSC_"; // ObjectPrefix: To prevent confusion with other indicators/EAs.

QCPositionSizeCalculator ExtDialog;

// Global variables:
bool Dont_Move_the_Panel_to_Default_Corner_X_Y;
uint LastRecalculationTime = 0;
bool StopLossLineIsBeingMoved = false;
bool TakeProfitLineIsBeingMoved = false;
bool NeedToToggleScaleOffOn = false;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
    MathSrand(GetTickCount() + 293029); // Used by CreateInstanceId() in Dialog.mqh (standard library). Keep the second number unique across other panel indicators/EAs.

    string indicator_short_name = "Position Size Calculator" + IntegerToString(ChartID());
    Dont_Move_the_Panel_to_Default_Corner_X_Y = true;

    // Prevent attachment of second panel if it is not a timeframe/parameters change.
    if (GlobalVariableGet("PSC-" + IntegerToString(ChartID()) + "-Flag") > 0)
    {
        GlobalVariableDel("PSC-" + IntegerToString(ChartID()) + "-Flag");
    }
    else
    {
        int indicators_total = ChartIndicatorsTotal(0, 0);
        for (int i = 0; i < indicators_total; i++)
        {
            if (ChartIndicatorName(0, 0, i) == indicator_short_name)
            {
                Print("Position Size Calculator is already attached.");
                return INIT_FAILED;
            }
        }
    }

    IndicatorSetString(INDICATOR_SHORTNAME, indicator_short_name);
    if (!ShowSpread) PanelCaptionBase = "Position Size Calculator (ver. " + Version + ")";
    else PanelCaptionBase = "PSC (ver. " + Version + ")"; // A shorter version for the Spread to fit.

    if (ScriptTakeProfitsNumber > 1)
    {
        ArrayResize(sets.ScriptTP, ScriptTakeProfitsNumber);
        ArrayResize(sets.ScriptTPShare, ScriptTakeProfitsNumber);
        ArrayInitialize(sets.ScriptTP, 0);
        ArrayInitialize(sets.ScriptTPShare, 100 / ScriptTakeProfitsNumber);
        ArrayResize(sets.WasSelectedAdditionalTakeProfitLine, ScriptTakeProfitsNumber - 1); // -1 because the flag for the main TP is saved elsewhere.
    }

    if (!ExtDialog.LoadSettingsFromDisk())
    {
        sets.TradeDirection = DefaultTradeDirection;
        sets.EntryLevel = EntryLevel;
        sets.StopLossLevel = StopLossLevel;
        sets.TakeProfitLevel = TakeProfitLevel; // Optional
        sets.ATRPeriod = DefaultATRPeriod;
        sets.ATRMultiplierSL = DefaultATRMultiplierSL;
        sets.ATRMultiplierTP = DefaultATRMultiplierTP;
        sets.ATRTimeframe = DefaultATRTimeframe;
        sets.EntryType = DefaultEntryType; // If Instant, Entry level will be updated to current Ask/Bid price automatically; if Pending, Entry level will remain intact and StopLevel warning will be issued if needed.
        sets.Risk = DefaultRisk; // Risk tolerance in percentage points
        sets.MoneyRisk = DefaultMoneyRisk; // Risk tolerance in account currency
        if (DefaultMoneyRisk > 0) sets.UseMoneyInsteadOfPercentage = true;
        else sets.UseMoneyInsteadOfPercentage = false;
        sets.CommissionPerLot = DefaultCommission; // Commission charged per lot (one side) in account currency.
        sets.CustomBalance = CustomBalance;
        sets.RiskFromPositionSize = false;
        sets.AccountButton = DefaultAccountButton;
        sets.CountPendingOrders = DefaultCountPendingOrders; // If true, portfolio risk calculation will also involve pending orders.
        sets.IgnoreOrdersWithoutStopLoss = DefaultIgnoreOrdersWithoutStopLoss; // If true, portfolio risk calculation will skip orders without stop-loss.
        sets.IgnoreOtherSymbols = DefaultIgnoreOtherSymbols; // If true, portfolio risk calculation will skip orders in other symbols.
        sets.HideAccSize = HideAccSize; // If true, account size line will not be shown.
        sets.ShowLines = DefaultShowLines;
        sets.SelectedTab = MainTab;
        sets.CustomLeverage = DefaultCustomLeverage;
        sets.MagicNumber = DefaultMagicNumber;
        sets.ScriptCommentary = DefaultCommentary;
        sets.ScriptCommentAutoSuffix = DefaultScriptCommentAutoSuffix;
        sets.DisableTradingWhenLinesAreHidden = DefaultDisableTradingWhenLinesAreHidden;
        if (ScriptTakeProfitsNumber > 1)
        {
            for (int i = 0; i < ScriptTakeProfitsNumber; i++)
            {
                sets.ScriptTP[i] = TakeProfitLevel;
                sets.ScriptTPShare[i] = 100 / ScriptTakeProfitsNumber;
            }
        }
        sets.MaxSlippage = DefaultMaxSlippage;
        sets.MaxSpread = DefaultMaxSpread;
        sets.MaxEntrySLDistance = DefaultMaxEntrySLDistance;
        sets.MinEntrySLDistance = DefaultMinEntrySLDistance;
        sets.MaxPositionSize = DefaultMaxPositionSize;
        sets.StopLoss = 0;
        sets.TakeProfit = 0;
        sets.SubtractPendingOrders = DefaultSubtractPOV;
        sets.SubtractPositions = DefaultSubtractOPV;
        sets.DoNotApplyStopLoss = DefaultDoNotApplyStopLoss;
        sets.DoNotApplyTakeProfit = DefaultDoNotApplyTakeProfit;
        sets.AskForConfirmation = DefaultAskForConfirmation;
        sets.WasSelectedEntryLine = false;
        sets.WasSelectedStopLossLine  = false;
        sets.WasSelectedTakeProfitLine = false;
        sets.IsPanelMinimized = false;
        sets.TPLockedOnSL = DefaultTPLockedOnSL;
        if ((int)sets.ATRTimeframe == 0) sets.ATRTimeframe = (ENUM_TIMEFRAMES)_Period;
    }

    if (!ExtDialog.Create(0, PanelCaption, 0, DefaultPanelPositionX, DefaultPanelPositionY)) return INIT_FAILED;

    // Prevent problems with trading instruments containing more than one dot in their name.
    // Also, bypasses a bug in Dialog.mqh with indicator name detection.
    string symbol = Symbol();
    StringReplace(symbol, ".", "_dot_");
    string filename = indicator_short_name + "_" + symbol + "_Ini" + ExtDialog.IniFileExt();
    ExtDialog.IniFileNameSet(filename);

    // No ini file - move the panel according to the inputs.
    if (!FileIsExist(filename)) Dont_Move_the_Panel_to_Default_Corner_X_Y = false;

    ExtDialog.IniFileLoad();
    ExtDialog.Run();

    Initialization();

    // Brings panel on top of other objects without actual maximization of the panel.
    ExtDialog.HideShowMaximize();

    NeedToToggleScaleOffOn = true;

    if (!Dont_Move_the_Panel_to_Default_Corner_X_Y)
    {
        int new_x = DefaultPanelPositionX, new_y = DefaultPanelPositionY;
        int chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
        int chart_height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
        int panel_width = ExtDialog.Width();
        int panel_height = ExtDialog.Height();

        // Invert coordinate if necessary.
        if (DefaultPanelPositionCorner == CORNER_LEFT_LOWER)
        {
            new_y = chart_height - panel_height - new_y;
        }
        else if (DefaultPanelPositionCorner == CORNER_RIGHT_UPPER)
        {
            new_x = chart_width - panel_width - new_x;
        }
        else if (DefaultPanelPositionCorner == CORNER_RIGHT_LOWER)
        {
            new_x = chart_width - panel_width - new_x;
            new_y = chart_height - panel_height - new_y;
        }
        ExtDialog.remember_left = new_x;
        ExtDialog.remember_top = new_y;
        ExtDialog.Move(new_x, new_y);
        ExtDialog.FixatePanelPosition(); // Remember the panel's new position for the INI file.
    }

    if ((StartPanelMinimized) && (!ExtDialog.IsMinimized()) && (!Dont_Move_the_Panel_to_Default_Corner_X_Y)) // Minimize only if needs minimization. We check Dont_Move_the_Panel_to_Default_Corner_X_Y to make sure we didn't load an INI-file. An INI-file already contains a more preferred state for the panel.
    {
        // No access to the minmax button, no way to edit the chart height.
        // Dummy variables for passing as references.
        long lparam = 0;
        double dparam = 0;
        string sparam = "";
        // Increasing the height of the panel beyond that of the chart will trigger its minimization.
        ExtDialog.Height((int)ChartGetInteger(ChartID(), CHART_HEIGHT_IN_PIXELS) + 1);
        // Call the chart event processing function.
        ExtDialog.ChartEvent(CHARTEVENT_CHART_CHANGE, lparam, dparam, sparam);
    }
    
    EventSetTimer(1);

    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
// If we tried to add a second indicator, do not delete objects.
    if (reason == REASON_INITFAILED) return;

    ObjectDelete(0, ObjectPrefix + "StopLossLabel");
    ObjectDelete(0, ObjectPrefix + "TakeProfitLabel");
    ObjectDelete(0, ObjectPrefix + "TPAdditionalLabel");
    ObjectDelete(0, ObjectPrefix + "SLAdditionalLabel");
    for (int i = 1; i < ScriptTakeProfitsNumber; i++)
    {
        ObjectDelete(0, ObjectPrefix + "TakeProfitLabel" + IntegerToString(i));
        ObjectDelete(0, ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i));
    }
    if (reason == REASON_REMOVE)
    {
        ExtDialog.DeleteSettingsFile();
        ObjectsDeleteAll(0, ObjectPrefix);
        if (!FileDelete(ExtDialog.IniFileName() + ExtDialog.IniFileExt())) Print("Failed to delete PSC panel's .ini file: ", GetLastError());
    }
    else
    {
        // It is deinitialization due to input parameters change - save current parameters values (that are also changed via panel) to global variables.
        if (reason == REASON_PARAMETERS) GlobalVariableSet("PSC-" + IntegerToString(ChartID()) + "-Parameters", 1);

        ExtDialog.SaveSettingsOnDisk();
        // Set temporary global variable, so that the indicator knows it is reinitializing because of timeframe/parameters change and should not prevent attachment.
        if ((reason == REASON_CHARTCHANGE) || (reason == REASON_PARAMETERS) || (reason == REASON_RECOMPILE)) GlobalVariableSet("PSC-" + IntegerToString(ChartID()) + "-Flag", 1);
    }

    ExtDialog.Destroy(reason);

    EventKillTimer();
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
    // Toggle price scale off and then on to return it to its original size.
    // This can be useful when switching from symbol with a wide price scale (index, BTC, etc.) to one with a narrow scale (EUR/USD).
    if (NeedToToggleScaleOffOn)
    {
        ChartSetInteger(ChartID(), CHART_SHOW_PRICE_SCALE, false);
        ChartSetInteger(ChartID(), CHART_SHOW_PRICE_SCALE, true);
        NeedToToggleScaleOffOn = false;
    }

    ExtDialog.RefreshValues();
    return rates_total;
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    // Mouse move while left mouse button is down.
    if ((id == CHARTEVENT_MOUSE_MOVE) && (((uint)sparam & 1) == 1))
    {
        if (SLDistanceInPoints)
        {
            double current_line_price = ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0);
            if (current_line_price != tStopLossLevel) StopLossLineIsBeingMoved = true;
            else StopLossLineIsBeingMoved = false;
        }
        if (TPDistanceInPoints)
        {
            TakeProfitLineIsBeingMoved = false;
            double current_line_price = ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0);
            if (current_line_price != tTakeProfitLevel) TakeProfitLineIsBeingMoved = true;
            // Additional take-profits.
            else if (ScriptTakeProfitsNumber > 1)
            {
                for (int i = 1; i < ScriptTakeProfitsNumber; i++)
                {
                    if (sets.ScriptTP[i] != 0) // With zero points TP, keep the TP lines at zero level - as with the main TP level.
                    {
                        current_line_price = ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, 0);
                        if (current_line_price != sets.ScriptTP[i])
                        {
                            TakeProfitLineIsBeingMoved = true;
                            break;
                        }
                    }
                }
            }
        }
    }

    // Remember the panel's location to have the same location for minimized and maximized states.
    if ((id == CHARTEVENT_CUSTOM + ON_DRAG_END) && (lparam == -1))
    {
        ExtDialog.remember_top = ExtDialog.Top();
        ExtDialog.remember_left = ExtDialog.Left();
    }

    // Catch multiple TP fields.
    if (ScriptTakeProfitsNumber > 1)
    {
        if (id == CHARTEVENT_CUSTOM + ON_END_EDIT)
        {
            // Additional take-profit field #N on Main tab.
            if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "AdditionalTPEdits")) == ExtDialog.Name() + "AdditionalTPEdits")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "AdditionalTPEdits"))) - 1;
                ExtDialog.UpdateAdditionalTPEdit(i);
            }
            // Script take-profit field #N on Script tab.
            else if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "m_EdtScriptTPEdit")) == ExtDialog.Name() + "m_EdtScriptTPEdit")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "m_EdtScriptTPEdit"))) - 1;
                ExtDialog.UpdateScriptTPEdit(i);
            }
            // Script take-profit share field #N on Script tab.
            else if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "m_EdtScriptTPShareEdit")) == ExtDialog.Name() + "m_EdtScriptTPShareEdit")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "m_EdtScriptTPShareEdit"))) - 1;
                ExtDialog.UpdateScriptTPShareEdit(i);
            }
        }
    }

    if (id == CHARTEVENT_KEYDOWN)
    {
        if (lparam == 9) // Tab key to shift from Long to Short and vice versa.
        {
            SwitchEntryDirection(); 
        }
    }

    // Call Panel's event handler only if it is not a CHARTEVENT_CHART_CHANGE - workaround for minimization bug on chart switch.
    if (id != CHARTEVENT_CHART_CHANGE) ExtDialog.OnEvent(id, lparam, dparam, sparam);
    
    // Recalculate on chart changes, clicks, and certain object dragging.
    if ((id == CHARTEVENT_CLICK) || (id == CHARTEVENT_CHART_CHANGE) ||
            ((id == CHARTEVENT_OBJECT_DRAG) && ((sparam == ObjectPrefix + "EntryLine") || (sparam == ObjectPrefix + "StopLossLine") || (StringFind(sparam, ObjectPrefix + "TakeProfitLine") != -1))))
    {
        // Moving lines when fixed SL/TP distance is enabled. Should set a new fixed SL/TP distance.
        if ((id == CHARTEVENT_OBJECT_DRAG) && ((SLDistanceInPoints) || (TPDistanceInPoints) || (ShowATROptions)))
        {
            if (sparam == ObjectPrefix + "StopLossLine") ExtDialog.UpdateFixedSL();
            else if (sparam == ObjectPrefix + "TakeProfitLine") ExtDialog.UpdateFixedTP();
            else if ((ScriptTakeProfitsNumber > 1) && (StringFind(sparam, ObjectPrefix + "TakeProfitLine") != -1))
            {
                int len = StringLen(ObjectPrefix + "TakeProfitLine");
                int i = (int)StringToInteger(StringSubstr(sparam, len));
                ExtDialog.UpdateAdditionalFixedTP(i);
            }
        }

        if (sparam == ObjectPrefix + "StopLossLine") StopLossLineIsBeingMoved = false; // In any case ending moving state for the stop-loss line.
        if (StringFind(sparam, ObjectPrefix + "TakeProfitLine") != -1) TakeProfitLineIsBeingMoved = false; // In any case ending moving state for the take-profit line.

        if (id != CHARTEVENT_CHART_CHANGE) ExtDialog.RefreshValues();

        static bool prev_chart_on_top = false;
        // If this is an active chart, make sure the panel is visible (not behind the chart's borders). For inactive chart, this will work poorly, because inactive charts get minimized by MetaTrader.
        if (ChartGetInteger(ChartID(), CHART_BRING_TO_TOP))
        {
            if (ExtDialog.Top() < 0) ExtDialog.Move(ExtDialog.Left(), 0);
            int chart_height = (int)ChartGetInteger(0, CHART_HEIGHT_IN_PIXELS);
            if (ExtDialog.Top() > chart_height) ExtDialog.Move(ExtDialog.Left(), chart_height - ExtDialog.Height());
            int chart_width = (int)ChartGetInteger(0, CHART_WIDTH_IN_PIXELS);
            if (ExtDialog.Left() > chart_width) ExtDialog.Move(chart_width - ExtDialog.Width(), ExtDialog.Top());
            // If chart was brought on top, refresh values to move labels.
            if ((prev_chart_on_top == false) && (ShowLineLabels)) ExtDialog.RefreshValues();
        }
        // Remember if the chart is on top or is minimized.
        prev_chart_on_top = ChartGetInteger(ChartID(), CHART_BRING_TO_TOP);
        ChartRedraw();
    }
}

//+------------------------------------------------------------------+
//| Trade event handler                                              |
//+------------------------------------------------------------------+
void OnTrade()
{
    ExtDialog.RefreshValues();
    ChartRedraw();
}

//+------------------------------------------------------------------+
//| Timer event handler                                              |
//+------------------------------------------------------------------+
void OnTimer()
{
    ExtDialog.CheckAndRestoreLines(); // Check if any lines should be restored.
    if (GetTickCount() - LastRecalculationTime < 1000) return; // Do not recalculate on timer if less than 1 second passed.
    ExtDialog.RefreshValues();
    ChartRedraw();
}
//+------------------------------------------------------------------+