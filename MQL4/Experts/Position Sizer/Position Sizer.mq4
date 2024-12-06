//+------------------------------------------------------------------+
//|                                               Position Sizer.mq4 |
//|                                  Copyright © 2024, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-expert-advisors/Position-Sizer/"
#property icon      "EF-Icon-64x64px.ico"
#property version   "3.10"
string    Version = "3.10";
#property strict

#include "Translations\English.mqh"
//#include "Translations\Arabic.mqh"
//#include "Translations\Chinese.mqh"
//#include "Translations\ChineseTraditional.mqh" // Contributed by fxchess.
//#include "Translations\Portuguese.mqh" // Contributed by Matheus Sevaroli.
//#include "Translations\Russian.mqh"
//#include "Translations\Spanish.mqh"
//#include "Translations\Ukrainian.mqh"

#property description "Calculates risk-based position size for your account."
#property description "Allows trade execution based the calculation results.\r\n"
#property description "WARNING: No warranty. This EA is offered \"as is\". Use at your own risk.\r\n"
#property description "Note: Pressing the \"T\" key will open a trade."

#include "Position Sizer.mqh";
#include "Position Sizer Trading.mqh";
#include "TesterSupport.mqh"

input group "Compactness"
input string ____Compactness = "";
input bool ShowLineLabels = true; // ShowLineLabels: Show point distance for TP/SL near lines?
input bool ShowAdditionalSLLabel = false; // ShowAdditionalSLLabel: Show SL $/% label?
input bool ShowAdditionalTPLabel = false; // ShowAdditionalTPLabel: Show TP $/% + R/R label?
input bool ShowAdditionalEntryLabel = false; // ShowAdditionalEntryLabel: Show Position Size label?
input bool DrawTextAsBackground = false; // DrawTextAsBackground: Draw label objects as background?
input bool HideAccSize = false; // HideAccSize: Hide account size?
input bool ShowPointValue = false; // ShowPointValue: Show point value?
input bool ShowMaxPSButton = false; // ShowMaxPSButton: Show Max Position Size button?
input bool StartPanelMinimized = false; // StartPanelMinimized: Start the panel minimized?
input bool ShowATROptions = false; // ShowATROptions: If true, SL and TP can be set via ATR.
input bool ShowMaxParametersOnTrading = true; // Show max parameters on Trading tab?
input bool ShowFusesOnTrading = true; // Show trading "fuses" on Trading tab?
input bool ShowCheckboxesOnTrading = true; // Show checkboxes on Trading tab?
input bool HideEntryLineOnInstant = false; // Hide Entry line for Instant orders?
input ADDITIONAL_TRADE_BUTTONS AdditionalTradeButtons = ADDITIONAL_TRADE_BUTTONS_NONE; // Additional Trade buttons:
input group "Fonts"
input string ____Fonts = "";
input color sl_label_font_color = clrGreen; // SL Label  Color
input color tp_label_font_color = clrGoldenrod; // TP Label Font Color
input color entry_label_font_color = clrBlue; // Entry Label Font Color
input uint font_size = 13; // Labels Font Size
input string font_face = "Courier"; // Labels Font Face
input group "Lines"
input string ____Lines = "";
input color entry_line_color = clrBlue; // Entry Line Color
input color stoploss_line_color = clrGreen; // Stop-Loss Line Color
input color takeprofit_line_color = clrGoldenrod; // Take-Profit Line Color
input color be_line_color = clrNONE; // BE Line Color
input ENUM_LINE_STYLE entry_line_style = STYLE_SOLID; // Entry Line Style
input ENUM_LINE_STYLE stoploss_line_style = STYLE_SOLID; // Stop-Loss Line Style
input ENUM_LINE_STYLE takeprofit_line_style = STYLE_SOLID; // Take-Profit Line Style
input ENUM_LINE_STYLE be_line_style = STYLE_DOT; // BE Line Style
input uint entry_line_width = 1; // Entry Line Width
input uint stoploss_line_width = 1; // Stop-Loss Line Width
input uint takeprofit_line_width = 1; // Take-Profit Line Width
input uint be_line_width = 1; // BE Line Width
input group "Defaults"
input string ____Defaults = "";
input TRADE_DIRECTION DefaultTradeDirection = Long; // TradeDirection: Default trade direction.
input int DefaultSL = 0; // SL: Default stop-loss value, in  points.
input int DefaultTP = 0; // TP: Default take-profit value, in points.
input int DefaultTakeProfitsNumber = 1; // TakeProfitsNumber: More than 1 target to split trades.
input ENTRY_TYPE DefaultEntryType = Instant; // EntryType: Instant or Pending.
input bool DefaultShowLines = true; // ShowLines: Show the lines by default?
input bool DefaultLinesSelected = true; // LinesSelected: SL/TP (Entry in Pending) lines selected.
input int DefaultATRPeriod = 14; // ATRPeriod: Default ATR period.
input double DefaultATRMultiplierSL = 0; // ATRMultiplierSL: Default ATR multiplier for SL.
input double DefaultATRMultiplierTP = 0; // ATRMultiplierTP: Default ATR multiplier for TP.
input ENUM_TIMEFRAMES DefaultATRTimeframe = PERIOD_CURRENT; // ATRTimeframe: Default timeframe for ATR.
input bool DefaultSpreadAdjustmentSL = false; // SpreadAdjustmentSL: Adjust SL by Spread value in ATR mode.
input bool DefaultSpreadAdjustmentTP = false; // SpreadAdjustmentTP: Adjust TP by Spread value in ATR mode.
input double DefaultCommission = 0; // Commission: Default one-way commission per 1 lot.
input COMMISSION_TYPE DefaultCommissionType = COMMISSION_CURRENCY; // CommissionType: Default commission type.
input ACCOUNT_BUTTON DefaultAccountButton = Balance; // AccountButton: Balance/Equity/Balance-CPR
input double DefaultRisk = 1; // Risk: Initial risk tolerance in percentage points
input double DefaultMoneyRisk = 0; // MoneyRisk: If > 0, money risk tolerance in currency.
input double DefaultPositionSize = 0; // PositionSize: If > 0, position size in lots.
input bool DefaultCountPendingOrders = false; // CountPendingOrders: Count pending orders for portfolio risk.
input bool DefaultIgnoreOrdersWithoutSL = false; // IgnoreOrdersWithoutSL: Ignore orders w/o SL in portfolio risk.
input bool DefaultIgnoreOrdersWithoutTP = false; // IgnoreOrdersWithoutTP: Ignore orders w/o TP in portfolio risk.
input IGNORE_SYMBOLS DefaultIgnoreSymbols = IGNORE_SYMBOLS_NONE; // IgnoreSymbols: Ignore trades in some symbols for portfolio risk?
input double DefaultCustomLeverage = 0; // CustomLeverage: Default custom leverage for Margin tab.
input int DefaultMagicNumber = 2022052714; // MagicNumber: Default magic number for Trading tab.
input string DefaultCommentary = ""; // Commentary: Default order comment for Trading tab.
input bool DefaultCommentAutoSuffix = false; // AutoSuffix: Automatic suffix for order comment in Trading tab.
input bool DefaultDisableTradingWhenLinesAreHidden = false; // DisableTradingWhenLinesAreHidden: for Trading tab.
input int DefaultMaxSlippage = 0; // MaxSlippage: Maximum slippage for Trading tab.
input int DefaultMaxSpread = 0; // MaxSpread: Maximum spread for Trading tab.
input int DefaultMaxEntrySLDistance = 0; // MaxEntrySLDistance: Maximum entry/SL distance for Trading tab.
input int DefaultMinEntrySLDistance = 0; // MinEntrySLDistance: Minimum entry/SL distance for Trading tab.
input double DefaultMaxRiskPercentage = 0; // MaxRiskPercentage: Maximum risk % for Trading tab.
input double DefaultMaxPositionSizeTotal = 0; // Maximum position size total for Trading tab.
input double DefaultMaxPositionSizePerSymbol = 0; // Maximum position size per symbol for Trading tab.
input bool DefaultSubtractOPV = false; // SubtractOPV: Subtract open positions volume (Trading tab).
input bool DefaultSubtractPOV = false; // SubtractPOV: Subtract pending orders volume (Trading tab).
input bool DefaultDoNotApplyStopLoss = false; // DoNotApplyStopLoss: Don't apply SL for Trading tab.
input bool DefaultDoNotApplyTakeProfit = false; // DoNotApplyTakeProfit: Don't apply TP for Trading tab.
input bool DefaultAskForConfirmation = true; // AskForConfirmation: Ask for confirmation for Trading tab.
input int DefaultPanelPositionX = 0; // PanelPositionX: Panel's X coordinate.
input int DefaultPanelPositionY = 15; // PanelPositionY: Panel's Y coordinate.
input ENUM_BASE_CORNER DefaultPanelPositionCorner = CORNER_LEFT_UPPER; // PanelPositionCorner: Panel's corner.
input bool DefaultTPLockedOnSL = false; // TPLockedOnSL: Lock TP to (multiplied) SL distance.
input int DefaultTrailingStop = 0; // TrailingStop: For the Trading tab.
input int DefaultBreakEven = 0; // BreakEven: For the Trading tab.
input int DefaultExpiryMinutes = 0; // ExpiryMinutes: Pending order expiration in minutes. Min = 10.
input int DefaultMaxNumberOfTradesTotal = 0; // MaxNumberOfTradesTotal: For the Trading tab. 0 - no limit.
input int DefaultMaxNumberOfTradesPerSymbol = 0; // MaxNumberOfTradesPerSymbol: For the Trading tab. 0 - no limit.
input double DefaultMaxRiskTotal = 0; // MaxRiskTotal: For the Trading tab. 0 - no limit.
input double DefaultMaxRiskPerSymbol = 0; // MaxRiskPerSymbol: For the Trading tab. 0 - no limit.
input bool DefaultSLDistanceInPoints = false; // SLDistanceInPoints: SL distance in points instead of a level.
input bool DefaultTPDistanceInPoints = false; // TPDistanceInPoints: TP distance in points instead of a level.
input group "Keyboard shortcuts"
input string ____Keyboard_Shortcuts = "Case-insensitive hotkey. Supports Ctrl, Shift.";
input string TradeHotKey = "T"; // TradeHotKey: Execute a trade.
input string SwitchOrderTypeHotKey = "O"; // SwitchOrderTypeHotKey: Switch order type.
input string SwitchEntryDirectionHotKey = "TAB"; // SwitchEntryDirectionHotKey: Switch entry direction.
input string SwitchHideShowLinesHotKey = "H"; // SwitchHideShowLinesHotKey: Switch Hide/Show lines.
input string SetStopLossHotKey = "S"; // SetStopLossHotKey: Set SL to where mouse pointer is.
input string SetTakeProfitHotKey = "P"; // SetTakeProfitHotKey: Set TP to where mouse pointer is.
input string SetEntryHotKey = "E"; // SetEntryHotKey: Set Entry to where mouse pointer is.
input string MinimizeMaximizeHotkey = "`"; // MinimizeMaximizeHotkey: Minimize/maximize the panel.
input string SwitchSLPointsLevelHotKey = "Shift+S"; // SwitchSLPointsLevelHotKey: Switch SL between points and level.
input string SwitchTPPointsLevelHotKey = "Shift+P"; // SwitchTPPointsLevelHotKey: Switch TP between points and level.
input group "Miscellaneous"
input string ____Miscellaneous = "";
input double TP_Multiplier = 1; // TP Multiplier for SL value, appears in Take-profit button.
input bool UseCommissionToSetTPDistance = false; // UseCommissionToSetTPDistance: For TP button.
input SHOW_SPREAD ShowSpread = No; // ShowSpread: Show current spread in points or as an SL ratio.
input double AdditionalFunds = 0; // AdditionalFunds: Added to account balance for risk calculation.
input double CustomBalance = 0; // CustomBalance: Overrides AdditionalFunds value.
input CANDLE_NUMBER ATRCandle = Current_Candle; // ATRCandle: Candle to get ATR value from.
input bool CalculateUnadjustedPositionSize = false; // CalculateUnadjustedPositionSize: Ignore broker's restrictions.
input bool SurpassBrokerMaxPositionSize = false; // Surpass Broker Max Position Size with multiple trades.
input bool RoundDown = true; // RoundDown: Position size and potential reward are rounded down.
input double QuickRisk1 = 0; // QuickRisk1: First quick risk button, in percentage points.
input double QuickRisk2 = 0; // QuickRisk2: Second quick risk button, in percentage points.
input string ObjectPrefix = "PS_"; // ObjectPrefix: To prevent confusion with other indicators/EAs.
input SYMBOL_CHART_CHANGE_REACTION SymbolChange = SYMBOL_CHART_CHANGE_EACH_OWN; // SymbolChange: What to do with the panel on chart symbol change?
input bool DisableTradingSounds = false; // DisableTradingSounds: If true, sound will be off for trading actions.
input bool IgnoreMarketExecutionMode = true; // IgnoreMarketExecutionMode: If true, ignore Market execution.
input bool MarketModeApplySLTPAfterAllTradesExecuted = false; // Market Mode: Apply SL/TP after all trades executed.
input bool DarkMode = false; // DarkMode: Enable dark mode for a less bright panel.
input string SettingsFile = ""; // SettingsFile: Custom settings file from \Files\PS_Settings\
input bool PrefillAdditionalTPsBasedOnMain = true; // Prefill additional TPs based on Main?
input bool AskBeforeClosing = false; // Ask for confirmation before closing the panel?
input bool CapMaxPositionSizeBasedOnMargin = false; // Cap position size based on available margin?
input bool LessRestrictiveMaxLimits = false; // Allow smaller trades when trading limits are exceeded?

