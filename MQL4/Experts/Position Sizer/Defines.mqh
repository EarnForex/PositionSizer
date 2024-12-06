//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                                  Copyright © 2024, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#include <Controls\Button.mqh>
#include <Controls\Dialog.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Label.mqh>
#include <Arrays\List.mqh>

color CONTROLS_EDIT_COLOR_ENABLE  = C'255,255,255';
color CONTROLS_EDIT_COLOR_DISABLE = C'221,221,211';

color CONTROLS_BUTTON_COLOR_ENABLE  = C'200,200,200';
color CONTROLS_BUTTON_COLOR_DISABLE = C'224,224,224';

color DARKMODE_BG_DARK_COLOR = 0x444444;
color DARKMODE_CONTROL_BRODER_COLOR = 0x888888;
color DARKMODE_MAIN_AREA_BORDER_COLOR = 0x333333;
color DARKMODE_MAIN_AREA_BG_COLOR = 0x666666;
color DARKMODE_EDIT_BG_COLOR = 0xAAAAAA;
color DARKMODE_BUTTON_BG_COLOR = 0xA19999;
color DARKMODE_TEXT_COLOR = 0x000000;;

color CONTROLS_BUTTON_COLOR_TP_UNLOCKED, CONTROLS_BUTTON_COLOR_TP_LOCKED;

#define MULTIPLIER_VALUE_CONTROL 10
#define MULTIPLIER_VALUE_SHIFT 100
#define MULTIPLIER_VALUE_CONTROL_SHIFT 1000

enum ENTRY_TYPE
{
    Instant,
    Pending
};

enum ACCOUNT_BUTTON
{
    Balance,
    Equity,
    Balance_minus_Risk // Balance - Risk
};

enum TABS
{
    MainTab,
    RiskTab,
    MarginTab,
    SwapsTab,
    TradingTab
};

enum TRADE_DIRECTION
{
    Long,
    Short
};

enum PROFIT_LOSS
{
    Profit,
    Loss
};

enum CANDLE_NUMBER
{
    Current_Candle = 0, // Current candle
    Previous_Candle = 1 // Previous candle
};

enum VOLUME_SHARE_MODE
{
    Equal,      // Equal shares
    Decreasing, // Decreasing shares
    Increasing  // Increasing shares
};

enum SHOW_SPREAD
{
    No,
    Points,
    Ratio   // Spread / SL ratio
};

enum SYMBOL_CHART_CHANGE_REACTION
{
    SYMBOL_CHART_CHANGE_EACH_OWN,   // Each symbol - own settings
    SYMBOL_CHART_CHANGE_HARD_RESET, // Reset to defaults on symbol change
    SYMBOL_CHART_CHANGE_KEEP_PANEL  // Keep panel as is
};

enum COMMISSION_TYPE
{
    COMMISSION_CURRENCY, // Currency units
    COMMISSION_PERCENT,  // Percentage
};

enum CALCULATE_RISK_FOR_TRADING_TAB
{
    CALCULATE_RISK_FOR_TRADING_TAB_NO, // Normal calculation
    CALCULATE_RISK_FOR_TRADING_TAB_TOTAL, // For Trading tab - total
    CALCULATE_RISK_FOR_TRADING_TAB_PER_SYMBOL // For Trading tab - per symbol
};

enum ADDITIONAL_TP_SCHEME
{
    ADDITIONAL_TP_SCHEME_INWARD,  // The "<<" button has been clicked.
    ADDITIONAL_TP_SCHEME_OUTWARD  // The ">>" button has been clicked.
};

enum ADDITIONAL_TRADE_BUTTONS
{
    ADDITIONAL_TRADE_BUTTONS_NONE, // None
    ADDITIONAL_TRADE_BUTTONS_LINE, // Above the Entry line
    ADDITIONAL_TRADE_BUTTONS_MAIN, // Main tab
    ADDITIONAL_TRADE_BUTTONS_BOTH  // Both 
};

