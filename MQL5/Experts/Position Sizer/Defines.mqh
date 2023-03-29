//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                                  Copyright © 2023, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#include <Controls\Button.mqh>
#include <Controls\Dialog.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Label.mqh>
#include <Arrays\List.mqh>

#define CONTROLS_EDIT_COLOR_ENABLE  C'255,255,255'
#define CONTROLS_EDIT_COLOR_DISABLE C'221,221,211'

#define CONTROLS_BUTTON_COLOR_ENABLE  C'200,200,200'
#define CONTROLS_BUTTON_COLOR_DISABLE C'224,224,224'

enum ENTRY_TYPE
{
    Instant,
    Pending,
    StopLimit // Stop Limit
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

struct Settings
{
    ENTRY_TYPE EntryType;
    double EntryLevel;
    double StopLossLevel;
    double TakeProfitLevel;
    int  TakeProfitsNumber;
    double StopPriceLevel;
    double Risk;
    double MoneyRisk;
    double CommissionPerLot;
    COMMISSION_TYPE CommissionType;
    bool UseMoneyInsteadOfPercentage;
    bool RiskFromPositionSize;
    double PositionSize; // Used only when RiskFromPositionSize == true.
    ACCOUNT_BUTTON AccountButton;
    double CustomBalance;
    bool DeleteLines;
    bool CountPendingOrders;
    bool IgnoreOrdersWithoutSL;
    bool IgnoreOrdersWithoutTP;
    bool IgnoreOtherSymbols;
    bool HideAccSize;
    bool ShowLines;
    TABS SelectedTab;
    double CustomLeverage;
    int MagicNumber;
    string Commentary;
    bool DisableTradingWhenLinesAreHidden;
    double TP[];
    int TPShare[];
    int MaxSlippage;
    int MaxSpread;
    int MaxEntrySLDistance;
    int MinEntrySLDistance;
    double MaxPositionSize;
    // For SL/TP distance modes:
    int StopLoss;
    int TakeProfit;
    // Only for SL distance mode:
    TRADE_DIRECTION TradeDirection;
    // For Trading only:
    bool SubtractPositions;
    bool SubtractPendingOrders;
    bool DoNotApplyStopLoss;
    bool DoNotApplyTakeProfit;
    bool AskForConfirmation;
    bool CommentAutoSuffix;
    int TrailingStopPoints;
    int BreakEvenPoints;
    int MaxNumberOfTrades;
    bool AllSymbols;
    double MaxTotalRisk;
    // For ATR:
    int ATRPeriod;
    double ATRMultiplierSL;
    double ATRMultiplierTP;
    ENUM_TIMEFRAMES ATRTimeframe;
    bool SpreadAdjustmentSL;
    bool SpreadAdjustmentTP;
    // Remembering which lines have been selected:
    bool WasSelectedEntryLine;
    bool WasSelectedStopLossLine;
    bool WasSelectedTakeProfitLine;
    bool WasSelectedStopPriceLine;
    bool WasSelectedAdditionalTakeProfitLine[];
    // Panel states:
    bool IsPanelMinimized;
    bool TPLockedOnSL;
    VOLUME_SHARE_MODE ShareVolumeMode;
    bool TemplateChanged;
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
//+------------------------------------------------------------------+//+------------------------------------------------------------------+