CPositionSizeCalculator* ExtDialog;

// Global variables:
bool Dont_Move_the_Panel_to_Default_Corner_X_Y;
uint LastRecalculationTime = 0;
bool StopLossLineIsBeingMoved = false;
bool TakeProfitLineIsBeingMoved[]; // Separate for each TP.
uchar MainKey_TradeHotKey = 0, MainKey_SwitchOrderTypeHotKey = 0, MainKey_SwitchEntryDirectionHotKey = 0, MainKey_SwitchHideShowLinesHotKey = 0, MainKey_SetStopLossHotKey = 0, MainKey_SetTakeProfitHotKey = 0, MainKey_SetEntryHotKey = 0, MainKey_MinimizeMaximizeHotkey = 0, MainKey_SwitchSLPointsLevelHotKey = 0, MainKey_SwitchTPPointsLevelHotKey = 0;
bool CtrlRequired_TradeHotKey = false, CtrlRequired_SwitchOrderTypeHotKey = false, CtrlRequired_SwitchEntryDirectionHotKey = false, CtrlRequired_SwitchHideShowLinesHotKey = false, CtrlRequired_SetStopLossHotKey = false, CtrlRequired_SetTakeProfitHotKey = false, CtrlRequired_SetEntryHotKey = false, CtrlRequired_MinimizeMaximizeHotkey = false, CtrlRequired_SwitchSLPointsLevelHotKey = false, CtrlRequired_SwitchTPPointsLevelHotKey = false;
bool ShiftRequired_TradeHotKey = false, ShiftRequired_SwitchOrderTypeHotKey = false, ShiftRequired_SwitchEntryDirectionHotKey = false, ShiftRequired_SwitchHideShowLinesHotKey = false, ShiftRequired_SetStopLossHotKey = false, ShiftRequired_SetTakeProfitHotKey = false, ShiftRequired_SetEntryHotKey = false, ShiftRequired_MinimizeMaximizeHotkey = false, ShiftRequired_SwitchSLPointsLevelHotKey = false, ShiftRequired_SwitchTPPointsLevelHotKey = false;
bool NeedToCheckToggleScaleOffOn;
int PrevChartWidth = -1;
int DeinitializationReason = -1;
string OldSymbol = "";
int OldTakeProfitsNumber = -1;
int Mouse_Last_X = 0, Mouse_Last_Y = 0; // For SL/TP hotkeys.