enum IGNORE_SYMBOLS
{
    IGNORE_SYMBOLS_NONE, // No symbols
    IGNORE_SYMBOLS_OTHER, // Other symbols
    IGNORE_SYMBOLS_CURRENT, // Current symbol
};

struct Settings
{
    ENTRY_TYPE       EntryType;
    double           EntryLevel;
    double           StopLossLevel;
    double           TakeProfitLevel;
    int              TakeProfitsNumber;
    double           Risk;
    double           MoneyRisk;
    double           CommissionPerLot;
    COMMISSION_TYPE  CommissionType;
    bool             UseMoneyInsteadOfPercentage;
    bool             RiskFromPositionSize;
    double           PositionSize; // Used only when RiskFromPositionSize == true.
    ACCOUNT_BUTTON   AccountButton;
    double           CustomBalance;
    bool             DeleteLines;
    bool             CountPendingOrders;
    bool             IgnoreOrdersWithoutSL;
    bool             IgnoreOrdersWithoutTP;
    IGNORE_SYMBOLS   IgnoreSymbols;
    bool             HideAccSize;
    bool             ShowLines;
    TABS             SelectedTab;
    double           CustomLeverage;
    int              MagicNumber;
    string           Commentary;
    bool             DisableTradingWhenLinesAreHidden;
    double           TP[];
    int              TPShare[];
    int              MaxSlippage;
    int              MaxSpread;
    int              MaxEntrySLDistance;
    int              MinEntrySLDistance;
    double           MaxRiskPercentage;
    // For SL/TP distance modes:
    bool             SLDistanceInPoints;
    bool             TPDistanceInPoints;
    int              StopLoss;
    int              TakeProfit;
    // Only for SL distance mode:
    TRADE_DIRECTION  TradeDirection;
    // For Trading only:
    bool             SubtractPositions;
    bool             SubtractPendingOrders;
    bool             DoNotApplyStopLoss;
    bool             DoNotApplyTakeProfit;
    bool             AskForConfirmation;
    bool             CommentAutoSuffix;
    int              TrailingStopPoints;
    int              BreakEvenPoints;
    int              MaxNumberOfTradesTotal;
    int              MaxNumberOfTradesPerSymbol;
    double           MaxPositionSizeTotal;
    double           MaxPositionSizePerSymbol;
    double           MaxRiskTotal;
    double           MaxRiskPerSymbol;
    int              ExpiryMinutes;
    // For ATR:
    int              ATRPeriod;
    double           ATRMultiplierSL;
    double           ATRMultiplierTP;
    ENUM_TIMEFRAMES  ATRTimeframe;
    bool             SpreadAdjustmentSL;
    bool             SpreadAdjustmentTP;
    // Remembering which lines have been selected:
    bool             WasSelectedEntryLine;
    bool             WasSelectedStopLossLine;
    bool             WasSelectedTakeProfitLine;
    bool             WasSelectedAdditionalTakeProfitLine[];
    // Panel states:
    bool             IsPanelMinimized;
    bool             TPLockedOnSL;
    VOLUME_SHARE_MODE ShareVolumeMode;
    bool             TemplateChanged;
    ADDITIONAL_TP_SCHEME LastAdditionalTPScheme;
} sets;

// An object class for a list of panel objects with their names for fields located on a given tab of the panel. There will be one list per tab.
class CStringForList : public CObject
{
    public:
        string      Name;
        CWnd*       Obj;
        bool        Hidden; // Used only in the Trading tab to avoid deleting the extra TPs but keep them hidden after removal.
        CStringForList() {Hidden = false;}
};

class CPanelList : public CList
{
    public:
        void DeleteListElementByName(const string name);
        void MoveListElementByName(const string name, const int index);
        void CreateListElementByName(CObject &obj, const string name);
        void SetHiddenByName(const string name, const bool hidden);
};
//+------------------------------------------------------------------+