int OnInit()
{
    if (DarkMode)
    {
        CONTROLS_EDIT_COLOR_ENABLE  = DARKMODE_EDIT_BG_COLOR;
        CONTROLS_EDIT_COLOR_DISABLE = 0x999999;
        CONTROLS_BUTTON_COLOR_ENABLE  = DARKMODE_BUTTON_BG_COLOR;
        CONTROLS_BUTTON_COLOR_DISABLE = 0x919999;
        CONTROLS_BUTTON_COLOR_TP_UNLOCKED = DARKMODE_BUTTON_BG_COLOR;
        CONTROLS_BUTTON_COLOR_TP_LOCKED = 0x909090;
    }
    else
    {
        CONTROLS_EDIT_COLOR_ENABLE  = C'255,255,255';
        CONTROLS_EDIT_COLOR_DISABLE = C'221,221,211';
        CONTROLS_BUTTON_COLOR_ENABLE  = C'200,200,200';
        CONTROLS_BUTTON_COLOR_DISABLE = C'224,224,224';
        CONTROLS_BUTTON_COLOR_TP_UNLOCKED = CONTROLS_BUTTON_COLOR_BG;
        CONTROLS_BUTTON_COLOR_TP_LOCKED = CONTROLS_BUTTON_COLOR_ENABLE;
    }

    TickSize = -1;

    if (DeinitializationReason != REASON_CHARTCHANGE) ExtDialog = new CPositionSizeCalculator; // Create the panel only if it is not a symbol/timeframe change.
    else OldTakeProfitsNumber = sets.TakeProfitsNumber; // Will be used to resize the panel if needed when switching symbols in some modes.
    
    PrevChartWidth = 0;
    
    MathSrand(GetTickCount() + 293029); // Used by CreateInstanceId() in Dialog.mqh (standard library). Keep the second number unique across other panel indicators/EAs.

    if (SettingsFile != "") // Load a custom settings file if given via input parameters.
    {
        ExtDialog.SetFileName(SettingsFile);
    }

    Dont_Move_the_Panel_to_Default_Corner_X_Y = true;

    PanelCaptionBase = "Position Sizer (ver. " + Version + ")";

    // Symbol changed.
    if ((DeinitializationReason == REASON_CHARTCHANGE) && (OldSymbol != _Symbol))
    {
        ObjectsDeleteAll(0, ObjectPrefix, -1, OBJ_HLINE); // All lines should be deleted, so that they could be recreated at new sets. values.
        if (SymbolChange == SYMBOL_CHART_CHANGE_EACH_OWN)
        {
            ExtDialog.SaveSettingsOnDisk(OldSymbol); // Save old symbol's settings.
        }
        ExtDialog.UpdateFileName(); // Update the filename.

        // Reset everything.
        OutputPointValue = ""; OutputSwapsType = TRANSLATION_LABEL_UNKNOWN; SwapsTripleDay = "?";
        OutputSwapsDailyLongLot = "?"; OutputSwapsDailyShortLot = "?"; OutputSwapsDailyLongPS = "?"; OutputSwapsDailyShortPS = "?";
        OutputSwapsYearlyLongLot = "?"; OutputSwapsYearlyShortLot = "?"; OutputSwapsYearlyLongPS = "?"; OutputSwapsYearlyShortPS = "?";
        OutputSwapsCurrencyDailyLot = ""; OutputSwapsCurrencyDailyPS = ""; OutputSwapsCurrencyYearlyLot = ""; OutputSwapsCurrencyYearlyPS = "";
        ReferenceSymbol = NULL; SwapConversionSymbol = ""; AdditionalReferenceSymbol = NULL;
        WarnedAboutZeroUnitCost = 0;
                
        NeedToCheckToggleScaleOffOn = true;

        if (SymbolChange == SYMBOL_CHART_CHANGE_HARD_RESET)
        {
            // Lines are treated as a part of the panel.
            if (DefaultLinesSelected) LinesSelectedStatus = 1; // Flip lines to selected.
            else LinesSelectedStatus = 2; // Flip lines to unselected.
        }
    }
    bool is_InitControlsValues_required = false;
    // Normal attempt to load settings fails (attempted in not chart change case and in chart case with 'each pair own settings' case
    if ((((DeinitializationReason != REASON_CHARTCHANGE) || ((DeinitializationReason == REASON_CHARTCHANGE) && (OldSymbol != _Symbol) && (SymbolChange == SYMBOL_CHART_CHANGE_EACH_OWN))) && (!ExtDialog.LoadSettingsFromDisk())) 
    // OR chart change with hard_reset configured and with symbol change.
      || ((DeinitializationReason == REASON_CHARTCHANGE) && (SymbolChange == SYMBOL_CHART_CHANGE_HARD_RESET) && (OldSymbol != _Symbol)))
    {
        sets.TradeDirection = DefaultTradeDirection;
        sets.EntryLevel = EntryLevel;
        sets.StopLossLevel = StopLossLevel;
        sets.TakeProfitLevel = TakeProfitLevel; // Optional
        sets.TakeProfitsNumber = DefaultTakeProfitsNumber;
        if (sets.TakeProfitsNumber < 1) sets.TakeProfitsNumber = 1; // At least one TP.
        ArrayResize(sets.TP, sets.TakeProfitsNumber);
        ArrayResize(sets.TPShare, sets.TakeProfitsNumber);
        ArrayResize(TakeProfitLineIsBeingMoved, sets.TakeProfitsNumber);
        ArrayInitialize(sets.TP, 0);
        ArrayInitialize(sets.TPShare, 100 / sets.TakeProfitsNumber);
        ArrayResize(sets.WasSelectedAdditionalTakeProfitLine, sets.TakeProfitsNumber - 1); // -1 because the flag for the main TP is saved elsewhere.
        sets.ATRPeriod = DefaultATRPeriod;
        sets.ATRMultiplierSL = DefaultATRMultiplierSL;
        sets.ATRMultiplierTP = DefaultATRMultiplierTP;
        sets.ATRTimeframe = DefaultATRTimeframe;
        sets.EntryType = DefaultEntryType; // If Instant, Entry level will be updated to current Ask/Bid price automatically; if Pending, Entry level will remain intact and StopLevel warning will be issued if needed.
        sets.Risk = DefaultRisk; // Risk tolerance in percentage points
        sets.MoneyRisk = DefaultMoneyRisk; // Risk tolerance in account currency
        if (DefaultMoneyRisk > 0) sets.UseMoneyInsteadOfPercentage = true;
        else sets.UseMoneyInsteadOfPercentage = false;
        if (DefaultPositionSize > 0)
        {
            sets.RiskFromPositionSize = true;
            sets.PositionSize = DefaultPositionSize;
            OutputPositionSize = DefaultPositionSize;
        }
        else sets.RiskFromPositionSize = false;
        sets.CommissionPerLot = DefaultCommission; // Commission charged per lot (one side) in account currency or %.
        sets.CommissionType = DefaultCommissionType;
        sets.CustomBalance = CustomBalance;
        sets.AccountButton = DefaultAccountButton;
        sets.CountPendingOrders = DefaultCountPendingOrders; // If true, portfolio risk calculation will also involve pending orders.
        sets.IgnoreOrdersWithoutSL = DefaultIgnoreOrdersWithoutSL; // If true, portfolio risk calculation will skip orders without stop-loss.
        sets.IgnoreOrdersWithoutTP = DefaultIgnoreOrdersWithoutTP; // If true, portfolio risk calculation will skip orders without take-profit.
        sets.IgnoreSymbols = DefaultIgnoreSymbols; // Skip trades in other/current/no symbols for portfolio risk calculation.
        sets.HideAccSize = HideAccSize; // If true, account size line will not be shown.
        sets.ShowLines = DefaultShowLines;
        sets.SelectedTab = MainTab;
        sets.CustomLeverage = DefaultCustomLeverage;
        sets.MagicNumber = DefaultMagicNumber;
        sets.Commentary = DefaultCommentary;
        sets.CommentAutoSuffix = DefaultCommentAutoSuffix;
        sets.DisableTradingWhenLinesAreHidden = DefaultDisableTradingWhenLinesAreHidden;
        if (sets.TakeProfitsNumber > 1)
        {
            for (int i = 0; i < sets.TakeProfitsNumber; i++)
            {
                sets.TP[i] = TakeProfitLevel;
                sets.TPShare[i] = 100 / sets.TakeProfitsNumber;
            }
        }
        sets.MaxSlippage = DefaultMaxSlippage;
        sets.MaxSpread = DefaultMaxSpread;
        sets.MaxEntrySLDistance = DefaultMaxEntrySLDistance;
        sets.MinEntrySLDistance = DefaultMinEntrySLDistance;
        sets.MaxPositionSizeTotal = DefaultMaxPositionSizeTotal;
        sets.MaxPositionSizePerSymbol = DefaultMaxPositionSizePerSymbol;
        sets.MaxRiskPercentage = DefaultMaxRiskPercentage;
        if ((sets.MaxPositionSizeTotal < sets.MaxPositionSizePerSymbol) && (sets.MaxPositionSizeTotal != 0)) sets.MaxPositionSizeTotal = sets.MaxPositionSizePerSymbol;
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
        sets.TrailingStopPoints = DefaultTrailingStop;
        sets.BreakEvenPoints = DefaultBreakEven;
        sets.ExpiryMinutes = DefaultExpiryMinutes;
        if ((sets.ExpiryMinutes != 0) && (sets.ExpiryMinutes < 10)) sets.ExpiryMinutes = 0;
        sets.MaxNumberOfTradesTotal = DefaultMaxNumberOfTradesTotal;
        sets.MaxNumberOfTradesPerSymbol = DefaultMaxNumberOfTradesPerSymbol;
        if ((sets.MaxNumberOfTradesTotal < sets.MaxNumberOfTradesPerSymbol) && (sets.MaxNumberOfTradesTotal != 0)) sets.MaxNumberOfTradesTotal = sets.MaxNumberOfTradesPerSymbol;
        sets.MaxRiskTotal = DefaultMaxRiskTotal;
        sets.MaxRiskPerSymbol = DefaultMaxRiskPerSymbol;
        if ((sets.MaxRiskTotal < sets.MaxRiskPerSymbol) && (sets.MaxRiskTotal != 0)) sets.MaxRiskTotal = sets.MaxRiskPerSymbol;
        sets.ShareVolumeMode = Decreasing;
        sets.TemplateChanged = false;
        sets.SLDistanceInPoints = DefaultSLDistanceInPoints;
        sets.TPDistanceInPoints = DefaultTPDistanceInPoints;
        if (DeinitializationReason == REASON_CHARTCHANGE) is_InitControlsValues_required = true;
        sets.LastAdditionalTPScheme = ADDITIONAL_TP_SCHEME_OUTWARD;
    }
    if (sets.TakeProfitsNumber < 1) // Read an old settings file with absent or bogus TakeProfitNumber parameter
    {
        sets.TakeProfitsNumber = 1; // At least one TP.
        ArrayResize(sets.TP, sets.TakeProfitsNumber);
        ArrayResize(sets.TPShare, sets.TakeProfitsNumber);
        ArrayResize(TakeProfitLineIsBeingMoved, sets.TakeProfitsNumber);
        ArrayInitialize(sets.TP, 0);
        ArrayInitialize(sets.TPShare, 100 / sets.TakeProfitsNumber);
        ArrayResize(sets.WasSelectedAdditionalTakeProfitLine, sets.TakeProfitsNumber - 1); // -1 because the flag for the main TP is saved elsewhere.
    }
    if (DeinitializationReason != REASON_CHARTCHANGE)
    {
        if (!ExtDialog.Create(0, "Position Sizer (ver. " + Version + ")", 0, DefaultPanelPositionX, DefaultPanelPositionY)) return INIT_FAILED;
        ExtDialog.Run();

        // No ini file - move the panel according to the inputs.
        if (!FileIsExist(ExtDialog.IniFileName() + ExtDialog.IniFileExt()))
        {
            Dont_Move_the_Panel_to_Default_Corner_X_Y = false;
        }
        ExtDialog.IniFileLoad();

        // If a hotkey is given, break up the string to check for hotkey presses in OnChartEvent().
        if (TradeHotKey != "") DissectHotKeyCombination(TradeHotKey, ShiftRequired_TradeHotKey, CtrlRequired_TradeHotKey, MainKey_TradeHotKey);
        else MainKey_TradeHotKey = 0;
        if (SwitchEntryDirectionHotKey != "") DissectHotKeyCombination(SwitchEntryDirectionHotKey, ShiftRequired_SwitchEntryDirectionHotKey, CtrlRequired_SwitchEntryDirectionHotKey, MainKey_SwitchEntryDirectionHotKey);
        else MainKey_SwitchEntryDirectionHotKey = 0;
        if (SwitchOrderTypeHotKey != "") DissectHotKeyCombination(SwitchOrderTypeHotKey, ShiftRequired_SwitchOrderTypeHotKey, CtrlRequired_SwitchOrderTypeHotKey, MainKey_SwitchOrderTypeHotKey);
        else MainKey_SwitchOrderTypeHotKey = 0;
        if (SwitchHideShowLinesHotKey != "") DissectHotKeyCombination(SwitchHideShowLinesHotKey, ShiftRequired_SwitchHideShowLinesHotKey, CtrlRequired_SwitchHideShowLinesHotKey, MainKey_SwitchHideShowLinesHotKey);
        else MainKey_SwitchHideShowLinesHotKey = 0;
        if (SetStopLossHotKey != "") DissectHotKeyCombination(SetStopLossHotKey, ShiftRequired_SetStopLossHotKey, CtrlRequired_SetStopLossHotKey, MainKey_SetStopLossHotKey);
        else MainKey_SetStopLossHotKey = 0;
        if (SetTakeProfitHotKey != "") DissectHotKeyCombination(SetTakeProfitHotKey, ShiftRequired_SetTakeProfitHotKey, CtrlRequired_SetTakeProfitHotKey, MainKey_SetTakeProfitHotKey);
        else MainKey_SetTakeProfitHotKey = 0;
        if (SetEntryHotKey != "") DissectHotKeyCombination(SetEntryHotKey, ShiftRequired_SetEntryHotKey, CtrlRequired_SetEntryHotKey, MainKey_SetEntryHotKey);
        else MainKey_SetEntryHotKey = 0;
        if (SwitchSLPointsLevelHotKey != "") DissectHotKeyCombination(SwitchSLPointsLevelHotKey, ShiftRequired_SwitchSLPointsLevelHotKey, CtrlRequired_SwitchSLPointsLevelHotKey, MainKey_SwitchSLPointsLevelHotKey);
        else MainKey_SwitchSLPointsLevelHotKey = 0;
        if (SwitchTPPointsLevelHotKey != "") DissectHotKeyCombination(SwitchTPPointsLevelHotKey, ShiftRequired_SwitchTPPointsLevelHotKey, CtrlRequired_SwitchTPPointsLevelHotKey, MainKey_SwitchTPPointsLevelHotKey);
        else MainKey_SwitchTPPointsLevelHotKey = 0;
        if (MinimizeMaximizeHotkey != "") DissectHotKeyCombination(MinimizeMaximizeHotkey, ShiftRequired_MinimizeMaximizeHotkey, CtrlRequired_MinimizeMaximizeHotkey, MainKey_MinimizeMaximizeHotkey);
        else MainKey_MinimizeMaximizeHotkey = 0;
    }
    else if (OldSymbol != _Symbol)
    {
        if (SymbolChange == SYMBOL_CHART_CHANGE_HARD_RESET) // Reset Entry, SL, and all TPs if it was a symbol change and a hard reset is required.
        {
            sets.EntryLevel = 0;
            sets.StopLossLevel = 0;
            sets.StopLoss = 0;
            sets.TakeProfitLevel = 0;
            sets.TakeProfit = 0;
            for (int i = 0; i < sets.TakeProfitsNumber; i++)
            {
                sets.TP[i] = 0;
            }
            Dont_Move_the_Panel_to_Default_Corner_X_Y = false;
        }
    }
    // Avoid re-initialization on timeframe change and on symbol change with the 'keep panel' setting.
    if ((DeinitializationReason != REASON_CHARTCHANGE) || ((DeinitializationReason == REASON_CHARTCHANGE) && (OldSymbol != _Symbol) && ((SymbolChange == SYMBOL_CHART_CHANGE_HARD_RESET) || (SymbolChange == SYMBOL_CHART_CHANGE_EACH_OWN))))
    {
        if (DeinitializationReason == REASON_CHARTCHANGE) // Do not run if it is not the symbol change because 'CPositionSizeCalculator::Create()' takes care of that in other cases.
        {
            // Remove extra empty space on the panel when going from a panel with more TPs to a panel with fewer TPs.
            if (sets.TakeProfitsNumber < OldTakeProfitsNumber)
            {
                Initialization();
                int NewTakeProfitsNumber = sets.TakeProfitsNumber;
                sets.TakeProfitsNumber = OldTakeProfitsNumber; // Used and decremented inside OnClickBtnTakeProfitsNumberRemove().
                while (sets.TakeProfitsNumber > NewTakeProfitsNumber)
                {
                    ExtDialog.OnClickBtnTakeProfitsNumberRemove();
                }
            }
            else// if (DeinitializationReason == REASON_CHARTCHANGE) // Do not run if it is not the symbol change because 'CPositionSizeCalculator::Create()' takes care of that in other cases.
            {
                // Create necessary panel elements if newly loaded symbol has more TPs.
                int NewTakeProfitsNumber = sets.TakeProfitsNumber;
                sets.TakeProfitsNumber = OldTakeProfitsNumber; // It will be increased inside OnClickBtnTakeProfitsNumberAdd().
                while (sets.TakeProfitsNumber < NewTakeProfitsNumber)
                {
                    ExtDialog.OnClickBtnTakeProfitsNumberAdd();
                }
                // Theese three should be executed only after all TP arrays are properly resized.
                Initialization();
                ExtDialog.IniFileLoad(); // InitObjects(); is skipped because it will be done after adding all the TP chart objects.
            }
        }
        else Initialization();
        // Brings panel on top of other objects without actual maximization of the panel.
        ExtDialog.HideShowMaximize();
    }

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

    if (!IsVisualMode()) // The timer doesn't work in MT4 Strategy Tester.
    {
        if (!EventSetTimer(1)) Print(TRANSLATION_MESSAGE_ERROR_SETTING_TIMER + ": ", GetLastError());
    }

    if (DarkMode)
    {
        int total = ObjectsTotal(ChartID());
        for (int i = 0; i < total; i++)
        {
            string obj_name = ObjectName(ChartID(), i);
            if (StringSubstr(obj_name, 0, StringLen(ExtDialog.Name())) != ExtDialog.Name()) continue; // Skip non-panel objects.
            if (obj_name == ExtDialog.Name() + "Back")
            {
                
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BGCOLOR, DARKMODE_BG_DARK_COLOR);
            }
            if (obj_name == ExtDialog.Name() + "Caption")
            {
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BGCOLOR, DARKMODE_BG_DARK_COLOR);
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_COLOR, DARKMODE_CONTROL_BRODER_COLOR);
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BORDER_COLOR, DARKMODE_BG_DARK_COLOR);
            }
            else if (obj_name == ExtDialog.Name() + "ClientBack")
            {
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_COLOR, DARKMODE_MAIN_AREA_BORDER_COLOR);
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BGCOLOR, DARKMODE_MAIN_AREA_BG_COLOR);
            }
            else if (StringSubstr(obj_name, 0, StringLen(ExtDialog.Name() + "m_Edt")) == ExtDialog.Name() + "m_Edt")
            {
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BGCOLOR, DARKMODE_EDIT_BG_COLOR);
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BORDER_COLOR, DARKMODE_CONTROL_BRODER_COLOR);
            }
            else if (obj_name == ExtDialog.Name() + "m_BtnTakeProfit") // TakeProfit button has its own colors.
            {
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BORDER_COLOR, DARKMODE_CONTROL_BRODER_COLOR);
            }
            else if (StringSubstr(obj_name, 0, StringLen(ExtDialog.Name() + "m_Btn")) == ExtDialog.Name() + "m_Btn")
            {
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BGCOLOR, DARKMODE_BUTTON_BG_COLOR);
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BORDER_COLOR, DARKMODE_CONTROL_BRODER_COLOR);
            }
            else if (StringSubstr(obj_name, 0, StringLen(ExtDialog.Name() + "m_Chk")) == ExtDialog.Name() + "m_Chk")
            {
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_COLOR, DARKMODE_TEXT_COLOR);
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BGCOLOR, DARKMODE_MAIN_AREA_BG_COLOR);
                ObjectSetInteger(ChartID(), obj_name, OBJPROP_BORDER_COLOR, DARKMODE_MAIN_AREA_BG_COLOR);
            }
            else
            {
                if (obj_name == ExtDialog.Name() + "m_LblURL") ObjectSetInteger(ChartID(), obj_name, OBJPROP_COLOR, 0x224400);
                else ObjectSetInteger(ChartID(), obj_name, OBJPROP_COLOR, DARKMODE_TEXT_COLOR);
            }
        }
    }
    
    // If symbol change with a reset was enacted.
    if (is_InitControlsValues_required) ExtDialog.InitControlsValues();

    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
    DeinitializationReason = reason; // Remember reason to avoid recreating the panel in the OnInit() if it is not deleted here.
    
    EventKillTimer();

    if (reason == REASON_TEMPLATE) sets.TemplateChanged = true; // Will be used to select lines according to the DefaultLinesSelected input parameter.

    if ((reason == REASON_CLOSE) || (reason == REASON_REMOVE) || (reason == REASON_CHARTCLOSE) || (reason == REASON_PROGRAM))
    {
        ObjectsDeleteAll(0, ObjectPrefix); // Delete all lines if platform was closed.
        if ((reason == REASON_REMOVE) || (reason == REASON_PROGRAM))
        {
            if (SettingsFile == "") ExtDialog.DeleteSettingsFile();
            if (!FileDelete(ExtDialog.IniFileName() + ExtDialog.IniFileExt())) Print(TRANSLATION_MESSAGE_FAILED_DELETE_INI + ": ", GetLastError());
        }
    }
    
    // It is deinitialization due to input parameters change - save current parameters values (that are also changed via panel) to global variables.
    if (reason == REASON_PARAMETERS) GlobalVariableSet("PS-" + IntegerToString(ChartID()) + "-Parameters", 1);

    if ((reason != REASON_CHARTCHANGE) && (reason != REASON_REMOVE) && (reason != REASON_PROGRAM))
    {
        ExtDialog.SaveSettingsOnDisk();
        ExtDialog.IniFileSave();
    }
    
    if (reason == REASON_CHARTCHANGE)
    {
        OldSymbol = _Symbol;
        PrevChartWidth = (int)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS); // Chart width is used to detect going from wide-quote symbol to a narrower one.
    }
    else
    {
        ObjectDelete(0, ObjectPrefix + "StopLossLabel");
        ObjectDelete(0, ObjectPrefix + "EntryLabel");
        ObjectsDeleteAll(0, ObjectPrefix + "TakeProfitLabel", -1, OBJ_LABEL);
        ObjectsDeleteAll(0, ObjectPrefix + "TPAdditionalLabel", -1, OBJ_LABEL);
        ObjectDelete(0, ObjectPrefix + "SLAdditionalLabel");
        ObjectDelete(0, ObjectPrefix + "EntryAdditionalLabel");
        ExtDialog.Destroy();
        delete ExtDialog;
    }
    
    ObjectsDeleteAll(0, ObjectPrefix + "BE"); // Delete all BE lines and labels.
}

void OnTick()
{
    if (IsVisualMode()) // Visual backtesting.
    {
        ListenToChartEvents(ExtDialog.Name()); // Check and generate chart events in Strategy Tester.
        ExtDialog.UpdateStrategyTesterTrades();
    }
    
    ExtDialog.RefreshValues();
    
    if (sets.TrailingStopPoints > 0) DoTrailingStop();
}

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
    if (id == CHARTEVENT_MOUSE_MOVE)
    {
        Mouse_Last_X = (int)lparam;
        Mouse_Last_Y = (int)dparam;
        if (((uint)sparam & 1) == 1) // While left mouse button is down.
        {
            if ((sets.SLDistanceInPoints) || ((ShowATROptions) && (sets.ATRMultiplierSL > 0)))
            {
                double current_line_price = NormalizeDouble(ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0), _Digits);
                if (MathAbs(current_line_price - tStopLossLevel) > _Point / 2.0) // != for doubles.
                {
                    StopLossLineIsBeingMoved = true;
                }
                else StopLossLineIsBeingMoved = false;
            }
            if ((sets.TPDistanceInPoints) || ((ShowATROptions) && (sets.ATRMultiplierTP > 0)))
            {
                ArrayInitialize(TakeProfitLineIsBeingMoved, false);
                double current_line_price = NormalizeDouble(ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0), _Digits);
                if (MathAbs(current_line_price - tTakeProfitLevel) > _Point / 2.0) // != for doubles.
                {
                    TakeProfitLineIsBeingMoved[0] = true;
                }
                // Additional take-profits.
                else
                {
                    for (int i = 1; i < sets.TakeProfitsNumber; i++) // Will fire only if sets.TakeProfitsNumber > 1.
                    {
                        if (sets.TP[i] != 0) // With zero points TP, keep the TP lines at zero level - as with the main TP level.
                        {
                            current_line_price = NormalizeDouble(ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, 0), _Digits);
                            if (MathAbs(current_line_price - sets.TP[i]) > _Point / 2.0) // != for doubles.
                            {
                                TakeProfitLineIsBeingMoved[i] = true;
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    // Some buttons cannot be processed using the panel's event handler because they aren't added to the panel's list of controls.
    if (id == CHARTEVENT_OBJECT_CLICK)
    {
        // Outside trade button:
        if (sparam == ExtDialog.Name() + "m_OutsideTradeButton")
        {
            ExtDialog.m_OutsideTradeButton.Pressed(false);
            Trade();
        }
        else if (IsVisualMode())
        {
            // Button to switch the corner of the outside close buttons.
            if (sparam == ExtDialog.Name() + "m_BtnOutsideCloseButtonsSwitchButton")
            {
                ExtDialog.ProcessOutsideCloseButtonsSwitchClick();
            }
            // Outside close button:
            else if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "m_BtnOutsideClose")) == ExtDialog.Name() + "m_BtnOutsideClose")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "m_BtnOutsideClose")));
                ExtDialog.ProcessOutsideCloseButtonClick(i);
            }
        }
    }
        
    if (id == CHARTEVENT_CLICK) // Avoid "sticking" of xxxLineIsBeingMoved variables.
    {
        StopLossLineIsBeingMoved = false;
        ArrayInitialize(TakeProfitLineIsBeingMoved, false);
    }

    // Remember the panel's location to have the same location for minimized and maximized states.
    if ((id == CHARTEVENT_CUSTOM + ON_DRAG_END) && (lparam == -1))
    {
        ExtDialog.remember_top = ExtDialog.Top();
        ExtDialog.remember_left = ExtDialog.Left();
    }

    // Catch multiple TP fields.
    if (sets.TakeProfitsNumber > 1)
    {
        if (id == CHARTEVENT_CUSTOM + ON_END_EDIT)
        {
            // Additional take-profit field #N on Main tab.
            if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "m_EdtAdditionalTPEdits")) == ExtDialog.Name() + "m_EdtAdditionalTPEdits")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "m_EdtAdditionalTPEdits"))) - 1;
                ExtDialog.UpdateAdditionalTPEdit(i);
            }
            // Take-profit field #N on Trading tab.
            else if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "m_EdtTradingTPEdit")) == ExtDialog.Name() + "m_EdtTradingTPEdit")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "m_EdtTradingTPEdit"))) - 1;
                ExtDialog.UpdateTradingTPEdit(i);
            }
            // Trading take-profit share field #N on Trading tab.
            else if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "m_EdtTradingTPShareEdit")) == ExtDialog.Name() + "m_EdtTradingTPShareEdit")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "m_EdtTradingTPShareEdit"))) - 1;
                ExtDialog.UpdateTradingTPShareEdit(i);
            }
        }
        else if (id == CHARTEVENT_CUSTOM + ON_CLICK)
        {
            // Additional take-profit increase button #N on Main tab.
            if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "m_BtnAdditionalTPButtonsIncrease")) == ExtDialog.Name() + "m_BtnAdditionalTPButtonsIncrease")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "m_BtnAdditionalTPButtonsIncrease"))) - 1;
                ExtDialog.ProcessAdditionalTPButtonsIncrease(i);
            }
            // Additional take-profit decrease button #N on Main tab.
            else if (StringSubstr(sparam, 0, StringLen(ExtDialog.Name() + "m_BtnAdditionalTPButtonsDecrease")) == ExtDialog.Name() + "m_BtnAdditionalTPButtonsDecrease")
            {
                int i = (int)StringToInteger(StringSubstr(sparam, StringLen(ExtDialog.Name() + "m_BtnAdditionalTPButtonsDecrease"))) - 1;
                ExtDialog.ProcessAdditionalTPButtonsDecrease(i);
            }
            // Because there is a bug that keeps a control's Id() = -1 if it is created after the panel is initialized. So, it cannot be processed with the panel's event processor.
            else if (sparam == ExtDialog.Name() + "m_BtnTakeProfitsNumberRemove")
            {
                ExtDialog.OnClickBtnTakeProfitsNumberRemove();
            }
            else if (sparam == ExtDialog.Name() + "m_BtnTPsInward")
            {
                ExtDialog.OnClickBtnTPsInward();
            }
            else if (sparam == ExtDialog.Name() + "m_BtnTPsOutward")
            {
                ExtDialog.OnClickBtnTPsOutward();
            }
            else if (sparam == ExtDialog.Name() + "m_BtnTradingTPShare")
            {
                ExtDialog.OnClickBtnTradingTPShare();
            }
        }
    }

    if (id == CHARTEVENT_KEYDOWN)
    {
        // Trade direction:
        if ((MainKey_SwitchEntryDirectionHotKey != 0) && (lparam == MainKey_SwitchEntryDirectionHotKey)
            && ((((!ShiftRequired_SwitchEntryDirectionHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SwitchEntryDirectionHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_SwitchEntryDirectionHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SwitchEntryDirectionHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0)))) // Control
           )
        {
            SwitchEntryDirection();
        }
        // Order type:
        else if ((MainKey_SwitchOrderTypeHotKey != 0) && (lparam == MainKey_SwitchOrderTypeHotKey)
            && ((((!ShiftRequired_SwitchOrderTypeHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SwitchOrderTypeHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_SwitchOrderTypeHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SwitchOrderTypeHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            ExtDialog.OnClickBtnOrderType();
        }
        // Hide/Show lines:
        else if ((MainKey_SwitchHideShowLinesHotKey != 0) && (lparam == MainKey_SwitchHideShowLinesHotKey)
            && ((((!ShiftRequired_SwitchHideShowLinesHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SwitchHideShowLinesHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_SwitchHideShowLinesHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SwitchHideShowLinesHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            ExtDialog.OnClickBtnLines();
        }
        // Trade:
        else if ((MainKey_TradeHotKey != 0) && (lparam == MainKey_TradeHotKey)
            && ((((!ShiftRequired_TradeHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_TradeHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_TradeHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_TradeHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            Trade(); 
        }
        // Set stop-loss:
        else if ((MainKey_SetStopLossHotKey != 0) && (lparam == MainKey_SetStopLossHotKey)
            && ((((!ShiftRequired_SetStopLossHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SetStopLossHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_SetStopLossHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SetStopLossHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            // Capture point price location.
            int subwindow;
            double price;
            datetime time; // Dummy.
            ChartXYToTimePrice(ChartID(), Mouse_Last_X, Mouse_Last_Y, subwindow, time, price);
            // If valid, move the SL line there.
            if ((subwindow == 0) && (price > 0))
            {
                if (TickSize > 0) price = NormalizeDouble(MathRound(price / TickSize) * TickSize, _Digits);
                ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, price);
                if ((sets.SLDistanceInPoints) || (ShowATROptions)) ExtDialog.UpdateFixedSL();
                ExtDialog.RefreshValues();
            }
        }
        // Set take-profit:
        else if ((MainKey_SetTakeProfitHotKey != 0) && (lparam == MainKey_SetTakeProfitHotKey)
            && ((((!ShiftRequired_SetTakeProfitHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SetTakeProfitHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_SetTakeProfitHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SetTakeProfitHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            // Capture point price location.
            int subwindow;
            double price;
            datetime time; // Dummy.
            ChartXYToTimePrice(ChartID(), Mouse_Last_X, Mouse_Last_Y, subwindow, time, price);
            // If valid, move the TP line there.
            if ((subwindow == 0) && (price > 0))
            {
                // If "TP locked on SL" mode was on, turn it off.
                if (sets.TPLockedOnSL)
                {
                    ExtDialog.SetTPButtonBackGroundColor(CONTROLS_BUTTON_COLOR_TP_UNLOCKED);
                    sets.TPLockedOnSL = false;
                }
                if (TickSize > 0) price = NormalizeDouble(MathRound(price / TickSize) * TickSize, _Digits);
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, price);
                if ((sets.TPDistanceInPoints) || (ShowATROptions)) ExtDialog.UpdateFixedTP();
                ExtDialog.ShowTPRelatedEdits();
                ExtDialog.RefreshValues();
                ExtDialog.HideShowMaximize();
                ExtDialog.MoveAndResize();
            }
        }
        // Set entry:
        else if ((MainKey_SetEntryHotKey != 0) && (lparam == MainKey_SetEntryHotKey)
            && ((((!ShiftRequired_SetEntryHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SetEntryHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_SetEntryHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SetEntryHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            // Capture point price location.
            int subwindow;
            double price;
            datetime time; // Dummy.
            ChartXYToTimePrice(ChartID(), Mouse_Last_X, Mouse_Last_Y, subwindow, time, price);
            // If valid, move the Entry line there and switch from Instant to Pending if necessary.
            if ((subwindow == 0) && (price > 0))
            {
                if (TickSize > 0) price = NormalizeDouble(MathRound(price / TickSize) * TickSize, _Digits);
                ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, price);
                if (sets.EntryType == Instant)
                {
                    ExtDialog.OnClickBtnOrderType(); // Includes RefreshValues().
                }
                else ExtDialog.RefreshValues();
            }
        }
        // Minimize/maximize:
        else if ((MainKey_MinimizeMaximizeHotkey != 0) && (lparam == MainKey_MinimizeMaximizeHotkey)
            && ((((!ShiftRequired_MinimizeMaximizeHotkey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_MinimizeMaximizeHotkey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_MinimizeMaximizeHotkey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_MinimizeMaximizeHotkey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            ExtDialog.EmulateMinMaxClick();
        }
        // Switch SL between points and level:
        else if ((MainKey_SwitchSLPointsLevelHotKey != 0) && (lparam == MainKey_SwitchSLPointsLevelHotKey)
            && ((((!ShiftRequired_SwitchSLPointsLevelHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SwitchSLPointsLevelHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_SwitchSLPointsLevelHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SwitchSLPointsLevelHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            if (sets.SLDistanceInPoints) sets.SLDistanceInPoints = false; // If was in points, set to level.
            else
            {
                sets.SLDistanceInPoints = true; // If was in level, set to points.
                sets.StopLoss = (int)MathRound(MathAbs(sets.StopLossLevel - sets.EntryLevel) / _Point);
            }
            ExtDialog.RefreshValues();
        }
        // Switch TP between points and level:
        else if ((MainKey_SwitchTPPointsLevelHotKey != 0) && (lparam == MainKey_SwitchTPPointsLevelHotKey)
            && ((((!ShiftRequired_SwitchTPPointsLevelHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) >= 0))   || ((ShiftRequired_SwitchTPPointsLevelHotKey) && (TerminalInfoInteger(TERMINAL_KEYSTATE_SHIFT) < 0))) // Shift
            &&  (((!CtrlRequired_SwitchTPPointsLevelHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) >= 0)) || ((CtrlRequired_SwitchTPPointsLevelHotKey)  && (TerminalInfoInteger(TERMINAL_KEYSTATE_CONTROL) < 0))))) // Control
        {
            if (sets.TPDistanceInPoints) sets.TPDistanceInPoints = false; // If was in points, set to level.
            else
            {
                sets.TPDistanceInPoints = true; // If was in level, set to points.
                if (sets.TakeProfitLevel != 0) sets.TakeProfit = (int)MathRound(MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / _Point);
                // Additional take-profits.
                if (sets.TakeProfitsNumber > 1)
                {
                    for (int i = 1; i < sets.TakeProfitsNumber; i++)
                    {
                        if (sets.TP[i] != 0) // With zero points TP, keep the TP lines at zero level - as with the main TP level.
                        {
                            if (sets.TP[i] != 0) ExtDialog.AdditionalTPEdits[i - 1].Text(DoubleToString(MathAbs(MathRound((sets.TP[i] - sets.EntryLevel) / _Point)), 0));
                        }
                    }
                }
            }
            ExtDialog.RefreshValues();
        }
    }

    // Call Panel's event handler only if it is not a CHARTEVENT_CHART_CHANGE - workaround for minimization bug on chart switch.
    if (id != CHARTEVENT_CHART_CHANGE) ExtDialog.OnEvent(id, lparam, dparam, sparam);
    
    // Recalculate on chart changes, clicks, and certain object dragging.
    if ((id == CHARTEVENT_CLICK) || (id == CHARTEVENT_CHART_CHANGE) || ((id == CHARTEVENT_OBJECT_DRAG) && 
        ((sparam == ObjectPrefix + "EntryLine") || (sparam == ObjectPrefix + "StopLossLine") || (StringFind(sparam, ObjectPrefix + "TakeProfitLine") != -1))))
    {
        // Moving lines when fixed SL/TP distance is enabled. Should set a new fixed SL/TP distance.
        if ((id == CHARTEVENT_OBJECT_DRAG) && ((sets.SLDistanceInPoints) || (sets.TPDistanceInPoints) || (ShowATROptions)))
        {
            if (sparam == ObjectPrefix + "StopLossLine") ExtDialog.UpdateFixedSL();
            else if (sparam == ObjectPrefix + "TakeProfitLine") ExtDialog.UpdateFixedTP();
            else if ((sets.TakeProfitsNumber > 1) && (StringFind(sparam, ObjectPrefix + "TakeProfitLine") != -1))
            {
                int len = StringLen(ObjectPrefix + "TakeProfitLine");
                int i = (int)StringToInteger(StringSubstr(sparam, len));
                ExtDialog.UpdateAdditionalFixedTP(i);
            }
        }

        if (sparam == ObjectPrefix + "StopLossLine") StopLossLineIsBeingMoved = false; // In any case ending moving state for the stop-loss line.
        if (StringFind(sparam, ObjectPrefix + "TakeProfitLine") != -1) ArrayInitialize(TakeProfitLineIsBeingMoved, false); // In any case ending moving state for the take-profit line.

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
    if (NeedToCheckToggleScaleOffOn)
    {
        if ((double)ChartGetInteger(ChartID(), CHART_WIDTH_IN_PIXELS) != PrevChartWidth)
        {
            // Toggle price scale off and then on to return it to its original size.
            // This can be useful when switching from symbol with a wide price scale (index, BTC, etc.) to one with a narrow scale (EUR/USD).
            ChartSetInteger(ChartID(), CHART_SHOW_PRICE_SCALE, false);
            ChartSetInteger(ChartID(), CHART_SHOW_PRICE_SCALE, true);
        }
        NeedToCheckToggleScaleOffOn = false;
    }
    ExtDialog.CheckAndRestoreLines(); // Check if any lines should be restored.
    if (GetTickCount() - LastRecalculationTime < 1000) return; // Do not recalculate on timer if less than 1 second passed.
    ExtDialog.RefreshValues();
    ChartRedraw();
}
//+------------------------------------------------------------------+