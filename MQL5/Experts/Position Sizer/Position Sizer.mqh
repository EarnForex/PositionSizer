//+------------------------------------------------------------------+
//|                                               Position Sizer.mqh |
//|                                  Copyright © 2023, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#include "Defines.mqh"

class CPositionSizeCalculator : public CAppDialog
{
private:
    CButton          m_BtnTabMain, m_BtnTabRisk, m_BtnTabMargin, m_BtnTabSwaps, m_BtnTabTrading, m_BtnOrderType, m_BtnAccount, m_BtnLines, m_BtnStopLoss, m_BtnTakeProfit, m_BtnEntry, m_BtnATRTimeframe, m_BtnCommissionType, m_BtnMaxPS, m_BtnTrade, m_BtnTPsInward, m_BtnTPsOutward, m_BtnTradingTPShare, m_BtnQuickRisk1, m_BtnQuickRisk2, m_BtnEntryIncrease, m_BtnEntryDecrease, m_BtnStopLossIncrease, m_BtnStopLossDecrease, m_BtnTakeProfitIncrease, m_BtnTakeProfitDecrease, m_BtnStopPriceIncrease, m_BtnStopPriceDecrease, m_BtnTakeProfitsNumberAdd, m_BtnTakeProfitsNumberRemove;;
    CCheckBox        m_ChkSpreadAdjustmentSL, m_ChkSpreadAdjustmentTP, m_ChkCountPendings, m_ChkIgnoreOrdersWithoutSL, m_ChkIgnoreOrdersWithoutTP, m_ChkIgnoreOtherSymbols, m_ChkDisableTradingWhenLinesAreHidden, m_ChkSubtractPositions, m_ChkSubtractPendingOrders, m_ChkDoNotApplyStopLoss, m_ChkDoNotApplyTakeProfit, m_ChkAskForConfirmation, m_ChkCommentAutoSuffix;
    CEdit            m_EdtEntryLevel, m_EdtSL, m_EdtTP, m_EdtStopPrice, m_EdtAccount, m_EdtCommissionSize, m_EdtRiskPIn, m_EdtRiskPRes, m_EdtRiskMIn, m_EdtRiskMRes, m_EdtReward1, m_EdtReward2, m_EdtRR1, m_EdtRR2, m_EdtPosSize, m_EdtPointValue, m_EdtATRPeriod, m_EdtATRMultiplierSL, m_EdtATRMultiplierTP, m_EdtCurRiskM, m_EdtCurRiskP, m_EdtPotRiskM, m_EdtPotRiskP, m_EdtCurProfitM, m_EdtCurProfitP, m_EdtPotProfitM, m_EdtPotProfitP, m_EdtCurL, m_EdtPotL, m_EdtCurrentRRR, m_EdtPotentialRRR, m_EdtPosMargin, m_EdtUsedMargin, m_EdtFreeMargin, m_EdtCustomLeverage, m_EdtMaxPositionSizeByMargin, m_EdtSwapsType, m_EdtSwapsTripleDay, m_EdtSwapsNominalLong, m_EdtSwapsNominalShort, m_EdtSwapsDailyLongLot, m_EdtSwapsDailyShortLot, m_EdtSwapsDailyLongPS, m_EdtSwapsDailyShortPS, m_EdtSwapsYearlyLongLot, m_EdtSwapsYearlyShortLot, m_EdtSwapsYearlyLongPS, m_EdtSwapsYearlyShortPS, m_EdtMagicNumber, m_EdtExpiry, m_EdtCommentary, m_EdtMaxSlippage, m_EdtMaxSpread, m_EdtMaxEntrySLDistance, m_EdtMinEntrySLDistance, m_EdtMaxPositionSize, m_EdtTrailingStopPoints, m_EdtBreakEvenPoints, m_EdtMaxNumberOfTradesTotal, m_EdtMaxNumberOfTradesPerSymbol, m_EdtMaxPositionSizeTotal, m_EdtMaxPositionSizePerSymbol, m_EdtMaxRiskTotal, m_EdtMaxRiskPerSymbol;
    CLabel           m_LblEntryLevel, m_LblEntryWarning, m_LblSL, m_LblSLWarning, m_LblTPWarning, m_LblStopPrice, m_LblStopPriceWarning, m_LblOrderType, m_LblCommissionSize, m_LblAdditionalFundsAsterisk, m_LblInput, m_LblResult, m_LblRisk, m_LblRiskM, m_LblReward, m_LblRR, m_LblPosSize, m_LblPointValue, m_LblATRPeriod, m_LblATRMultiplierSL, m_LblATRMultiplierTP, m_LblATRValue, m_LblATRTimeframe, m_LblCurrentRiskMoney, m_LblCurrentRiskPerc, m_LblCurrentProfitMoney, m_LblCurrentProfitPerc, m_LblPotentialRiskMoney, m_LblPotentialRiskPerc, m_LblPotentialProfitMoney, m_LblPotentialProfitPerc, m_LblCurrentLots, m_LblCurrentRRR, m_LblPotentialLots, m_LblPotentialRRR, m_LblCurrentPortfolio, m_LblPotentialPortfolio, m_LblPosMargin, m_LblUsedMargin, m_LblFreeMargin, m_LblCustomLeverage, m_LblAccLeverage, m_LblSymbolLeverage, m_LblMaxPositionSizeByMargin, m_LblSwapsType, m_LblSwapsTripleDay, m_LblSwapsLong, m_LblSwapsShort, m_LblSwapsNominal, m_LblSwapsDaily, m_LblSwapsYearly, m_LblSwapsPerLotDaily, m_LblSwapsPerPSDaily, m_LblSwapsPerLotYearly, m_LblSwapsPerPSYearly, m_LblMagicNumber, m_LblExpiry, m_LblMinutes, m_LblCommentary, m_LblTradingPoints, m_LblMaxSlippage, m_LblMaxSpread, m_LblMaxEntrySLDistance, m_LblMinEntrySLDistance, m_LblTradingLots, m_LblURL, m_LblTradingTP, m_LblTrailingStop, m_LblBreakEven, m_LblMaxNumberOfTrades, m_LblMaxNumberOfTradesTotal, m_LblMaxNumberOfTradesPerSymbol, m_LblMaxPositionSize, m_LblMaxPositionSizeTotal, m_LblMaxPositionSizePerSymbol, m_LblMaxRisk, m_LblMaxRiskTotal, m_LblMaxRiskPerSymbol;;

    string           m_FileName;
    double           m_DPIScale;
    bool             NoPanelMaximization; // A crutch variable to prevent panel maximization when Maximize() is called at the indicator's initialization.
    int              ATR_handle;
    int              PanelWidth;

    CLabel           TradingTPLabels[];
    CEdit            TradingTPEdits[];
    CEdit            TradingTPShareEdits[];

    // Extra TP fields for the Main tab.
    CLabel           AdditionalTPLabels[], AdditionalTPWarnings[];
    CButton          AdditionalTPButtonsIncrease[], AdditionalTPButtonsDecrease[];
    // Store ordered and named panel objects arranged by tabs.
    CPanelList       *MainTabList, *RiskTabList, *MarginTabList, *SwapsTabList, *TradingTabList;
    
    // Some of the panel measurement parameters are used by more than one method:
    int              first_column_start, normal_label_width, normal_edit_width, second_column_start, element_height, third_column_start, narrow_label_width, v_spacing, multi_tp_column_start,
                     multi_tp_label_width, multi_tp_button_start, leverage_edit_width, third_trading_column_start, second_trading_column_start;

public:
    CPositionSizeCalculator(void);
   ~CPositionSizeCalculator(void);

            void     UpdateFileName();
            void     InitVariables();
    virtual void     Destroy();
    virtual bool     Create(const long chart, const string name, const int subwin, const int x1, const int y1);
    virtual bool     OnEvent(const int id, const long& lparam, const double& dparam, const string& sparam);
    virtual void     CalculateSettingsBasedOnLines(); // Gets values from lines.
    virtual void     RefreshValues(); // Recalculates position size.
    virtual bool     SaveSettingsOnDisk(string symbol);
    virtual bool     LoadSettingsFromDisk();
    virtual bool     DeleteSettingsFile();
    virtual bool     Run()
    {
        SeekAndDestroyDuplicatePanels();
        return(CAppDialog::Run());
    }
    virtual void     HideShowMaximize();
    virtual void     MoveAndResize(); // Arranges panel objects on the panel.
    virtual void     InitATR();
    virtual void     UpdateFixedSL();
    virtual void     UpdateFixedTP();
    virtual void     UpdateAdditionalFixedTP(int i);
    virtual void     FixatePanelPosition()
    {
        if (!m_minimized) m_norm_rect.SetBound(m_rect);    // Used to fixate panel's position after calling Move(). Otherwise, unless the panel gets dragged by mouse, its position isn't remembered properly in the INI file.
        else m_min_rect.SetBound(m_rect);
    }
    virtual void     UpdateTradingTPEdit(int i);
    virtual void     UpdateAdditionalTPEdit(int i);
    virtual void     ProcessLineObjectsAfterUpdatingMultipleTP(int i);
    virtual void     UpdateTradingTPShareEdit(int i);
    virtual void     ProcessAdditionalTPButtonsIncrease(int i);
    virtual void     ProcessAdditionalTPButtonsDecrease(int i);
    virtual void     CheckAndRestoreLines();
    virtual void     DummyObjectSelect(string dummy_name);
    virtual bool     IsMinimized() {return m_minimized;}
    virtual void     IniFileLoad() {CAppDialog::IniFileLoad(); InitObjects();} // Need to init objects after ini file load.
    virtual void     EmulateMinMaxClick();
            void     OnClickBtnTakeProfitsNumberRemove();
            void     OnClickBtnTPsInward();
            void     OnClickBtnTPsOutward();
            void     OnClickBtnTradingTPShare();
            void     OnClickBtnOrderType();
            void     OnClickBtnLines();

            int      MaxTakeProfitsNumber;
            void     OnClickBtnTakeProfitsNumberAdd();
    virtual void     UpdateAdditionalTradingPanelTP(int i);
            void     ShowTPRelatedEdits();
            void     SetFileName(string file_name) {m_FileName = file_name;}
            void     InitControlsValues();
    virtual void     Maximize();
    virtual void     Minimize();
            void     SetTPButtonBackGroundColor(color);
    CEdit            AdditionalTPEdits[];
            // Remember the panel's location to have the same location for minimized and maximized states.
            int      remember_top, remember_left;
private:

    virtual void     ShowMain();
    virtual void     ShowRisk();
    virtual void     ShowMargin();
    virtual void     ShowSwaps();
    virtual void     ShowTrading();
    virtual void     HideMain();
    virtual void     HideRisk();
    virtual void     HideMargin();
    virtual void     HideSwaps();
    virtual void     HideTrading();

    virtual bool     CreateObjects();
    virtual bool     InitObjects();
    virtual bool     DisplayValues(); // Updates values in the panel.
    virtual void     ProcessTPChange(const bool tp_button_click);

    virtual bool     ButtonCreate    (CList* list, CButton&    Btn, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n");
    virtual bool     CheckBoxCreate  (CList* list, CCheckBox&  Chk, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n");
    virtual bool     EditCreate      (CList* list, CEdit&      Edt, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n");
    virtual bool     LabelCreate     (CList* list, CLabel&     Lbl, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n");
    void             SeekAndDestroyDuplicatePanels();

    // Event handlers
    void OnEndEditEdtEntryLevel();
    void OnClickBtnEntryIncrease();
    void OnClickBtnEntryDecrease();
    void OnEndEditEdtSL();
    void OnClickBtnStopLossIncrease();
    void OnClickBtnStopLossDecrease();
    void OnEndEditEdtTP();
    void OnClickBtnTakeProfitIncrease();
    void OnClickBtnTakeProfitDecrease();
    void OnEndEditEdtStopPrice();
    void OnClickBtnStopPriceIncrease();
    void OnClickBtnStopPriceDecrease();
    void OnClickBtnAccount();
    void OnClickBtnCommissionType();
    void OnClickBtnMaxPS();
    void OnEndEditEdtCommissionSize();
    void OnEndEditEdtAccount();
    void OnEndEditEdtRiskPIn();
    void OnEndEditEdtRiskMIn();
    void OnEndEditEdtPosSize();
    void OnEndEditATRPeriod();
    void OnEndEditATRMultiplierSL();
    void OnEndEditATRMultiplierTP();
    void OnChangeChkSpreadAdjustmentSL();
    void OnChangeChkSpreadAdjustmentTP();
    void OnChangeChkCountPendings();
    void OnChangeChkIgnoreOrdersWithoutSL();
    void OnChangeChkIgnoreOrdersWithoutTP();
    void OnChangeChkIgnoreOtherSymbols();
    void OnEndEditEdtCustomLeverage();
    void OnEndEditEdtMagicNumber();
    void OnEndEditEdtCommentary();
    void OnChangeChkDisableTradingWhenLinesAreHidden();
    void OnEndEditEdtMaxSlippage();
    void OnEndEditEdtMaxSpread();
    void OnEndEditEdtMaxEntrySLDistance();
    void OnEndEditEdtMinEntrySLDistance();
    void OnEndEditEdtMaxPositionSizeTotal();
    void OnEndEditEdtMaxPositionSizePerSymbol();
    void OnEndEditEdtTrailingStopPoints();
    void OnEndEditEdtBreakEvenPoints();
    void OnEndEditEdtMaxNumberOfTradesTotal();
    void OnEndEditEdtMaxNumberOfTradesPerSymbol();
    void OnEndEditEdtMaxRiskTotal();
    void OnEndEditEdtMaxRiskPerSymbol();
    void OnEndEditEdtExpiry();
    void OnChangeChkSubtractPositions();
    void OnChangeChkSubtractPendingOrders();
    void OnChangeChkDoNotApplyStopLoss();
    void OnChangeChkDoNotApplyTakeProfit();
    void OnChangeChkAskForConfirmation();
    void OnChangeChkCommentAutoSuffix();
    void OnClickBtnTabMain();
    void OnClickBtnTabRisk();
    void OnClickBtnTabMargin();
    void OnClickBtnTabSwaps();
    void OnClickBtnTabTrading();
    void OnClickBtnStopLoss();
    void OnClickBtnTakeProfit();
    void OnClickBtnEntry();
    void OnClickBtnATRTimeframe();
    void OnClickBtnTrade();
    void OnClickBtnQuickRisk1();
    void OnClickBtnQuickRisk2();
};

// Event Map
EVENT_MAP_BEGIN(CPositionSizeCalculator)
ON_EVENT(ON_END_EDIT, m_EdtEntryLevel, OnEndEditEdtEntryLevel)
ON_EVENT(ON_CLICK, m_BtnEntryIncrease, OnClickBtnEntryIncrease)
ON_EVENT(ON_CLICK, m_BtnEntryDecrease, OnClickBtnEntryDecrease)
ON_EVENT(ON_END_EDIT, m_EdtSL, OnEndEditEdtSL)
ON_EVENT(ON_CLICK, m_BtnStopLossIncrease, OnClickBtnStopLossIncrease)
ON_EVENT(ON_CLICK, m_BtnStopLossDecrease, OnClickBtnStopLossDecrease)
ON_EVENT(ON_END_EDIT, m_EdtTP, OnEndEditEdtTP)
ON_EVENT(ON_CLICK, m_BtnTakeProfitsNumberAdd, OnClickBtnTakeProfitsNumberAdd)
ON_EVENT(ON_CLICK, m_BtnTakeProfitIncrease, OnClickBtnTakeProfitIncrease)
ON_EVENT(ON_CLICK, m_BtnTakeProfitDecrease, OnClickBtnTakeProfitDecrease)
ON_EVENT(ON_END_EDIT, m_EdtStopPrice, OnEndEditEdtStopPrice)
ON_EVENT(ON_CLICK, m_BtnStopPriceIncrease, OnClickBtnStopPriceIncrease)
ON_EVENT(ON_CLICK, m_BtnStopPriceDecrease, OnClickBtnStopPriceDecrease)
ON_EVENT(ON_CLICK, m_BtnOrderType, OnClickBtnOrderType)
ON_EVENT(ON_CLICK, m_BtnLines, OnClickBtnLines)
if (!HideAccSize) ON_EVENT(ON_CLICK, m_BtnAccount, OnClickBtnAccount)
ON_EVENT(ON_CLICK, m_BtnCommissionType, OnClickBtnCommissionType)
if (ShowMaxPSButton) ON_EVENT(ON_CLICK, m_BtnMaxPS, OnClickBtnMaxPS)
ON_EVENT(ON_END_EDIT, m_EdtCommissionSize, OnEndEditEdtCommissionSize)
ON_EVENT(ON_END_EDIT, m_EdtAccount, OnEndEditEdtAccount)
ON_EVENT(ON_END_EDIT, m_EdtRiskPIn, OnEndEditEdtRiskPIn)
ON_EVENT(ON_END_EDIT, m_EdtRiskMIn, OnEndEditEdtRiskMIn)
ON_EVENT(ON_END_EDIT, m_EdtPosSize, OnEndEditEdtPosSize)
ON_EVENT(ON_END_EDIT, m_EdtATRPeriod, OnEndEditATRPeriod)
ON_EVENT(ON_END_EDIT, m_EdtATRMultiplierSL, OnEndEditATRMultiplierSL)
ON_EVENT(ON_END_EDIT, m_EdtATRMultiplierTP, OnEndEditATRMultiplierTP)
ON_EVENT(ON_CHANGE, m_ChkSpreadAdjustmentSL, OnChangeChkSpreadAdjustmentSL)
ON_EVENT(ON_CHANGE, m_ChkSpreadAdjustmentTP, OnChangeChkSpreadAdjustmentTP)
ON_EVENT(ON_CHANGE, m_ChkCountPendings, OnChangeChkCountPendings)
ON_EVENT(ON_CHANGE, m_ChkIgnoreOrdersWithoutSL, OnChangeChkIgnoreOrdersWithoutSL)
ON_EVENT(ON_CHANGE, m_ChkIgnoreOrdersWithoutTP, OnChangeChkIgnoreOrdersWithoutTP)
ON_EVENT(ON_CHANGE, m_ChkIgnoreOtherSymbols, OnChangeChkIgnoreOtherSymbols)
ON_EVENT(ON_END_EDIT, m_EdtCustomLeverage, OnEndEditEdtCustomLeverage)
ON_EVENT(ON_END_EDIT, m_EdtMagicNumber, OnEndEditEdtMagicNumber)
ON_EVENT(ON_END_EDIT, m_EdtCommentary, OnEndEditEdtCommentary)
ON_EVENT(ON_CHANGE, m_ChkDisableTradingWhenLinesAreHidden, OnChangeChkDisableTradingWhenLinesAreHidden)
ON_EVENT(ON_END_EDIT, m_EdtMaxSlippage, OnEndEditEdtMaxSlippage)
ON_EVENT(ON_END_EDIT, m_EdtMaxSpread, OnEndEditEdtMaxSpread)
ON_EVENT(ON_END_EDIT, m_EdtMaxEntrySLDistance, OnEndEditEdtMaxEntrySLDistance)
ON_EVENT(ON_END_EDIT, m_EdtMinEntrySLDistance, OnEndEditEdtMinEntrySLDistance)
ON_EVENT(ON_END_EDIT, m_EdtMaxPositionSizeTotal, OnEndEditEdtMaxPositionSizeTotal)
ON_EVENT(ON_END_EDIT, m_EdtMaxPositionSizePerSymbol, OnEndEditEdtMaxPositionSizePerSymbol)
ON_EVENT(ON_END_EDIT, m_EdtTrailingStopPoints, OnEndEditEdtTrailingStopPoints)
ON_EVENT(ON_END_EDIT, m_EdtBreakEvenPoints, OnEndEditEdtBreakEvenPoints)
ON_EVENT(ON_END_EDIT, m_EdtMaxNumberOfTradesTotal, OnEndEditEdtMaxNumberOfTradesTotal)
ON_EVENT(ON_END_EDIT, m_EdtMaxNumberOfTradesPerSymbol, OnEndEditEdtMaxNumberOfTradesPerSymbol)
ON_EVENT(ON_END_EDIT, m_EdtMaxRiskTotal, OnEndEditEdtMaxRiskTotal)
ON_EVENT(ON_END_EDIT, m_EdtMaxRiskPerSymbol, OnEndEditEdtMaxRiskPerSymbol)
ON_EVENT(ON_END_EDIT, m_EdtExpiry, OnEndEditEdtExpiry)
ON_EVENT(ON_CHANGE, m_ChkSubtractPositions, OnChangeChkSubtractPositions)
ON_EVENT(ON_CHANGE, m_ChkSubtractPendingOrders, OnChangeChkSubtractPendingOrders)
ON_EVENT(ON_CHANGE, m_ChkDoNotApplyStopLoss, OnChangeChkDoNotApplyStopLoss)
ON_EVENT(ON_CHANGE, m_ChkDoNotApplyTakeProfit, OnChangeChkDoNotApplyTakeProfit)
ON_EVENT(ON_CHANGE, m_ChkAskForConfirmation, OnChangeChkAskForConfirmation)
ON_EVENT(ON_CHANGE, m_ChkCommentAutoSuffix, OnChangeChkCommentAutoSuffix)
ON_EVENT(ON_CLICK, m_BtnTabMain, OnClickBtnTabMain)
ON_EVENT(ON_CLICK, m_BtnTabRisk, OnClickBtnTabRisk)
ON_EVENT(ON_CLICK, m_BtnTabMargin, OnClickBtnTabMargin)
ON_EVENT(ON_CLICK, m_BtnTabSwaps, OnClickBtnTabSwaps)
ON_EVENT(ON_CLICK, m_BtnTabTrading, OnClickBtnTabTrading)
if (DefaultSL > 0) ON_EVENT(ON_CLICK, m_BtnStopLoss, OnClickBtnStopLoss)
ON_EVENT(ON_CLICK, m_BtnTakeProfit, OnClickBtnTakeProfit)
ON_EVENT(ON_CLICK, m_BtnEntry, OnClickBtnEntry)
if (ShowATROptions) ON_EVENT(ON_CLICK, m_BtnATRTimeframe, OnClickBtnATRTimeframe)
ON_EVENT(ON_CLICK, m_BtnTrade, OnClickBtnTrade)
if (QuickRisk1 > 0) ON_EVENT(ON_CLICK, m_BtnQuickRisk1, OnClickBtnQuickRisk1)
if (QuickRisk2 > 0) ON_EVENT(ON_CLICK, m_BtnQuickRisk2, OnClickBtnQuickRisk2)
EVENT_MAP_END(CAppDialog)

//+-------------------+
//| Class constructor |
//+-------------------+
CPositionSizeCalculator::CPositionSizeCalculator(void)
{
    UpdateFileName();
    InitVariables();
}

//+-------------------+
//| Class destructor  |
//+-------------------+
CPositionSizeCalculator::~CPositionSizeCalculator(void)
{
    delete MainTabList;
    delete RiskTabList;
    delete MarginTabList;
    delete SwapsTabList;
    delete TradingTabList;
}

// Updates filename used for settings storage.
void CPositionSizeCalculator::UpdateFileName()
{
    m_FileName = Symbol() + IntegerToString(ChartID());
    StringReplace(m_FileName, ".", "_dot_");
    m_FileName += ".txt";
}

// Initialize variables from the class constructor.
void CPositionSizeCalculator::InitVariables()
{
    LinesSelectedStatus = 0;
    remember_left = -1;
    remember_top = -1;
    MaxTakeProfitsNumber = 1;
}

//+--------+
//| Button |
//+--------+
bool CPositionSizeCalculator::ButtonCreate(CList *list, CButton &Btn, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n")
{
    if (!Btn.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return false;
    if (!Add(Btn))                                                              return false;
    if (!Btn.Text(Text))                                                        return false;
    ObjectSetString(ChartID(), m_name + Name, OBJPROP_TOOLTIP, Tooltip);
    if (list != NULL)
    {
        CStringForList *obj = new CStringForList;
        obj.Name = Name;
        obj.Obj = GetPointer(Btn);
        list.Add(obj);
    }

    return true;
}

//+----------+
//| Checkbox |
//+----------+
bool CPositionSizeCalculator::CheckBoxCreate(CList *list, CCheckBox &Chk, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n")
{
    if (!Chk.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return false;
    if (!Add(Chk))                                                              return false;
    if (!Chk.Text(Text))                                                        return false;
    ObjectSetString(ChartID(), m_name + Name + "Label", OBJPROP_TOOLTIP, Tooltip);
    CStringForList *obj = new CStringForList;
    obj.Name = Name;
    obj.Obj = GetPointer(Chk);
    list.Add(obj);

    return true;
}

//+------+
//| Edit |
//+------+
bool CPositionSizeCalculator::EditCreate(CList *list, CEdit &Edt, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n")
{
    if (!Edt.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return false;
    if (!Add(Edt))                                                              return false;
    if (!Edt.Text(Text))                                                        return false;
    ObjectSetString(ChartID(), m_name + Name, OBJPROP_TOOLTIP, Tooltip);
    CStringForList *obj = new CStringForList;
    obj.Name = Name;
    obj.Obj = GetPointer(Edt);
    list.Add(obj);

    return true;
}

//+-------+
//| Label |
//+-------+
bool CPositionSizeCalculator::LabelCreate(CList *list, CLabel &Lbl, int X1, int Y1, int X2, int Y2, string Name, string Text, string Tooltip = "\n")
{
    if (!Lbl.Create(m_chart_id, m_name + Name, m_subwin, X1, Y1, X2, Y2))       return false;
    if (!Add(Lbl))                                                              return false;
    if (!Lbl.Text(Text))                                                        return false;
    ObjectSetString(ChartID(), m_name + Name, OBJPROP_TOOLTIP, Tooltip);
    CStringForList *obj = new CStringForList;
    obj.Name = Name;
    obj.Obj = GetPointer(Lbl);
    list.Add(obj);

    return true;
}

//+-----------------------+
//| Create a panel object |
//+-----------------------+
bool CPositionSizeCalculator::Create(const long chart, const string name, const int subwin, const int x1, const int y1)
{
    double screen_dpi = (double)TerminalInfoInteger(TERMINAL_SCREEN_DPI);
    m_DPIScale = screen_dpi / 96.0;

    if ((AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS) > 2) || (_Digits > 5)) // Wide panel required.
        PanelWidth = 500;
    else PanelWidth = 350; // Narrow panel (like in MT4).

    int x2 = x1 + (int)MathRound(PanelWidth * m_DPIScale);
    int y2 = y1 + (int)MathRound(570 * m_DPIScale);

    if (!CAppDialog::Create(chart, name, subwin, x1, y1, x2, y2))               return false;
    if (!CreateObjects())                                                         return false;
    if (sets.TakeProfitsNumber > MaxTakeProfitsNumber) MaxTakeProfitsNumber = sets.TakeProfitsNumber;
    return true;
}

void CPositionSizeCalculator::Destroy()
{
    m_chart.Detach();
    // Call parent destroy.
    CDialog::Destroy();
}

bool CPositionSizeCalculator::CreateObjects()
{
    int row_start, h_spacing,
        tab_button_start, tab_button_width, tab_button_spacing, narrow_edit_width, risk_perc_edit_width, narrowest_label_width, risk_lot_edit, wide_edit_width, wide_label_width, swap_last_label_width, swap_type_edit_width, swap_size_edit_width, atr_period_label_width, atr_period_edit_width, quick_risk_button_width, quick_risk_button_offset,
        second_risk_column_start, second_margin_column_start, second_swaps_column_start, third_risk_column_start, third_swaps_column_start, fourth_risk_column_start, fourth_swaps_column_start, max_psc_column_start,
        panel_end;

    // Same for both modes - narrow and wide.
    row_start = (int)MathRound(10 * m_DPIScale);
    element_height = (int)MathRound(20 * m_DPIScale);
    v_spacing = (int)MathRound(4 * m_DPIScale);
    h_spacing = (int)MathRound(5 * m_DPIScale);
    tab_button_start = (int)MathRound(15 * m_DPIScale);
    tab_button_width = (int)MathRound(50 * m_DPIScale);
    normal_label_width = (int)MathRound(108 * m_DPIScale);
    narrow_label_width = (int)MathRound(85 * m_DPIScale);
    narrow_edit_width = (int)MathRound(75 * m_DPIScale);
    narrowest_label_width = (int)MathRound(50 * m_DPIScale);
    leverage_edit_width = (int)MathRound(35 * m_DPIScale);
    wide_edit_width = (int)MathRound(170 * m_DPIScale);
    wide_label_width = (int)MathRound(193 * m_DPIScale);
    swap_type_edit_width = narrow_edit_width * 2 + h_spacing;
    quick_risk_button_width = (int)MathRound(32 * m_DPIScale);
    first_column_start = 2 * h_spacing;
    second_swaps_column_start = first_column_start + narrowest_label_width + h_spacing;
    multi_tp_column_start = first_column_start + normal_label_width;
    multi_tp_label_width = (int)MathRound(70 * m_DPIScale);

    // Wide mode.
    if (PanelWidth > 350) // Wide panel required.
    {
        tab_button_spacing = (int)MathRound(50 * m_DPIScale);
        normal_edit_width = (int)MathRound(125 * m_DPIScale);
        risk_perc_edit_width = (int)MathRound(85 * m_DPIScale);
        swap_last_label_width = (int)MathRound(100 * m_DPIScale);
        swap_size_edit_width = normal_edit_width;
        atr_period_label_width = (int)MathRound(78 * m_DPIScale);
        atr_period_edit_width = (int)MathRound(70 * m_DPIScale);
        quick_risk_button_offset = (int)MathRound(90 * m_DPIScale);
        risk_lot_edit = normal_edit_width;

        second_column_start = first_column_start + (int)MathRound(163 * m_DPIScale);
        second_risk_column_start = first_column_start + (int)MathRound(122 * m_DPIScale);
        second_margin_column_start = first_column_start + (int)MathRound(178 * m_DPIScale);
        second_trading_column_start = second_margin_column_start + h_spacing;

        third_column_start = second_column_start + (int)MathRound(182 * m_DPIScale);
        third_risk_column_start = second_risk_column_start + normal_edit_width + (int)MathRound(8 * m_DPIScale);
        third_swaps_column_start = second_swaps_column_start + normal_edit_width + h_spacing;
        third_trading_column_start = second_trading_column_start + normal_edit_width + (int)MathRound(5 * m_DPIScale);

        fourth_risk_column_start = third_risk_column_start + risk_perc_edit_width + (int)MathRound(8 * m_DPIScale);
        fourth_swaps_column_start = third_swaps_column_start + normal_edit_width + h_spacing;

        max_psc_column_start = second_margin_column_start + leverage_edit_width;

        multi_tp_button_start = second_trading_column_start + (int)MathRound(50 * m_DPIScale);
    }
    else
    {
        tab_button_spacing = (int)MathRound(15 * m_DPIScale);
        normal_edit_width = (int)MathRound(85 * m_DPIScale);
        risk_perc_edit_width = (int)MathRound(65 * m_DPIScale);
        swap_last_label_width = (int)MathRound(80 * m_DPIScale);
        swap_size_edit_width = narrow_edit_width;
        atr_period_label_width = (int)MathRound(72 * m_DPIScale);
        atr_period_edit_width = (int)MathRound(36 * m_DPIScale);
        quick_risk_button_offset = tab_button_width;
        risk_lot_edit = narrowest_label_width;

        second_column_start = first_column_start + (int)MathRound(123 * m_DPIScale);
        second_risk_column_start = first_column_start + (int)MathRound(114 * m_DPIScale);
        second_margin_column_start = first_column_start + (int)MathRound(138 * m_DPIScale);
        second_trading_column_start = second_margin_column_start + h_spacing;

        third_column_start = second_column_start + (int)MathRound(102 * m_DPIScale);
        third_risk_column_start = second_risk_column_start + normal_edit_width + (int)MathRound(4 * m_DPIScale);
        third_swaps_column_start = second_swaps_column_start + narrow_edit_width + h_spacing;
        third_trading_column_start = second_trading_column_start + normal_edit_width + (int)MathRound(5 * m_DPIScale);

        fourth_risk_column_start = third_risk_column_start + risk_perc_edit_width + (int)MathRound(4 * m_DPIScale);
        fourth_swaps_column_start = third_swaps_column_start + narrow_edit_width + h_spacing;

        max_psc_column_start = second_margin_column_start + normal_edit_width + h_spacing;

        multi_tp_button_start = second_trading_column_start + (int)MathRound(11 * m_DPIScale);
    }

    panel_end = third_column_start + narrow_label_width;

    int y = (int)MathRound(8 * m_DPIScale);

// Tabs

    if (!ButtonCreate(NULL, m_BtnTabMain, tab_button_start, y, tab_button_start + tab_button_width, y + element_height, "m_BtnTabMain", TRANSLATION_TAB_BUTTON_MAIN))                                                                                                                    return false;
    MainTabList = new CPanelList;
    if (!ButtonCreate(NULL, m_BtnTabRisk, tab_button_start + tab_button_width + tab_button_spacing, y, tab_button_start + tab_button_width * 2 + tab_button_spacing, y + element_height, "m_BtnTabRisk", TRANSLATION_TAB_BUTTON_RISK))                                                                                                                   return false;
    RiskTabList = new CPanelList;
    if (!ButtonCreate(NULL, m_BtnTabMargin, tab_button_start + tab_button_width * 2 + tab_button_spacing * 2, y, tab_button_start + tab_button_width * 3 + tab_button_spacing * 2, y + element_height, "m_BtnTabMargin", TRANSLATION_TAB_BUTTON_MARGIN))                                                                                                             return false;
    MarginTabList = new CPanelList;
    if (!ButtonCreate(NULL, m_BtnTabSwaps, tab_button_start + tab_button_width * 3 + tab_button_spacing * 3, y, tab_button_start + tab_button_width * 4 + tab_button_spacing * 3, y + element_height, "m_BtnTabSwaps", TRANSLATION_TAB_BUTTON_SWAPS))                                                                                                                return false;
    SwapsTabList = new CPanelList;
    if (!ButtonCreate(NULL, m_BtnTabTrading, tab_button_start + tab_button_width * 4 + tab_button_spacing * 4, y, tab_button_start + tab_button_width * 5 + tab_button_spacing * 4, y + element_height, "m_BtnTabTrading", TRANSLATION_TAB_BUTTON_TRADING))                                                                                                             return false;
    TradingTabList = new CPanelList;

// Main

    y = row_start + element_height + 3 * v_spacing;

    if (!LabelCreate(MainTabList, m_LblEntryLevel, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblEntryLevel", TRANSLATION_LABEL_ENTRY + ":"))                                        return false;
    // Button to quickly switch between Long/Short trade planning.

    if (!ButtonCreate(MainTabList, m_BtnEntry, first_column_start + narrowest_label_width + v_spacing, y, second_column_start - v_spacing, y + element_height, "m_BtnEntry", EnumToString(sets.TradeDirection), TRANSLATION_TOOLTIP_BUTTON_LONG_SHORT))                    return false;
    if (!EditCreate(MainTabList, m_EdtEntryLevel, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtEntryLevel", ""))                                                 return false;
    if (!ButtonCreate(MainTabList, m_BtnEntryIncrease, second_column_start + normal_edit_width + 1, y, second_column_start + normal_edit_width + v_spacing * 4, y + element_height / 2, "m_BtnEntryIncrease", "+", TRANSLATION_TOOLTIP_ENTRY_INCREASE))                    return false;
    if (!ButtonCreate(MainTabList, m_BtnEntryDecrease, second_column_start + normal_edit_width + 1, y + element_height / 2, second_column_start + normal_edit_width + v_spacing * 4, y + element_height, "m_BtnEntryDecrease", "-", TRANSLATION_TOOLTIP_ENTRY_DECREASE))                    return false;
    if (!LabelCreate(MainTabList, m_LblEntryWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblEntryWarning", ""))                                         return false;

    y += element_height + v_spacing;

    string stoploss_label_text = TRANSLATION_LABEL_STOPLOSS + ":";
    if (sets.SLDistanceInPoints) stoploss_label_text = TRANSLATION_BUTTON_SL + ":";

    if (DefaultSL > 0) // Use button to quickly set SL.
    {
        if (!ButtonCreate(MainTabList, m_BtnStopLoss, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_BtnStopLoss", stoploss_label_text))                    return false;
    }
    else if (!LabelCreate(MainTabList, m_LblSL, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblSL", stoploss_label_text))                                               return false;

    if (!EditCreate(MainTabList, m_EdtSL, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtSL", ""))                                                                 return false;
    if (!ButtonCreate(MainTabList, m_BtnStopLossIncrease, second_column_start + normal_edit_width + 1, y, second_column_start + normal_edit_width + v_spacing * 4, y + element_height / 2, "m_BtnStopLossIncrease", "+", TRANSLATION_TOOLTIP_STOPLOSS_INCREASE))                    return false;
    if (!ButtonCreate(MainTabList, m_BtnStopLossDecrease, second_column_start + normal_edit_width + 1, y + element_height / 2, second_column_start + normal_edit_width + v_spacing * 4, y + element_height, "m_BtnStopLossDecrease", "-", TRANSLATION_TOOLTIP_STOPLOSS_DECREASE))                    return false;
    if (!LabelCreate(MainTabList, m_LblSLWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblSLWarning", ""))                                               return false;

    y += element_height + v_spacing;

    string takeprofit_label_text = TRANSLATION_LABEL_TAKEPROFIT + ":";
    if (sets.TPDistanceInPoints) takeprofit_label_text = TRANSLATION_BUTTON_TP + ":";
    if (!ButtonCreate(MainTabList, m_BtnTakeProfitsNumberAdd, first_column_start, y, first_column_start + v_spacing * 4 - 1, y + element_height, "m_BtnTakeProfitsNumberAdd", "+", TRANSLATION_TOOLTIP_TAKEPROFIT_ADD))                    return false;
    if (!ButtonCreate(MainTabList, m_BtnTakeProfit, first_column_start + v_spacing * 4, y, first_column_start + v_spacing * 3 + normal_label_width, y + element_height, "m_BtnTakeProfit", takeprofit_label_text, TRANSLATION_TOOLTIP_BUTTON_TP))                    return false;
    if (!EditCreate(MainTabList, m_EdtTP, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtTP", ""))                                                                 return false;
    if (!ButtonCreate(MainTabList, m_BtnTakeProfitIncrease, second_column_start + normal_edit_width + 1, y, second_column_start + normal_edit_width + v_spacing * 4, y + element_height / 2, "m_BtnTakeProfitIncrease", "+", TRANSLATION_TOOLTIP_TAKEPROFIT_INCREASE))                    return false;
    if (!ButtonCreate(MainTabList, m_BtnTakeProfitDecrease, second_column_start + normal_edit_width + 1, y + element_height / 2, second_column_start + normal_edit_width + v_spacing * 4, y + element_height, "m_BtnTakeProfitDecrease", "-", TRANSLATION_TOOLTIP_TAKEPROFIT_DECREASE))                    return false;
    if (!LabelCreate(MainTabList, m_LblTPWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblTPWarning", ""))                                               return false;

    // Multiple TP levels for the Main tab.
    if (sets.TakeProfitsNumber > 1)
    {
        // -1 because there is already one main TP level.
        ArrayResize(AdditionalTPLabels, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalTPEdits, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalTPWarnings, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalTPButtonsIncrease, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalTPButtonsDecrease, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalWarningTP, sets.TakeProfitsNumber - 1); // String array.
        ArrayResize(AdditionalOutputRR, sets.TakeProfitsNumber - 1); // String array.
        ArrayResize(AdditionalOutputReward, sets.TakeProfitsNumber - 1); // Double array.
        string additional_tp_label_beginning = TRANSLATION_LABEL_TAKEPROFIT + " ";
        string additional_tp_label_end = ":";
        if (sets.TPDistanceInPoints)
        {
            additional_tp_label_beginning = TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_DISTANCE + " ";
            additional_tp_label_end = ", " + TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_POINTS + ":";
        }
        for (int i = 0; i < sets.TakeProfitsNumber - 1; i++)
        {
            y += element_height + v_spacing;
            if (i == sets.TakeProfitsNumber - 2) // The last iteration.
            {
                // Because only one Remove button is needed.
                if (!ButtonCreate(MainTabList, m_BtnTakeProfitsNumberRemove, first_column_start, y, first_column_start + v_spacing * 4 - 1, y + element_height, "m_BtnTakeProfitsNumberRemove", "x", TRANSLATION_TOOLTIP_TAKEPROFIT_REMOVE))                    return false;
            }
            if (!LabelCreate(MainTabList, AdditionalTPLabels[i], first_column_start + v_spacing * 4, y, first_column_start + normal_label_width, y + element_height, "m_LblAdditionalTPLabels" + IntegerToString(i + 2), additional_tp_label_beginning + IntegerToString(i + 2) + additional_tp_label_end))                                       return false;
            if (!EditCreate(MainTabList, AdditionalTPEdits[i], second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtAdditionalTPEdits" + IntegerToString(i + 2), ""))                                               return false;
            if (!ButtonCreate(MainTabList, AdditionalTPButtonsIncrease[i], second_column_start + normal_edit_width + 1, y, second_column_start + normal_edit_width + v_spacing * 4, y + element_height / 2, "m_BtnAdditionalTPButtonsIncrease" + IntegerToString(i + 2), "+", TRANSLATION_TOOLTIP_TAKEPROFIT_INCREASE_MULTIPLE + " #" + IntegerToString(i + 2) + " " + TRANSLATION_TOOLTIP_TAKEPROFIT_BY_ONE_POINT))                    return false;
            if (!ButtonCreate(MainTabList, AdditionalTPButtonsDecrease[i], second_column_start + normal_edit_width + 1, y + element_height / 2, second_column_start + normal_edit_width + v_spacing * 4, y + element_height, "m_BtnAdditionalTPButtonsDecrease" + IntegerToString(i + 2), "-", TRANSLATION_TOOLTIP_TAKEPROFIT_INCREASE_MULTIPLE + " #" + IntegerToString(i + 2) + " " + TRANSLATION_TOOLTIP_TAKEPROFIT_BY_ONE_POINT))                    return false;
            if (!LabelCreate(MainTabList, AdditionalTPWarnings[i], third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblAdditionalTPWarnings" + IntegerToString(i + 2), ""))                                                 return false;
        }
    }

    y += element_height + v_spacing;

    if (!LabelCreate(MainTabList, m_LblStopPrice, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblStopPrice", TRANSLATION_LABEL_STOPPRICE + ":"))                    return false;
    if (!EditCreate(MainTabList, m_EdtStopPrice, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtStopPrice", ""))                                                               return false;
    if (!ButtonCreate(MainTabList, m_BtnStopPriceIncrease, second_column_start + normal_edit_width + 1, y, second_column_start + normal_edit_width + v_spacing * 4, y + element_height / 2, "m_BtnStopPriceIncrease", "+", TRANSLATION_TOOLTIP_STOPPRICE_INCREASE))                    return false;
    if (!ButtonCreate(MainTabList, m_BtnStopPriceDecrease, second_column_start + normal_edit_width + 1, y + element_height / 2, second_column_start + normal_edit_width + v_spacing * 4, y + element_height, "m_BtnStopPriceDecrease", "-", TRANSLATION_TOOLTIP_STOPPRICE_DECREASE))                    return false;
    if (!LabelCreate(MainTabList, m_LblStopPriceWarning, third_column_start, y, third_column_start + narrow_label_width, y + element_height, "m_LblStopPriceWarning", ""))                                             return false;

    if (ShowATROptions)
    {
        y += element_height + v_spacing;

        if (!LabelCreate(MainTabList, m_LblATRPeriod, first_column_start, y, first_column_start + atr_period_label_width, y + element_height, "m_LblATRPeriod", TRANSLATION_LABEL_ATR_PERIOD + ":"))                                                 return false;
        if (!EditCreate(MainTabList, m_EdtATRPeriod, first_column_start + atr_period_label_width, y, first_column_start + atr_period_label_width + atr_period_edit_width, y + element_height, "m_EdtATRPeriod", ""))                                                                return false;

        if (!LabelCreate(MainTabList, m_LblATRMultiplierSL, second_column_start, y, second_column_start + narrow_label_width, y + element_height, "m_LblATRMultiplierSL", TRANSLATION_LABEL_ATR_SL_MULTIPLIER + ":"))                                                 return false;

        if (!EditCreate(MainTabList, m_EdtATRMultiplierSL, second_column_start + narrow_label_width, y, second_column_start + narrow_label_width + tab_button_width, y + element_height, "m_EdtATRMultiplierSL", ""))                                                                 return false;

        if (PanelWidth > 350)
        {
            if (!CheckBoxCreate(MainTabList, m_ChkSpreadAdjustmentSL, second_column_start + narrow_label_width + tab_button_width + v_spacing, y, second_column_start + narrow_label_width + tab_button_width + normal_label_width / 2 - v_spacing * 2, y + element_height, "m_ChkSpreadAdjustmentSL", TRANSLATION_CHECKBOX_ATR_SA, TRANSLATION_TOOLTIP_ATR_SA_SL))                                                              return false;
            if (!LabelCreate(MainTabList, m_LblATRTimeframe, third_column_start, y, third_column_start + normal_label_width, y + element_height, "m_LblATRTimeframe", TRANSLATION_LABEL_ATR_TIMEFRAME + ":"))                                                 return false;
        }
        else
        {
            if (!CheckBoxCreate(MainTabList, m_ChkSpreadAdjustmentSL, third_column_start + normal_edit_width / 2 + v_spacing, y, third_column_start + normal_edit_width + v_spacing * 4, y + element_height, "m_ChkSpreadAdjustmentSL", TRANSLATION_CHECKBOX_ATR_SA, TRANSLATION_TOOLTIP_ATR_SA_SL))                                                              return false;
        }

        y += element_height + v_spacing;

        if (!LabelCreate(MainTabList, m_LblATRValue, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblATRValue", TRANSLATION_LABEL_ATR_VALUE + " = "))                                                return false;

        if (!LabelCreate(MainTabList, m_LblATRMultiplierTP, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblATRMultiplierTP", TRANSLATION_LABEL_ATR_TP_MULTIPLIER + ":"))                                                 return false;

        if (!EditCreate(MainTabList, m_EdtATRMultiplierTP, second_column_start + narrow_label_width, y, second_column_start + narrow_label_width + tab_button_width, y + element_height, "m_EdtATRMultiplierTP", ""))                                                                 return false;

        if (PanelWidth > 350)
        {
            if (!CheckBoxCreate(MainTabList, m_ChkSpreadAdjustmentTP, second_column_start + narrow_label_width + tab_button_width + v_spacing, y, second_column_start + narrow_label_width + tab_button_width + normal_label_width / 2 - v_spacing * 2, y + element_height, "m_ChkSpreadAdjustmentTP", TRANSLATION_CHECKBOX_ATR_SA, TRANSLATION_TOOLTIP_ATR_SA_TP))                                                              return false;
            if (!ButtonCreate(MainTabList, m_BtnATRTimeframe, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_BtnATRTimeframe", EnumToString((ENUM_TIMEFRAMES)_Period)))                                                               return false;
        }
        else
        {
            if (!CheckBoxCreate(MainTabList, m_ChkSpreadAdjustmentTP, third_column_start + normal_edit_width / 2 + v_spacing, y, third_column_start + normal_edit_width + v_spacing * 4, y + element_height, "m_ChkSpreadAdjustmentTP", TRANSLATION_CHECKBOX_ATR_SA, TRANSLATION_TOOLTIP_ATR_SA_TP))                                                              return false;

            y += element_height + v_spacing;

            if (!LabelCreate(MainTabList, m_LblATRTimeframe, first_column_start, y, first_column_start + atr_period_label_width, y + element_height, "m_LblATRTimeframe", TRANSLATION_LABEL_ATR_TIMEFRAME + ":"))                                                 return false;

            if (!ButtonCreate(MainTabList, m_BtnATRTimeframe, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_BtnATRTimeframe", EnumToString((ENUM_TIMEFRAMES)_Period)))                                                                 return false;
        }
    }

    y += element_height + v_spacing;

    if (!LabelCreate(MainTabList, m_LblOrderType, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblOrderType", TRANSLATION_LABEL_ORDER_TYPE + ":"))                                    return false;
    if (!ButtonCreate(MainTabList, m_BtnOrderType, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_BtnOrderType", TRANSLATION_BUTTON_ORDER_TYPE_INSTANT, TRANSLATION_TOOLTIP_ORDER_TYPE))                                           return false;

    if (!ButtonCreate(MainTabList, m_BtnLines, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_BtnLines", TRANSLATION_BUTTON_HIDE_LINES))                                     return false;

    y += element_height + v_spacing;

    if (!LabelCreate(MainTabList, m_LblCommissionSize, first_column_start, y, second_column_start + risk_perc_edit_width, y + element_height, "m_LblCommissionSize", TRANSLATION_LABEL_COMMISSION + ":", TRANSLATION_TOOLTIP_COMMISSION))         return false;
    if (!ButtonCreate(MainTabList, m_BtnCommissionType, second_column_start + risk_perc_edit_width, y, third_column_start - v_spacing, y + element_height, "m_BtnCommissionType", "???", TRANSLATION_TOOLTIP_COMMISSION_TYPE))         return false;
    if (!EditCreate(MainTabList, m_EdtCommissionSize, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtCommissionSize", ""))                                       return false;

    y += element_height + v_spacing;

    if (!HideAccSize)
    {
        if (!ButtonCreate(MainTabList, m_BtnAccount, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_BtnAccount", TRANSLATION_BUTTON_ACCOUNT_BALANCE, TRANSLATION_TOOLTIP_ACCOUNT_SIZE))                                       return false;
        if (!EditCreate(MainTabList, m_EdtAccount, second_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtAccount", ""))                                                    return false;

        string tooltip = "";
        if (CustomBalance > 0) tooltip = TRANSLATION_TOOLTIP_ACCOUNT_SIZE_ASTERISK_CUSTOM;
        else if (AdditionalFunds > 0) tooltip = "+" + DoubleToString(AdditionalFunds, 2) + " " + TRANSLATION_TOOLTIP_ACCOUNT_SIZE_ASTERISK_ADD;
        else if (AdditionalFunds < 0) tooltip = DoubleToString(-AdditionalFunds, 2) + " " + TRANSLATION_TOOLTIP_ACCOUNT_SIZE_ASTERISK_SUB;
        if (!LabelCreate(MainTabList, m_LblAdditionalFundsAsterisk, third_column_start + normal_edit_width + v_spacing, y, third_column_start + normal_edit_width + v_spacing * 2, y + element_height, "m_LblAdditionalFundsAsterisk", "*", tooltip))       return false;

        y += element_height + v_spacing;
    }

    if (!LabelCreate(MainTabList, m_LblInput, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_LblInput", TRANSLATION_LABEL_INPUT))                                                 return false;
    if (!LabelCreate(MainTabList, m_LblResult, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_LblResult", TRANSLATION_LABEL_RESULT))                                            return false;

    y += element_height + v_spacing;

    if (!LabelCreate(MainTabList, m_LblRisk, first_column_start, y, first_column_start + tab_button_width - v_spacing, y + element_height, "m_LblRisk", TRANSLATION_LABEL_RISK + ", %:"))                                                   return false;

    if (QuickRisk1 > 0) if (!ButtonCreate(MainTabList, m_BtnQuickRisk1, first_column_start + quick_risk_button_offset, y, first_column_start + quick_risk_button_offset + quick_risk_button_width, y + element_height, "m_BtnQuickRisk1", "", "%"))                                                    return false;
    if (QuickRisk2 > 0) if (!ButtonCreate(MainTabList, m_BtnQuickRisk2, first_column_start + quick_risk_button_offset + quick_risk_button_width + v_spacing, y, first_column_start + quick_risk_button_offset + quick_risk_button_width * 2 + v_spacing, y + element_height, "m_BtnQuickRisk2", "", "%"))                                                  return false;

    if (!EditCreate(MainTabList, m_EdtRiskPIn, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRiskPIn", ""))                                                       return false;
    if (!EditCreate(MainTabList, m_EdtRiskPRes, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRiskPRes", ""))                                                   return false;
    m_EdtRiskPRes.ReadOnly(true);
    m_EdtRiskPRes.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(MainTabList, m_LblRiskM, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblRiskM", TRANSLATION_LABEL_RISK + ", " + TRANSLATION_LABEL_MONEY + ":"))                                           return false;
    if (!EditCreate(MainTabList, m_EdtRiskMIn, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRiskMIn", ""))                                                       return false;
    if (!EditCreate(MainTabList, m_EdtRiskMRes, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRiskMRes", ""))                                                   return false;
    m_EdtRiskMRes.ReadOnly(true);
    m_EdtRiskMRes.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(MainTabList, m_LblReward, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblReward", TRANSLATION_LABEL_REWARD + ", " + TRANSLATION_LABEL_MONEY + ":"))                                              return false;
    if (!EditCreate(MainTabList, m_EdtReward1, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtReward1", ""))                                                       return false;
    m_EdtReward1.ReadOnly(true);
    m_EdtReward1.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(MainTabList, m_EdtReward2, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtReward2", ""))                                                     return false;
    m_EdtReward2.ReadOnly(true);
    m_EdtReward2.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(MainTabList, m_LblRR, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblRR", TRANSLATION_LABEL_REWARD_RISK + ":"))                                                 return false;
    if (!EditCreate(MainTabList, m_EdtRR1, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_EdtRR1", ""))                                                               return false;
    if (!EditCreate(MainTabList, m_EdtRR2, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtRR2", ""))                                                                 return false;
    m_EdtRR1.ReadOnly(true);
    m_EdtRR1.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtRR2.ReadOnly(true);
    m_EdtRR2.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(MainTabList, m_LblPosSize, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblPosSize", TRANSLATION_LABEL_POSITION_SIZE + ":"))                                 return false;
    if (ShowMaxPSButton) if (!ButtonCreate(MainTabList, m_BtnMaxPS, second_column_start, y, second_column_start + normal_edit_width, y + element_height, "m_BtnMaxPS", TRANSLATION_BUTTON_MAX_PS))                                                               return false;
    if (!EditCreate(MainTabList, m_EdtPosSize, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtPosSize", ""))                                                     return false;

    if (ShowPointValue)
    {
        y += element_height + v_spacing;

        if (!LabelCreate(MainTabList, m_LblPointValue, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblPointValue", TRANSLATION_LABEL_POINT_VALUE + ":", ""))                                return false;
        if (!EditCreate(MainTabList, m_EdtPointValue, third_column_start, y, third_column_start + normal_edit_width, y + element_height, "m_EdtPointValue", ""))                                                    return false;
        m_EdtPointValue.ReadOnly(true);
        m_EdtPointValue.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    }

    y += element_height + v_spacing;

    // EarnForex URL
    if (!LabelCreate(MainTabList, m_LblURL, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblURL", "www.earnforex.com"))                                         return false;
    m_LblURL.FontSize(8);
    m_LblURL.Color(C'0,115,66'); // Green

// Portfolio Risk

// Reset
    y = row_start + element_height + 3 * v_spacing;

    if (!CheckBoxCreate(RiskTabList, m_ChkCountPendings, first_column_start, y, panel_end, y + element_height, "m_ChkCountPendings", TRANSLATION_CHECKBOX_COUNT_PENDING_ORDERS))          return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(RiskTabList, m_ChkIgnoreOrdersWithoutSL, first_column_start, y, panel_end, y + element_height, "m_ChkIgnoreOrdersWithoutSL", TRANSLATION_CHECKBOX_IGNORE_ORDERS_WO_SL)) return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(RiskTabList, m_ChkIgnoreOrdersWithoutTP, first_column_start, y, panel_end, y + element_height, "m_ChkIgnoreOrdersWithoutTP", TRANSLATION_CHECKBOX_IGNORE_ORDERS_WO_TP)) return false;

    y += element_height + v_spacing;

    if (!CheckBoxCreate(RiskTabList, m_ChkIgnoreOtherSymbols, first_column_start, y, panel_end, y + element_height, "m_ChkIgnoreOtherSymbols", TRANSLATION_CHECKBOX_IGNORE_ORDERS_IN_OTHER_SYMBOLS)) return false;

    y += element_height + v_spacing;

    if (!LabelCreate(RiskTabList, m_LblCurrentRiskMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblCurrentRiskMoney", TRANSLATION_LABEL_RISK + " $"))                                               return false;
    if (!LabelCreate(RiskTabList, m_LblCurrentRiskPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentRiskPerc", TRANSLATION_LABEL_RISK + " %"))                                                    return false;
    if (!LabelCreate(RiskTabList, m_LblCurrentLots, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentLots", TRANSLATION_LABEL_LOTS))                                                    return false;

    y += element_height + v_spacing;

    if (!LabelCreate(RiskTabList, m_LblCurrentPortfolio, first_column_start, y, second_risk_column_start, y + element_height, "m_LblCurrentPortfolio", TRANSLATION_LABEL_CURRENT_PORTFOLIO + ":", TRANSLATION_TOOLTIP_CURRENT_PORTFOLIO))                            return false;
    if (!EditCreate(RiskTabList, m_EdtCurRiskM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtCurRiskM", ""))                                                   return false;
    m_EdtCurRiskM.ReadOnly(true);
    m_EdtCurRiskM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(RiskTabList, m_EdtCurRiskP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtCurRiskP", ""))                                                  return false;
    m_EdtCurRiskP.ReadOnly(true);
    m_EdtCurRiskP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(RiskTabList, m_EdtCurL, fourth_risk_column_start, y, fourth_risk_column_start + risk_lot_edit, y + element_height, "m_EdtCurL", ""))                                                   return false;
    m_EdtCurL.ReadOnly(true);
    m_EdtCurL.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(RiskTabList, m_LblCurrentProfitMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblCurrentProfitMoney", TRANSLATION_LABEL_REWARD + " $"))                                                     return false;
    if (!LabelCreate(RiskTabList, m_LblCurrentProfitPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentProfitPerc", TRANSLATION_LABEL_REWARD + " %"))                                                  return false;
    if (!LabelCreate(RiskTabList, m_LblCurrentRRR, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_LblCurrentRRR", "RRR", TRANSLATION_LABEL_CRRR_TOOLTIP))                                                  return false;

    y += element_height + v_spacing;

    if (!EditCreate(RiskTabList, m_EdtCurProfitM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtCurProfitM", ""))                                                   return false;
    m_EdtCurProfitM.ReadOnly(true);
    m_EdtCurProfitM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(RiskTabList, m_EdtCurProfitP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtCurProfitP", ""))                                                  return false;
    m_EdtCurProfitP.ReadOnly(true);
    m_EdtCurProfitP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(RiskTabList, m_EdtCurrentRRR, fourth_risk_column_start, y, fourth_risk_column_start + risk_lot_edit, y + element_height, "m_EdtCurrentRRR", ""))                                                   return false;
    m_EdtCurrentRRR.ReadOnly(true);
    m_EdtCurrentRRR.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(RiskTabList, m_LblPotentialRiskMoney, second_risk_column_start, y, second_risk_column_start + narrow_label_width, y + element_height, "m_LblPotentialRiskMoney", TRANSLATION_LABEL_RISK + " $"))                                               return false;
    if (!LabelCreate(RiskTabList, m_LblPotentialRiskPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialRiskPerc", TRANSLATION_LABEL_RISK + " %"))                                                    return false;
    if (!LabelCreate(RiskTabList, m_LblPotentialLots, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialLots", TRANSLATION_LABEL_LOTS))                                                    return false;

    y += element_height + v_spacing;

    if (!LabelCreate(RiskTabList, m_LblPotentialPortfolio, first_column_start, y, second_risk_column_start, y + element_height, "m_LblPotentialPortfolio", TRANSLATION_LABEL_POTENTIAL_PORTFOLIO + ":", TRANSLATION_TOOLTIP_POTENTIAL_PORTFOLIO))                         return false;
    if (!EditCreate(RiskTabList, m_EdtPotRiskM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtPotRiskM", ""))                                                   return false;
    m_EdtPotRiskM.ReadOnly(true);
    m_EdtPotRiskM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(RiskTabList, m_EdtPotRiskP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtPotRiskP", ""))                                                  return false;
    m_EdtPotRiskP.ReadOnly(true);
    m_EdtPotRiskP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(RiskTabList, m_EdtPotL, fourth_risk_column_start, y, fourth_risk_column_start + risk_lot_edit, y + element_height, "m_EdtPotL", ""))                                                   return false;
    m_EdtPotL.ReadOnly(true);
    m_EdtPotL.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(RiskTabList, m_LblPotentialProfitMoney, second_risk_column_start, y, second_risk_column_start + narrow_edit_width, y + element_height, "m_LblPotentialProfitMoney", TRANSLATION_LABEL_REWARD + " $"))                                                     return false;
    if (!LabelCreate(RiskTabList, m_LblPotentialProfitPerc, third_risk_column_start, y, third_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialProfitPerc", TRANSLATION_LABEL_REWARD + " %"))                                                  return false;
    if (!LabelCreate(RiskTabList, m_LblPotentialRRR, fourth_risk_column_start, y, fourth_risk_column_start + narrowest_label_width, y + element_height, "m_LblPotentialRRR", "RRR", TRANSLATION_LABEL_PRRR_TOOLTIP))                                                  return false;

    y += element_height + v_spacing;

    if (!EditCreate(RiskTabList, m_EdtPotProfitM, second_risk_column_start, y, second_risk_column_start + normal_edit_width, y + element_height, "m_EdtPotProfitM", ""))                                                   return false;
    m_EdtPotProfitM.ReadOnly(true);
    m_EdtPotProfitM.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(RiskTabList, m_EdtPotProfitP, third_risk_column_start, y, third_risk_column_start + risk_perc_edit_width, y + element_height, "m_EdtPotProfitP", ""))                                                  return false;
    m_EdtPotProfitP.ReadOnly(true);
    m_EdtPotProfitP.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    if (!EditCreate(RiskTabList, m_EdtPotentialRRR, fourth_risk_column_start, y, fourth_risk_column_start + risk_lot_edit, y + element_height, "m_EdtPotentialRRR", ""))                                                   return false;
    m_EdtPotentialRRR.ReadOnly(true);
    m_EdtPotentialRRR.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Margin

// Reset
    y = row_start + element_height + 3 * v_spacing;

    if (!LabelCreate(MarginTabList, m_LblPosMargin, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblPosMargin", TRANSLATION_LABEL_POSITION_MARGIN + ":"))                               return false;
    if (!EditCreate(MarginTabList, m_EdtPosMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtPosMargin", ""))                                                   return false;
    m_EdtPosMargin.ReadOnly(true);
    m_EdtPosMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(MarginTabList, m_LblUsedMargin, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblUsedMargin", TRANSLATION_LABEL_FUTURE_USED_MARGIN + ":"))                      return false;
    if (!EditCreate(MarginTabList, m_EdtUsedMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtUsedMargin", "            "))                              return false;
    m_EdtUsedMargin.ReadOnly(true);
    m_EdtUsedMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(MarginTabList, m_LblFreeMargin, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblFreeMargin", TRANSLATION_LABEL_FUTURE_FREE_MARGIN + ":"))                          return false;
    if (!EditCreate(MarginTabList, m_EdtFreeMargin, second_margin_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtFreeMargin", ""))                                                 return false;
    m_EdtFreeMargin.ReadOnly(true);
    m_EdtFreeMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    string extra_spaces = "";
    if (PanelWidth > 350) extra_spaces = "         ";
    if (!LabelCreate(MarginTabList, m_LblCustomLeverage, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblCustomLeverage", TRANSLATION_LABEL_CUSTOM_LEVERAGE + " = " + extra_spaces + "  1:"))                         return false;
    if (!EditCreate(MarginTabList, m_EdtCustomLeverage, second_margin_column_start, y, second_margin_column_start + leverage_edit_width, y + element_height, "m_EdtCustomLeverage", ""))                                                return false;
    if (!LabelCreate(MarginTabList, m_LblAccLeverage, second_margin_column_start + leverage_edit_width + 2 * h_spacing, y, second_margin_column_start + leverage_edit_width + h_spacing + wide_edit_width, y + element_height, "m_LblAccLeverage", ""))                          return false;

    y += element_height + v_spacing;

    if (!LabelCreate(MarginTabList, m_LblSymbolLeverage, second_margin_column_start + leverage_edit_width + 2 * h_spacing, y, second_margin_column_start + leverage_edit_width + h_spacing + wide_edit_width, y + element_height, "m_LblSymbolLeverage", "(" + TRANSLATION_LABEL_SYMBOL + " = 1:?)"))                          return false;

    y += element_height + v_spacing;

    if (!LabelCreate(MarginTabList, m_LblMaxPositionSizeByMargin, first_column_start, y, first_column_start + wide_label_width, y + element_height, "m_LblMaxPositionSizeByMargin", TRANSLATION_LABEL_MAX_PS_BY_MARGIN + ":"))                         return false;
    if (!EditCreate(MarginTabList, m_EdtMaxPositionSizeByMargin, max_psc_column_start, y, second_margin_column_start + wide_edit_width, y + element_height, "m_EdtMaxPositionSizeByMargin", "", TRANSLATION_TOOLTIP_MAX_PS_BY_MARGIN))                                              return false;
    m_EdtMaxPositionSizeByMargin.ReadOnly(true);
    m_EdtMaxPositionSizeByMargin.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Swaps

// Reset
    y = row_start + element_height + 3 * v_spacing;

    if (!LabelCreate(SwapsTabList, m_LblSwapsType, first_column_start, y, first_column_start + narrow_edit_width, y + element_height, "m_LblSwapsType", TRANSLATION_LABEL_TYPE + ":"))                                       return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsType, first_column_start + narrow_edit_width, y, second_swaps_column_start + swap_type_edit_width, y + element_height, "m_EdtSwapsType", TRANSLATION_LABEL_UNKNOWN))                                                return false;
    m_EdtSwapsType.ReadOnly(true);
    m_EdtSwapsType.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(SwapsTabList, m_LblSwapsTripleDay, first_column_start, y, first_column_start + narrow_edit_width, y + element_height, "m_LblSwapsTripleDay", TRANSLATION_LABEL_TRIPLE_SWAP + ":"))                                          return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsTripleDay, first_column_start + narrow_edit_width, y, second_swaps_column_start + swap_type_edit_width, y + element_height, "m_EdtSwapsTripleDay", "?"))                                                return false;
    m_EdtSwapsTripleDay.ReadOnly(true);
    m_EdtSwapsTripleDay.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(SwapsTabList, m_LblSwapsLong, second_swaps_column_start, y, second_swaps_column_start + normal_edit_width, y + element_height, "m_LblSwapsLong", TRANSLATION_BUTTON_LONG))                                          return false;
    if (!LabelCreate(SwapsTabList, m_LblSwapsShort, third_swaps_column_start, y, third_swaps_column_start + normal_edit_width, y + element_height, "m_LblSwapsShort", TRANSLATION_BUTTON_SHORT))                                         return false;

    y += element_height + v_spacing;

    if (!LabelCreate(SwapsTabList, m_LblSwapsNominal, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsNominal", TRANSLATION_LABEL_NOMINAL + ":"))                                          return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsNominalLong, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsNominalLong", "?"))                                                 return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsNominalShort, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsNominalShort", "?"))                                                 return false;
    m_EdtSwapsNominalLong.ReadOnly(true);
    m_EdtSwapsNominalLong.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsNominalShort.ReadOnly(true);
    m_EdtSwapsNominalShort.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(SwapsTabList, m_LblSwapsDaily, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsDaily",  TRANSLATION_LABEL_DAILY+ ":"))                                        return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsDailyLongLot, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsDailyLongLot", "?"))                                               return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsDailyShortLot, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsDailyShortLot", "?"))                                               return false;
    if (!LabelCreate(SwapsTabList, m_LblSwapsPerLotDaily, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerLotDaily", "USD " + TRANSLATION_LABEL_PER_LOT))                                         return false;
    m_EdtSwapsDailyLongLot.ReadOnly(true);
    m_EdtSwapsDailyLongLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsDailyShortLot.ReadOnly(true);
    m_EdtSwapsDailyShortLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!EditCreate(SwapsTabList, m_EdtSwapsDailyLongPS, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsDailyLongPS", "?"))                                                 return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsDailyShortPS, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsDailyShortPS", "?"))                                                 return false;
    if (!LabelCreate(SwapsTabList, m_LblSwapsPerPSDaily, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerPSDaily", "USD " + TRANSLATION_LABEL_PER_PS + " ()"))                                         return false;
    m_EdtSwapsDailyLongPS.ReadOnly(true);
    m_EdtSwapsDailyLongPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsDailyShortPS.ReadOnly(true);
    m_EdtSwapsDailyShortPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!LabelCreate(SwapsTabList, m_LblSwapsYearly, first_column_start, y, first_column_start + narrowest_label_width, y + element_height, "m_LblSwapsYearly", TRANSLATION_LABEL_YEARLY + ":"))                                         return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsYearlyLongLot, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsYearlyLongLot", "?"))                                                 return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsYearlyShortLot, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsYearlyShortLot", "?"))                                                 return false;
    if (!LabelCreate(SwapsTabList, m_LblSwapsPerLotYearly, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerLotYearly", "USD " + TRANSLATION_LABEL_PER_LOT))                                       return false;
    m_EdtSwapsYearlyLongLot.ReadOnly(true);
    m_EdtSwapsYearlyLongLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsYearlyShortLot.ReadOnly(true);
    m_EdtSwapsYearlyShortLot.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

    y += element_height + v_spacing;

    if (!EditCreate(SwapsTabList, m_EdtSwapsYearlyLongPS, second_swaps_column_start, y, second_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsYearlyLongPS", "?"))                                               return false;
    if (!EditCreate(SwapsTabList, m_EdtSwapsYearlyShortPS, third_swaps_column_start, y, third_swaps_column_start + swap_size_edit_width, y + element_height, "m_EdtSwapsYearlyShortPS", "?"))                                               return false;
    if (!LabelCreate(SwapsTabList, m_LblSwapsPerPSYearly, fourth_swaps_column_start, y, fourth_swaps_column_start + swap_last_label_width, y + element_height, "m_LblSwapsPerPSYearly", "USD " + TRANSLATION_LABEL_PER_PS + " ()"))                                       return false;
    m_EdtSwapsYearlyLongPS.ReadOnly(true);
    m_EdtSwapsYearlyLongPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    m_EdtSwapsYearlyShortPS.ReadOnly(true);
    m_EdtSwapsYearlyShortPS.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);

// Trading

    // Reset
    y = row_start + element_height + 3 * v_spacing;

    if (!ButtonCreate(TradingTabList, m_BtnTrade, first_column_start, y, first_column_start + tab_button_width, y + element_height, "m_BtnTrade", TRANSLATION_BUTTON_TRADE))                                          return false;
    if (!LabelCreate(TradingTabList, m_LblTrailingStop, first_column_start + tab_button_width + v_spacing * 2, y, first_column_start + v_spacing + tab_button_width + normal_edit_width, y + element_height, "m_LblTrailingStop", TRANSLATION_LABEL_TRAILING_STOP + ":"))                                          return false;
    if (!EditCreate(TradingTabList, m_EdtTrailingStopPoints, first_column_start + v_spacing * 2 + tab_button_width + normal_edit_width, y, first_column_start + v_spacing * 2 + tab_button_width * 2 + normal_edit_width, y + element_height, "m_EdtTrailingStopPoints", "0"))                                                 return false;
    if (!LabelCreate(TradingTabList, m_LblBreakEven, first_column_start + v_spacing * 5 + tab_button_width * 2 + normal_edit_width, y, first_column_start + v_spacing * 3 + tab_button_width * 2 + normal_edit_width + narrow_edit_width, y + element_height, "m_LblBreakEven", TRANSLATION_LABEL_BREAKEVEN + ":"))                                          return false;
    if (!EditCreate(TradingTabList, m_EdtBreakEvenPoints, first_column_start + v_spacing * 4 + tab_button_width * 2 + normal_edit_width + narrow_edit_width, y, first_column_start + v_spacing * 4 + tab_button_width * 3 + normal_edit_width + narrow_edit_width, y + element_height, "m_EdtBreakEvenPoints", "0"))                                                 return false;

    y += element_height + v_spacing;

//    if (!LabelCreate(TradingTabList, m_LblMagicNumber, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMagicNumber", TRANSLATION_LABEL_MAGIC_NUMBER + ":"))                                          return false;
    //if (!EditCreate(TradingTabList, m_EdtMagicNumber, second_trading_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, "m_EdtMagicNumber", ""))                                                 return false;

    if (!LabelCreate(TradingTabList, m_LblMagicNumber, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMagicNumber", TRANSLATION_LABEL_MAGIC_NUMBER + ":"))                                          return false;
    if (!EditCreate(TradingTabList, m_EdtMagicNumber, first_column_start + normal_label_width, y, first_column_start + normal_label_width + normal_edit_width, y + element_height, "m_EdtMagicNumber", ""))                                                 return false;
    if (!LabelCreate(TradingTabList, m_LblExpiry, first_column_start + normal_label_width + normal_edit_width + v_spacing, y, first_column_start + normal_label_width + normal_edit_width + narrowest_label_width, y + element_height, "m_LblExpiry", TRANSLATION_LABEL_EXPIRY + ":", TRANSLATION_TOOLTIP_EXPIRY))                                          return false;
    if (!EditCreate(TradingTabList, m_EdtExpiry, first_column_start + normal_label_width + normal_edit_width + narrowest_label_width, y, first_column_start + normal_label_width + normal_edit_width + narrowest_label_width + tab_button_width, y + element_height, "m_EdtExpiry", "", TRANSLATION_TOOLTIP_EXPIRY))                                          return false;
    if (!LabelCreate(TradingTabList, m_LblMinutes, first_column_start + normal_label_width + normal_edit_width + narrowest_label_width + tab_button_width + v_spacing, y, panel_end, y + element_height, "m_LblMinutes", TRANSLATION_LABEL_MINUTES, TRANSLATION_TOOLTIP_MINUTES))                                          return false;

    y += element_height + v_spacing;

    if (!LabelCreate(TradingTabList, m_LblCommentary, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblCommentary", TRANSLATION_LABEL_ORDER_COMMENTARY + ":"))                                        return false;
    if (!EditCreate(TradingTabList, m_EdtCommentary, second_trading_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, "m_EdtCommentary", ""))                                               return false;
    if (!CheckBoxCreate(TradingTabList, m_ChkCommentAutoSuffix, third_trading_column_start, y, third_trading_column_start + narrow_label_width + h_spacing, y + element_height, "m_ChkCommentAutoSuffix", TRANSLATION_LABEL_ORDER_AUTOSUFFIX, TRANSLATION_TOOLTIP_ORDER_AUTOSUFFIX))                                               return false;

    y += element_height + v_spacing;

    if (ShowMaxParametersOnTrading)
    {
        if (!LabelCreate(TradingTabList, m_LblMaxNumberOfTrades, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxNumberOfTrades", TRANSLATION_LABEL_MAX_NUMBER_OF_TRADES))                                        return false;
        if (!LabelCreate(TradingTabList, m_LblMaxNumberOfTradesTotal, first_column_start + narrow_label_width + element_height - v_spacing * 2, y, multi_tp_column_start + tab_button_width, y + element_height, "m_LblMaxNumberOfTradesTotal", TRANSLATION_LABEL_TOTAL + ":"))                                         return false;
        if (!EditCreate(TradingTabList, m_EdtMaxNumberOfTradesTotal, first_column_start + v_spacing * 2 + tab_button_width + normal_edit_width, y, first_column_start + v_spacing * 2 + tab_button_width * 2 + normal_edit_width, y + element_height, "m_EdtMaxNumberOfTradesTotal", ""))                                                 return false;
        if (!LabelCreate(TradingTabList, m_LblMaxNumberOfTradesPerSymbol, multi_tp_button_start + leverage_edit_width + v_spacing * 2, y, multi_tp_button_start + leverage_edit_width + v_spacing * 6 + tab_button_width, y + element_height, "m_LblMaxNumberOfTradesPerSymbol", TRANSLATION_LABEL_PER_SYMBOL + ":"))                                         return false;
        if (!EditCreate(TradingTabList, m_EdtMaxNumberOfTradesPerSymbol, multi_tp_button_start + leverage_edit_width + v_spacing * 7 + tab_button_width, y, multi_tp_button_start + leverage_edit_width + v_spacing * 7 + tab_button_width * 2, y + element_height, "m_EdtMaxNumberOfTradesPerSymbol", ""))                                                 return false;
    
        y += element_height + v_spacing;
    
        if (!LabelCreate(TradingTabList, m_LblMaxPositionSize, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxPositionSize", TRANSLATION_LABEL_MAX_VOLUME))                                         return false;
        if (!LabelCreate(TradingTabList, m_LblMaxPositionSizeTotal, first_column_start + narrow_label_width + element_height - v_spacing * 2, y, multi_tp_column_start + tab_button_width, y + element_height, "m_LblMaxPositionSizeTotal", TRANSLATION_LABEL_TOTAL + ":"))                                         return false;
        if (!EditCreate(TradingTabList, m_EdtMaxPositionSizeTotal, first_column_start + v_spacing * 2 + tab_button_width + normal_edit_width, y, first_column_start + v_spacing * 2 + tab_button_width * 2 + normal_edit_width, y + element_height, "m_EdtMaxPositionSizeTotal", ""))                                                 return false;
        if (!LabelCreate(TradingTabList, m_LblMaxPositionSizePerSymbol, multi_tp_button_start + leverage_edit_width + v_spacing * 2, y, multi_tp_button_start + leverage_edit_width + v_spacing * 6 + tab_button_width, y + element_height, "m_LblMaxPositionSizePerSymbol", TRANSLATION_LABEL_PER_SYMBOL + ":"))                                         return false;
        if (!EditCreate(TradingTabList, m_EdtMaxPositionSizePerSymbol, multi_tp_button_start + leverage_edit_width + v_spacing * 7 + tab_button_width, y, multi_tp_button_start + leverage_edit_width + v_spacing * 7 + tab_button_width * 2, y + element_height, "m_EdtMaxPositionSizePerSymbol", ""))                                                 return false;
    
        y += element_height + v_spacing;
    
        if (!LabelCreate(TradingTabList, m_LblMaxRisk, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxRisk", TRANSLATION_LABEL_MAX_RISK + ", %"))                                         return false;
        if (!LabelCreate(TradingTabList, m_LblMaxRiskTotal, first_column_start + narrow_label_width + element_height - v_spacing * 2, y, multi_tp_column_start + tab_button_width, y + element_height, "m_LblMaxRiskTotal", TRANSLATION_LABEL_TOTAL + ":"))                                         return false;
        if (!EditCreate(TradingTabList, m_EdtMaxRiskTotal, first_column_start + v_spacing * 2 + tab_button_width + normal_edit_width, y, first_column_start + v_spacing * 2 + tab_button_width * 2 + normal_edit_width, y + element_height, "m_EdtMaxRiskTotal", ""))                                                 return false;
        if (!LabelCreate(TradingTabList, m_LblMaxRiskPerSymbol, multi_tp_button_start + leverage_edit_width + v_spacing * 2, y, multi_tp_button_start + leverage_edit_width + v_spacing * 6 + tab_button_width, y + element_height, "m_LblMaxRiskPerSymbol", TRANSLATION_LABEL_PER_SYMBOL + ":"))                                         return false;
        if (!EditCreate(TradingTabList, m_EdtMaxRiskPerSymbol, multi_tp_button_start + leverage_edit_width + v_spacing * 7 + tab_button_width, y, multi_tp_button_start + leverage_edit_width + v_spacing * 7 + tab_button_width * 2, y + element_height, "m_EdtMaxRiskPerSymbol", ""))                                                 return false;
    
        y += element_height + v_spacing;
    }

    if (!CheckBoxCreate(TradingTabList, m_ChkDisableTradingWhenLinesAreHidden, first_column_start, y, panel_end + h_spacing, y + element_height, "m_ChkDisableTradingWhenLinesAreHidden", TRANSLATION_CHECKBOX_DISABLE_TRADING_LINES_HIDDEN))           return false;

    y += element_height + v_spacing;

    // Need multiple TP targets.
    if (sets.TakeProfitsNumber > 1)
    {
        if (!LabelCreate(TradingTabList, m_LblTradingTP, multi_tp_column_start, y, multi_tp_column_start + multi_tp_label_width, y + element_height, "m_LblTradingTP", TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_DISTANCE))                                        return false;
        if (!ButtonCreate(TradingTabList, m_BtnTPsInward, multi_tp_button_start, y, multi_tp_button_start + leverage_edit_width, y + element_height, "m_BtnTPsInward", "<<", TRANSLATION_TOOLTIP_FILL_INWARD))                                          return false;
        if (!ButtonCreate(TradingTabList, m_BtnTPsOutward, multi_tp_button_start + leverage_edit_width + v_spacing, y, multi_tp_button_start + 2 * leverage_edit_width + v_spacing, y + element_height, "m_BtnTPsOutward", ">>", TRANSLATION_TOOLTIP_FILL_OUTWARD))                                          return false;
        if (!ButtonCreate(TradingTabList, m_BtnTradingTPShare, third_trading_column_start, y, third_trading_column_start + normal_edit_width, y + element_height, "m_BtnTradingTPShare", TRANSLATION_LABEL_SHARE + ", %", TRANSLATION_TOOLTIP_SHARE))                                       return false;

        y += element_height + v_spacing;

        ArrayResize(TradingTPLabels, sets.TakeProfitsNumber);
        ArrayResize(TradingTPEdits, sets.TakeProfitsNumber);
        ArrayResize(TradingTPShareEdits, sets.TakeProfitsNumber);
        for (int i = 0; i < sets.TakeProfitsNumber; i++)
        {
            if (!LabelCreate(TradingTabList, TradingTPLabels[i], first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblTradingTPLabel" + IntegerToString(i + 1), TRANSLATION_LABEL_TAKEPROFIT + " " + IntegerToString(i + 1)))                                        return false;
            if (!EditCreate(TradingTabList, TradingTPEdits[i], multi_tp_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, "m_EdtTradingTPEdit" + IntegerToString(i + 1), ""))                                              return false;
            if (!EditCreate(TradingTabList, TradingTPShareEdits[i], third_trading_column_start, y, third_trading_column_start + leverage_edit_width, y + element_height, "m_EdtTradingTPShareEdit" + IntegerToString(i + 1), ""))                                               return false;
            y += element_height + v_spacing;
        }
    }

    if (ShowFusesOnTrading)
    {
        if (!LabelCreate(TradingTabList, m_LblTradingPoints, second_trading_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, "m_LblTradingPoints", TRANSLATION_LABEL_POINTS, ""))                                       return false;
    
        y += element_height + v_spacing;
    
        if (!LabelCreate(TradingTabList, m_LblMaxSlippage, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxSlippage", TRANSLATION_LABEL_MAX_SLIPPAGE + ":"))                                          return false;
        if (!EditCreate(TradingTabList, m_EdtMaxSlippage, second_trading_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, "m_EdtMaxSlippage", ""))                                                 return false;
    
        y += element_height + v_spacing;
    
        if (!LabelCreate(TradingTabList, m_LblMaxSpread, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxSpread", TRANSLATION_LABEL_MAX_SPREAD + ":"))                                        return false;
        if (!EditCreate(TradingTabList, m_EdtMaxSpread, second_trading_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, "m_EdtMaxSpread", ""))                                                 return false;
    
        y += element_height + v_spacing;
    
        if (!LabelCreate(TradingTabList, m_LblMaxEntrySLDistance, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMaxEntrySLDistance", TRANSLATION_LABEL_MAX_ENTRY_SL_DISTANCE + ":"))                                       return false;
        if (!EditCreate(TradingTabList, m_EdtMaxEntrySLDistance, second_trading_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, "m_EdtMaxEntrySLDistance", ""))                                               return false;
    
        y += element_height + v_spacing;
    
        if (!LabelCreate(TradingTabList, m_LblMinEntrySLDistance, first_column_start, y, first_column_start + normal_label_width, y + element_height, "m_LblMinEntrySLDistance", TRANSLATION_LABEL_MIN_ENTRY_SL_DISTANCE + ":"))                                       return false;
        if (!EditCreate(TradingTabList, m_EdtMinEntrySLDistance, second_trading_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, "m_EdtMinEntrySLDistance", ""))                                               return false;
    
        y += element_height + v_spacing;
    }

    if (ShowCheckboxesOnTrading)
    {
        if (PanelWidth > 350)
        {
            if (!CheckBoxCreate(TradingTabList, m_ChkSubtractPositions, first_column_start, y, second_trading_column_start + 5 * h_spacing, y + element_height, "m_ChkSubtractPositions", TRANSLATION_CHECKBOX_SUBTRACT_OPEN_POSITIONS_VOLUME, TRANSLATION_TOOLTIP_SUBTRACT_OPEN_POSITIONS_VOLUME))            return false;
            if (!CheckBoxCreate(TradingTabList, m_ChkSubtractPendingOrders, second_trading_column_start + 6 * h_spacing, y, panel_end, y + element_height, "m_ChkSubtractPendingOrders", TRANSLATION_CHECKBOX_SUBTRACT_PENDING_ORDERS_VOLUME, TRANSLATION_TOOLTIP_SUBTRACT_PENDING_ORDERS_VOLUME))            return false;
    
            y += element_height + v_spacing;
    
            if (!CheckBoxCreate(TradingTabList, m_ChkDoNotApplyStopLoss, first_column_start, y, second_trading_column_start + 5 * h_spacing, y + element_height, "m_ChkDoNotApplyStopLoss", TRANSLATION_CHECKBOX_DO_NOT_APPLY_STOPLOSS, TRANSLATION_TOOLTIP_DO_NOT_APPLY_STOPLOSS))           return false;
            if (!CheckBoxCreate(TradingTabList, m_ChkDoNotApplyTakeProfit, second_trading_column_start + 6 * h_spacing, y, panel_end, y + element_height, "m_ChkDoNotApplyTakeProfit", TRANSLATION_CHECKBOX_DO_NOT_APPLY_TAKEPROFIT, TRANSLATION_TOOLTIP_DO_NOT_APPLY_TAKEPROFIT))            return false;
        }
        else
        {
            if (!CheckBoxCreate(TradingTabList, m_ChkSubtractPositions, first_column_start, y, panel_end, y + element_height, "m_ChkSubtractPositions", TRANSLATION_CHECKBOX_SUBTRACT_OPEN_POSITIONS_VOLUME, TRANSLATION_TOOLTIP_SUBTRACT_OPEN_POSITIONS_VOLUME))             return false;
    
            y += element_height + v_spacing;
    
            if (!CheckBoxCreate(TradingTabList, m_ChkSubtractPendingOrders, first_column_start, y, panel_end, y + element_height, "m_ChkSubtractPendingOrders", TRANSLATION_CHECKBOX_SUBTRACT_PENDING_ORDERS_VOLUME, TRANSLATION_TOOLTIP_SUBTRACT_PENDING_ORDERS_VOLUME))            return false;
    
            y += element_height + v_spacing;
    
            if (!CheckBoxCreate(TradingTabList, m_ChkDoNotApplyStopLoss, first_column_start, y, panel_end, y + element_height, "m_ChkDoNotApplyStopLoss", TRANSLATION_CHECKBOX_DO_NOT_APPLY_STOPLOSS, TRANSLATION_TOOLTIP_DO_NOT_APPLY_STOPLOSS))            return false;
    
            y += element_height + v_spacing;
    
            if (!CheckBoxCreate(TradingTabList, m_ChkDoNotApplyTakeProfit, first_column_start, y, panel_end, y + element_height, "m_ChkDoNotApplyTakeProfit", TRANSLATION_CHECKBOX_DO_NOT_APPLY_TAKEPROFIT, TRANSLATION_TOOLTIP_DO_NOT_APPLY_TAKEPROFIT))            return false;
        }
    
        y += element_height + v_spacing;
    }
    
    if (!CheckBoxCreate(TradingTabList, m_ChkAskForConfirmation, first_column_start, y, panel_end, y + element_height, "m_ChkAskForConfirmation", TRANSLATION_CHECKBOX_ASK_FOR_CONFIRMATION, TRANSLATION_TOOLTIP_ASK_FOR_CONFIRMATION))           return false;

    InitObjects();

    return true;
}

bool CPositionSizeCalculator::InitObjects()
{
    //+-------------------------------------+
    //| Align text in all objects.          |
    //+-------------------------------------+
    ENUM_ALIGN_MODE align = ALIGN_RIGHT;
    if (!m_EdtEntryLevel.TextAlign(align))                                   return false;
    if (!m_EdtSL.TextAlign(align))                                           return false;
    if (!m_EdtTP.TextAlign(align))                                           return false;
    if (sets.TakeProfitsNumber > 1)
        for (int i = 0; i < sets.TakeProfitsNumber - 1; i++)
            if (!AdditionalTPEdits[i].TextAlign(align))                      return false;
    if (!m_EdtStopPrice.TextAlign(align))                                    return false;
    if (!m_EdtCommissionSize.TextAlign(align))                               return false;
    if (!HideAccSize) if (!m_EdtAccount.TextAlign(align))                    return false;
    if (!m_EdtRiskPIn.TextAlign(align))                                      return false;
    if (!m_EdtRiskPRes.TextAlign(align))                                     return false;
    if (!m_EdtRiskMIn.TextAlign(align))                                      return false;
    if (!m_EdtRiskMRes.TextAlign(align))                                     return false;
    if (!m_EdtReward1.TextAlign(align))                                      return false;
    if (!m_EdtReward2.TextAlign(align))                                      return false;
    if (!m_EdtRR1.TextAlign(align))                                          return false;
    if (!m_EdtRR2.TextAlign(align))                                          return false;
    if (!m_EdtPosSize.TextAlign(align))                                      return false;
    if (ShowATROptions)
    {
        if (!m_EdtATRPeriod.TextAlign(align))                                return false;
        if (!m_EdtATRMultiplierSL.TextAlign(align))                          return false;
        if (!m_EdtATRMultiplierTP.TextAlign(align))                          return false;
    }
    if (ShowPointValue) if (!m_EdtPointValue.TextAlign(align))               return false;
    if (!m_EdtCurRiskM.TextAlign(align))                                     return false;
    if (!m_EdtCurRiskP.TextAlign(align))                                     return false;
    if (!m_EdtCurProfitM.TextAlign(align))                                   return false;
    if (!m_EdtCurProfitP.TextAlign(align))                                   return false;
    if (!m_EdtCurL.TextAlign(align))                                         return false;
    if (!m_EdtCurrentRRR.TextAlign(align))                                   return false;
    if (!m_EdtPotRiskM.TextAlign(align))                                     return false;
    if (!m_EdtPotRiskP.TextAlign(align))                                     return false;
    if (!m_EdtPotProfitM.TextAlign(align))                                   return false;
    if (!m_EdtPotProfitP.TextAlign(align))                                   return false;
    if (!m_EdtPotL.TextAlign(align))                                         return false;
    if (!m_EdtPotentialRRR.TextAlign(align))                                 return false;
    if (!m_EdtPosMargin.TextAlign(align))                                    return false;
    if (!m_EdtUsedMargin.TextAlign(align))                                   return false;
    if (!m_EdtFreeMargin.TextAlign(align))                                   return false;
    if (!m_EdtMaxPositionSizeByMargin.TextAlign(align))                      return false;
    if (!m_EdtSwapsNominalLong.TextAlign(align))                             return false;
    if (!m_EdtSwapsNominalShort.TextAlign(align))                            return false;
    if (!m_EdtSwapsDailyLongLot.TextAlign(align))                            return false;
    if (!m_EdtSwapsDailyShortLot.TextAlign(align))                           return false;
    if (!m_EdtSwapsDailyLongPS.TextAlign(align))                             return false;
    if (!m_EdtSwapsDailyShortPS.TextAlign(align))                            return false;
    if (!m_EdtSwapsYearlyLongLot.TextAlign(align))                           return false;
    if (!m_EdtSwapsYearlyShortLot.TextAlign(align))                          return false;
    if (!m_EdtSwapsYearlyLongPS.TextAlign(align))                            return false;
    if (!m_EdtSwapsYearlyShortPS.TextAlign(align))                           return false;
    if (!m_EdtMagicNumber.TextAlign(align))                                  return false;
    // Multiple TP targets.
    if (sets.TakeProfitsNumber > 1)
    {
        for (int i = 0; i < sets.TakeProfitsNumber; i++)
        {
            if (!TradingTPEdits[i].TextAlign(align))                         return false;
            if (!TradingTPShareEdits[i].TextAlign(align))                    return false;
        }
    }
    if (ShowFusesOnTrading)
    {
        if (!m_EdtMaxSlippage.TextAlign(align))                                  return false;
        if (!m_EdtMaxSpread.TextAlign(align))                                    return false;
        if (!m_EdtMaxEntrySLDistance.TextAlign(align))                           return false;
        if (!m_EdtMinEntrySLDistance.TextAlign(align))                           return false;
    }
    if (!m_EdtTrailingStopPoints.TextAlign(align))                           return false;
    if (!m_EdtBreakEvenPoints.TextAlign(align))                              return false;
    if (!m_EdtExpiry.TextAlign(align))                                       return false;
    if (ShowMaxParametersOnTrading)
    {
        if (!m_EdtMaxNumberOfTradesTotal.TextAlign(align))                       return false;
        if (!m_EdtMaxNumberOfTradesPerSymbol.TextAlign(align))                   return false;
        if (!m_EdtMaxPositionSizeTotal.TextAlign(align))                         return false;
        if (!m_EdtMaxPositionSizePerSymbol.TextAlign(align))                     return false;
        if (!m_EdtMaxRiskTotal.TextAlign(align))                                 return false;
        if (!m_EdtMaxRiskPerSymbol.TextAlign(align))                             return false;
    }
    if (sets.TPLockedOnSL) m_BtnTakeProfit.ColorBackground(CONTROLS_BUTTON_COLOR_TP_LOCKED);
    else m_BtnTakeProfit.ColorBackground(CONTROLS_BUTTON_COLOR_TP_UNLOCKED);

    HideRisk();
    HideMargin();
    HideMain();
    HideSwaps();
    HideTrading();

    if (sets.SelectedTab == MainTab) ShowMain();
    else if (sets.SelectedTab == RiskTab) ShowRisk();
    else if (sets.SelectedTab == MarginTab) ShowMargin();
    else if (sets.SelectedTab == SwapsTab) ShowSwaps();
    else if (sets.SelectedTab == TradingTab) ShowTrading();

    InitControlsValues(); // Init values inside controls.

    MoveAndResize();

    DisplayValues();

    if (sets.TakeProfitsNumber > 1)
    {
        for (int i = 0; i < sets.TakeProfitsNumber; i++)
        {
            TradingTPShareEdits[i].Text(IntegerToString(sets.TPShare[i])); // Display the values on the panel because they aren't refreshed in DisplayValues();
            TradingTPEdits[i].Text(DoubleToString(sets.TP[i], _Digits));
        }
    }
    return true;
}

void CPositionSizeCalculator::InitControlsValues()
{
    if ((TP_Multiplier < 0.999) || (TP_Multiplier > 1.001))
    {
        if (!sets.TPDistanceInPoints)
        {
            m_BtnTakeProfit.Text(TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_DISTANCE + " x " + DoubleToString(TP_Multiplier, CountDecimalPlaces(TP_Multiplier)) + ":");
        }
        else m_BtnTakeProfit.Text(TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_DISTANCE + " x " + DoubleToString(TP_Multiplier, CountDecimalPlaces(TP_Multiplier)) + ":");
    }

    if (sets.EntryType == Pending)
    {
        m_BtnOrderType.Text(TRANSLATION_BUTTON_ORDER_TYPE_PENDING);
    }
    else if (sets.EntryType == Instant)
    {
        m_BtnOrderType.Text(TRANSLATION_BUTTON_ORDER_TYPE_INSTANT);
        m_EdtEntryLevel.ReadOnly(true);
        m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
    }
    else if (sets.EntryType == StopLimit)
    {
        m_BtnOrderType.Text(TRANSLATION_BUTTON_ORDER_TYPE_STOPLIMIT);
    }

    // Hide Stop Limit fields.
    if (sets.EntryType != StopLimit)
    {
        m_LblStopPrice.Hide();
        m_EdtStopPrice.Hide();
        m_LblStopPriceWarning.Hide();
    }

    double acc_val;

    if (!HideAccSize)
    {
        switch(sets.AccountButton)
        {
        default:
        case Balance:
            m_BtnAccount.Text(TRANSLATION_BUTTON_ACCOUNT_BALANCE);
            // Custom balance.
            if (CustomBalance > 0) acc_val = CustomBalance;
            else acc_val = AccountInfoDouble(ACCOUNT_BALANCE);
            // Account balance editable.
            m_EdtAccount.ReadOnly(false);
            m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE);
            break;
        case Equity:
            m_BtnAccount.Text(TRANSLATION_BUTTON_ACCOUNT_EQUITY);
            acc_val = AccountInfoDouble(ACCOUNT_EQUITY);
            // Account balance uneditable.
            m_EdtAccount.ReadOnly(true);
            m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
            break;
        case Balance_minus_Risk:
            m_BtnAccount.Text(TRANSLATION_BUTTON_BALANCE_MINUS_CPR);
            // Custom balance.
            if (CustomBalance > 0) acc_val = CustomBalance;
            else acc_val = AccountInfoDouble(ACCOUNT_BALANCE);
            // Account balance uneditable.
            m_EdtAccount.ReadOnly(true);
            m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
            break;
        }
        // Applying additional funds (e.g. bank balance or total net worth, etc.).
        if (CustomBalance <= 0) acc_val += AdditionalFunds;
        m_EdtAccount.Text(DoubleToString(acc_val, 2));
        // Star to show that it is not original account balance.
        if ((AdditionalFunds >= 0.01) || (AdditionalFunds <= -0.01) || ((CustomBalance > 0) && (sets.AccountButton != Equity))) m_LblAdditionalFundsAsterisk.Show();
        else m_LblAdditionalFundsAsterisk.Hide();
    }

    if (sets.CommissionType == COMMISSION_PERCENT)
    {
        CommissionDecimals = CountDecimalPlaces(sets.CommissionPerLot);
        m_BtnCommissionType.Text("%");
    }
    else
    {
        CommissionDecimals = (int)AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS);
        m_BtnCommissionType.Text(AccountInfoString(ACCOUNT_CURRENCY));
    }

    if (QuickRisk1 > 0)
    {
        int digits = 2;
        if (QuickRisk1 >= 100) digits = 0;
        else if (QuickRisk1 >= 10) digits = 1;
        m_BtnQuickRisk1.Text(DoubleToString(QuickRisk1, digits));
    }
    if (QuickRisk2 > 0)
    {
        int digits = 2;
        if (QuickRisk2 >= 100) digits = 0;
        else if (QuickRisk2 >= 10) digits = 1;
        m_BtnQuickRisk2.Text(DoubleToString(QuickRisk2, digits));
    }

    m_EdtRiskPIn.Text(DoubleToString(sets.Risk, 2));
    m_EdtRiskMIn.Text(DoubleToString(sets.MoneyRisk, AccountCurrencyDigits));

    if (ShowATROptions)
    {
        m_EdtATRPeriod.Text(IntegerToString(sets.ATRPeriod));
        m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2));
        m_ChkSpreadAdjustmentSL.Checked(sets.SpreadAdjustmentSL);
        m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
        m_ChkSpreadAdjustmentTP.Checked(sets.SpreadAdjustmentTP);
        if (sets.ATRTimeframe != PERIOD_CURRENT) m_BtnATRTimeframe.Text(EnumToString(sets.ATRTimeframe));
        else m_BtnATRTimeframe.Text(TRANSLATION_BUTTON_ATR_PERIOD_CURRENT);
    }

    m_ChkCountPendings.Checked(sets.CountPendingOrders);
    m_ChkIgnoreOrdersWithoutSL.Checked(sets.IgnoreOrdersWithoutSL);
    m_ChkIgnoreOrdersWithoutTP.Checked(sets.IgnoreOrdersWithoutTP);
    m_ChkIgnoreOtherSymbols.Checked(sets.IgnoreOtherSymbols);

    // Show/hide RiskReward
    if (sets.TakeProfitLevel == 0)
    {
        m_LblRR.Hide();
        m_EdtRR1.Hide();
        m_EdtRR2.Hide();
        m_LblReward.Hide();
        m_EdtReward1.Hide();
        m_EdtReward2.Hide();
    }

    CustomLeverage = sets.CustomLeverage;
    CustomLeverageDecimals = CountDecimalPlaces(CustomLeverage);

    // Trading
    m_EdtTrailingStopPoints.Text(IntegerToString(sets.TrailingStopPoints));
    m_EdtBreakEvenPoints.Text(IntegerToString(sets.BreakEvenPoints));
    m_EdtMagicNumber.Text(IntegerToString(sets.MagicNumber));
    m_EdtExpiry.Text(IntegerToString(sets.ExpiryMinutes));
    m_EdtCommentary.Text(sets.Commentary);
    m_ChkCommentAutoSuffix.Checked(sets.CommentAutoSuffix);
    if (ShowMaxParametersOnTrading)
    {
        m_EdtMaxNumberOfTradesTotal.Text(IntegerToString(sets.MaxNumberOfTradesTotal));
        m_EdtMaxNumberOfTradesPerSymbol.Text(IntegerToString(sets.MaxNumberOfTradesPerSymbol));
        m_EdtMaxPositionSizeTotal.Text(DoubleToString(sets.MaxPositionSizeTotal, 2));
        m_EdtMaxPositionSizePerSymbol.Text(DoubleToString(sets.MaxPositionSizeTotal, 2));
        m_EdtMaxRiskTotal.Text(DoubleToString(sets.MaxRiskTotal, 2));
        m_EdtMaxRiskPerSymbol.Text(DoubleToString(sets.MaxRiskPerSymbol, 2));
    }
    m_ChkDisableTradingWhenLinesAreHidden.Checked(sets.DisableTradingWhenLinesAreHidden);
    if (ShowFusesOnTrading)
    {
        m_EdtMaxSlippage.Text(IntegerToString(sets.MaxSlippage));
        m_EdtMaxSpread.Text(IntegerToString(sets.MaxSpread));
        m_EdtMaxEntrySLDistance.Text(IntegerToString(sets.MaxEntrySLDistance));
        m_EdtMinEntrySLDistance.Text(IntegerToString(sets.MinEntrySLDistance));
    }
    if (ShowCheckboxesOnTrading)
    {
        m_ChkSubtractPositions.Checked(sets.SubtractPositions);
        m_ChkSubtractPendingOrders.Checked(sets.SubtractPendingOrders);
        m_ChkDoNotApplyStopLoss.Checked(sets.DoNotApplyStopLoss);
        m_ChkDoNotApplyTakeProfit.Checked(sets.DoNotApplyTakeProfit);
    }
    m_ChkAskForConfirmation.Checked(sets.AskForConfirmation);
}

// Moves elements on the panel depending on the choice of showing TP-related stuff, risk, and margin.
// Adjusts panel's height accordingly.
void CPositionSizeCalculator::MoveAndResize()
{
    int col_height = (int)MathRound(24 * m_DPIScale);
    int new_height = col_height;
    int ref_point;
    int y;

    switch(sets.SelectedTab)
    {
    case MainTab:
        ref_point = m_BtnTakeProfit.Top() + col_height * (sets.TakeProfitsNumber - 1);

        if (sets.EntryType == StopLimit) // Stop Price label & edit should be moved to ref_point. Everything else to below them.
        {
            m_LblStopPrice.Move(m_LblStopPrice.Left(), ref_point + 1 * col_height);
            m_EdtStopPrice.Move(m_EdtStopPrice.Left(), ref_point + 1 * col_height);
            m_BtnStopPriceIncrease.Move(m_BtnStopPriceIncrease.Left(), ref_point + 1 * col_height);
            m_BtnStopPriceDecrease.Move(m_BtnStopPriceDecrease.Left(), ref_point + 1 * col_height + element_height / 2);
            m_LblStopPriceWarning.Move(m_LblStopPriceWarning.Left(), ref_point + 1 * col_height);

            ref_point = m_LblStopPrice.Top();
        }

        if (ShowATROptions)
        {
            // ATR Period label, ATR Period edit, SL multiplier label, SL multiplier edit, ATR timeframe label
            m_LblATRPeriod.Move(m_LblATRPeriod.Left(), ref_point + 1 * col_height);
            m_EdtATRPeriod.Move(m_EdtATRPeriod.Left(), ref_point + 1 * col_height);
            m_LblATRMultiplierSL.Move(m_LblATRMultiplierSL.Left(), ref_point + 1 * col_height);
            m_EdtATRMultiplierSL.Move(m_EdtATRMultiplierSL.Left(), ref_point + 1 * col_height);
            m_ChkSpreadAdjustmentSL.Move(m_ChkSpreadAdjustmentSL.Left(), ref_point + 1 * col_height);
            if (PanelWidth > 350) m_LblATRTimeframe.Move(m_LblATRTimeframe.Left(), ref_point + 1 * col_height);
            // ATR Value label, TP multiplier label, TP multiplier edit, ATR timeframe button
            m_LblATRValue.Move(m_LblATRValue.Left(), ref_point + 2 * col_height);
            m_LblATRMultiplierTP.Move(m_LblATRMultiplierTP.Left(), ref_point + 2 * col_height);
            m_EdtATRMultiplierTP.Move(m_EdtATRMultiplierTP.Left(), ref_point + 2 * col_height);
            m_ChkSpreadAdjustmentTP.Move(m_ChkSpreadAdjustmentTP.Left(), ref_point + 2 * col_height);
            if (PanelWidth > 350) m_BtnATRTimeframe.Move(m_BtnATRTimeframe.Left(), ref_point + 2 * col_height);
            else
            {
                m_LblATRTimeframe.Move(m_LblATRTimeframe.Left(), ref_point + 3 * col_height);
                m_BtnATRTimeframe.Move(m_BtnATRTimeframe.Left(), ref_point + 3 * col_height);
            }
            ref_point = m_BtnATRTimeframe.Top();
        }

        // Order type label, order type button, hide lines button
        m_LblOrderType.Move(m_LblOrderType.Left(), ref_point + 1 * col_height);
        m_BtnOrderType.Move(m_BtnOrderType.Left(), ref_point + 1 * col_height);
        m_BtnLines.Move(m_BtnLines.Left(), ref_point + 1 * col_height);
        // Commission label, commission edit
        m_LblCommissionSize.Move(m_LblCommissionSize.Left(), ref_point + 2 * col_height);
        m_BtnCommissionType.Move(m_BtnCommissionType.Left(), ref_point + 2 * col_height);
        m_EdtCommissionSize.Move(m_EdtCommissionSize.Left(), ref_point + 2 * col_height);
        // Account balance label, account balance edit, account balance asterisk,
        y = 3;
        if (!HideAccSize)
        {
            m_BtnAccount.Move(m_BtnAccount.Left(), ref_point + y * col_height);
            m_EdtAccount.Move(m_EdtAccount.Left(), ref_point + y * col_height);
            m_LblAdditionalFundsAsterisk.Move(m_LblAdditionalFundsAsterisk.Left(), ref_point + y * col_height);
            y++;
        }
        // Input label, Result label
        m_LblInput.Move(m_LblInput.Left(), ref_point + y * col_height);
        m_LblResult.Move(m_LblResult.Left(), ref_point + y * col_height);
        y++;
        // Risk % label, Risk % edit input,  Risk % edit result
        m_LblRisk.Move(m_LblRisk.Left(), ref_point + y * col_height);
        if (QuickRisk1 > 0) m_BtnQuickRisk1.Move(m_BtnQuickRisk1.Left(), ref_point + y * col_height);
        if (QuickRisk2 > 0) m_BtnQuickRisk2.Move(m_BtnQuickRisk2.Left(), ref_point + y * col_height);
        m_EdtRiskPIn.Move(m_EdtRiskPIn.Left(), ref_point + y * col_height);
        m_EdtRiskPRes.Move(m_EdtRiskPRes.Left(), ref_point + y * col_height);
        y++;
        // Risk $ label, Risk $ edit input,  Risk $ edit result
        m_LblRiskM.Move(m_LblRiskM.Left(), ref_point + y * col_height);
        m_EdtRiskMIn.Move(m_EdtRiskMIn.Left(), ref_point + y * col_height);
        m_EdtRiskMRes.Move(m_EdtRiskMRes.Left(), ref_point + y * col_height);

        ref_point = m_LblRiskM.Top();

        if (sets.TakeProfitLevel == 0) y = 1; // Start right below the Risk row.
        else
        {
            m_LblReward.Move(m_LblReward.Left(), ref_point + 1 * col_height);
            m_EdtReward1.Move(m_EdtReward1.Left(), ref_point + 1 * col_height);
            m_EdtReward2.Move(m_EdtReward2.Left(), ref_point + 1 * col_height);
            m_LblRR.Move(m_LblRR.Left(), ref_point + 2 * col_height);
            m_EdtRR1.Move(m_EdtRR1.Left(), ref_point + 2 * col_height);
            m_EdtRR2.Move(m_EdtRR2.Left(), ref_point + 2 * col_height);
            y = 3; // Start right below the Reward row.
        }
        m_LblPosSize.Move(m_LblPosSize.Left(), ref_point + y * col_height);
        m_BtnMaxPS.Move(m_BtnMaxPS.Left(), ref_point + y * col_height);
        m_EdtPosSize.Move(m_EdtPosSize.Left(), ref_point + y * col_height);
        ref_point = ref_point + y * col_height;

        if (ShowPointValue)
        {
            m_LblPointValue.Move(m_LblPointValue.Left(), ref_point + 1 * col_height);
            m_EdtPointValue.Move(m_EdtPointValue.Left(), ref_point + 1 * col_height);
            ref_point = ref_point + 1 * col_height;
        }
        break;
    case RiskTab:
        ref_point = m_EdtPotProfitM.Top();
        break;
    case MarginTab:
        ref_point = m_LblMaxPositionSizeByMargin.Top();
        break;
    case SwapsTab:
        ref_point = m_LblSwapsPerPSYearly.Top();
        break;
    case TradingTab:
        ref_point = m_ChkAskForConfirmation.Top();
        break;
    default:
        ref_point = m_LblRiskM.Top();
        break;
    }
    m_LblURL.Move(m_LblURL.Left(), ref_point + col_height);
    new_height = m_LblURL.Top() + col_height - Top();

    if (!m_minimized)
    {
        // Resize window.
        Height(new_height);
        // Needed only in case of initialization when actual panel maximization is avoided.
        if (NoPanelMaximization) Width((int)MathRound(PanelWidth * m_DPIScale));
    }
    NoPanelMaximization = false;
}

bool CPositionSizeCalculator::DisplayValues()
{
    //=== Spread
    if (ShowSpread == Points)
    {
        if (!Caption(PanelCaption + " " + TRANSLATION_LABEL_SPREAD + ": " + IntegerToString(SymbolInfoInteger(Symbol(), SYMBOL_SPREAD)))) return false;
    }
    else if (ShowSpread == Ratio) // Spread / SL ratio in percentage.
    {
        double SL;
        if (sets.SLDistanceInPoints) SL = sets.StopLoss * _Point;
        else SL = MathAbs(sets.StopLossLevel - sets.EntryLevel);
        if (SL != 0) if (!Caption(PanelCaption + " " + TRANSLATION_LABEL_SPREAD + ": " + DoubleToString((SymbolInfoInteger(Symbol(), SYMBOL_SPREAD) * _Point / SL) * 100, 2) + "%")) return false;
    }
    else if (!Caption(PanelCaption)) return false;

    //=== Levels
    /* Entry Level    */ if (!m_EdtEntryLevel.Text(DoubleToString(sets.EntryLevel, _Digits)))                                  return false;
    if (sets.TradeDirection == Long) m_BtnEntry.Text(TRANSLATION_BUTTON_LONG);
    else if (sets.TradeDirection == Short) m_BtnEntry.Text(TRANSLATION_BUTTON_SHORT);
    /* Entry Warning  */ if (!m_LblEntryWarning.Text(WarningEntry))                                                        return false;

    /* Stop-Loss      */ if (!sets.SLDistanceInPoints)
    {
        if (!m_EdtSL.Text(DoubleToString(sets.StopLossLevel, _Digits)))                                return false;
    }
    else if (!m_EdtSL.Text(IntegerToString(sets.StopLoss)))                                            return false;

    /* SL Warning     */ if (!m_LblSLWarning.Text(WarningSL))                                                              return false;

    /* Take Profit    */ if (!sets.TPDistanceInPoints)
    {
        if (!m_EdtTP.Text(DoubleToString(sets.TakeProfitLevel, _Digits)))                              return false;
    }
    else if (!m_EdtTP.Text(IntegerToString(sets.TakeProfit)))                                           return false;
    for (int i = 1; i < sets.TakeProfitsNumber; i++)
    {
        if (!sets.TPDistanceInPoints)
        {
            // Price level.
            if (!AdditionalTPEdits[i - 1].Text(DoubleToString(sets.TP[i], _Digits)))               return false;
        }
        else
        {
            // Points.
            string tp_text = "0";
            // If line's value was zero, then points distance should be also zero.
            if (sets.TP[i] != 0) tp_text = IntegerToString((int)MathRound(MathAbs(sets.TP[i] - sets.EntryLevel) / _Point));
            if (!AdditionalTPEdits[i - 1].Text(tp_text))                                                                         return false;
        }
    }

    /* TP Warning     */ if (!m_LblTPWarning.Text(WarningTP))                                                              return false;
    for (int i = 1; i < sets.TakeProfitsNumber; i++)
    {
        AdditionalTPWarnings[i - 1].Text(AdditionalWarningTP[i - 1]);
    }

    /* Stop Limit     */ if (sets.EntryType == StopLimit)
    {
        if (!m_EdtStopPrice.Text(DoubleToString(sets.StopPriceLevel, _Digits)))                        return false;
        /* StopPrice Warning */ if (!m_LblStopPriceWarning.Text(WarningSP))                                                    return false;
    }

    /* Order type */ if (sets.EntryType == Instant)
                     {
                         m_BtnOrderType.Text(TRANSLATION_BUTTON_ORDER_TYPE_INSTANT);
                         m_EdtEntryLevel.ReadOnly(true);
                         m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
                     }
                     else if (sets.EntryType == Pending)
                     {
                         m_BtnOrderType.Text(TRANSLATION_BUTTON_ORDER_TYPE_PENDING);
                         m_EdtEntryLevel.ReadOnly(false);
                         m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE);
                     }
                     else if (sets.EntryType == StopLimit)
                     {
                         m_BtnOrderType.Text(TRANSLATION_BUTTON_ORDER_TYPE_STOPLIMIT);
                         m_EdtEntryLevel.ReadOnly(false);
                         m_EdtEntryLevel.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE);
                     }
    /* Account Value  */ if (!HideAccSize) if (!m_EdtAccount.Text(FormatDouble(DoubleToString(AccSize, AccountCurrencyDigits), AccountCurrencyDigits)))                  return false;

    /* Account Asterisk */
    if (sets.SelectedTab == MainTab)
    {
        switch(sets.AccountButton)
        {
        default:
        case Balance:
        case Balance_minus_Risk:
            if (sets.CustomBalance > 0)
            {
                if (!m_minimized) m_LblAdditionalFundsAsterisk.Show();
                ObjectSetString(ChartID(), m_name + "m_LblAdditionalFundsAsterisk", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_ACCOUNT_SIZE_ASTERISK_CUSTOM);
            }
            else
            {
                m_LblAdditionalFundsAsterisk.Hide();
            }
            break;
        case Equity:
            m_LblAdditionalFundsAsterisk.Hide();
            break;
        }
        if (sets.CustomBalance <= 0)
        {
            if (AdditionalFunds != 0)
            {
                if (!m_minimized) m_LblAdditionalFundsAsterisk.Show();
                string tooltip = "";
                if (AdditionalFunds > 0) tooltip = "+" + DoubleToString(AdditionalFunds, 2) + " " + TRANSLATION_TOOLTIP_ACCOUNT_SIZE_ASTERISK_ADD;
                else if (AdditionalFunds < 0) tooltip = DoubleToString(-AdditionalFunds, 2) + " " + TRANSLATION_TOOLTIP_ACCOUNT_SIZE_ASTERISK_SUB;

                ObjectSetString(ChartID(), m_name + "m_LblAdditionalFundsAsterisk", OBJPROP_TOOLTIP, tooltip);
            }
        }
    }

    /* Lines */          if (sets.ShowLines)
    {
        if (!m_BtnLines.Text(TRANSLATION_BUTTON_HIDE_LINES))                                                            return false;
    }
    else
    {
        if (!m_BtnLines.Text(TRANSLATION_BUTTON_SHOW_LINES))                                                            return false;
    }

    //=== ATR SL and TP
    if (ShowATROptions)
    {
        double buf[1] = {0};
        if (ATR_handle != INVALID_HANDLE) CopyBuffer(ATR_handle, 0, (int)ATRCandle, 1, buf);
        double atr = buf[0];
        m_LblATRValue.Text(TRANSLATION_LABEL_ATR_VALUE + " = " + DoubleToString(atr, _Digits));
    }
    //=== Commission, risk, position size
    /* Commission size*/ m_EdtCommissionSize.Text(DoubleToString(sets.CommissionPerLot, CommissionDecimals));
    /* Risk In        */ if (!m_EdtRiskPIn.Text(FormatDouble(DoubleToString(DisplayRisk, 2))))                                 return false;
    /* Risk currency  */ if (StringLen(AccountCurrency) > 0) if (!m_LblRiskM.Text(TRANSLATION_LABEL_RISK + ", " + AccountCurrency + ":"))       return false;
    /* Risk Money In  */ if (!m_EdtRiskMIn.Text(FormatDouble(DoubleToString(RiskMoney, AccountCurrencyDigits), AccountCurrencyDigits)))                                return false;
    /* Risk Money Out */ if (!m_EdtRiskMRes.Text(FormatDouble(DoubleToString(OutputRiskMoney), AccountCurrencyDigits)))                                return false;
    if (OutputRiskMoney != 0)
    {
        if (AccSize != 0)
        {
        /* Risk Out       */ if (!m_EdtRiskPRes.Text(FormatDouble(DoubleToString(Round(OutputRiskMoney / AccSize * 100, AccountCurrencyDigits), AccountCurrencyDigits)))) return false;
        }
        else if (!m_EdtRiskPRes.Text("100")) return false;
    }
    else if (!m_EdtRiskPRes.Text("0")) return false;
    /* Reward currency*/ if (StringLen(AccountCurrency) > 0) if (!m_LblReward.Text(TRANSLATION_LABEL_REWARD + ", " + AccountCurrency + ":"))    return false;
    /* Reward 1       */ if (!m_EdtReward1.Text(FormatDouble(InputReward, AccountCurrencyDigits)))                                                return false;
    /* Reward 2       */ if (!m_EdtReward2.Text(FormatDouble(DoubleToString(OutputReward, AccountCurrencyDigits), AccountCurrencyDigits)))                            return false;
    /* Risk/Reward 1  */ if (!m_EdtRR1.Text(InputRR))                                                                      return false;
    if (InputRR == TRANSLATION_LABEL_WARNING_INVALID_TP) m_EdtRR1.Color(clrRed);
    else m_EdtRR1.Color(m_EdtTP.Color());
    if (StringToDouble(m_EdtTP.Text()) != 0)
    {
        if (InputRR == "") m_EdtRR1.Hide();
        else if (m_EdtRR2.IsVisible()) m_EdtRR1.Show();
    }
    /* Risk/Reward 2  */ if (!m_EdtRR2.Text(OutputRR))                                                                         return false;
    if (OutputRR == TRANSLATION_LABEL_WARNING_INVALID_TP) m_EdtRR2.Color(clrRed);
    else m_EdtRR2.Color(m_EdtTP.Color());
    /* Position size  */ if (!m_EdtPosSize.Text(FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits)))                         return false;
    if (OutputPositionSize > OutputMaxPositionSize)
    {
        m_EdtPosSize.Color(clrRed); // Calculated position size is greater than maximum position size by margin.
        ObjectSetString(ChartID(), m_name + "m_EdtPosSize", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_WARNING_PS);
    }
    else
    {
        m_EdtPosSize.Color(m_EdtTP.Color());
        ObjectSetString(ChartID(), m_name + "m_EdtPosSize", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_MAX_PS_BY_MARGIN);
    }
    /* Point value      */ if (ShowPointValue)
    {
        if (StringLen(AccountCurrency) > 0) if (!m_LblPointValue.Text(TRANSLATION_LABEL_POINT_VALUE + ", " + AccountCurrency + ":")) return false;
        if (!m_EdtPointValue.Text(OutputPointValue))                                                        return false;
    }

    //=== Show/hide risk
    /* Money label    */ if (AccountCurrency != "")
    {
        if (!m_LblCurrentRiskMoney.Text(TRANSLATION_LABEL_RISK + " " + AccountCurrency))                             return false;
        if (!m_LblCurrentProfitMoney.Text(TRANSLATION_LABEL_REWARD + " " + AccountCurrency))                        return false;
        if (!m_LblPotentialRiskMoney.Text(TRANSLATION_LABEL_RISK + " " + AccountCurrency))                          return false;
        if (!m_LblPotentialProfitMoney.Text(TRANSLATION_LABEL_REWARD + " " + AccountCurrency))                      return false;
    }
    /* Current Portfolio Risk $     */ if (!m_EdtCurRiskM.Text(PLM))                                                       return false;
    /* Current Portfolio Risk %     */ if (!m_EdtCurRiskP.Text(CPR))                                                       return false;
    /* Current Portfolio Lots       */ if (!m_EdtCurL.Text(CPL))                                                           return false;
    /* Current Portfolio Profit $   */ if (!m_EdtCurProfitM.Text(PRM))                                                     return false;
    /* Current Portfolio Profit %   */ if (!m_EdtCurProfitP.Text(CPRew))                                                   return false;
    /* Current Portfolio RRR        */ if (!m_EdtCurrentRRR.Text(CPRRR))                                                   return false;
    /* Potential Portfolio Risk $   */ if (!m_EdtPotRiskM.Text(PPMR))                                                      return false;
    /* Potential Portfolio Risk %   */ if (!m_EdtPotRiskP.Text(PPR))                                                       return false;
    /* Potential Portfolio Profit $ */ if (!m_EdtPotProfitM.Text(PPMRew))                                                  return false;
    /* Potential Portfolio Profit % */ if (!m_EdtPotProfitP.Text(PPRew))                                                   return false;
    /* Potential Portfolio Lots     */ if (!m_EdtPotL.Text(PPL))                                                           return false;
    /* Potential Portfolio RRR      */ if (!m_EdtPotentialRRR.Text(PPRRR))                                                 return false;

    //=== Show/hide margin
    /* Position Margin         */ if (!m_EdtPosMargin.Text(FormatDouble(DoubleToString(PositionMargin, AccountCurrencyDigits), AccountCurrencyDigits)))            return false;
    if (MarginInUnconvertedMarginCurrency)
    {
        m_LblPosMargin.Text(TRANSLATION_LABEL_POSITION_MARGIN + ", " + MarginCurrency + ":");
        m_EdtUsedMargin.Text("???");
        m_EdtFreeMargin.Text("???");
        SymbolLeverage = 0;
    }
    else
    {
        /* Future Used Margin      */ if (!m_EdtUsedMargin.Text(FormatDouble(DoubleToString(UsedMargin, AccountCurrencyDigits), AccountCurrencyDigits)))               return false;
        /* Future Free Margin      */ if (!m_EdtFreeMargin.Text(FormatDouble(DoubleToString(FutureMargin, AccountCurrencyDigits), AccountCurrencyDigits)))                 return false;
    }
    /* Custom Leverage             */ if (!m_EdtCustomLeverage.Text(DoubleToString(sets.CustomLeverage, CustomLeverageDecimals)))                     return false;
    string acc_lev = IntegerToString(AccountInfoInteger(ACCOUNT_LEVERAGE));
    /* Account Leverage   */ if (StringLen(acc_lev) > 0) if (!m_LblAccLeverage.Text("(" + TRANSLATION_LABEL_DEFAULT + " = 1:" + acc_lev + ")"))                      return false;
    /* Symbol Leverage    */ if (SymbolLeverage) if (!m_LblSymbolLeverage.Text("(" + TRANSLATION_LABEL_SYMBOL + " = 1:" + DoubleToString(SymbolLeverage, SymbolLeverageDecimals) + ")")) return false;
    /* Max Position size  */ if (!m_EdtMaxPositionSizeByMargin.Text(FormatDouble(DoubleToString(OutputMaxPositionSize, LotStep_digits), LotStep_digits)))          return false;
    if (!StopOut) // Black
    {
        m_LblFreeMargin.Color(C'40,41,59');
        m_EdtFreeMargin.Color(C'40,41,59');

    }
    else // Red
    {
        m_LblFreeMargin.Color(clrRed);
        m_EdtFreeMargin.Color(clrRed);
    }

    //=== Swaps
    /* Swaps Type                  */ if (!m_EdtSwapsType.Text(OutputSwapsType))                                                           return false;
    /* Swaps Triple Day            */ if (!m_EdtSwapsTripleDay.Text(SwapsTripleDay))                                                       return false;
    double swap_long = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_LONG);
    int swap_long_decimal_places = CountDecimalPlaces(swap_long);
    double swap_short = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_SHORT);
    int swap_short_decimal_places = CountDecimalPlaces(swap_short);
    /* Swaps Nominal Long            */ if (!m_EdtSwapsNominalLong.Text(DoubleToString(swap_long, swap_long_decimal_places)))    return false;
    /* Swaps Nominal Short           */ if (!m_EdtSwapsNominalShort.Text(DoubleToString(swap_short, swap_short_decimal_places))) return false;
    /* Swaps Daily Long Lot          */ if (!m_EdtSwapsDailyLongLot.Text(OutputSwapsDailyLongLot))                                         return false;
    /* Swaps Daily Short Lot         */ if (!m_EdtSwapsDailyShortLot.Text(OutputSwapsDailyShortLot))                                       return false;
    /* Swaps Label Daily per Lot     */ if (!m_LblSwapsPerLotDaily.Text(OutputSwapsCurrencyDailyLot))                              return false;
    /* Swaps Daily Long PS           */ if (!m_EdtSwapsDailyLongPS.Text(OutputSwapsDailyLongPS))                                           return false;
    /* Swaps Daily Short PS          */ if (!m_EdtSwapsDailyShortPS.Text(OutputSwapsDailyShortPS))                                         return false;
    /* Swaps Label Daily per PS  */ if (!m_LblSwapsPerPSDaily.Text(OutputSwapsCurrencyDailyPS))                            return false;
    /* Swaps Yearly Long Lot         */ if (!m_EdtSwapsYearlyLongLot.Text(OutputSwapsYearlyLongLot))                                       return false;
    /* Swaps Yearly Short Lot        */ if (!m_EdtSwapsYearlyShortLot.Text(OutputSwapsYearlyShortLot))                                 return false;
    /* Swaps Label Yearly per Lot */ if (!m_LblSwapsPerLotYearly.Text(OutputSwapsCurrencyYearlyLot))                          return false;
    /* Swaps Yearly Long PS          */ if (!m_EdtSwapsYearlyLongPS.Text(OutputSwapsYearlyLongPS))                                         return false;
    /* Swaps Yearly Short PS         */ if (!m_EdtSwapsYearlyShortPS.Text(OutputSwapsYearlyShortPS))                                       return false;
    /* Swaps Label Yearly per PS     */ if (!m_LblSwapsPerPSYearly.Text(OutputSwapsCurrencyYearlyPS))                             return false;

    //=== Trading
    /* Multiple TP levels         */
    if (sets.TakeProfitsNumber > 1)
    {
        sets.TP[0] = sets.TakeProfitLevel; // Always the main TP.
        TradingTPEdits[0].Text(DoubleToString(sets.TP[0], _Digits));
        if (AdditionalTPLineMoved)
        {
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                if (!TradingTPEdits[i].Text(DoubleToString(sets.TP[i], _Digits)))               return false;
            }
            AdditionalTPLineMoved = false;
        }
    }

    return true;
}

void CPositionSizeCalculator::Minimize()
{
    CAppDialog::Minimize();
    sets.IsPanelMinimized = true;
    if (remember_left != -1)
    {
        Move(remember_left, remember_top);
        m_min_rect.Move(remember_left, remember_top);
    }
    IniFileSave();
}

void CPositionSizeCalculator::Maximize()
{
    if (!NoPanelMaximization)
    {
        sets.IsPanelMinimized = false;
        CAppDialog::Maximize();
    }
    else if (m_minimized) CAppDialog::Minimize();

    HideRisk();
    HideMargin();
    HideMain();
    HideSwaps();
    HideTrading();

    if (!m_minimized)
    {
        if (sets.SelectedTab == MainTab) ShowMain();
        else if (sets.SelectedTab == RiskTab) ShowRisk();
        else if (sets.SelectedTab == MarginTab) ShowMargin();
        else if (sets.SelectedTab == SwapsTab) ShowSwaps();
        else if (sets.SelectedTab == TradingTab) ShowTrading();
    }

    MoveAndResize();
    if (remember_left != -1) Move(remember_left, remember_top);
}

void CPositionSizeCalculator::SetTPButtonBackGroundColor(color bg_color)
{
    m_BtnTakeProfit.ColorBackground(bg_color);
}

void CPositionSizeCalculator::CalculateSettingsBasedOnLines()
{
    if ((ShowATROptions) && ((sets.ATRMultiplierSL > 0) || (sets.ATRMultiplierTP > 0)))
    {
        double buf[1] = {0};
        if (ATR_handle != INVALID_HANDLE) CopyBuffer(ATR_handle, 0, (int)ATRCandle, 1, buf);
        double atr = buf[0];
        if (atr != 0) // if atr == 0, the indicator data hasn't loaded yet.
        {
            if (sets.ATRMultiplierSL > 0)
            {
                double sl = atr * sets.ATRMultiplierSL;
                if (sets.TradeDirection == Long)
                {
                    sets.StopLossLevel = sets.EntryLevel - sl;
                    if (sets.SpreadAdjustmentSL) sets.StopLossLevel -= (SymbolInfoDouble(Symbol(), SYMBOL_ASK) - SymbolInfoDouble(Symbol(), SYMBOL_BID)); // Adjust for spread to preserve probabilities.
                }
                else
                {
                    sets.StopLossLevel = sets.EntryLevel + sl;
                    if (sets.SpreadAdjustmentSL) sets.StopLossLevel += (SymbolInfoDouble(Symbol(), SYMBOL_ASK) - SymbolInfoDouble(Symbol(), SYMBOL_BID)); // Adjust for spread to preserve probabilities.
                }
                sets.StopLoss = (int)MathRound(MathAbs(sets.StopLossLevel - sets.EntryLevel) / _Point);
            }
            if (sets.ATRMultiplierTP > 0)
            {
                double tp = atr * sets.ATRMultiplierTP;
                // If no ATR SL multiplier is given, TradeType should be determined by Entry-SL difference.
                if (sets.StopLossLevel < sets.EntryLevel)
                {
                    sets.TakeProfitLevel = sets.EntryLevel + tp;
                    if (sets.SpreadAdjustmentTP) sets.TakeProfitLevel -= (SymbolInfoDouble(Symbol(), SYMBOL_ASK) - SymbolInfoDouble(Symbol(), SYMBOL_BID)); // Adjust for spread to preserve probabilities.
                }
                else
                {
                    sets.TakeProfitLevel = sets.EntryLevel - tp;
                    if (sets.SpreadAdjustmentTP) sets.TakeProfitLevel += (SymbolInfoDouble(Symbol(), SYMBOL_ASK) - SymbolInfoDouble(Symbol(), SYMBOL_BID)); // Adjust for spread to preserve probabilities.
                }
                sets.TakeProfit = (int)MathRound(MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / _Point);
            }
        }
    }

    double read_value;
    if ((sets.ATRMultiplierSL == 0) || (!ShowATROptions))
    {
        if (ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0, read_value)) sets.StopLossLevel = NormalizeDouble(read_value, _Digits); // Rewrite value only if line exists.
    }
    if ((sets.ATRMultiplierTP == 0) || (!ShowATROptions))
    {
        if (ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0, read_value)) sets.TakeProfitLevel = NormalizeDouble(read_value, _Digits); // Rewrite value only if line exists.
    }
    for (int i = 1; i < sets.TakeProfitsNumber; i++)
    {
        if (ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, 0, read_value)) sets.TP[i] = NormalizeDouble(read_value, _Digits); // Rewrite value only if line exists.
    }

    // Check and adjust for TickSize granularity.
    if (TickSize > 0)
    {
        sets.StopLossLevel = NormalizeDouble(MathRound(sets.StopLossLevel / TickSize) * TickSize, _Digits);
        if ((!StopLossLineIsBeingMoved) || (sets.ATRMultiplierSL == 0) || (!ShowATROptions)) ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
        sets.TakeProfitLevel = NormalizeDouble(MathRound(sets.TakeProfitLevel / TickSize) * TickSize, _Digits);
        if ((!TakeProfitLineIsBeingMoved[0]) || (sets.ATRMultiplierTP == 0) || (!ShowATROptions)) ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
        if (sets.TakeProfitsNumber > 1)
        {
            for (int i = 0; i < sets.TakeProfitsNumber; i++)
            {
                sets.TP[i] = NormalizeDouble(MathRound(sets.TP[i] / TickSize) * TickSize, _Digits);
            }
        }
    }

    if (sets.EntryType == Instant)
    {
        double read_tStopLossLevel;
        if (!ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0, read_tStopLossLevel)) return; // Line was deleted, waiting for automatic restoration.
        tStopLossLevel = Round(read_tStopLossLevel, _Digits);
        if ((SymbolInfoDouble(_Symbol, SYMBOL_ASK) > 0) && (SymbolInfoDouble(_Symbol, SYMBOL_BID) > 0))
        {
            // Long entry
            if (tStopLossLevel < SymbolInfoDouble(_Symbol, SYMBOL_BID)) tEntryLevel = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            // Short entry
            else if (tStopLossLevel > SymbolInfoDouble(_Symbol, SYMBOL_ASK)) tEntryLevel = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            // Undefined entry
            else
            {
                // Move tEntryLevel to the nearest line.
                if ((tEntryLevel - SymbolInfoDouble(_Symbol, SYMBOL_BID)) < (tEntryLevel - SymbolInfoDouble(_Symbol, SYMBOL_ASK))) tEntryLevel = SymbolInfoDouble(_Symbol, SYMBOL_BID);
                else tEntryLevel = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            }
            ObjectSetDouble(0, ObjectPrefix + "EntryLine", OBJPROP_PRICE, tEntryLevel);
            sets.EntryLevel = tEntryLevel;
        }
    }
    else // Pending or Stop Limit.
    {
        if (ObjectGetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, 0, read_value)) sets.EntryLevel = read_value; // Rewrite value only if line exists.
        if ((sets.EntryLevel == StopLimit) && (ObjectGetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, 0, read_value))) sets.StopPriceLevel = read_value;
        // Check and adjust for TickSize granularity.
        if (TickSize > 0)
        {
            sets.EntryLevel = NormalizeDouble(MathRound(sets.EntryLevel / TickSize) * TickSize, _Digits);
            ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
            if (sets.EntryLevel == StopLimit)
            {
                sets.StopPriceLevel = NormalizeDouble(MathRound(sets.StopPriceLevel / TickSize) * TickSize, _Digits);
                ObjectSetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, sets.StopPriceLevel);
            }
        }
    }

    // Set line based on the entered SL distance.
    if (sets.SLDistanceInPoints)
    {
        if (sets.TradeDirection == Long) sets.StopLossLevel = sets.EntryLevel - sets.StopLoss * _Point;
        else sets.StopLossLevel = sets.EntryLevel + sets.StopLoss * _Point;
        if (!StopLossLineIsBeingMoved) ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
    }

    // Set lines based on the entered TP distance.
    if (sets.TPDistanceInPoints)
    {
        if (sets.TakeProfit > 0)
        {
            if (sets.TradeDirection == Long) sets.TakeProfitLevel = sets.EntryLevel + sets.TakeProfit * _Point;
            else sets.TakeProfitLevel = sets.EntryLevel - sets.TakeProfit * _Point;
            if (!TakeProfitLineIsBeingMoved[0]) ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
        }
        // Additional take-profits.
        if (sets.TakeProfitsNumber > 1)
        {
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                if (sets.TP[i] != 0) // With zero points TP, keep the TP lines at zero level - as with the main TP level.
                {

                    if (sets.TradeDirection == Long) sets.TP[i] = NormalizeDouble(sets.EntryLevel + StringToDouble(AdditionalTPEdits[i - 1].Text()) * _Point, _Digits);
                    else sets.TP[i] = NormalizeDouble(sets.EntryLevel - StringToDouble(AdditionalTPEdits[i - 1].Text()) * _Point, _Digits);
                }
                if (!TakeProfitLineIsBeingMoved[i]) ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.TP[i]);
            }
        }
    }

    sets.CustomLeverage = StringToDouble(m_EdtCustomLeverage.Text());

    if (sets.EntryLevel < sets.StopLossLevel) sets.TradeDirection = Short;
    else if (sets.EntryLevel > sets.StopLossLevel) sets.TradeDirection = Long;

    if (sets.TPLockedOnSL)
    {
        tEntryLevel = sets.EntryLevel;
        tStopLossLevel = sets.StopLossLevel;
        if (sets.TakeProfitLevel == 0) ProcessTPChange(true); // When TPLockedOnSL has been enabled via an input parameter.
        else ProcessTPChange(false);
    }

    if (sets.TradeDirection == Short) PanelCaption = "\x25BC " + PanelCaptionBase;
    else PanelCaption = "\x25B2 " + PanelCaptionBase;
}

void CPositionSizeCalculator::RefreshValues()
{
    if (sets.StopLossLevel < 0) Initialization(); // Helps with 'Waiting for data'. MT5 only solution. MT4 handles this differently.

    CalculateSettingsBasedOnLines();
    RecalculatePositionSize();

    DisplayValues();

    if ((sets.SelectedTab == MainTab) && (((!m_LblStopPrice.IsVisible()) && (sets.EntryType == StopLimit)) || ((m_LblStopPrice.IsVisible()) && (sets.EntryType != StopLimit))) && (Height() > 26))
    {
        if ((!m_LblStopPrice.IsVisible()) && (sets.EntryType == StopLimit)) // Switched to Stop-Limit order type.
        {
            // Show StopPrice-related panel elements.
            m_LblStopPrice.Show();
            m_EdtStopPrice.Show();
            m_LblStopPriceWarning.Show();
            // To put the panel on top of the stop price line.
            HideShowMaximize();
        }
        else if ((m_LblStopPrice.IsVisible()) && (sets.EntryType != StopLimit)) // Switched from Stop-Limit order type.
        {
            // Hide StopPrice-related panel elements.
            m_LblStopPrice.Hide();
            m_EdtStopPrice.Hide();
            m_LblStopPriceWarning.Hide();
        }
        MoveAndResize();
    }

    DoBreakEven();

    LastRecalculationTime = GetTickCount();
}

void CPositionSizeCalculator::HideMain()
{
    m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    for (CStringForList * obj = MainTabList.GetFirstNode(); obj != NULL; obj = MainTabList.GetNextNode())
    {
        obj.Obj.Hide();
    }
}

void CPositionSizeCalculator::ShowMain()
{
    m_BtnTabMain.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    m_LblEntryLevel.Show();
    m_BtnEntry.Show();
    m_EdtEntryLevel.Show();
    if (sets.EntryType != Instant)
    {
        m_BtnEntryIncrease.Show();
        m_BtnEntryDecrease.Show();
    }
    m_LblEntryWarning.Show();
    if (DefaultSL > 0) m_BtnStopLoss.Show();
    else m_LblSL.Show();
    m_EdtSL.Show();
    if (!ShowATROptions)
    {
        m_BtnStopLossIncrease.Show();
        m_BtnStopLossDecrease.Show();
    }
    m_LblSLWarning.Show();
    m_BtnTakeProfitsNumberAdd.Show();
    m_BtnTakeProfit.Show();
    m_EdtTP.Show();
    if (!ShowATROptions)
    {
        m_BtnTakeProfitIncrease.Show();
        m_BtnTakeProfitDecrease.Show();
    }
    if (sets.TakeProfitsNumber > 1) m_BtnTakeProfitsNumberRemove.Show();
    m_LblTPWarning.Show();
    if (sets.EntryType == StopLimit)
    {
        m_LblStopPrice.Show();
        m_EdtStopPrice.Show();
        m_BtnStopPriceIncrease.Show();
        m_BtnStopPriceDecrease.Show();
        m_LblStopPriceWarning.Show();
    }
    if (sets.TakeProfitsNumber > 1)
    {
        for (int i = 0; i < sets.TakeProfitsNumber - 1; i++)
        {
            AdditionalTPEdits[i].Show();
            AdditionalTPLabels[i].Show();
            AdditionalTPButtonsIncrease[i].Show();
            AdditionalTPButtonsDecrease[i].Show();
            AdditionalTPWarnings[i].Show();
        }
    }
    if (ShowATROptions)
    {
        m_LblATRPeriod.Show();
        m_LblATRMultiplierSL.Show();
        m_LblATRMultiplierTP.Show();
        m_EdtATRPeriod.Show();
        m_EdtATRMultiplierSL.Show();
        m_EdtATRMultiplierTP.Show();
        m_LblATRValue.Show();
        m_LblATRTimeframe.Show();
        m_BtnATRTimeframe.Show();
        m_ChkSpreadAdjustmentSL.Show();
        m_ChkSpreadAdjustmentTP.Show();
    }
    m_LblOrderType.Show();
    m_BtnOrderType.Show();
    m_BtnLines.Show();
    m_LblCommissionSize.Show();
    m_BtnCommissionType.Show();
    m_EdtCommissionSize.Show();
    if (!HideAccSize)
    {
        m_BtnAccount.Show();
        m_EdtAccount.Show();
        if ((AdditionalFunds >= 0.01) || (AdditionalFunds <= -0.01) || ((sets.CustomBalance > 0) && (sets.AccountButton != Equity))) m_LblAdditionalFundsAsterisk.Show();
    }
    m_LblInput.Show();
    m_LblResult.Show();
    m_LblRisk.Show();
    if (QuickRisk1 > 0) m_BtnQuickRisk1.Show();
    if (QuickRisk2 > 0) m_BtnQuickRisk2.Show();
    m_EdtRiskPIn.Show();
    m_EdtRiskPRes.Show();
    m_LblRiskM.Show();
    m_EdtRiskMIn.Show();
    m_EdtRiskMRes.Show();
    if (sets.TakeProfitLevel != 0)
    {
        ShowTPRelatedEdits();
    }
    m_LblPosSize.Show();
    if (ShowMaxPSButton) m_BtnMaxPS.Show();
    m_EdtPosSize.Show();
    if (ShowPointValue)
    {
        m_LblPointValue.Show();
        m_EdtPointValue.Show();
    }
    m_LblURL.Show();
}

void CPositionSizeCalculator::HideRisk()
{
    m_BtnTabRisk.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    for (CStringForList * obj = RiskTabList.GetFirstNode(); obj != NULL; obj = RiskTabList.GetNextNode())
    {
        obj.Obj.Hide();
    }
}

void CPositionSizeCalculator::ShowRisk()
{
    m_BtnTabRisk.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    for (CStringForList * obj = RiskTabList.GetFirstNode(); obj != NULL; obj = RiskTabList.GetNextNode())
    {
        obj.Obj.Show();
    }
    m_LblURL.Show();
}

void CPositionSizeCalculator::HideMargin()
{
    m_BtnTabMargin.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    for (CStringForList * obj = MarginTabList.GetFirstNode(); obj != NULL; obj = MarginTabList.GetNextNode())
    {
        obj.Obj.Hide();
    }
}

void CPositionSizeCalculator::ShowMargin()
{
    m_BtnTabMargin.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    for (CStringForList * obj = MarginTabList.GetFirstNode(); obj != NULL; obj = MarginTabList.GetNextNode())
    {
        obj.Obj.Show();
    }
    m_LblURL.Show();
}

void CPositionSizeCalculator::HideSwaps()
{
    m_BtnTabSwaps.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    for (CStringForList * obj = SwapsTabList.GetFirstNode(); obj != NULL; obj = SwapsTabList.GetNextNode())
    {
        obj.Obj.Hide();
    }
}

void CPositionSizeCalculator::ShowSwaps()
{
    m_BtnTabSwaps.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    for (CStringForList * obj = SwapsTabList.GetFirstNode(); obj != NULL; obj = SwapsTabList.GetNextNode())
    {
        obj.Obj.Show();
    }
    m_LblURL.Show();
}

void CPositionSizeCalculator::HideTrading()
{
    m_BtnTabTrading.ColorBackground(CONTROLS_BUTTON_COLOR_DISABLE);
    for (CStringForList * obj = TradingTabList.GetFirstNode(); obj != NULL; obj = TradingTabList.GetNextNode())
    {
        obj.Obj.Hide();
    }
}

void CPositionSizeCalculator::ShowTrading()
{
    m_BtnTabTrading.ColorBackground(CONTROLS_BUTTON_COLOR_ENABLE);
    for (CStringForList * obj = TradingTabList.GetFirstNode(); obj != NULL; obj = TradingTabList.GetNextNode())
    {
        if (!obj.Hidden) obj.Obj.Show();
    }
    m_LblURL.Show();
}

void CPositionSizeCalculator::ProcessTPChange(const bool tp_button_click)
{
    double tp_distance = 0;
    if ((UseCommissionToSetTPDistance) && (sets.CommissionPerLot != 0))
    {
        // Calculate real commission first.
        double commission = CalculateCommission();

        // Calculate potential loss as SL + Commission * 2.
        // Calculate potential profit as TP - Commission * 2.
        // TP Distance = Profit / Point_value.
        // Profit = Risk * N + Commission * 2.
        // TP distance =  (Risk * N + Commission * 2) / Point_value.
        if ((UnitCost_reward != 0) && (OutputPositionSize != 0) && (TickSize != 0))
            tp_distance = (RiskMoney * TP_Multiplier + OutputPositionSize * commission * 2) / (OutputPositionSize * UnitCost_reward / TickSize);
        if (tEntryLevel < tStopLossLevel) tp_distance = -tp_distance;
    }
    else tp_distance = (tEntryLevel - tStopLossLevel) * TP_Multiplier;

    sets.TakeProfitLevel = NormalizeDouble(tEntryLevel + tp_distance, _Digits);

    if (tTakeProfitLevel != sets.TakeProfitLevel)
    {
        if ((PrefillAdditionalTPsBasedOnMain) && (sets.TakeProfitsNumber > 1))
        {
            if ((tTakeProfitLevel == 0) && (sets.TakeProfitLevel != 0)) // Was zero, became non-zero.
            {
                for (int i = 0; i < sets.TakeProfitsNumber; i++)
                {
                    if (i == 0) sets.TP[i] = sets.TakeProfitLevel;
                    else
                    {
                        TradingTPEdits[i].Text(DoubleToString(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * double(sets.TakeProfitsNumber - i) / double(sets.TakeProfitsNumber)));
                        UpdateTradingTPEdit(i);
                    }
                }
            }
        }
        tTakeProfitLevel = sets.TakeProfitLevel;
        if (sets.ATRMultiplierSL > 0)
        {
            sets.ATRMultiplierTP = NormalizeDouble(sets.ATRMultiplierSL * TP_Multiplier, 2);
            m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
        }
        if (!sets.TPDistanceInPoints) m_EdtTP.Text(DoubleToString(tTakeProfitLevel, _Digits));
        else
        {
            sets.TakeProfit = (int)MathRound(MathAbs(tTakeProfitLevel - tEntryLevel) / _Point);
            m_EdtTP.Text(IntegerToString(sets.TakeProfit));
        }
        DummyObjectSelect();
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine") == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_HIDDEN, false);
            ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TOOLTIP, "Take-Profit");

            // Create multiple TP lines.
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJ_HLINE, 0, TimeCurrent(), sets.TP[i]);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_STYLE, takeprofit_line_style);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_COLOR, takeprofit_line_color);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_WIDTH, takeprofit_line_width);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_HIDDEN, false);
                ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TOOLTIP, "Take-Profit #" + IntegerToString(i + 1));
            }
        }
        else
        {
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            // Move multiple TP lines.
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.TP[i]);
            }
        }
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTABLE, true);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
        }

        if (StringToDouble(m_EdtTP.Text()) == 0) // Hide.
        {
            m_LblRR.Hide();
            m_EdtRR1.Hide();
            m_EdtRR2.Hide();
            m_LblReward.Hide();
            m_EdtReward1.Hide();
            m_EdtReward2.Hide();
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            }
            MoveAndResize();
        }
        else // Show.
        {
            if (!m_minimized)
            {
                if (sets.SelectedTab == MainTab)
                {
                    ShowTPRelatedEdits();
                }
            }
            if (sets.ShowLines)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_BACK, false);
                if (ShowLineLabels)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                if (ShowAdditionalTPLabel)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                for (int i = 1; i < sets.TakeProfitsNumber; i++)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_BACK, false);
                    if (ShowLineLabels)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                    if (ShowAdditionalTPLabel)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                }
            }
            // Hides and shows the panel. Needed to put it to the foreground. Maximize() hides internal controls that were hidden before.
            if (tp_button_click)
            {
                HideShowMaximize();
                MoveAndResize();
            }
        }
        // Need to call RefreshValues() only if this function is invoked from TP Button click event handler. In all other cases it is called from within RefreshValues() itself.
        if (tp_button_click)
        {
            RefreshValues();
            ChartRedraw();
        }
    }
}

//+--------------------------------------------+
//|                                            |
//|                   EVENTS                   |
//|                                            |
//+--------------------------------------------+
void CPositionSizeCalculator::OnClickBtnTabMain()
{
    if (sets.SelectedTab != MainTab)
    {
        sets.SelectedTab = MainTab;
        ShowMain();
        HideRisk();
        HideMargin();
        HideSwaps();
        HideTrading();

        MoveAndResize();
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnTabRisk()
{
    if (sets.SelectedTab != RiskTab)
    {
        sets.SelectedTab = RiskTab;
        HideMain();
        ShowRisk();
        HideMargin();
        HideSwaps();
        HideTrading();

        MoveAndResize();
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnTabMargin()
{
    if (sets.SelectedTab != MarginTab)
    {
        sets.SelectedTab = MarginTab;
        HideRisk();
        HideMain();
        ShowMargin();
        HideSwaps();
        HideTrading();

        MoveAndResize();
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnTabSwaps()
{
    if (sets.SelectedTab != SwapsTab)
    {
        sets.SelectedTab = SwapsTab;
        HideRisk();
        HideMain();
        HideMargin();
        ShowSwaps();
        HideTrading();

        MoveAndResize();
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnTabTrading()
{
    if (sets.SelectedTab != TradingTab)
    {
        sets.SelectedTab = TradingTab;
        HideRisk();
        HideMain();
        HideMargin();
        HideSwaps();
        ShowTrading();

        MoveAndResize();
    }
}

void CPositionSizeCalculator::OnClickBtnOrderType()
{
    if (sets.EntryType == Instant) sets.EntryType = Pending;
    else if (sets.EntryType == Pending)
    {
        if (!DisableStopLimit) sets.EntryType = StopLimit;
        else sets.EntryType = Instant;
    }
    else if (sets.EntryType == StopLimit) sets.EntryType = Instant;

    if (sets.EntryType == Instant)
    {
        sets.WasSelectedEntryLine = ObjectGetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED);
        sets.WasSelectedStopPriceLine = ObjectGetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, false);
        m_BtnEntryIncrease.Hide();
        m_BtnEntryDecrease.Hide();
        m_BtnStopPriceIncrease.Hide();
        m_BtnStopPriceDecrease.Hide();
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
    }
    else if (sets.EntryType == Pending)
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, true);
        if ((sets.WasSelectedEntryLine) || (DefaultLinesSelected)) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
        if ((sets.SelectedTab == MainTab) && (!m_minimized))
        {
            m_BtnEntryIncrease.Show();
            m_BtnEntryDecrease.Show();
        }
        m_BtnStopPriceIncrease.Hide();
        m_BtnStopPriceDecrease.Hide();
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        if ((sets.ShowLines) && (ShowLineLabels)) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
    }
    else if (sets.EntryType == StopLimit)
    {
        DummyObjectSelect();
        if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTABLE, true);
        if ((sets.WasSelectedStopPriceLine) || (DefaultLinesSelected)) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED, true);
        if (sets.StopPriceLevel == 0)
        {
            if (sets.EntryLevel > sets.StopLossLevel)
            {
                sets.StopPriceLevel = sets.EntryLevel + iHigh(Symbol(), Period(), 0) - iLow(Symbol(), Period(), 0);
                if (sets.StopPriceLevel == sets.EntryLevel) sets.StopPriceLevel += _Point;
            }
            else
            {
                sets.StopPriceLevel = sets.EntryLevel - (iHigh(Symbol(), Period(), 0) - iLow(Symbol(), Period(), 0));
                if (sets.StopPriceLevel == sets.EntryLevel) sets.StopPriceLevel -= _Point;
            }
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, sets.StopPriceLevel);
        }
        if ((sets.SelectedTab == MainTab) && (!m_minimized))
        {
            m_BtnEntryIncrease.Show();
            m_BtnEntryDecrease.Show();
            m_BtnStopPriceIncrease.Show();
            m_BtnStopPriceDecrease.Show();
        }
        if ((sets.ShowLines) && (ShowLineLabels)) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
    }
    RefreshValues();
}

void CPositionSizeCalculator::OnClickBtnAccount()
{
    switch(sets.AccountButton)
    {
    case Balance:
        // Switch to Equity.
        sets.AccountButton = Equity;
        m_BtnAccount.Text(TRANSLATION_BUTTON_ACCOUNT_EQUITY);
        // Account balance uneditable.
        m_EdtAccount.ReadOnly(true);
        m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
        break;
    case Equity:
        // Switch to Balance minus Risk.
        sets.AccountButton = Balance_minus_Risk;
        m_BtnAccount.Text(TRANSLATION_BUTTON_BALANCE_MINUS_CPR);
        // Account balance uneditable.
        m_EdtAccount.ReadOnly(true);
        m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_DISABLE);
        break;
    default:
    case Balance_minus_Risk:
        // Switch to Balance.
        sets.AccountButton = Balance;
        m_BtnAccount.Text(TRANSLATION_BUTTON_ACCOUNT_BALANCE);
        // Account balance editable.
        m_EdtAccount.ReadOnly(false);
        m_EdtAccount.ColorBackground(CONTROLS_EDIT_COLOR_ENABLE);
        break;
    }
    RefreshValues();
}

void CPositionSizeCalculator::OnClickBtnLines()
{
    sets.ShowLines = !sets.ShowLines;
    if (sets.ShowLines)
    {
        m_BtnLines.Text(TRANSLATION_BUTTON_HIDE_LINES);
    }
    else
    {
        m_BtnLines.Text(TRANSLATION_BUTTON_SHOW_LINES);
    }
    if (sets.ShowLines)
    {
        DummyObjectSelect();
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        if (sets.EntryType == StopLimit) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        }

        if (ShowLineLabels)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_BACK, DrawTextAsBackground);
            if (ShowAdditionalSLLabel)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
            }
            if (sets.EntryType != Instant)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_BACK, DrawTextAsBackground);
            }
            if (ShowAdditionalEntryLabel)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
            }
            if (StringToDouble(m_EdtTP.Text()) != 0)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
                if (ShowAdditionalTPLabel)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                for (int i = 1; i < sets.TakeProfitsNumber; i++)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    if (ShowAdditionalTPLabel)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                }
            }
            if (sets.EntryType == StopLimit)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_BACK, DrawTextAsBackground);
            }
        }

        if ((sets.WasSelectedEntryLine) && (sets.EntryType != Instant)) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
        if (sets.WasSelectedStopLossLine) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true);
        if (sets.WasSelectedTakeProfitLine) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
        if (sets.WasSelectedStopPriceLine) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED, true);
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            if (sets.WasSelectedAdditionalTakeProfitLine[i - 1]) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
        }
        HideShowMaximize();
    }
    else
    {
        sets.WasSelectedEntryLine = ObjectGetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED);
        sets.WasSelectedStopLossLine = ObjectGetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED);
        sets.WasSelectedTakeProfitLine = ObjectGetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED);
        sets.WasSelectedStopPriceLine = ObjectGetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED);
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            sets.WasSelectedAdditionalTakeProfitLine[i - 1] = ObjectGetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED);
        }

        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }

        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
    }
}

void CPositionSizeCalculator::OnClickBtnStopLoss()
{
    if (sets.ATRMultiplierSL > 0) return;

    double sl_distance = DefaultSL * _Point;
    if (sets.TradeDirection == Long) sl_distance = -sl_distance;
    sets.StopLossLevel = NormalizeDouble(tEntryLevel + sl_distance, _Digits);

    if (tStopLossLevel != sets.StopLossLevel)
    {
        tStopLossLevel = sets.StopLossLevel;
        if (!sets.SLDistanceInPoints) m_EdtSL.Text(DoubleToString(tStopLossLevel, _Digits));
        else
        {
            sets.StopLoss = (int)MathRound(MathAbs(tStopLossLevel - tEntryLevel) / _Point);
            m_EdtSL.Text(IntegerToString(sets.StopLoss));
        }
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
    }
}

void CPositionSizeCalculator::OnClickBtnTakeProfit()
{
    // If "TP locked on SL" mode was on, turn it off.
    if (sets.TPLockedOnSL)
    {
        m_BtnTakeProfit.ColorBackground(CONTROLS_BUTTON_COLOR_TP_UNLOCKED);
        sets.TPLockedOnSL = false;
        return;
    }
    // If already have some take-profit, switch to a locked mode - TP always follows SL when Entry-SL difference changes.
    else if (sets.TakeProfitLevel != 0)
    {
        sets.TPLockedOnSL = true;
        m_BtnTakeProfit.ColorBackground(CONTROLS_BUTTON_COLOR_TP_LOCKED);
    }

    ProcessTPChange(true);
}

void CPositionSizeCalculator::OnClickBtnEntry()
{
    SwitchEntryDirection();
}

void SwitchEntryDirection()
{
    // Switch trade type.
    if (sets.TradeDirection == Long)
    {
        sets.TradeDirection = Short;

        double old_tp_distance = 0;
        if (sets.TakeProfitLevel > 0) old_tp_distance = sets.TakeProfitLevel - sets.EntryLevel;
        double old_sl_distance = sets.EntryLevel - sets.StopLossLevel;

        if (sets.EntryType == Instant) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_BID);

        if ((ShowATROptions) && (sets.ATRMultiplierSL > 0))
        {
            sets.StopLossLevel = sets.EntryLevel + sets.StopLoss * _Point;
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.EntryLevel + sets.StopLoss * _Point); // ATR stop-loss in use.
        }
        else
        {
            sets.StopLossLevel = sets.EntryLevel + old_sl_distance;
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.EntryLevel + old_sl_distance); // Other cases.
        }

        if (sets.TakeProfitLevel > 0)
        {
            if (sets.TPDistanceInPoints) sets.TakeProfitLevel = sets.EntryLevel - sets.TakeProfit * _Point;
            else sets.TakeProfitLevel = sets.EntryLevel - old_tp_distance;
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                if (sets.TP[i] == 0) continue;
                old_tp_distance = sets.TP[i] - sets.EntryLevel;
                sets.TP[i] = NormalizeDouble(sets.EntryLevel - old_tp_distance, _Digits);
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.TP[i]);
            }
        }

        if (sets.EntryType == StopLimit)
        {
            // If Stop Price line is above the current price - move it to below the current price.
            if (sets.StopPriceLevel > sets.EntryLevel)
            {
                sets.StopPriceLevel = sets.EntryLevel - (sets.StopPriceLevel - sets.EntryLevel);
                ObjectSetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, sets.StopPriceLevel);
            }
        }
    }
    else
    {
        sets.TradeDirection = Long;

        double old_tp_distance = 0;
        if (sets.TakeProfitLevel > 0) old_tp_distance = sets.EntryLevel - sets.TakeProfitLevel;
        double old_sl_distance = sets.StopLossLevel - sets.EntryLevel;

        if (sets.EntryType == Instant) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_ASK);

        if ((ShowATROptions) && (sets.ATRMultiplierSL > 0))
        {
            sets.StopLossLevel = tEntryLevel - sets.StopLoss * _Point;
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, tEntryLevel - sets.StopLoss * _Point); // ATR stop-loss in use.
        }
        else
        {
            sets.StopLossLevel = sets.EntryLevel - old_sl_distance;
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.EntryLevel - old_sl_distance); // Other cases.
        }

        if (sets.TakeProfitLevel > 0)
        {

            if (sets.TPDistanceInPoints) sets.TakeProfitLevel = sets.EntryLevel + sets.TakeProfit * _Point;
            else sets.TakeProfitLevel = sets.EntryLevel + old_tp_distance;
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                if (sets.TP[i] == 0) continue;
                old_tp_distance = sets.EntryLevel - sets.TP[i];
                sets.TP[i] = NormalizeDouble(sets.EntryLevel + old_tp_distance, _Digits);
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.TP[i]);
            }
        }

        if (sets.EntryType == StopLimit)
        {
            // If Stop Price line is below the current price - move it to above the current price.
            if (sets.StopPriceLevel < sets.EntryLevel)
            {
                sets.StopPriceLevel = sets.EntryLevel + (sets.EntryLevel - sets.StopPriceLevel);
                ObjectSetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, sets.StopPriceLevel);
            }
        }
    }

    ExtDialog.RefreshValues();
    ChartRedraw();
}

void CPositionSizeCalculator::OnClickBtnATRTimeframe()
{
    switch(sets.ATRTimeframe)
    {
    case PERIOD_CURRENT:
        sets.ATRTimeframe = PERIOD_M1;
        break;
    case PERIOD_M1:
        sets.ATRTimeframe = PERIOD_M2;
        break;
    case PERIOD_M2:
        sets.ATRTimeframe = PERIOD_M3;
        break;
    case PERIOD_M3:
        sets.ATRTimeframe = PERIOD_M4;
        break;
    case PERIOD_M4:
        sets.ATRTimeframe = PERIOD_M5;
        break;
    case PERIOD_M5:
        sets.ATRTimeframe = PERIOD_M6;
        break;
    case PERIOD_M6:
        sets.ATRTimeframe = PERIOD_M10;
        break;
    case PERIOD_M10:
        sets.ATRTimeframe = PERIOD_M12;
        break;
    case PERIOD_M12:
        sets.ATRTimeframe = PERIOD_M15;
        break;
    case PERIOD_M15:
        sets.ATRTimeframe = PERIOD_M20;
        break;
    case PERIOD_M20:
        sets.ATRTimeframe = PERIOD_M30;
        break;
    case PERIOD_M30:
        sets.ATRTimeframe = PERIOD_H1;
        break;
    case PERIOD_H1:
        sets.ATRTimeframe = PERIOD_H2;
        break;
    case PERIOD_H2:
        sets.ATRTimeframe = PERIOD_H3;
        break;
    case PERIOD_H3:
        sets.ATRTimeframe = PERIOD_H4;
        break;
    case PERIOD_H4:
        sets.ATRTimeframe = PERIOD_H6;
        break;
    case PERIOD_H6:
        sets.ATRTimeframe = PERIOD_H8;
        break;
    case PERIOD_H8:
        sets.ATRTimeframe = PERIOD_H12;
        break;
    case PERIOD_H12:
        sets.ATRTimeframe = PERIOD_D1;
        break;
    case PERIOD_D1:
        sets.ATRTimeframe = PERIOD_W1;
        break;
    case PERIOD_W1:
        sets.ATRTimeframe = PERIOD_MN1;
        break;
    case PERIOD_MN1:
        sets.ATRTimeframe = PERIOD_CURRENT;
        break;
    default:
        sets.ATRTimeframe = (ENUM_TIMEFRAMES)_Period;
        break;
    }
    if (sets.ATRTimeframe != PERIOD_CURRENT) m_BtnATRTimeframe.Text(EnumToString(sets.ATRTimeframe));
    else m_BtnATRTimeframe.Text(TRANSLATION_BUTTON_ATR_PERIOD_CURRENT);
    InitATR();
    RefreshValues();
}

void CPositionSizeCalculator::OnClickBtnCommissionType()
{
    if (sets.CommissionType == COMMISSION_CURRENCY) // Switching to percent.
    {
        sets.CommissionType = COMMISSION_PERCENT;
        CommissionDecimals = CountDecimalPlaces(sets.CommissionPerLot);
        m_BtnCommissionType.Text("%");
    }
    else // Switching to $.
    {
        sets.CommissionType = COMMISSION_CURRENCY;
        CommissionDecimals = AccountCurrencyDigits;
        m_BtnCommissionType.Text(AccountCurrency);
    }
    CalculateRiskAndPositionSize();
    DisplayValues();
}

void CPositionSizeCalculator::OnClickBtnMaxPS()
{
    OutputPositionSize = OutputMaxPositionSize;
    sets.RiskFromPositionSize = true;
    string text = m_EdtPosSize.Text();
    StringReplace(text, ",", ""); // Remove commas that might appear as the thousands separator due to number formatting.
    double field_value = StringToDouble(text);
    if (OutputPositionSize != field_value)
    {
        m_EdtPosSize.Text(FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits));
        sets.PositionSize = OutputPositionSize;
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

// Call the trade function.
void CPositionSizeCalculator::OnClickBtnTrade()
{
    Trade();
}

// Each TP is calculated to be equally spaced between main TP and Entry.
void CPositionSizeCalculator::OnClickBtnTPsInward()
{
    if (sets.TakeProfitLevel == 0) ProcessTPChange(true); // True - for RefreshValues() call.
    for (int i = 0; i < sets.TakeProfitsNumber; i++)
    {
        TradingTPEdits[i].Text(DoubleToString(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * double(sets.TakeProfitsNumber - i) / double(sets.TakeProfitsNumber)));
        UpdateTradingTPEdit(i);
    }
    RefreshValues();
}

// Each TP is calculated as the previous level + main TP size.
void CPositionSizeCalculator::OnClickBtnTPsOutward()
{
    if (sets.TakeProfitLevel == 0) ProcessTPChange(true); // True - for RefreshValues() call.
    for (int i = 0; i < sets.TakeProfitsNumber; i++)
    {
        TradingTPEdits[i].Text(DoubleToString(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * (i + 1)));
        UpdateTradingTPEdit(i);
    }
    RefreshValues();
}

// Fills the volume shares with schemes that switch iteratively:
// 1. Equal shares.
// 2. Decreasing shares by halving when possible.
// 3. Increasing shares - same as above but in reverse.
void CPositionSizeCalculator::OnClickBtnTradingTPShare()
{
    if (sets.ShareVolumeMode == Equal)
    {
        ArrayInitialize(sets.TPShare, 100 / sets.TakeProfitsNumber);
        sets.ShareVolumeMode = Decreasing; // Next mode.
    }
    else if (sets.ShareVolumeMode == Decreasing)
    {
        sets.TPShare[0] = 50;
        int remaining_volume = 50;
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            if (i == sets.TakeProfitsNumber - 1) sets.TPShare[i] = remaining_volume;
            else sets.TPShare[i] = (int)MathRound((double)remaining_volume / 2.0);
            remaining_volume -= sets.TPShare[i];
        }
        sets.ShareVolumeMode = Increasing; // Next mode.
    }
    else if (sets.ShareVolumeMode == Increasing)
    {
        sets.TPShare[sets.TakeProfitsNumber - 1] = 50;
        int remaining_volume = 50;
        for (int i = sets.TakeProfitsNumber - 2; i >= 0 ; i--)
        {
            if (i == 0) sets.TPShare[i] = remaining_volume;
            else sets.TPShare[i] = (int)MathRound((double)remaining_volume / 2.0);
            remaining_volume -= sets.TPShare[i];
        }
        sets.ShareVolumeMode = Equal; // Next mode.
    }
    for (int i = 0; i < sets.TakeProfitsNumber; i++)
    {
        TradingTPShareEdits[i].Text(IntegerToString(sets.TPShare[i])); // Display.
    }
    // Switch color back to normal if it was red because the button results in correct shares.
    for (int j = 0; j < sets.TakeProfitsNumber; j++)
    {
        TradingTPShareEdits[j].Color(m_EdtSL.Color()); // Normal color.
    }
    RefreshValues();
}

void CPositionSizeCalculator::OnClickBtnQuickRisk1()
{
    sets.UseMoneyInsteadOfPercentage = false;
    sets.RiskFromPositionSize = false;
    if (sets.Risk != QuickRisk1)
    {
        sets.Risk = QuickRisk1;
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnClickBtnQuickRisk2()
{
    sets.UseMoneyInsteadOfPercentage = false;
    sets.RiskFromPositionSize = false;
    if (sets.Risk != QuickRisk2)
    {
        sets.Risk = QuickRisk2;
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

// Entry "+" button pressed.
void CPositionSizeCalculator::OnClickBtnEntryIncrease()
{
    if (sets.EntryType == Instant) return; // Entry shouldn't be changeable in Instant order mode.
    // Should actually operate in TickSize rather than point as only TickSize changes make sense.
    if (TickSize > 0) sets.EntryLevel += TickSize;
    else sets.EntryLevel += _Point;
    if (tEntryLevel != sets.EntryLevel)
    {
        // Check and adjust for TickSize granularity.
        tEntryLevel = sets.EntryLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnEntryDecrease()
{
    if (sets.EntryType == Instant) return; // Entry shouldn't be changeable in Instant order mode.
    // Should actually operate in TickSize rather than point as only TickSize changes make sense.
    if (TickSize > 0) sets.EntryLevel -= TickSize;
    else sets.EntryLevel -= _Point;
    if (sets.EntryLevel < 0) sets.EntryLevel = 0; // No negative values.
    if (tEntryLevel != sets.EntryLevel)
    {
        // Check and adjust for TickSize granularity.
        tEntryLevel = sets.EntryLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnStopLossIncrease()
{
    if (ShowATROptions) return; // Stop-loss cannot be changed by +/- buttons in ATR mode.
    // Should actually operate in TickSize rather than point as only TickSize changes make sense.
    if (!sets.SLDistanceInPoints)
    {
        if (TickSize > 0) sets.StopLossLevel += TickSize;
        else sets.StopLossLevel += _Point;
        if ((sets.TradeDirection == Long) && (sets.StopLossLevel > sets.EntryLevel)) sets.StopLossLevel = sets.EntryLevel; // Don't go over the Entry.
    }
    else
    {
        if (TickSize > 0) sets.StopLoss += (int)MathRound(TickSize / _Point);
        else sets.StopLoss += 1;
        if (sets.TradeDirection == Long)
        {
            sets.StopLossLevel = NormalizeDouble(sets.EntryLevel - sets.StopLoss * _Point, _Digits);
            if (sets.StopLossLevel < 0) // Cannot go below zero.
            {
                sets.StopLossLevel = 0;
                sets.StopLoss = (int)MathRound(sets.EntryLevel / _Point);
            }
        }
        else
        {
            sets.StopLossLevel = NormalizeDouble(sets.EntryLevel + sets.StopLoss * _Point, _Digits);
        }
    }
    if (tStopLossLevel != sets.StopLossLevel)
    {
        tStopLossLevel = sets.StopLossLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnStopLossDecrease()
{
    if (ShowATROptions) return; // Stop-loss cannot be changed by +/- buttons in ATR mode.
    // Should actually operate in TickSize rather than point as only TickSize changes make sense.
    if (!sets.SLDistanceInPoints)
    {
        if (TickSize > 0) sets.StopLossLevel -= TickSize;
        else sets.StopLossLevel -= _Point;
        if ((sets.TradeDirection == Short) && (sets.StopLossLevel < sets.EntryLevel)) sets.StopLossLevel = sets.EntryLevel; // Don't go over the Entry.
        if (sets.StopLossLevel < 0) sets.StopLossLevel = 0; // No negative values.
    }
    else
    {
        if (TickSize > 0) sets.StopLoss -= (int)MathRound(TickSize / _Point);
        else sets.StopLoss -= 1;
        if (sets.StopLoss < 0) sets.StopLoss = 0; // No negative values.
        if (sets.TradeDirection == Long)
        {
            sets.StopLossLevel = NormalizeDouble(sets.EntryLevel - sets.StopLoss * _Point, _Digits);
        }
        else
        {
            sets.StopLossLevel = NormalizeDouble(sets.EntryLevel + sets.StopLoss * _Point, _Digits);
        }
    }
    if (tStopLossLevel != sets.StopLossLevel)
    {
        tStopLossLevel = sets.StopLossLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnTakeProfitIncrease()
{
    if (ShowATROptions) return; // Take-profit cannot be changed by +/- buttons in ATR mode.
    if (!sets.TPDistanceInPoints)
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.TakeProfitLevel += TickSize;
        else sets.TakeProfitLevel += _Point;
        if ((sets.TradeDirection == Short) && (sets.TakeProfitLevel > sets.EntryLevel)) sets.TakeProfitLevel = sets.EntryLevel; // Don't go over the Entry.
    }
    else
    {
        if (TickSize > 0) sets.TakeProfit += (int)MathRound(TickSize / _Point);
        else sets.TakeProfit += 1;
        
        if (sets.TakeProfit > 0)
        {
            if (sets.TradeDirection == Long)
            {
                sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel + sets.TakeProfit * _Point, _Digits);
            }
            else
            {
                sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel - sets.TakeProfit * _Point, _Digits);
                if (sets.TakeProfitLevel < 0) // Cannot go below zero.
                {
                    sets.TakeProfitLevel = 0;
                    sets.TakeProfit = (int)MathRound(sets.EntryLevel / _Point);
                }
            }
        }
        else sets.TakeProfitLevel = 0;
    }
    if (tTakeProfitLevel != sets.TakeProfitLevel)
    {
        tTakeProfitLevel = sets.TakeProfitLevel;
        if (ArraySize(sets.TP) > 0)
        {
            sets.TP[0] = sets.TakeProfitLevel;
            if (sets.TakeProfitsNumber > 1) TradingTPEdits[0].Text(DoubleToString(sets.TP[0], _Digits));
        }
        ProcessLineObjectsAfterUpdatingMultipleTP(0);
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnTakeProfitDecrease()
{
    if (ShowATROptions) return; // Take-profit cannot be changed by +/- buttons in ATR mode.
    if (!sets.TPDistanceInPoints)
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.TakeProfitLevel -= TickSize;
        else sets.TakeProfitLevel -= _Point;
        if ((sets.TradeDirection == Long) && (sets.TakeProfitLevel < sets.EntryLevel)) sets.TakeProfitLevel = sets.EntryLevel; // Don't go over the Entry.
        if (sets.TakeProfitLevel < 0) sets.TakeProfitLevel = 0; // No negative values.
    }
    else
    {
        if (TickSize > 0) sets.TakeProfit -= (int)MathRound(TickSize / _Point);
        else sets.TakeProfit -= 1;
        if (sets.TakeProfit < 0) sets.TakeProfit = 0; // No negative values.
        
        if (sets.TakeProfit > 0)
        {
            if (sets.TradeDirection == Long)
            {
                sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel + sets.TakeProfit * _Point, _Digits);
            }
            else
            {
                sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel - sets.TakeProfit * _Point, _Digits);
            }
        }
        else sets.TakeProfitLevel = 0;
    }
    if (tTakeProfitLevel != sets.TakeProfitLevel)
    {
        tTakeProfitLevel = sets.TakeProfitLevel;
        if (ArraySize(sets.TP) > 0)
        {
            sets.TP[0] = sets.TakeProfitLevel;
            if (sets.TakeProfitsNumber > 1) TradingTPEdits[0].Text(DoubleToString(sets.TP[0], _Digits));
        }
        ProcessLineObjectsAfterUpdatingMultipleTP(0);
        RefreshValues();
    }
}

void CPositionSizeCalculator::ProcessAdditionalTPButtonsIncrease(int i)
{
    if (!sets.TPDistanceInPoints) // Everything is easy.
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.TP[i] += TickSize;
        else sets.TP[i] += _Point;
        if ((sets.TradeDirection == Short) && (sets.TP[i] > sets.EntryLevel)) sets.TP[i] = sets.EntryLevel; // Don't go over the Entry.
        sets.TP[i] = NormalizeDouble(sets.TP[i], _Digits);
        TradingTPEdits[i].Text(DoubleToString(sets.TP[i], _Digits));
    }
    else // Since additional TPs are stored only in their level form, need to differentiate between + on the Long trade and + on the Short trade.
    {
        if (sets.TP[i] == 0) sets.TP[i] = sets.EntryLevel; // Was zero, should place the TP near the Entry not at absolute 0 + 0.0001 level.
        if (sets.TradeDirection == Long)
        {
            if (TickSize > 0) sets.TP[i] += TickSize;
            else sets.TP[i] += _Point;
            sets.TP[i] = NormalizeDouble(sets.TP[i], _Digits);
            AdditionalTPEdits[i - 1].Text(DoubleToString(MathRound((sets.TP[i] - sets.EntryLevel) / _Point), 0));
            TradingTPEdits[i].Text(AdditionalTPEdits[i - 1].Text());
        }
        else
        {
            if (TickSize > 0) sets.TP[i] -= TickSize;
            else sets.TP[i] -= _Point;
            if (sets.TP[i] > sets.EntryLevel) sets.TP[i] = sets.EntryLevel;
            sets.TP[i] = NormalizeDouble(sets.TP[i], _Digits);
            AdditionalTPEdits[i - 1].Text(DoubleToString(MathRound((sets.EntryLevel - sets.TP[i]) / _Point), 0));
            TradingTPEdits[i].Text(AdditionalTPEdits[i - 1].Text());
        }
    }
    ProcessLineObjectsAfterUpdatingMultipleTP(i);
    RefreshValues();
}

void CPositionSizeCalculator::ProcessAdditionalTPButtonsDecrease(int i)
{
    if (!sets.TPDistanceInPoints) // Everything is more or less easy.
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.TP[i] -= TickSize;
        else sets.TP[i] -= _Point;
        if (sets.TP[i] < 0) sets.TP[i] = 0;
        if ((sets.TradeDirection == Long) && (sets.TP[i] < sets.EntryLevel)) sets.TP[i] = sets.EntryLevel;
        sets.TP[i] = NormalizeDouble(sets.TP[i], _Digits);
        TradingTPEdits[i].Text(DoubleToString(sets.TP[i], _Digits));
    }
    else // Since additional TPs are stored only in their level form, need to differentiate between - on the Long trade and - on the Short trade.
    {
        if (sets.TradeDirection == Long)
        {
            if (TickSize > 0) sets.TP[i] -= TickSize;
            else sets.TP[i] -= _Point;
            if (sets.TP[i] < 0) sets.TP[i] = 0;
            if (sets.TP[i] < sets.EntryLevel) sets.TP[i] = sets.EntryLevel;
            sets.TP[i] = NormalizeDouble(sets.TP[i], _Digits);
            if (sets.TP[i] == sets.EntryLevel) // Got down to zero, should be removed.
            {
                sets.TP[i] = 0;
                AdditionalTPEdits[i - 1].Text(DoubleToString(0, _Digits));
            }
            else
            {
                AdditionalTPEdits[i - 1].Text(DoubleToString(MathRound((sets.TP[i] - sets.EntryLevel) / _Point), 0));
            }
        }
        else
        {
            if (sets.TP[i] == 0) return; // Was zero, decreasing shouldn't do a thing.
            if (TickSize > 0) sets.TP[i] += TickSize;
            else sets.TP[i] += _Point;
            if (sets.TP[i] > sets.EntryLevel) sets.TP[i] = sets.EntryLevel;
            sets.TP[i] = NormalizeDouble(sets.TP[i], _Digits);
            if (sets.TP[i] == sets.EntryLevel) // Got down to zero, should be removed.
            {
                sets.TP[i] = 0;
                AdditionalTPEdits[i - 1].Text(DoubleToString(0, _Digits));
            }
            else
            {
                AdditionalTPEdits[i - 1].Text(DoubleToString(MathRound((sets.EntryLevel - sets.TP[i]) / _Point), 0));
            }
        }
    }
    ProcessLineObjectsAfterUpdatingMultipleTP(i);
    RefreshValues();
}

void CPositionSizeCalculator::OnClickBtnStopPriceIncrease()
{
    if (sets.EntryType != StopLimit) return; // Stop price should only be changeable in StopLimit order mode.
    // Should actually operate in TickSize rather than point as only TickSize changes make sense.
    if (TickSize > 0) sets.StopPriceLevel += TickSize;
    else sets.StopPriceLevel += _Point;

    if (tStopPriceLevel != sets.StopPriceLevel)
    {
        tStopPriceLevel = sets.StopPriceLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, sets.StopPriceLevel);
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnClickBtnStopPriceDecrease()
{
    if (sets.EntryType != StopLimit) return; // Stop price should only be changeable in StopLimit order mode.
    // Should actually operate in TickSize rather than point as only TickSize changes make sense.
    if (TickSize > 0) sets.StopPriceLevel += TickSize;
    if (sets.StopPriceLevel < 0) sets.StopPriceLevel = 0; // No negative values.
    
    if (tStopPriceLevel != sets.StopPriceLevel)
    {
        tStopPriceLevel = sets.StopPriceLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, sets.StopPriceLevel);
        RefreshValues();
    }
}

// Generate a new TP on both the Main and Trading tabs, creating necessary data.
void CPositionSizeCalculator::OnClickBtnTakeProfitsNumberAdd()
{
    // Prepare data for the new TP.
    sets.TakeProfitsNumber++;
    // Have to avoid deleting the panel objects from the memory.
    // Because the CDialog implementation doesn't have any methods for removal of the panel objects from it. It only has Add().
    // It is based on a class property storing the maximum number of TPs ever added in the current instance.
    // If it is not exceeded, then nothing is resized.
    if (sets.TakeProfitsNumber > MaxTakeProfitsNumber)
    {
        // "- 1" because there is already one main TP level.
        ArrayResize(AdditionalTPLabels, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalTPEdits, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalTPWarnings, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalTPButtonsIncrease, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalTPButtonsDecrease, sets.TakeProfitsNumber - 1);
        ArrayResize(AdditionalWarningTP, sets.TakeProfitsNumber - 1); // String array.
        ArrayResize(AdditionalOutputRR, sets.TakeProfitsNumber - 1); // String array.
        ArrayResize(AdditionalOutputReward, sets.TakeProfitsNumber - 1); // Double array.
        ArrayResize(TradingTPLabels, sets.TakeProfitsNumber); // Without "- 1" because these also store the main TP.
        ArrayResize(TradingTPEdits, sets.TakeProfitsNumber);
        ArrayResize(TradingTPShareEdits, sets.TakeProfitsNumber);
    }
    string additional_tp_label_beginning = TRANSLATION_LABEL_TAKEPROFIT + " ";
    string additional_tp_label_end = ":";
    if (sets.TPDistanceInPoints)
    {
        additional_tp_label_beginning = TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_DISTANCE + " ";
        additional_tp_label_end = ", " + TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_POINTS + ":";
    }
    if (ArraySize(sets.TP) < sets.TakeProfitsNumber) // Resize only if required. Sometimes, when switching symbols, this won't be required.
    {
        ArrayResize(sets.TP, sets.TakeProfitsNumber);
        ArrayResize(TakeProfitLineIsBeingMoved, sets.TakeProfitsNumber);
        ArrayInitialize(TakeProfitLineIsBeingMoved, false);
        sets.TP[sets.TakeProfitsNumber - 1] = 0; // Initialize
        ArrayResize(sets.TPShare, sets.TakeProfitsNumber);
        if (sets.ShareVolumeMode == Decreasing) // Do the previous method because sets.ShareVolumeMode gets switched over once you click the button.
        {
            ArrayInitialize(sets.TPShare, 100 / sets.TakeProfitsNumber);
        }
        else if (sets.ShareVolumeMode == Increasing)
        {
            sets.TPShare[0] = 50;
            int remaining_volume = 50;
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                if (i == sets.TakeProfitsNumber - 1) sets.TPShare[i] = remaining_volume;
                else sets.TPShare[i] = (int)MathRound((double)remaining_volume / 2.0);
                remaining_volume -= sets.TPShare[i];
            }
        }
        else if (sets.ShareVolumeMode == Equal)
        {
            sets.TPShare[sets.TakeProfitsNumber - 1] = 50;
            int remaining_volume = 50;
            for (int i = sets.TakeProfitsNumber - 2; i >= 0 ; i--)
            {
                if (i == 0) sets.TPShare[i] = remaining_volume;
                else sets.TPShare[i] = (int)MathRound((double)remaining_volume / 2.0);
                remaining_volume -= sets.TPShare[i];
            }
        }
        ArrayResize(sets.WasSelectedAdditionalTakeProfitLine, sets.TakeProfitsNumber - 1); // -1 because the flag for the main TP is saved elsewhere.
        ArrayResize(ArrayPositionSize, sets.TakeProfitsNumber);
    }

    // Move everything on the Main tab down by one line to insert the new take-profit.
    int col_height = (int)MathRound(24 * m_DPIScale);
    CStringForList * obj;
    bool start_moving = false; // Wait till the first panel object that has to be moved is found.
    int y = 0; // Y-position for the new TP.
    int index = 0; // Index of the Main tab list of fields.
    for (obj = MainTabList.GetFirstNode(); obj != NULL; obj = MainTabList.GetNextNode())
    {
        if (!start_moving)
        {
            // Stop Price label is the first object to be moved (even if it's hidden).
            if (obj.Name == "m_LblStopPrice")
            {
                start_moving = true; // From now on, everything below should be moved down.
                y = obj.Obj.Top() - (CONTROLS_DIALOG_CAPTION_HEIGHT + 3 * CONTROLS_BORDER_WIDTH) - remember_top; // Remember the y where the new TP fields will be inserted. Relative measurement.
                index = MainTabList.IndexOf(obj) - 1; // Remember the index to insert the new TP in the list of Main tab fields.
            }
        }
        if (start_moving)        
        {
            obj.Obj.Move(obj.Obj.Left(), obj.Obj.Top() + col_height); // Down.
        }
    }
    string name = "m_BtnTakeProfitsNumberRemove";
    // If it is the first additional TP:
    if (sets.TakeProfitsNumber == 2)
    {
        // And it is added for the first time, create the Remove button:
        if (MaxTakeProfitsNumber == 1)
        {
            ButtonCreate(MainTabList, m_BtnTakeProfitsNumberRemove, first_column_start, y, first_column_start + v_spacing * 4 - 1, y + element_height, name, "x", "Remove Take-profit");
            if (DarkMode)
            {
                m_BtnTakeProfitsNumberRemove.ColorBackground(DARKMODE_BUTTON_BG_COLOR);
                m_BtnTakeProfitsNumberRemove.ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
            }
            MainTabList.MoveListElementByName(name, index);
        }
    }
    else // Otherwise, move it down one line.
    {
        m_BtnTakeProfitsNumberRemove.Move(m_BtnTakeProfitsNumberRemove.Left(), m_BtnTakeProfitsNumberRemove.Top() + col_height);
    }
    index++;

    // Create Main panel fields for the new TP. Actual creation of the control objects should only be performed if the previous maximum number of TPs is exceeded.
    if (MaxTakeProfitsNumber < sets.TakeProfitsNumber)
    {
        int i = sets.TakeProfitsNumber - 2;
        name = "m_LblAdditionalTPLabels" + IntegerToString(i + 2);
        LabelCreate(MainTabList, AdditionalTPLabels[i], first_column_start + v_spacing * 4, y, first_column_start + normal_label_width, y + element_height, name, additional_tp_label_beginning + IntegerToString(i + 2) + additional_tp_label_end);
        if (DarkMode)
        {
            AdditionalTPLabels[i].Color(DARKMODE_TEXT_COLOR);
        }
        MainTabList.MoveListElementByName(name, index);

        name = "m_EdtAdditionalTPEdits" + IntegerToString(i + 2);
        EditCreate(MainTabList, AdditionalTPEdits[i], second_column_start, y, second_column_start + normal_edit_width, y + element_height, name, "");
        AdditionalTPEdits[i].TextAlign(ALIGN_RIGHT);
        if (DarkMode)
        {
            AdditionalTPEdits[i].ColorBackground(DARKMODE_EDIT_BG_COLOR);
            AdditionalTPEdits[i].ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
        }
        MainTabList.MoveListElementByName(name, index + 1);

        name = "m_BtnAdditionalTPButtonsIncrease" + IntegerToString(i + 2);
        ButtonCreate(MainTabList, AdditionalTPButtonsIncrease[i], second_column_start + normal_edit_width + 1, y, second_column_start + normal_edit_width + v_spacing * 4, y + element_height / 2, name, "+", TRANSLATION_TOOLTIP_TAKEPROFIT_INCREASE_MULTIPLE + " #" + IntegerToString(i + 2) + " " + TRANSLATION_TOOLTIP_TAKEPROFIT_BY_ONE_POINT);
        if (DarkMode)
        {
            AdditionalTPButtonsIncrease[i].ColorBackground(DARKMODE_BUTTON_BG_COLOR);
            AdditionalTPButtonsIncrease[i].ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
        }
        MainTabList.MoveListElementByName(name, index + 2);

        name = "m_BtnAdditionalTPButtonsDecrease" + IntegerToString(i + 2);
        ButtonCreate(MainTabList, AdditionalTPButtonsDecrease[i], second_column_start + normal_edit_width + 1, y + element_height / 2, second_column_start + normal_edit_width + v_spacing * 4, y + element_height, name, "-", TRANSLATION_TOOLTIP_TAKEPROFIT_DECREASE_MULTIPLE + " #" + IntegerToString(i + 2) + " " + TRANSLATION_TOOLTIP_TAKEPROFIT_BY_ONE_POINT);
        if (DarkMode)
        {
            AdditionalTPButtonsDecrease[i].ColorBackground(DARKMODE_BUTTON_BG_COLOR);
            AdditionalTPButtonsDecrease[i].ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
        }
        MainTabList.MoveListElementByName(name, index + 3);

        name = "m_LblAdditionalTPWarnings" + IntegerToString(i + 2);
        LabelCreate(MainTabList, AdditionalTPWarnings[i], third_column_start, y, third_column_start + narrow_label_width, y + element_height, name, " ");
        if (DarkMode)
        {
            AdditionalTPWarnings[i].Color(DARKMODE_TEXT_COLOR);
        }
        MainTabList.MoveListElementByName(name, index + 4);
    }

    // Proceed to generating new panel fields for the Trading tab.

    // Move everything on the Trading tab down by one or two lines to insert the new take-profit.
    start_moving = false; // Wait till the first panel object that has to be moved is found.
    y = 0; // Y-position for the new TP.
    index = 0; // Index of the Trading tab list of fields.
    int m = 1; // The number of rows to move down. If it is the first additional TP that is being added, then need to move 3 rows down due to the headers and the main TP.
    for (obj = TradingTabList.GetFirstNode(); obj != NULL; obj = TradingTabList.GetNextNode())
    {
        if (!start_moving)
        {
            // The "Points" label on the Trading tab. If it is absent, then the "Subtract position volume" checkbox. If it is absent, "Ask for confimration" checkbox.
            if (((ShowFusesOnTrading) && (obj.Name == "m_LblTradingPoints")) || ((ShowCheckboxesOnTrading) && (obj.Name == "m_ChkSubtractPositions")) || (obj.Name == "m_ChkAskForConfirmation"))
            {
                start_moving = true; // From now on everything below should be moved down.
                y = obj.Obj.Top() - (CONTROLS_DIALOG_CAPTION_HEIGHT + 3 * CONTROLS_BORDER_WIDTH) - remember_top; // Remember the y where the new TP fields will be inserted. Relative measurement.
                index = TradingTabList.IndexOf(obj) - 1; // Remember the index to insert the new TP in the list of Trading tab fields.
                if (sets.TakeProfitsNumber == 2) m = 3; // Will be moving three rows down: headers + main TP + first secondary TP.
            }
        }
        if (start_moving)        
        {
            obj.Obj.Move(obj.Obj.Left(), obj.Obj.Top() + m * col_height); // Down.
        }
    }
    
    // Increased from 1 to 2.
    if (sets.TakeProfitsNumber == 2)
    {
        // Actual creation of panel elements is needed only the first time.
        
        // Need to add a row with headers and buttons above the Points header first.
        if (MaxTakeProfitsNumber == 1)
        {
            name = "m_LblTradingTP";
            LabelCreate(TradingTabList, m_LblTradingTP, multi_tp_column_start, y, multi_tp_column_start + multi_tp_label_width, y + element_height, name, TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_DISTANCE);
            if (DarkMode)
            {
                m_LblTradingTP.Color(DARKMODE_TEXT_COLOR);
            }
            TradingTabList.MoveListElementByName(name, index);
    
            name = "m_BtnTPsInward";
            ButtonCreate(TradingTabList, m_BtnTPsInward, multi_tp_button_start, y, multi_tp_button_start + leverage_edit_width, y + element_height, name, "<<", TRANSLATION_TOOLTIP_FILL_INWARD);
            if (DarkMode)
            {
                m_BtnTPsInward.ColorBackground(DARKMODE_BUTTON_BG_COLOR);
                m_BtnTPsInward.ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
            }
            TradingTabList.MoveListElementByName(name, index + 1);

            name = "m_BtnTPsOutward";
            ButtonCreate(TradingTabList, m_BtnTPsOutward, multi_tp_button_start + leverage_edit_width + v_spacing, y, multi_tp_button_start + 2 * leverage_edit_width + v_spacing, y + element_height, name, ">>", TRANSLATION_TOOLTIP_FILL_OUTWARD);
            if (DarkMode)
            {
                m_BtnTPsOutward.ColorBackground(DARKMODE_BUTTON_BG_COLOR);
                m_BtnTPsOutward.ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
            }
            TradingTabList.MoveListElementByName(name, index + 2);

            name = "m_BtnTradingTPShare";
            ButtonCreate(TradingTabList, m_BtnTradingTPShare, third_trading_column_start, y, third_trading_column_start + normal_edit_width, y + element_height, name, TRANSLATION_LABEL_SHARE + ", %", TRANSLATION_TOOLTIP_SHARE);
            if (DarkMode)
            {
                m_BtnTradingTPShare.ColorBackground(DARKMODE_BUTTON_BG_COLOR);
                m_BtnTradingTPShare.ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
            }
            TradingTabList.MoveListElementByName(name, index + 3);

            y += col_height;
            index += 4;

            // First (main) TP:
        
            name = "m_LblTradingTPLabel1";
            LabelCreate(TradingTabList, TradingTPLabels[0], first_column_start, y, first_column_start + normal_label_width, y + element_height, name, TRANSLATION_LABEL_TAKEPROFIT + " 1");
            if (DarkMode)
            {
                TradingTPLabels[0].Color(DARKMODE_TEXT_COLOR);
            }
            TradingTabList.MoveListElementByName(name, index);

            name = "m_EdtTradingTPEdit1";
            EditCreate(TradingTabList, TradingTPEdits[0], multi_tp_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, name, "");
            TradingTPEdits[0].TextAlign(ALIGN_RIGHT);
            if (DarkMode)
            {
                TradingTPEdits[0].ColorBackground(DARKMODE_EDIT_BG_COLOR);
                TradingTPEdits[0].ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
            }
            TradingTabList.MoveListElementByName(name, index + 1);

            name = "m_EdtTradingTPShareEdit1";
            EditCreate(TradingTabList, TradingTPShareEdits[0], third_trading_column_start, y, third_trading_column_start + leverage_edit_width, y + element_height, name, "");
            TradingTPShareEdits[0].TextAlign(ALIGN_RIGHT);
            if (DarkMode)
            {
                TradingTPShareEdits[0].ColorBackground(DARKMODE_EDIT_BG_COLOR);
                TradingTPShareEdits[0].ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
            }
            TradingTabList.MoveListElementByName(name, index + 2);
        }
        else
        {
            TradingTabList.SetHiddenByName("m_LblTradingTP", false);
            TradingTabList.SetHiddenByName("m_BtnTPsInward", false);
            TradingTabList.SetHiddenByName("m_BtnTPsOutward", false);
            TradingTabList.SetHiddenByName("m_BtnTradingTPShare", false);
            
            // Need to do this to have the same y and index as if the above condition was true:
            y += col_height;
            index += 4;
            
            TradingTabList.SetHiddenByName("m_LblTradingTPLabel1", false);
            TradingTabList.SetHiddenByName("m_EdtTradingTPEdit1", false);
            TradingTabList.SetHiddenByName("m_EdtTradingTPShareEdit1", false);
        }

        y += col_height;
        index += 3;
    }

    if (MaxTakeProfitsNumber < sets.TakeProfitsNumber)
    {
        name = "m_LblTradingTPLabel" + IntegerToString(sets.TakeProfitsNumber);
        LabelCreate(TradingTabList, TradingTPLabels[sets.TakeProfitsNumber - 1], first_column_start, y, first_column_start + normal_label_width, y + element_height, name, TRANSLATION_LABEL_TAKEPROFIT + " " + IntegerToString(sets.TakeProfitsNumber));
        if (DarkMode)
        {
            TradingTPLabels[sets.TakeProfitsNumber - 1].Color(DARKMODE_TEXT_COLOR);
        }
        TradingTabList.MoveListElementByName(name, index);

        name = "m_EdtTradingTPEdit" + IntegerToString(sets.TakeProfitsNumber);
        EditCreate(TradingTabList, TradingTPEdits[sets.TakeProfitsNumber - 1], multi_tp_column_start, y, second_trading_column_start + normal_edit_width, y + element_height, name, "");
        TradingTPEdits[sets.TakeProfitsNumber - 1].TextAlign(ALIGN_RIGHT);
        if (DarkMode)
        {
            TradingTPEdits[sets.TakeProfitsNumber - 1].ColorBackground(DARKMODE_EDIT_BG_COLOR);
            TradingTPEdits[sets.TakeProfitsNumber - 1].ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
        }
        TradingTabList.MoveListElementByName(name, index + 1);

        name = "m_EdtTradingTPShareEdit" + IntegerToString(sets.TakeProfitsNumber);
        EditCreate(TradingTabList, TradingTPShareEdits[sets.TakeProfitsNumber - 1], third_trading_column_start, y, third_trading_column_start + leverage_edit_width, y + element_height, name, "");
        TradingTPShareEdits[sets.TakeProfitsNumber - 1].TextAlign(ALIGN_RIGHT);
        if (DarkMode)
        {
            TradingTPShareEdits[sets.TakeProfitsNumber - 1].ColorBackground(DARKMODE_EDIT_BG_COLOR);
            TradingTPShareEdits[sets.TakeProfitsNumber - 1].ColorBorder(DARKMODE_CONTROL_BRODER_COLOR);
        }
        TradingTabList.MoveListElementByName(name, index + 2);
    }
    else
    {
        TradingTabList.SetHiddenByName("m_LblTradingTPLabel" + IntegerToString(sets.TakeProfitsNumber), false);
        TradingTabList.SetHiddenByName("m_EdtTradingTPEdit" + IntegerToString(sets.TakeProfitsNumber), false);
        TradingTabList.SetHiddenByName("m_EdtTradingTPShareEdit" + IntegerToString(sets.TakeProfitsNumber), false);
    }

    if (MaxTakeProfitsNumber < sets.TakeProfitsNumber) MaxTakeProfitsNumber = sets.TakeProfitsNumber;

    if ((PrefillAdditionalTPsBasedOnMain) && (sets.TakeProfitLevel != 0)) // If added a new TP when the first TP was already set, set some value to the new one too.
    {
        if (!sets.TPDistanceInPoints) sets.TP[sets.TakeProfitsNumber - 1] = NormalizeDouble(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * sets.TakeProfitsNumber, _Digits);
        else
        {
            if (sets.TradeDirection == Short) sets.TP[sets.TakeProfitsNumber - 1] = NormalizeDouble(sets.EntryLevel - sets.TakeProfit * _Point * sets.TakeProfitsNumber, _Digits);
            else if (sets.TradeDirection == Long) sets.TP[sets.TakeProfitsNumber - 1] = NormalizeDouble(sets.EntryLevel + sets.TakeProfit * _Point * sets.TakeProfitsNumber, _Digits);
            AdditionalTPEdits[sets.TakeProfitsNumber - 2].Text(IntegerToString(sets.TakeProfit * sets.TakeProfitsNumber));
        }
    }

    if ((ShowLineLabels) || (ShowAdditionalTPLabel)) Initialization(); // Creates necessary line labels.
    HideShowMaximize(); // For panel resizing.
    RefreshValues(); // For some value to appear inside the TP edit field.
    for (int i = 0; i < sets.TakeProfitsNumber; i++)
    {
        TradingTPShareEdits[i].Text(IntegerToString(sets.TPShare[i])); // Update display values on the panel.
        TradingTPEdits[i].Text(DoubleToString(sets.TP[i], _Digits));
    }
}

// Remove the bottom TP on both the Main and Trading tabs, erasing accompanying data and, possibly, the Remove button itself.
// Removed TPs should still be deleted from the TabList lists of names and probably hidden?
void CPositionSizeCalculator::OnClickBtnTakeProfitsNumberRemove()
{
    // Move everything on the Main tab up by one line as the bottom-most take-profit is removed.
    int col_height = (int)MathRound(24 * m_DPIScale);
    CStringForList * obj;
    bool start_moving = false; // Wait till the first panel object that has to be moved is found.
    for (obj = MainTabList.GetFirstNode(); obj != NULL; obj = MainTabList.GetNextNode())
    {
        if (!start_moving)
        {
            // Stop Price label is the first object to be moved (even if it's hidden).
            if (obj.Name == "m_LblStopPrice")
            {
                start_moving = true; // From now on everything below should be moved up.
            }
        }
        if (start_moving)        
        {
            obj.Obj.Move(obj.Obj.Left(), obj.Obj.Top() - col_height); // Up.
        }
    }

    // Hide Main panel fields for the deleted TP.
    int i = sets.TakeProfitsNumber - 2;
    AdditionalTPLabels[i].Hide();
    AdditionalTPEdits[i].Hide();
    AdditionalTPButtonsIncrease[i].Hide();
    AdditionalTPButtonsDecrease[i].Hide();
    AdditionalTPWarnings[i].Hide();

    // If it was the last additional TP, hide the Remove button, otherwise, move it up one line.
    if (sets.TakeProfitsNumber == 2)
    {
        m_BtnTakeProfitsNumberRemove.Hide();
    }
    else
    {
        m_BtnTakeProfitsNumberRemove.Move(m_BtnTakeProfitsNumberRemove.Left(), m_BtnTakeProfitsNumberRemove.Top() - col_height);
    }

    // Delete fields on the Trading tab.

    // Move everything on the Trading tab up by one or two lines after deleting the take-profit.
    start_moving = false; // Wait till the first panel object that has to be moved is found.
    int m = 1; // The number of rows to move up. If it is the last additional TP that is being removed, then need to move 3 rows up due to the headers and the main TP.
    for (obj = TradingTabList.GetFirstNode(); obj != NULL; obj = TradingTabList.GetNextNode())
    {
        if (!start_moving)
        {
            // The "Points" label on the Trading tab. If it is absent, then the "Subtract position volume" checkbox. If it is absent, "Ask for confimration" checkbox.
            if (((ShowFusesOnTrading) && (obj.Name == "m_LblTradingPoints")) || ((ShowCheckboxesOnTrading) && (obj.Name == "m_ChkSubtractPositions")) || (obj.Name == "m_ChkAskForConfirmation"))
            {
                start_moving = true; // From now on everything below should be moved up.
                if (sets.TakeProfitsNumber == 2) m = 3; // Will be moving three rows up: headers + main TP + first secondary TP.
            }
        }
        if (start_moving)        
        {
            obj.Obj.Move(obj.Obj.Left(), obj.Obj.Top() - m * col_height);
        }
    }
    
    if (sets.TakeProfitsNumber == 2) // Will decrease from 2 to 1. The actual decreasing happens at the end of this function.
    {
        // Need to hide the row with headers and buttons.

        TradingTabList.SetHiddenByName("m_LblTradingTP", true);
        TradingTabList.SetHiddenByName("m_BtnTPsInward", true);
        TradingTabList.SetHiddenByName("m_BtnTPsOutward", true);
        TradingTabList.SetHiddenByName("m_BtnTradingTPShare", true);

        // First (main) TP:
        TradingTabList.SetHiddenByName("m_LblTradingTPLabel1", true);
        TradingTabList.SetHiddenByName("m_EdtTradingTPEdit1", true);
        TradingTabList.SetHiddenByName("m_EdtTradingTPShareEdit1", true);
    }

    TradingTabList.SetHiddenByName("m_LblTradingTPLabel" + IntegerToString(sets.TakeProfitsNumber), true);
    TradingTabList.SetHiddenByName("m_EdtTradingTPEdit" + IntegerToString(sets.TakeProfitsNumber), true);
    TradingTabList.SetHiddenByName("m_EdtTradingTPShareEdit" + IntegerToString(sets.TakeProfitsNumber), true);

    // Clean up data of the delted TP.
    sets.TakeProfitsNumber--;
    ArrayResize(sets.TP, sets.TakeProfitsNumber);
    ArrayResize(TakeProfitLineIsBeingMoved, sets.TakeProfitsNumber);
    ArrayResize(sets.TPShare, sets.TakeProfitsNumber);
    if (sets.ShareVolumeMode == Decreasing) // Do the previous method because sets.ShareVolumeMode gets switched over once you click the button.
    {
        ArrayInitialize(sets.TPShare, 100 / sets.TakeProfitsNumber);
    }
    else if (sets.ShareVolumeMode == Increasing)
    {
        sets.TPShare[0] = 50;
        int remaining_volume = 50;
        for (int j = 1; j < sets.TakeProfitsNumber; j++)
        {
            if (j == sets.TakeProfitsNumber - 1) sets.TPShare[j] = remaining_volume;
            else sets.TPShare[j] = (int)MathRound((double)remaining_volume / 2.0);
            remaining_volume -= sets.TPShare[j];
        }
    }
    else if (sets.ShareVolumeMode == Equal)
    {
        sets.TPShare[sets.TakeProfitsNumber - 1] = 50;
        int remaining_volume = 50;
        for (int j = sets.TakeProfitsNumber - 2; j >= 0 ; j--)
        {
            if (j == 0) sets.TPShare[j] = remaining_volume;
            else sets.TPShare[j] = (int)MathRound((double)remaining_volume / 2.0);
            remaining_volume -= sets.TPShare[j];
        }
    }
    for (int j = 0; j < sets.TakeProfitsNumber; j++)
    {
        TradingTPShareEdits[j].Text(IntegerToString(sets.TPShare[j])); // Display.
    }
    ArrayResize(sets.WasSelectedAdditionalTakeProfitLine, sets.TakeProfitsNumber - 1); // -1 because the flag for the main TP is saved elsewhere.
    ArrayResize(ArrayPositionSize, sets.TakeProfitsNumber);
    ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(sets.TakeProfitsNumber));
    ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(sets.TakeProfitsNumber));
    ObjectDelete(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(sets.TakeProfitsNumber));

    HideShowMaximize(); // For panel resizing.
}

void CPositionSizeCalculator::OnEndEditEdtEntryLevel()
{
    sets.EntryLevel = StringToDouble(m_EdtEntryLevel.Text());
    if (tEntryLevel != sets.EntryLevel)
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.EntryLevel = NormalizeDouble(MathRound(sets.EntryLevel / TickSize) * TickSize, _Digits);
        tEntryLevel = sets.EntryLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtSL()
{
    if (!sets.SLDistanceInPoints)
    {
        double new_value = StringToDouble(m_EdtSL.Text());
        if (new_value == 0) // Not allowed.
        {
            m_EdtSL.Text(DoubleToString(sets.StopLossLevel, _Digits)); // Change back.
            return;
        }
        sets.StopLossLevel = new_value;
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.StopLossLevel = NormalizeDouble(MathRound(sets.StopLossLevel / TickSize) * TickSize, _Digits);
    }
    else
    {
        if ((int)StringToInteger(m_EdtSL.Text()) <= 0)
        {
            Print(TRANSLATION_MESSAGE_SL_SHOULD_BE_POSITIVE);
            m_EdtSL.Text(IntegerToString(sets.StopLoss));
        }
        else
        {
            sets.StopLoss = (int)StringToInteger(m_EdtSL.Text());
            // Check and adjust for TickSize granularity.
            if (TickSize > 0) sets.StopLoss = (int)MathRound(MathRound(sets.StopLoss * _Point / TickSize) * TickSize / _Point);
        }

        if (sets.TradeDirection == Long)
            sets.StopLossLevel = NormalizeDouble(sets.EntryLevel - sets.StopLoss * _Point, _Digits);
        else
            sets.StopLossLevel = NormalizeDouble(sets.EntryLevel + sets.StopLoss * _Point, _Digits);
    }
    if (tStopLossLevel != sets.StopLossLevel)
    {
        tStopLossLevel = sets.StopLossLevel;
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
        if (ShowATROptions) // Update ATR multiplier after the value was changed by the user.
        {
            double buf[1] = {0};
            if (ATR_handle != INVALID_HANDLE) CopyBuffer(ATR_handle, 0, (int)ATRCandle, 1, buf);
            double atr = buf[0];
            if (atr != 0) sets.ATRMultiplierSL = MathAbs(sets.StopLossLevel - sets.EntryLevel) / atr;
            m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2));
        }
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtTP()
{
    if (!sets.TPDistanceInPoints)
    {
        sets.TakeProfitLevel = StringToDouble(m_EdtTP.Text());
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.TakeProfitLevel = NormalizeDouble(MathRound(sets.TakeProfitLevel / TickSize) * TickSize, _Digits);
    }
    else
    {
        sets.TakeProfit = (int)StringToInteger(m_EdtTP.Text());
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) sets.TakeProfit = (int)MathRound(MathRound(sets.TakeProfit * _Point / TickSize) * TickSize / _Point);
        if (sets.TakeProfit > 0)
        {
            if (sets.TradeDirection == Long)
                sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel + sets.TakeProfit * _Point, _Digits);
            else
                sets.TakeProfitLevel = NormalizeDouble(sets.EntryLevel - sets.TakeProfit * _Point, _Digits);
        }
        else sets.TakeProfitLevel = 0;
    }

    if (tTakeProfitLevel != sets.TakeProfitLevel)
    {
        if ((PrefillAdditionalTPsBasedOnMain) && (sets.TakeProfitsNumber > 1))
        {
            if ((tTakeProfitLevel == 0) && (sets.TakeProfitLevel != 0)) // Was zero, became non-zero.
            {
                for (int i = 0; i < sets.TakeProfitsNumber; i++)
                {
                    if (i == 0) sets.TP[i] = sets.TakeProfitLevel;
                    else
                    {
                        TradingTPEdits[i].Text(DoubleToString(sets.EntryLevel + (sets.TakeProfitLevel - sets.EntryLevel) * double(sets.TakeProfitsNumber - i) / double(sets.TakeProfitsNumber)));
                        UpdateTradingTPEdit(i);
                    }
                }
            }
        }
        tTakeProfitLevel = sets.TakeProfitLevel;
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine") == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_HIDDEN, false);
            ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TOOLTIP, TRANSLATION_LABEL_TAKEPROFIT);
            // Create multiple TP lines.
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_STYLE, takeprofit_line_style);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_COLOR, takeprofit_line_color);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_WIDTH, takeprofit_line_width);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_HIDDEN, false);
                ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TOOLTIP, TRANSLATION_LABEL_TAKEPROFIT + " #" + IntegerToString(i + 1));
            }
        }
        else
        {
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
            // Move multiple TP lines.
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.TP[i]);
            }
        }

        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTABLE, true);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
        }

        if (StringToDouble(m_EdtTP.Text()) == 0) // Hide.
        {
            m_LblRR.Hide();
            m_EdtRR1.Hide();
            m_EdtRR2.Hide();
            m_LblReward.Hide();
            m_EdtReward1.Hide();
            m_EdtReward2.Hide();
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            }
            MoveAndResize();
        }
        else // Show.
        {
            DummyObjectSelect();
            ShowTPRelatedEdits();
            if (sets.ShowLines)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_BACK, false);
                if (ShowLineLabels)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                if (ShowAdditionalTPLabel)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
                }
                for (int i = 1; i < sets.TakeProfitsNumber; i++)
                {
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_BACK, false);
                    if (ShowLineLabels)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                    if (ShowAdditionalTPLabel)
                    {
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                    }
                }
                HideShowMaximize();
                MoveAndResize();
            }
        }
        if (ShowATROptions) // Update ATR multiplier after the line was moved by the user.
        {
            double buf[1] = {0};
            if (ATR_handle != INVALID_HANDLE) CopyBuffer(ATR_handle, 0, (int)ATRCandle, 1, buf);
            double atr = buf[0];
            if (atr != 0) sets.ATRMultiplierTP = MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / atr;
            m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
            // Untick spread adjustment checkbox as TP was set explicitly:
            m_ChkSpreadAdjustmentTP.Checked(false);
            sets.SpreadAdjustmentTP = false;
        }
        RefreshValues();
    }
}

// A public function to be run from event processing and from member functions.
void CPositionSizeCalculator::ShowTPRelatedEdits()
{
    m_LblRR.Show();
    if (InputRR != "") m_EdtRR1.Show();
    m_EdtRR2.Show();
    m_LblReward.Show();
    m_EdtReward1.Show();
    m_EdtReward2.Show();
}

void CPositionSizeCalculator::OnEndEditEdtStopPrice()
{
    sets.StopPriceLevel = StringToDouble(m_EdtStopPrice.Text());
    // Check and adjust for TickSize granularity.
    if (TickSize > 0) sets.StopPriceLevel = NormalizeDouble(MathRound(sets.StopPriceLevel / TickSize) * TickSize, _Digits);

    if (tStopPriceLevel != sets.StopPriceLevel)
    {
        tStopPriceLevel = sets.StopPriceLevel;
        if (ObjectFind(ChartID(), ObjectPrefix + "StopPriceLine") == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "StopPriceLine", OBJ_HLINE, 0, TimeCurrent(), sets.StopPriceLevel);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_STYLE, stopprice_line_style);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_COLOR, stopprice_line_color);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_WIDTH, stopprice_line_width);
        }
        else
        {
            ObjectSetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, sets.StopPriceLevel);
        }

        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTABLE, true);
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED, true);

        RefreshValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtCommissionSize()
{
    if (sets.CommissionPerLot != StringToDouble(m_EdtCommissionSize.Text()))
    {
        sets.CommissionPerLot = StringToDouble(m_EdtCommissionSize.Text());
        if (sets.CommissionType == COMMISSION_PERCENT) CommissionDecimals = CountDecimalPlaces(sets.CommissionPerLot);
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtAccount()
{
    string text = m_EdtAccount.Text();
    StringReplace(text, ",", ""); // Remove commas that might appear as the thousands separator due to number formatting.
    double field_value = StringToDouble(text);
    if (sets.CustomBalance != field_value)
    {
        if (field_value >= 0) sets.CustomBalance = field_value;
        RecalculatePositionSize();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtRiskPIn()
{
    string text = m_EdtRiskPIn.Text();
    StringReplace(text, ",", ""); // Remove commas that might appear as the thousands separator due to number formatting.
    double field_value = StringToDouble(text);
    sets.UseMoneyInsteadOfPercentage = false;
    sets.RiskFromPositionSize = false;
    if (sets.Risk != field_value)
    {
        sets.Risk = field_value;
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtRiskMIn()
{
    string text = m_EdtRiskMIn.Text();
    StringReplace(text, ",", "");
    double field_value = StringToDouble(text);
    sets.UseMoneyInsteadOfPercentage = true;
    sets.RiskFromPositionSize = false;
    if (sets.MoneyRisk != field_value)
    {
        sets.MoneyRisk = field_value;
        CalculateRiskAndPositionSize();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtPosSize()
{
    string text = m_EdtPosSize.Text();
    StringReplace(text, ",", "");
    double field_value = StringToDouble(text);
    if (field_value >= 0)
    {
        if (OutputPositionSize != field_value)
        {
            OutputPositionSize = field_value;
            sets.PositionSize = OutputPositionSize;
            sets.RiskFromPositionSize = true;
            CalculateRiskAndPositionSize();
            DisplayValues();
        }
    }
    else
    {
        m_EdtPosSize.Text(FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits));
    }
}

void CPositionSizeCalculator::OnEndEditATRPeriod()
{
    int i_val = (int)StringToInteger(m_EdtATRPeriod.Text());
    if (i_val > 0)
    {
        if (sets.ATRPeriod != i_val)
        {
            sets.ATRPeriod = i_val;
            InitATR();
            RefreshValues();
        }
        m_EdtATRPeriod.Text(IntegerToString(i_val));
    }
    else m_EdtATRPeriod.Text(IntegerToString(sets.ATRPeriod));
}

void CPositionSizeCalculator::OnEndEditATRMultiplierSL()
{
    double d_val = StringToDouble(m_EdtATRMultiplierSL.Text());
    if (d_val >= 0)
    {
        if (sets.ATRMultiplierSL != d_val)
        {
            sets.ATRMultiplierSL = d_val;
            RefreshValues();
        }
        m_EdtATRMultiplierSL.Text(DoubleToString(d_val, 2));
    }
    else m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2));
}

void CPositionSizeCalculator::OnChangeChkSpreadAdjustmentSL()
{
    if (sets.SpreadAdjustmentSL != m_ChkSpreadAdjustmentSL.Checked())
    {
        sets.SpreadAdjustmentSL = m_ChkSpreadAdjustmentSL.Checked();
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnEndEditATRMultiplierTP()
{
    double d_val = StringToDouble(m_EdtATRMultiplierTP.Text());
    if (d_val >= 0)
    {
        if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        if (sets.ATRMultiplierTP != d_val)
        {
            if (d_val == 0) // Remove TP if zero multiplier is given.
            {
                sets.TakeProfitLevel = 0;
                sets.TakeProfit = 0;
                ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0, 0);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                m_LblRR.Hide();
                m_EdtRR1.Hide();
                m_EdtRR2.Hide();
                m_LblReward.Hide();
                m_EdtReward1.Hide();
                m_EdtReward2.Hide();
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                sets.ATRMultiplierTP = d_val;
                MoveAndResize();
                RefreshValues();
            }
            else if (sets.ATRMultiplierTP == 0) // Was zero.
            {
                ShowTPRelatedEdits();
                sets.ATRMultiplierTP = d_val;
                RefreshValues();
                MoveAndResize();
            }
            else
            {
                sets.ATRMultiplierTP = d_val;
                RefreshValues();
            }
        }
        m_EdtATRMultiplierTP.Text(DoubleToString(d_val, 2));
    }
    else m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
}

void CPositionSizeCalculator::OnChangeChkSpreadAdjustmentTP()
{
    if (sets.SpreadAdjustmentTP != m_ChkSpreadAdjustmentTP.Checked())
    {
        sets.SpreadAdjustmentTP = m_ChkSpreadAdjustmentTP.Checked();
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnChangeChkCountPendings()
{
    if (sets.CountPendingOrders != m_ChkCountPendings.Checked())
    {
        sets.CountPendingOrders = m_ChkCountPendings.Checked();
        CalculatePortfolioRisk();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnChangeChkIgnoreOrdersWithoutSL()
{
    if (sets.IgnoreOrdersWithoutSL != m_ChkIgnoreOrdersWithoutSL.Checked())
    {
        sets.IgnoreOrdersWithoutSL = m_ChkIgnoreOrdersWithoutSL.Checked();
        CalculatePortfolioRisk();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnChangeChkIgnoreOrdersWithoutTP()
{
    if (sets.IgnoreOrdersWithoutTP != m_ChkIgnoreOrdersWithoutTP.Checked())
    {
        sets.IgnoreOrdersWithoutTP = m_ChkIgnoreOrdersWithoutTP.Checked();
        CalculatePortfolioRisk();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnChangeChkIgnoreOtherSymbols()
{
    if (sets.IgnoreOtherSymbols != m_ChkIgnoreOtherSymbols.Checked())
    {
        sets.IgnoreOtherSymbols = m_ChkIgnoreOtherSymbols.Checked();
        CalculatePortfolioRisk();
        DisplayValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtCustomLeverage()
{
    sets.CustomLeverage = StringToDouble(m_EdtCustomLeverage.Text());
    if (CustomLeverage != sets.CustomLeverage)
    {
        CustomLeverage = sets.CustomLeverage;
        CustomLeverageDecimals = CountDecimalPlaces(CustomLeverage);
        RefreshValues();
    }
}

void CPositionSizeCalculator::OnEndEditEdtMagicNumber()
{
    sets.MagicNumber = (int)StringToInteger(m_EdtMagicNumber.Text());
    if (sets.MagicNumber < 0)
    {
        sets.MagicNumber = -sets.MagicNumber;
        m_EdtMagicNumber.Text(IntegerToString(sets.MagicNumber));
    }
}

void CPositionSizeCalculator::OnEndEditEdtCommentary()
{
    sets.Commentary = m_EdtCommentary.Text();
}

void CPositionSizeCalculator::OnChangeChkDisableTradingWhenLinesAreHidden()
{
    sets.DisableTradingWhenLinesAreHidden = m_ChkDisableTradingWhenLinesAreHidden.Checked();
}

void CPositionSizeCalculator::OnEndEditEdtMaxSlippage()
{
    sets.MaxSlippage = (int)StringToInteger(m_EdtMaxSlippage.Text());
}

void CPositionSizeCalculator::OnEndEditEdtMaxSpread()
{
    sets.MaxSpread = (int)StringToInteger(m_EdtMaxSpread.Text());
}

void CPositionSizeCalculator::OnEndEditEdtMaxEntrySLDistance()
{
    sets.MaxEntrySLDistance = (int)StringToInteger(m_EdtMaxEntrySLDistance.Text());
}

void CPositionSizeCalculator::OnEndEditEdtMinEntrySLDistance()
{
    sets.MinEntrySLDistance = (int)StringToInteger(m_EdtMinEntrySLDistance.Text());
}

void CPositionSizeCalculator::OnEndEditEdtMaxPositionSizeTotal()
{
    sets.MaxPositionSizeTotal = (double)StringToDouble(m_EdtMaxPositionSizeTotal.Text());
    // Only allow changing the total value to be no lower than the per symbol value. Zero is an exception.
    if ((sets.MaxPositionSizeTotal < sets.MaxPositionSizePerSymbol) && (sets.MaxPositionSizeTotal != 0)) sets.MaxPositionSizeTotal = sets.MaxPositionSizePerSymbol;
    m_EdtMaxPositionSizeTotal.Text(DoubleToString(sets.MaxPositionSizeTotal, LotStep_digits));
}

void CPositionSizeCalculator::OnEndEditEdtMaxPositionSizePerSymbol()
{
    sets.MaxPositionSizePerSymbol = (double)StringToDouble(m_EdtMaxPositionSizePerSymbol.Text());
    // Only allow changing the per symbol value to be no greater than the per symbol value. Zero is an exception.
    if ((sets.MaxPositionSizePerSymbol > sets.MaxPositionSizeTotal) && (sets.MaxPositionSizeTotal != 0)) sets.MaxPositionSizePerSymbol = sets.MaxPositionSizeTotal;
    m_EdtMaxPositionSizePerSymbol.Text(DoubleToString(sets.MaxPositionSizePerSymbol, LotStep_digits));
}

void CPositionSizeCalculator::OnChangeChkSubtractPositions()
{
    sets.SubtractPositions = m_ChkSubtractPositions.Checked();
}

void CPositionSizeCalculator::OnChangeChkSubtractPendingOrders()
{
    sets.SubtractPendingOrders = m_ChkSubtractPendingOrders.Checked();
}

void CPositionSizeCalculator::OnChangeChkDoNotApplyStopLoss()
{
    sets.DoNotApplyStopLoss = m_ChkDoNotApplyStopLoss.Checked();
}

void CPositionSizeCalculator::OnChangeChkDoNotApplyTakeProfit()
{
    sets.DoNotApplyTakeProfit = m_ChkDoNotApplyTakeProfit.Checked();
}

void CPositionSizeCalculator::OnChangeChkAskForConfirmation()
{
    sets.AskForConfirmation = m_ChkAskForConfirmation.Checked();
}

void CPositionSizeCalculator::OnChangeChkCommentAutoSuffix()
{
    sets.CommentAutoSuffix = m_ChkCommentAutoSuffix.Checked();
}

void CPositionSizeCalculator::OnEndEditEdtTrailingStopPoints()
{
    sets.TrailingStopPoints = (int)StringToInteger(m_EdtTrailingStopPoints.Text());
    m_EdtTrailingStopPoints.Text(IntegerToString(sets.TrailingStopPoints));
}

void CPositionSizeCalculator::OnEndEditEdtBreakEvenPoints()
{
    sets.BreakEvenPoints = (int)StringToInteger(m_EdtBreakEvenPoints.Text());
    m_EdtBreakEvenPoints.Text(IntegerToString(sets.BreakEvenPoints));
}

void CPositionSizeCalculator::OnEndEditEdtMaxNumberOfTradesTotal()
{
    sets.MaxNumberOfTradesTotal = (int)StringToInteger(m_EdtMaxNumberOfTradesTotal.Text());
    // Only allow changing the total value to be no lower than the per symbol value. Zero is an exception.
    if ((sets.MaxNumberOfTradesTotal < sets.MaxNumberOfTradesPerSymbol) && (sets.MaxNumberOfTradesTotal != 0)) sets.MaxNumberOfTradesTotal = sets.MaxNumberOfTradesPerSymbol;
    m_EdtMaxNumberOfTradesTotal.Text(IntegerToString(sets.MaxNumberOfTradesTotal));
}

void CPositionSizeCalculator::OnEndEditEdtMaxNumberOfTradesPerSymbol()
{
    sets.MaxNumberOfTradesPerSymbol = (int)StringToInteger(m_EdtMaxNumberOfTradesPerSymbol.Text());
    // Only allow changing the per symbol value to be no greater than the per symbol value. Zero is an exception.
    if ((sets.MaxNumberOfTradesPerSymbol > sets.MaxNumberOfTradesTotal) && (sets.MaxNumberOfTradesTotal != 0)) sets.MaxNumberOfTradesPerSymbol = sets.MaxNumberOfTradesTotal;
    m_EdtMaxNumberOfTradesPerSymbol.Text(IntegerToString(sets.MaxNumberOfTradesPerSymbol));
}

void CPositionSizeCalculator::OnEndEditEdtMaxRiskTotal()
{
    sets.MaxRiskTotal = StringToDouble(m_EdtMaxRiskTotal.Text());
    // Only allow changing the total value to be no lower than the per symbol value. Zero is an exception.
    if ((sets.MaxRiskTotal < sets.MaxRiskPerSymbol) && (sets.MaxRiskTotal != 0)) sets.MaxRiskTotal = sets.MaxRiskPerSymbol;
    m_EdtMaxRiskTotal.Text(DoubleToString(sets.MaxRiskTotal, 2));
}

void CPositionSizeCalculator::OnEndEditEdtMaxRiskPerSymbol()
{
    sets.MaxRiskPerSymbol = StringToDouble(m_EdtMaxRiskPerSymbol.Text());
    // Only allow changing the per symbol value to be no greater than the per symbol value. Zero is an exception.
    if ((sets.MaxRiskPerSymbol > sets.MaxRiskTotal) && (sets.MaxRiskTotal != 0)) sets.MaxRiskPerSymbol = sets.MaxRiskTotal;
    m_EdtMaxRiskPerSymbol.Text(DoubleToString(sets.MaxRiskPerSymbol, 2));
}

void CPositionSizeCalculator::OnEndEditEdtExpiry()
{
    sets.ExpiryMinutes = (int)StringToInteger(m_EdtExpiry.Text());
    if ((sets.ExpiryMinutes != 0) && (sets.ExpiryMinutes < 2))
    {
        sets.ExpiryMinutes = 0;
        Print(TRANSLATION_MESSAGE_MINIMUM_EXPIRY);
    }
    m_EdtExpiry.Text(IntegerToString(sets.ExpiryMinutes));
}

//+-----------------------+
//| Working with settings |
//|+----------------------+
bool CPositionSizeCalculator::SaveSettingsOnDisk(string symbol = "")
{
    Print(TRANSLATION_MESSAGE_TRYING_TO_SAVE_FILE + ": " + m_FileName + ".");

    int fh;
    // Save to new format only.
    fh = FileOpen("PS_Settings\\" + m_FileName, FILE_CSV | FILE_WRITE);
    if (fh == INVALID_HANDLE)
    {
        Print(TRANSLATION_MESSAGE_FAILED_TO_OPEN_FOR_WRITING + ": PS_Settings\\" + m_FileName + ". " + TRANSLATION_MESSAGE_ERROR + ": " + IntegerToString(GetLastError()));
        return false;
    }

    int digits = _Digits;
    if (symbol != "") // If saving the settings from within OnInit() in CHARTCHANGE case.
    {
        digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS); // Hence, using the previous symbol's parameters.
    }

    // Order does not matter.
    FileWrite(fh, "EntryType");
    FileWrite(fh, IntegerToString(sets.EntryType));
    FileWrite(fh, "EntryLevel");
    FileWrite(fh, DoubleToString(sets.EntryLevel, digits));
    FileWrite(fh, "StopLossLevel");
    FileWrite(fh, DoubleToString(sets.StopLossLevel, digits));
    FileWrite(fh, "TakeProfitLevel");
    FileWrite(fh, DoubleToString(sets.TakeProfitLevel, digits));
    FileWrite(fh, "TakeProfitsNumber");
    FileWrite(fh, IntegerToString(sets.TakeProfitsNumber));
    FileWrite(fh, "StopPriceLevel");
    FileWrite(fh, DoubleToString(sets.StopPriceLevel, digits));
    FileWrite(fh, "Risk");
    FileWrite(fh, DoubleToString(sets.Risk, 2));
    FileWrite(fh, "MoneyRisk");
    FileWrite(fh, DoubleToString(sets.MoneyRisk, AccountCurrencyDigits));
    FileWrite(fh, "CommissionPerLot");
    FileWrite(fh, DoubleToString(sets.CommissionPerLot, CommissionDecimals));
    FileWrite(fh, "CommissionType");
    FileWrite(fh, IntegerToString(sets.CommissionType));
    FileWrite(fh, "CustomBalance");
    FileWrite(fh, DoubleToString(sets.CustomBalance, AccountCurrencyDigits));
    FileWrite(fh, "UseMoneyInsteadOfPercentage");
    FileWrite(fh, IntegerToString(sets.UseMoneyInsteadOfPercentage));
    FileWrite(fh, "RiskFromPositionSize");
    FileWrite(fh, IntegerToString(sets.RiskFromPositionSize));
    if (sets.RiskFromPositionSize)
    {
        FileWrite(fh, "PositionSize");
        FileWrite(fh, DoubleToString(sets.PositionSize, LotStep_digits));
    }
    FileWrite(fh, "AccountButton");
    FileWrite(fh, IntegerToString(sets.AccountButton));
    FileWrite(fh, "CountPendingOrders");
    FileWrite(fh, IntegerToString(sets.CountPendingOrders));
    FileWrite(fh, "IgnoreOrdersWithoutSL");
    FileWrite(fh, IntegerToString(sets.IgnoreOrdersWithoutSL));
    FileWrite(fh, "IgnoreOrdersWithoutTP");
    FileWrite(fh, IntegerToString(sets.IgnoreOrdersWithoutTP));
    FileWrite(fh, "IgnoreOtherSymbols");
    FileWrite(fh, IntegerToString(sets.IgnoreOtherSymbols));
    FileWrite(fh, "ShowLines");
    FileWrite(fh, IntegerToString(sets.ShowLines));
    FileWrite(fh, "SelectedTab");
    FileWrite(fh, IntegerToString(sets.SelectedTab));
    FileWrite(fh, "CustomLeverage");
    FileWrite(fh, DoubleToString(sets.CustomLeverage));
    FileWrite(fh, "MagicNumber");
    FileWrite(fh, IntegerToString(sets.MagicNumber));
    FileWrite(fh, "Commentary");
    FileWrite(fh, sets.Commentary);
    FileWrite(fh, "DisableTradingWhenLinesAreHidden");
    FileWrite(fh, IntegerToString(sets.DisableTradingWhenLinesAreHidden));
    // Multiple TPs in use.
    if (sets.TakeProfitsNumber > 1)
    {
        for (int i = 0; i < sets.TakeProfitsNumber; i++)
        {
            FileWrite(fh, "TP_" + IntegerToString(i));
            FileWrite(fh, DoubleToString(sets.TP[i], digits));
            FileWrite(fh, "TPShare_" + IntegerToString(i));
            FileWrite(fh, IntegerToString(sets.TPShare[i]));
        }
    }
    FileWrite(fh, "MaxSlippage");
    FileWrite(fh, IntegerToString(sets.MaxSlippage));
    FileWrite(fh, "MaxSpread");
    FileWrite(fh, IntegerToString(sets.MaxSpread));
    FileWrite(fh, "MaxEntrySLDistance");
    FileWrite(fh, IntegerToString(sets.MaxEntrySLDistance));
    FileWrite(fh, "MinEntrySLDistance");
    FileWrite(fh, IntegerToString(sets.MinEntrySLDistance));
    FileWrite(fh, "SLDistanceInPoints");
    FileWrite(fh, IntegerToString(sets.SLDistanceInPoints));
    FileWrite(fh, "TPDistanceInPoints");
    FileWrite(fh, IntegerToString(sets.TPDistanceInPoints));
    FileWrite(fh, "StopLoss");
    FileWrite(fh, IntegerToString(sets.StopLoss));
    FileWrite(fh, "TakeProfit");
    FileWrite(fh, IntegerToString(sets.TakeProfit));
    FileWrite(fh, "TradeDirection");
    FileWrite(fh, IntegerToString(sets.TradeDirection));
    FileWrite(fh, "SubtractPositions");
    FileWrite(fh, IntegerToString(sets.SubtractPositions));
    FileWrite(fh, "SubtractPendingOrders");
    FileWrite(fh, IntegerToString(sets.SubtractPendingOrders));
    FileWrite(fh, "ATRPeriod");
    FileWrite(fh, IntegerToString(sets.ATRPeriod));
    FileWrite(fh, "ATRMultiplierSL");
    FileWrite(fh, DoubleToString(sets.ATRMultiplierSL, 2));
    FileWrite(fh, "ATRMultiplierTP");
    FileWrite(fh, DoubleToString(sets.ATRMultiplierTP, 2));
    FileWrite(fh, "ATRTimeframe");
    FileWrite(fh, IntegerToString(sets.ATRTimeframe));
    FileWrite(fh, "SpreadAdjustmentSL");
    FileWrite(fh, IntegerToString(sets.SpreadAdjustmentSL));
    FileWrite(fh, "SpreadAdjustmentTP");
    FileWrite(fh, IntegerToString(sets.SpreadAdjustmentTP));
    FileWrite(fh, "WasSelectedEntryLine");
    FileWrite(fh, IntegerToString(sets.WasSelectedEntryLine));
    FileWrite(fh, "WasSelectedStopLossLine");
    FileWrite(fh, IntegerToString(sets.WasSelectedStopLossLine));
    FileWrite(fh, "WasSelectedTakeProfitLine");
    FileWrite(fh, IntegerToString(sets.WasSelectedTakeProfitLine));
    FileWrite(fh, "WasSelectedStopPriceLine");
    FileWrite(fh, IntegerToString(sets.WasSelectedStopPriceLine));
    // Multiple TPs in use.
    if (sets.TakeProfitsNumber > 1)
    {
        for (int i = 0; i < sets.TakeProfitsNumber - 1; i++)
        {
            FileWrite(fh, "WasSelectedAdditionalTakeProfitLine_" + IntegerToString(i));
            FileWrite(fh, IntegerToString(sets.WasSelectedAdditionalTakeProfitLine[i]));
        }
    }
    FileWrite(fh, "DoNotApplyStopLoss");
    FileWrite(fh, IntegerToString(sets.DoNotApplyStopLoss));
    FileWrite(fh, "DoNotApplyTakeProfit");
    FileWrite(fh, IntegerToString(sets.DoNotApplyTakeProfit));
    FileWrite(fh, "AskForConfirmation");
    FileWrite(fh, IntegerToString(sets.AskForConfirmation));
    FileWrite(fh, "CommentAutoSuffix");
    FileWrite(fh, IntegerToString(sets.CommentAutoSuffix));
    FileWrite(fh, "TrailingStopPoints");
    FileWrite(fh, IntegerToString(sets.TrailingStopPoints));
    FileWrite(fh, "BreakEvenPoints");
    FileWrite(fh, IntegerToString(sets.BreakEvenPoints));
    FileWrite(fh, "ExpiryMinutes");
    FileWrite(fh, IntegerToString(sets.ExpiryMinutes));
    FileWrite(fh, "MaxNumberOfTradesTotal");
    FileWrite(fh, IntegerToString(sets.MaxNumberOfTradesTotal));
    FileWrite(fh, "MaxNumberOfTradesPerSymbol");
    FileWrite(fh, IntegerToString(sets.MaxNumberOfTradesPerSymbol));
    FileWrite(fh, "MaxPositionSizeTotal");
    FileWrite(fh, DoubleToString(sets.MaxPositionSizeTotal, LotStep_digits));
    FileWrite(fh, "MaxPositionSizePerSymbol");
    FileWrite(fh, DoubleToString(sets.MaxPositionSizePerSymbol, LotStep_digits));
    FileWrite(fh, "MaxRiskTotal");
    FileWrite(fh, DoubleToString(sets.MaxRiskTotal, 2));
    FileWrite(fh, "MaxRiskPerSymbol");
    FileWrite(fh, DoubleToString(sets.MaxRiskPerSymbol, 2));
    FileWrite(fh, "IsPanelMinimized");
    FileWrite(fh, IntegerToString(sets.IsPanelMinimized));
    FileWrite(fh, "TPLockedOnSL");
    FileWrite(fh, IntegerToString(sets.TPLockedOnSL));
    FileWrite(fh, "ShareVolumeMode");
    FileWrite(fh, IntegerToString(sets.ShareVolumeMode));
    FileWrite(fh, "TemplateChanged");
    FileWrite(fh, IntegerToString(sets.TemplateChanged));

    // These are not part of settings but are panel-related input parameters.
    // When the EA is reloaded due to its input parameters change, these should be compared to the new values.
    // If the value is changed, it should be updated in the panel too.
    // Is the EA reloading due to the input parameters change?
    if (GlobalVariableGet("PS-" + IntegerToString(ChartID()) + "-Parameters") > 0)
    {
        FileWrite(fh, "Parameter_DefaultTradeDirection");
        FileWrite(fh, IntegerToString(DefaultTradeDirection));
        FileWrite(fh, "Parameter_DefaultSL");
        FileWrite(fh, IntegerToString(DefaultSL));
        FileWrite(fh, "Parameter_DefaultTP");
        FileWrite(fh, IntegerToString(DefaultTP));
        FileWrite(fh, "Parameter_DefaultShowLines");
        FileWrite(fh, IntegerToString(DefaultShowLines));
        FileWrite(fh, "Parameter_DefaultLinesSelected");
        FileWrite(fh, IntegerToString(DefaultLinesSelected));
        FileWrite(fh, "Parameter_DefaultATRPeriod");
        FileWrite(fh, IntegerToString(DefaultATRPeriod));
        FileWrite(fh, "Parameter_DefaultATRMultiplierSL");
        FileWrite(fh, DoubleToString(DefaultATRMultiplierSL, 2));
        FileWrite(fh, "Parameter_DefaultATRMultiplierTP");
        FileWrite(fh, DoubleToString(DefaultATRMultiplierTP, 2));
        FileWrite(fh, "Parameter_DefaultATRTimeframe");
        FileWrite(fh, IntegerToString(DefaultATRTimeframe));
        FileWrite(fh, "Parameter_DefaultEntryType");
        FileWrite(fh, IntegerToString(DefaultEntryType));
        FileWrite(fh, "Parameter_DefaultCommission");
        FileWrite(fh, DoubleToString(DefaultCommission, CommissionDecimals));
        FileWrite(fh, "Parameter_DefaultCommissionType");
        FileWrite(fh, IntegerToString(DefaultCommissionType));
        FileWrite(fh, "Parameter_DefaultAccountButton");
        FileWrite(fh, IntegerToString(DefaultAccountButton));
        FileWrite(fh, "Parameter_CustomBalance");
        FileWrite(fh, DoubleToString(CustomBalance));
        FileWrite(fh, "Parameter_DefaultRisk");
        FileWrite(fh, DoubleToString(DefaultRisk, 2));
        FileWrite(fh, "Parameter_DefaultMoneyRisk");
        FileWrite(fh, DoubleToString(DefaultMoneyRisk, AccountCurrencyDigits));
        FileWrite(fh, "Parameter_DefaultPositionSize");
        FileWrite(fh, DoubleToString(DefaultPositionSize, LotStep_digits));
        FileWrite(fh, "Parameter_DefaultCountPendingOrders");
        FileWrite(fh, IntegerToString(DefaultCountPendingOrders));
        FileWrite(fh, "Parameter_DefaultIgnoreOrdersWithoutSL");
        FileWrite(fh, IntegerToString(DefaultIgnoreOrdersWithoutSL));
        FileWrite(fh, "Parameter_DefaultIgnoreOrdersWithoutTP");
        FileWrite(fh, IntegerToString(DefaultIgnoreOrdersWithoutTP));
        FileWrite(fh, "Parameter_DefaultIgnoreOtherSymbols");
        FileWrite(fh, IntegerToString(DefaultIgnoreOtherSymbols));
        FileWrite(fh, "Parameter_DefaultCustomLeverage");
        FileWrite(fh, DoubleToString(DefaultCustomLeverage));
        FileWrite(fh, "Parameter_DefaultMagicNumber");
        FileWrite(fh, IntegerToString(DefaultMagicNumber));
        FileWrite(fh, "Parameter_DefaultCommentary");
        FileWrite(fh, DefaultCommentary);
        FileWrite(fh, "Parameter_DefaultCommentAutoSuffix");
        FileWrite(fh, IntegerToString(DefaultCommentAutoSuffix));
        FileWrite(fh, "Parameter_DefaultDisableTradingWhenLinesAreHidden");
        FileWrite(fh, IntegerToString(DefaultDisableTradingWhenLinesAreHidden));
        FileWrite(fh, "Parameter_DefaultMaxSlippage");
        FileWrite(fh, IntegerToString(DefaultMaxSlippage));
        FileWrite(fh, "Parameter_DefaultMaxSpread");
        FileWrite(fh, IntegerToString(DefaultMaxSpread));
        FileWrite(fh, "Parameter_DefaultMaxEntrySLDistance");
        FileWrite(fh, IntegerToString(DefaultMaxEntrySLDistance));
        FileWrite(fh, "Parameter_DefaultMinEntrySLDistance");
        FileWrite(fh, IntegerToString(DefaultMinEntrySLDistance));
        FileWrite(fh, "Parameter_DefaultMaxPositionSizeTotal");
        FileWrite(fh, DoubleToString(DefaultMaxPositionSizeTotal, LotStep_digits));
        FileWrite(fh, "Parameter_DefaultMaxPositionSizePerSymbol");
        FileWrite(fh, DoubleToString(DefaultMaxPositionSizePerSymbol, LotStep_digits));
        FileWrite(fh, "Parameter_DefaultSubtractOPV");
        FileWrite(fh, IntegerToString(DefaultSubtractOPV));
        FileWrite(fh, "Parameter_DefaultSubtractPOV");
        FileWrite(fh, IntegerToString(DefaultSubtractPOV));
        FileWrite(fh, "Parameter_DefaultDoNotApplyStopLoss");
        FileWrite(fh, IntegerToString(DefaultDoNotApplyStopLoss));
        FileWrite(fh, "Parameter_DefaultDoNotApplyTakeProfit");
        FileWrite(fh, IntegerToString(DefaultDoNotApplyTakeProfit));
        FileWrite(fh, "Parameter_DefaultAskForConfirmation");
        FileWrite(fh, IntegerToString(DefaultAskForConfirmation));
        FileWrite(fh, "Parameter_DefaultPanelPositionCorner");
        FileWrite(fh, IntegerToString(DefaultPanelPositionCorner));
        FileWrite(fh, "Parameter_DefaultPanelPositionX");
        FileWrite(fh, IntegerToString(DefaultPanelPositionX));
        FileWrite(fh, "Parameter_DefaultPanelPositionY");
        FileWrite(fh, IntegerToString(DefaultPanelPositionY));
        FileWrite(fh, "Parameter_DefaultTPLockedOnSL");
        FileWrite(fh, IntegerToString(DefaultTPLockedOnSL));
        FileWrite(fh, "Parameter_DefaultTrailingStop");
        FileWrite(fh, IntegerToString(DefaultTrailingStop));
        FileWrite(fh, "Parameter_DefaultBreakEven");
        FileWrite(fh, IntegerToString(DefaultBreakEven));
        FileWrite(fh, "Parameter_DefaultExpiryMinutes");
        FileWrite(fh, IntegerToString(DefaultExpiryMinutes));
        FileWrite(fh, "Parameter_DefaultSpreadAdjustmentSL");
        FileWrite(fh, IntegerToString(DefaultSpreadAdjustmentSL));
        FileWrite(fh, "Parameter_DefaultSpreadAdjustmentTP");
        FileWrite(fh, IntegerToString(DefaultSpreadAdjustmentTP));
        FileWrite(fh, "Parameter_DefaultMaxNumberOfTradesTotal");
        FileWrite(fh, IntegerToString(DefaultMaxNumberOfTradesTotal));
        FileWrite(fh, "Parameter_DefaultMaxNumberOfTradesPerSymbol");
        FileWrite(fh, IntegerToString(DefaultMaxNumberOfTradesPerSymbol));
        FileWrite(fh, "Parameter_DefaultMaxRiskTotal");
        FileWrite(fh, DoubleToString(DefaultMaxRiskTotal));
        FileWrite(fh, "Parameter_DefaultMaxRiskPerSymbol");
        FileWrite(fh, DoubleToString(DefaultMaxRiskPerSymbol));
        // Not a part of sets, but needed for proper deletion of unnecessary additional TP lines.
        FileWrite(fh, "Parameter_DefaultTakeProfitsNumber");
        FileWrite(fh, IntegerToString(DefaultTakeProfitsNumber));
        FileWrite(fh, "Parameter_DefaultSLDistanceInPoints");
        FileWrite(fh, IntegerToString(DefaultSLDistanceInPoints));
        FileWrite(fh, "Parameter_DefaultTPDistanceInPoints");
        FileWrite(fh, IntegerToString(DefaultTPDistanceInPoints));
    }

    FileClose(fh);

    Print(TRANSLATION_MESSAGE_SAVED_SETTINGS);
    return true;
}

bool CPositionSizeCalculator::LoadSettingsFromDisk()
{
    Print(TRANSLATION_MESSAGE_TRYING_TO_LOAD_FILE);

    int fh;

    if (FileIsExist("PS_Settings\\" + m_FileName)) // New format settings file found.
    {
        fh = FileOpen("PS_Settings\\" + m_FileName, FILE_CSV | FILE_READ);
        if (fh == INVALID_HANDLE)
        {
            Print(TRANSLATION_MESSAGE_FAILED_TO_OPEN_FOR_READING + ": PS_Settings\\" + m_FileName + ". " + TRANSLATION_MESSAGE_ERROR + ": " + IntegerToString(GetLastError()));
            return false;
        }
    }
    else // No new format file, try to load old format.
    {
        if (!FileIsExist("PS_" + m_FileName))
        {
            Print(TRANSLATION_MESSAGE_NO_SETTINGS_FILE_TO_LOAD);
            return false;
        }
        fh = FileOpen("PS_" + m_FileName, FILE_CSV | FILE_READ);
        if (fh == INVALID_HANDLE)
        {
            Print(TRANSLATION_MESSAGE_FAILED_TO_OPEN_FOR_READING + ": PS_" + m_FileName + ". " + TRANSLATION_MESSAGE_ERROR + ": " + IntegerToString(GetLastError()));
            return false;
        }
    }

    while (!FileIsEnding(fh))
    {
        string var_name = FileReadString(fh);
        string var_content = FileReadString(fh);
        if (var_name == "EntryType")
            sets.EntryType = (ENTRY_TYPE)StringToInteger(var_content);
        else if (var_name == "EntryLevel")
            sets.EntryLevel = StringToDouble(var_content);
        else if (var_name == "StopLossLevel")
            sets.StopLossLevel = StringToDouble(var_content);
        else if (var_name == "TakeProfitLevel")
            sets.TakeProfitLevel = StringToDouble(var_content);
        else if (var_name == "TakeProfitsNumber")
        {
            sets.TakeProfitsNumber = (int)StringToInteger(var_content);
            // Resize and initialize arrays for multiple TPs.
            if (sets.TakeProfitsNumber > 1)
            {
                ArrayResize(sets.TP, sets.TakeProfitsNumber);
                ArrayResize(sets.TPShare, sets.TakeProfitsNumber);
                ArrayInitialize(sets.TP, 0);
                ArrayInitialize(sets.TPShare, 100 / sets.TakeProfitsNumber);
                ArrayResize(sets.WasSelectedAdditionalTakeProfitLine, sets.TakeProfitsNumber - 1); // -1 because the flag for the main TP is saved elsewhere.
            }
            ArrayResize(TakeProfitLineIsBeingMoved, sets.TakeProfitsNumber);
            ArrayInitialize(TakeProfitLineIsBeingMoved, false);
        }
        else if (var_name == "StopPriceLevel")
            sets.StopPriceLevel = StringToDouble(var_content);
        else if (var_name == "Risk")
            sets.Risk = StringToDouble(var_content);
        else if (var_name == "MoneyRisk")
            sets.MoneyRisk = StringToDouble(var_content);
        else if (var_name == "CommissionPerLot")
            sets.CommissionPerLot = StringToDouble(var_content);
        else if (var_name == "CommissionType")
            sets.CommissionType = (COMMISSION_TYPE)StringToInteger(var_content);
        else if (var_name == "CustomBalance")
            sets.CustomBalance = StringToDouble(var_content);
        else if (var_name == "UseMoneyInsteadOfPercentage")
            sets.UseMoneyInsteadOfPercentage = (bool)StringToInteger(var_content);
        else if (var_name == "RiskFromPositionSize")
            sets.RiskFromPositionSize = (bool)StringToInteger(var_content);
        else if ((var_name == "PositionSize") && (sets.RiskFromPositionSize))
        {
            sets.PositionSize = StringToDouble(var_content);
            OutputPositionSize = sets.PositionSize;
        }
        else if (var_name == "AccountButton")
            sets.AccountButton = (ACCOUNT_BUTTON)StringToInteger(var_content);
        else if (var_name == "CountPendingOrders")
            sets.CountPendingOrders = (bool)StringToInteger(var_content);
        else if (var_name == "IgnoreOrdersWithoutSL")
            sets.IgnoreOrdersWithoutSL = (bool)StringToInteger(var_content);
        else if (var_name == "IgnoreOrdersWithoutTP")
            sets.IgnoreOrdersWithoutTP = (bool)StringToInteger(var_content);
        else if (var_name == "IgnoreOtherSymbols")
            sets.IgnoreOtherSymbols = (bool)StringToInteger(var_content);
        else if (var_name == "ShowLines")
            sets.ShowLines = (bool)StringToInteger(var_content);
        else if (var_name == "SelectedTab")
            sets.SelectedTab = (TABS)StringToInteger(var_content);
        else if (var_name == "CustomLeverage")
            sets.CustomLeverage = StringToDouble(var_content);
        else if (var_name == "MagicNumber")
            sets.MagicNumber = (int)StringToInteger(var_content);
        else if (var_name == "Commentary")
            sets.Commentary = var_content;
        else if (var_name == "CommentAutoSuffix")
            sets.CommentAutoSuffix = (bool)StringToInteger(var_content);
        else if (var_name == "TrailingStopPoints")
            sets.TrailingStopPoints = (int)StringToInteger(var_content);
        else if (var_name == "BreakEvenPoints")
            sets.BreakEvenPoints = (int)StringToInteger(var_content);
        else if (var_name == "ExpiryMinutes")
        {
            sets.ExpiryMinutes = (int)StringToInteger(var_content);
            if ((sets.ExpiryMinutes != 0) && (sets.ExpiryMinutes < 2)) sets.ExpiryMinutes = 0;
        }
        else if (var_name == "MaxNumberOfTradesTotal")
            sets.MaxNumberOfTradesTotal = (int)StringToInteger(var_content);
        else if (var_name == "MaxNumberOfTradesPerSymbol")
            sets.MaxNumberOfTradesPerSymbol = (int)StringToInteger(var_content);
        else if (var_name == "MaxPositionSizeTotal")
            sets.MaxPositionSizeTotal = StringToDouble(var_content);
        else if (var_name == "MaxPositionSizePerSymbol")
            sets.MaxPositionSizePerSymbol = StringToDouble(var_content);
        else if (var_name == "MaxRiskTotal")
            sets.MaxRiskTotal = StringToDouble(var_content);
        else if (var_name == "MaxRiskPerSymbol")
            sets.MaxRiskPerSymbol = StringToDouble(var_content);
        else if (var_name == "DisableTradingWhenLinesAreHidden")
            sets.DisableTradingWhenLinesAreHidden = (bool)StringToInteger(var_content);
        // Multiple TPs.
        else if ((sets.TakeProfitsNumber > 1) && (StringSubstr(var_name, 0, 3) == "TP_"))
        {
            int i = (int)StringToInteger(StringSubstr(var_name, 3)); // This TP's number.
            if (i > sets.TakeProfitsNumber - 1) continue; // Cannot accommodate so many.
            sets.TP[i] = NormalizeDouble(StringToDouble(var_content), _Digits);
        }
        else if ((sets.TakeProfitsNumber > 1) && (StringSubstr(var_name, 0, 8) == "TPShare_"))
        {
            int i = (int)StringToInteger(StringSubstr(var_name, 8)); // This TP Share's number.
            if (i > sets.TakeProfitsNumber - 1) continue; // Cannot accommodate so many.
            sets.TPShare[i] = (int)StringToInteger(var_content);
        }
        else if (var_name == "MaxSlippage")
            sets.MaxSlippage = (int)StringToInteger(var_content);
        else if (var_name == "MaxSpread")
            sets.MaxSpread = (int)StringToInteger(var_content);
        else if (var_name == "MaxEntrySLDistance")
            sets.MaxEntrySLDistance = (int)StringToInteger(var_content);
        else if (var_name == "MinEntrySLDistance")
            sets.MinEntrySLDistance = (int)StringToInteger(var_content);
        else if (var_name == "TradeDirection")
            sets.TradeDirection = (TRADE_DIRECTION)StringToInteger(var_content);
        else if (var_name == "SLDistanceInPoints")
            sets.SLDistanceInPoints = (bool)StringToInteger(var_content);
        else if (var_name == "TPDistanceInPoints")
            sets.TPDistanceInPoints = (bool)StringToInteger(var_content);
        else if (var_name == "StopLoss")
            sets.StopLoss = (int)StringToInteger(var_content);
        else if (var_name == "TakeProfit")
            sets.TakeProfit = (int)StringToInteger(var_content);
        else if (var_name == "SubtractPositions")
            sets.SubtractPositions = (bool)StringToInteger(var_content);
        else if (var_name == "SubtractPendingOrders")
            sets.SubtractPendingOrders = (bool)StringToInteger(var_content);
        else if (var_name == "ATRPeriod")
            sets.ATRPeriod = (int)StringToInteger(var_content);
        else if (var_name == "ATRMultiplierSL")
            sets.ATRMultiplierSL = StringToDouble(var_content);
        else if (var_name == "ATRMultiplierTP")
            sets.ATRMultiplierTP = StringToDouble(var_content);
        else if (var_name == "ATRTimeframe")
            sets.ATRTimeframe = (ENUM_TIMEFRAMES)StringToInteger(var_content);
        else if (var_name == "SpreadAdjustmentSL")
            sets.SpreadAdjustmentSL = (bool)StringToInteger(var_content);
        else if (var_name == "SpreadAdjustmentTP")
            sets.SpreadAdjustmentTP = (bool)StringToInteger(var_content);
        else if (var_name == "WasSelectedEntryLine")
            sets.WasSelectedEntryLine = (bool)StringToInteger(var_content);
        else if (var_name == "WasSelectedStopLossLine")
            sets.WasSelectedStopLossLine = (bool)StringToInteger(var_content);
        else if (var_name == "WasSelectedTakeProfitLine")
            sets.WasSelectedTakeProfitLine = (bool)StringToInteger(var_content);
        else if (var_name == "WasSelectedStopPriceLine")
            sets.WasSelectedStopPriceLine = (bool)StringToInteger(var_content);
        // Multiple TPs.
        else if ((sets.TakeProfitsNumber > 1) && (StringSubstr(var_name, 0, 36) == "WasSelectedAdditionalTakeProfitLine_"))
        {
            int i = (int)StringToInteger(StringSubstr(var_name, 36)); // This TP's number.
            if (i > sets.TakeProfitsNumber - 2) continue; // Cannot accommodate so many.
            sets.WasSelectedAdditionalTakeProfitLine[i] = StringToInteger(var_content);
        }
        else if (var_name == "DoNotApplyStopLoss")
            sets.DoNotApplyStopLoss = (bool)StringToInteger(var_content);
        else if (var_name == "DoNotApplyTakeProfit")
            sets.DoNotApplyTakeProfit = (bool)StringToInteger(var_content);
        else if (var_name == "AskForConfirmation")
            sets.AskForConfirmation = (bool)StringToInteger(var_content);
        else if (var_name == "IsPanelMinimized")
            sets.IsPanelMinimized = (bool)StringToInteger(var_content);
        else if (var_name == "TPLockedOnSL")
            sets.TPLockedOnSL = (bool)StringToInteger(var_content);
        else if (var_name == "ShareVolumeMode")
            sets.ShareVolumeMode = (VOLUME_SHARE_MODE)StringToInteger(var_content);
        else if (var_name == "TemplateChanged")
            sets.TemplateChanged = (bool)StringToInteger(var_content);

        // Is expert advisor reloading due to the input parameters change?
        else if (GlobalVariableGet("PS-" + IntegerToString(ChartID()) + "-Parameters") > 0)
        {
            // These are not part of settings but are panel-related input parameters.
            // When the expert advisor is reloaded due to its input parameters change, these should be compared to the new values.
            // If the value is changed, it should be updated in the panel too.
            if (var_name == "Parameter_DefaultTradeDirection")
            {
                if ((TRADE_DIRECTION)StringToInteger(var_content) != DefaultTradeDirection) sets.TradeDirection = DefaultTradeDirection;
            }
            else if (var_name == "Parameter_DefaultShowLines")
            {
                if ((bool)StringToInteger(var_content) != DefaultShowLines) sets.ShowLines = DefaultShowLines;
            }
            else if (var_name == "Parameter_DefaultSL")
            {
                if (StringToInteger(var_content) != DefaultSL)
                {
                    // Will be set to actual value via Initialization().
                    sets.StopLossLevel = 0;
                    sets.StopLoss = 0;
                }
            }
            else if (var_name == "Parameter_DefaultTP")
            {
                if (StringToInteger(var_content) != DefaultTP)
                {
                    // Will be set to actual value via Initialization().
                    sets.TakeProfitLevel = 0;
                    sets.TakeProfit = 0;
                }
            }
            else if (var_name == "Parameter_DefaultLinesSelected")
            {
                if ((bool)StringToInteger(var_content) != DefaultLinesSelected)
                {
                    if (DefaultLinesSelected) LinesSelectedStatus = 1; // Flip lines to selected.
                    else LinesSelectedStatus = 2; // Flip lines to unselected.
                    // Actual flipping happens inside Initialization() function.
                }
                else LinesSelectedStatus = 0; // No change.
            }
            else if (var_name == "Parameter_DefaultATRPeriod")
            {
                if (StringToInteger(var_content) != DefaultATRPeriod) sets.ATRPeriod = DefaultATRPeriod;
            }
            else if (var_name == "Parameter_DefaultATRMultiplierSL")
            {
                if (StringToDouble(var_content) != DefaultATRMultiplierSL) sets.ATRMultiplierSL = DefaultATRMultiplierSL;
            }
            else if (var_name == "Parameter_DefaultATRMultiplierTP")
            {
                if (StringToDouble(var_content) != DefaultATRMultiplierTP) sets.ATRMultiplierTP = DefaultATRMultiplierTP;
            }
            else if (var_name == "Parameter_DefaultATRTimeframe")
            {
                if ((ENUM_TIMEFRAMES)StringToInteger(var_content) != DefaultATRTimeframe) sets.ATRTimeframe = DefaultATRTimeframe;
            }
            else if (var_name == "Parameter_DefaultEntryType")
            {
                if ((ENTRY_TYPE)StringToInteger(var_content) != DefaultEntryType) sets.EntryType = DefaultEntryType;
            }
            else if (var_name == "Parameter_DefaultCommission")
            {
                if (StringToDouble(var_content) != DefaultCommission) sets.CommissionPerLot = DefaultCommission;
            }
            else if (var_name == "Parameter_DefaultCommissionType")
            {
                if ((COMMISSION_TYPE)StringToInteger(var_content) != DefaultCommissionType) sets.CommissionType = DefaultCommissionType;
            }
            else if (var_name == "Parameter_DefaultAccountButton")
            {
                if ((ACCOUNT_BUTTON)StringToInteger(var_content) != DefaultAccountButton) sets.AccountButton = DefaultAccountButton;
            }
            else if (var_name == "Parameter_CustomBalance")
            {
                if (StringToDouble(var_content) != CustomBalance) sets.CustomBalance = CustomBalance;
            }
            else if (var_name == "Parameter_DefaultRisk")
            {
                if (StringToDouble(var_content) != DefaultRisk) sets.Risk = DefaultRisk;
            }
            else if (var_name == "Parameter_DefaultMoneyRisk")
            {
                if (DefaultMoneyRisk > 0)
                {
                    sets.UseMoneyInsteadOfPercentage = true; // Should be set to true whenever the DefaultMoneyRisk is non-zero.
                    if (StringToDouble(var_content) != DefaultMoneyRisk) sets.MoneyRisk = DefaultMoneyRisk;
                }
                else sets.UseMoneyInsteadOfPercentage = false;
            }
            else if (var_name == "Parameter_DefaultPositionSize")
            {
                if ((StringToDouble(var_content) != DefaultPositionSize))
                {
                    if (DefaultPositionSize > 0)
                    {
                        sets.RiskFromPositionSize = true;
                        sets.PositionSize = DefaultPositionSize;
                        OutputPositionSize = sets.PositionSize;
                    }
                    else sets.RiskFromPositionSize = false;
                }
            }
            else if (var_name == "Parameter_DefaultCountPendingOrders")
            {
                if ((bool)StringToInteger(var_content) != DefaultCountPendingOrders) sets.CountPendingOrders = DefaultCountPendingOrders;
            }
            else if (var_name == "Parameter_DefaultIgnoreOrdersWithoutSL")
            {
                if ((bool)StringToInteger(var_content) != DefaultIgnoreOrdersWithoutSL) sets.IgnoreOrdersWithoutSL = DefaultIgnoreOrdersWithoutSL;
            }
            else if (var_name == "Parameter_DefaultIgnoreOrdersWithoutTP")
            {
                if ((bool)StringToInteger(var_content) != DefaultIgnoreOrdersWithoutTP) sets.IgnoreOrdersWithoutTP = DefaultIgnoreOrdersWithoutTP;
            }
            else if (var_name == "Parameter_DefaultIgnoreOtherSymbols")
            {
                if ((bool)StringToInteger(var_content) != DefaultIgnoreOtherSymbols) sets.IgnoreOtherSymbols = DefaultIgnoreOtherSymbols;
            }
            else if (var_name == "Parameter_DefaultCustomLeverage")
            {
                if (StringToDouble(var_content) != DefaultCustomLeverage) sets.CustomLeverage = DefaultCustomLeverage;
            }
            else if (var_name == "Parameter_DefaultMagicNumber")
            {
                if (StringToInteger(var_content) != DefaultMagicNumber) sets.MagicNumber = DefaultMagicNumber;
            }
            else if (var_name == "Parameter_DefaultCommentary")
            {
                if (var_content != DefaultCommentary) sets.Commentary = DefaultCommentary;
            }
            else if (var_name == "Parameter_DefaultCommentAutoSuffix")
            {
                if ((bool)StringToInteger(var_content) != DefaultCommentAutoSuffix) sets.CommentAutoSuffix = DefaultCommentAutoSuffix;
            }
            else if (var_name == "Parameter_DefaultDisableTradingWhenLinesAreHidden")
            {
                if ((bool)StringToInteger(var_content) != DefaultDisableTradingWhenLinesAreHidden) sets.DisableTradingWhenLinesAreHidden = DefaultDisableTradingWhenLinesAreHidden;
            }
            else if (var_name == "Parameter_DefaultMaxSlippage")
            {
                if (StringToInteger(var_content) != DefaultMaxSlippage) sets.MaxSlippage = DefaultMaxSlippage;
            }
            else if (var_name == "Parameter_DefaultMaxSpread")
            {
                if (StringToInteger(var_content) != DefaultMaxSpread) sets.MaxSpread = DefaultMaxSpread;
            }
            else if (var_name == "Parameter_DefaultMaxEntrySLDistance")
            {
                if (StringToInteger(var_content) != DefaultMaxEntrySLDistance) sets.MaxEntrySLDistance = DefaultMaxEntrySLDistance;
            }
            else if (var_name == "Parameter_DefaultMinEntrySLDistance")
            {
                if (StringToInteger(var_content) != DefaultMinEntrySLDistance) sets.MinEntrySLDistance = DefaultMinEntrySLDistance;
            }
            else if (var_name == "Parameter_DefaultMaxPositionSizeTotal")
            {
                if (StringToDouble(var_content) != DefaultMaxPositionSizeTotal) sets.MaxPositionSizeTotal = DefaultMaxPositionSizeTotal;
            }
            else if (var_name == "Parameter_DefaultMaxPositionSizePerSymbol")
            {
                if (StringToDouble(var_content) != DefaultMaxPositionSizePerSymbol) sets.MaxPositionSizePerSymbol = DefaultMaxPositionSizePerSymbol;
            }
            else if (var_name == "Parameter_DefaultSubtractOPV")
            {
                if ((bool)StringToInteger(var_content) != DefaultSubtractOPV) sets.SubtractPositions = DefaultSubtractOPV;
            }
            else if (var_name == "Parameter_DefaultSubtractPOV")
            {
                if ((bool)StringToInteger(var_content) != DefaultSubtractPOV) sets.SubtractPendingOrders = DefaultSubtractPOV;
            }
            else if (var_name == "Parameter_DefaultDoNotApplyStopLoss")
            {
                if ((bool)StringToInteger(var_content) != DefaultDoNotApplyStopLoss) sets.DoNotApplyStopLoss = DefaultDoNotApplyStopLoss;
            }
            else if (var_name == "Parameter_DefaultDoNotApplyTakeProfit")
            {
                if ((bool)StringToInteger(var_content) != DefaultDoNotApplyTakeProfit) sets.DoNotApplyTakeProfit = DefaultDoNotApplyTakeProfit;
            }
            else if (var_name == "Parameter_DefaultAskForConfirmation")
            {
                if ((bool)StringToInteger(var_content) != DefaultAskForConfirmation) sets.AskForConfirmation = DefaultAskForConfirmation;
            }
            // These three only trigger panel repositioning (default position changed via the input parameters deliberately).
            else if (var_name == "Parameter_DefaultPanelPositionCorner")
            {
                if ((ENUM_BASE_CORNER)StringToInteger(var_content) != DefaultPanelPositionCorner) Dont_Move_the_Panel_to_Default_Corner_X_Y = false;
            }
            else if (var_name == "Parameter_DefaultPanelPositionX")
            {
                if (StringToInteger(var_content) != DefaultPanelPositionX) Dont_Move_the_Panel_to_Default_Corner_X_Y = false;
            }
            else if (var_name == "Parameter_DefaultPanelPositionY")
            {
                if (StringToInteger(var_content) != DefaultPanelPositionY) Dont_Move_the_Panel_to_Default_Corner_X_Y = false;
            }
            else if (var_name == "Parameter_DefaultTPLockedOnSL")
            {
                if (StringToInteger(var_content) != DefaultTPLockedOnSL) sets.TPLockedOnSL = DefaultTPLockedOnSL;
            }
            else if (var_name == "Parameter_DefaultTrailingStop")
            {
                if (StringToInteger(var_content) != DefaultTrailingStop) sets.TrailingStopPoints = DefaultTrailingStop;
            }
            else if (var_name == "Parameter_DefaultBreakEven")
            {
                if (StringToInteger(var_content) != DefaultBreakEven) sets.BreakEvenPoints = DefaultBreakEven;
            }
            else if (var_name == "Parameter_DefaultExpiryMinutes")
            {
                if (StringToInteger(var_content) != DefaultExpiryMinutes)
                {
                    sets.ExpiryMinutes = DefaultExpiryMinutes;
                    if ((sets.ExpiryMinutes != 0) && (sets.ExpiryMinutes < 2)) sets.ExpiryMinutes = 0;
                }
            }
            else if (var_name == "Parameter_DefaultSpreadAdjustmentSL")
            {
                if ((bool)StringToInteger(var_content) != DefaultSpreadAdjustmentSL) sets.SpreadAdjustmentSL = DefaultSpreadAdjustmentSL;
            }
            else if (var_name == "Parameter_DefaultSpreadAdjustmentTP")
            {
                if ((bool)StringToInteger(var_content) != DefaultSpreadAdjustmentTP) sets.SpreadAdjustmentTP = DefaultSpreadAdjustmentTP;
            }
            else if (var_name == "Parameter_DefaultMaxNumberOfTradesTotal")
            {
                if (StringToInteger(var_content) != DefaultMaxNumberOfTradesTotal) sets.MaxNumberOfTradesTotal = DefaultMaxNumberOfTradesTotal;
            }
            else if (var_name == "Parameter_DefaultMaxNumberOfTradesPerSymbol")
            {
                if (StringToInteger(var_content) != DefaultMaxNumberOfTradesPerSymbol) sets.MaxNumberOfTradesPerSymbol = DefaultMaxNumberOfTradesPerSymbol;
            }
            else if (var_name == "Parameter_DefaultMaxRiskTotal")
            {
                if (StringToDouble(var_content) != DefaultMaxRiskTotal) sets.MaxRiskTotal = DefaultMaxRiskTotal;
            }
            else if (var_name == "Parameter_DefaultMaxRiskPerSymbol")
            {
                if (StringToDouble(var_content) != DefaultMaxRiskPerSymbol) sets.MaxRiskPerSymbol = DefaultMaxRiskPerSymbol;
            }
            else if (var_name == "Parameter_DefaultTakeProfitsNumber")
            {
                if (StringToInteger(var_content) != DefaultTakeProfitsNumber) // Only if new input parameter value is different.
                {
                    int old_STPN = sets.TakeProfitsNumber;
                    sets.TakeProfitsNumber = DefaultTakeProfitsNumber;
                    for (int i = old_STPN - 1; i >= sets.TakeProfitsNumber; i--)
                    {
                        ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i)); // Delete remaining additional TP lines.
                        ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i)); // Delete remaining additional TP lines.
                        ObjectDelete(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i)); // Delete remaining additional TP lines.
                    }
                    // Resize and initialize arrays for multiple TPs.
                    if (sets.TakeProfitsNumber > 1)
                    {
                        ArrayResize(sets.TP, sets.TakeProfitsNumber);
                        ArrayResize(sets.TPShare, sets.TakeProfitsNumber);
                        ArrayInitialize(sets.TP, 0);
                        ArrayInitialize(sets.TPShare, 100 / sets.TakeProfitsNumber);
                        ArrayResize(sets.WasSelectedAdditionalTakeProfitLine, sets.TakeProfitsNumber - 1); // -1 because the flag for the main TP is saved elsewhere.
                    }
                    ArrayResize(TakeProfitLineIsBeingMoved, sets.TakeProfitsNumber);
                    ArrayInitialize(TakeProfitLineIsBeingMoved, false);
                }
            }
            else if (var_name == "Parameter_DefaultSLDistanceInPoints")
            {
                if (StringToDouble(var_content) != DefaultSLDistanceInPoints) sets.SLDistanceInPoints = DefaultSLDistanceInPoints;
            }
            else if (var_name == "Parameter_DefaultTPDistanceInPoints")
            {
                if (StringToDouble(var_content) != DefaultTPDistanceInPoints) sets.TPDistanceInPoints = DefaultTPDistanceInPoints;
            }
        }
    }

    // Make sure total and per symbol values do not contradict each other.
    if ((sets.MaxPositionSizeTotal < sets.MaxPositionSizePerSymbol) && (sets.MaxPositionSizeTotal != 0)) sets.MaxPositionSizeTotal = sets.MaxPositionSizePerSymbol;
    if ((sets.MaxNumberOfTradesTotal < sets.MaxNumberOfTradesPerSymbol) && (sets.MaxNumberOfTradesTotal != 0)) sets.MaxNumberOfTradesTotal = sets.MaxNumberOfTradesPerSymbol;
    if ((sets.MaxRiskTotal < sets.MaxRiskPerSymbol) && (sets.MaxRiskTotal != 0)) sets.MaxRiskTotal = sets.MaxRiskPerSymbol;

    FileClose(fh);
    Print(TRANSLATION_MESSAGE_LOADED_SETTINGS);

    // Is expert advisor reloading due to the input parameters change? Delete the flag variable.
    if (GlobalVariableGet("PS-" + IntegerToString(ChartID()) + "-Parameters") > 0) GlobalVariableDel("PS-" + IntegerToString(ChartID()) + "-Parameters");

    return true;
}

bool CPositionSizeCalculator::DeleteSettingsFile()
{
    if (!FileIsExist(m_FileName))
    {
        Print(TRANSLATION_MESSAGE_NO_SETTINGS_FILE_TO_DELETE);
        return false;
    }
    Print(TRANSLATION_MESSAGE_TRYING_TO_DELETE_FILE);
    if (!FileDelete(m_FileName))
    {
        Print(TRANSLATION_MESSAGE_FAILED_TO_DELETE_FILE + ": " + m_FileName + ". " + TRANSLATION_MESSAGE_ERROR + ": " + IntegerToString(GetLastError()));
        return false;
    }
    Print(TRANSLATION_MESSAGE_DELETED_SETTINGS);
    return true;
}

void CPositionSizeCalculator::HideShowMaximize()
{
    // Remember the panel's location.
    remember_left = Left();
    remember_top = Top();

    Hide();
    Show();
    NoPanelMaximization = true;
    Maximize();
}

// Initializes ATR handle for further use.
void CPositionSizeCalculator::InitATR()
{
    ATR_handle = iATR(Symbol(), sets.ATRTimeframe, sets.ATRPeriod);
    if (ATR_handle == INVALID_HANDLE) Print(TRANSLATION_MESSAGE_FAILED_TO_CREATE_ATR + ": ", GetLastError());
}

//+------------------------------------------------------------------+
//| Update Fixed SL distance in points if the line got moved.        |
//+------------------------------------------------------------------+
void CPositionSizeCalculator::UpdateFixedSL()
{
    double read_value;
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0, read_value)) return; // Update only if line exists.
    else sets.StopLossLevel = read_value;

    // Check and adjust for TickSize granularity.
    if (TickSize > 0)
    {
        sets.StopLossLevel = NormalizeDouble(MathRound(sets.StopLossLevel / TickSize) * TickSize, _Digits);
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
    }
    sets.StopLoss = (int)MathRound(MathAbs(sets.StopLossLevel - sets.EntryLevel) / _Point);
    m_EdtSL.Text(IntegerToString(sets.StopLoss));

    if (ShowATROptions) // Update ATR multiplier after the line was moved by the user.
    {
        double buf[1] = {0};
        if (ATR_handle != INVALID_HANDLE) CopyBuffer(ATR_handle, 0, (int)ATRCandle, 1, buf);
        double atr = buf[0];
        if (atr != 0) sets.ATRMultiplierSL = MathAbs(sets.StopLossLevel - sets.EntryLevel) / atr;
        m_EdtATRMultiplierSL.Text(DoubleToString(sets.ATRMultiplierSL, 2));
        // Untick spread adjustment checkbox as SL was set explicitly:
        m_ChkSpreadAdjustmentSL.Checked(false);
        sets.SpreadAdjustmentSL = false;
    }

    if (sets.StopLossLevel < sets.EntryLevel)
    {
        sets.TradeDirection = Long;
    }
    else
    {
        sets.TradeDirection = Short;
    }
}

//+------------------------------------------------------------------+
//| Update Fixed TP distance in points if the line got moved.        |
//+------------------------------------------------------------------+
void CPositionSizeCalculator::UpdateFixedTP()
{
    double read_value;
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0, read_value)) return; // Update only if line exists.
    else sets.TakeProfitLevel = read_value;

    // Check and adjust for TickSize granularity.
    if (TickSize > 0)
    {
        sets.TakeProfitLevel = NormalizeDouble(MathRound(sets.TakeProfitLevel / TickSize) * TickSize, _Digits);
        ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
    }
    sets.TakeProfit = (int)MathRound(MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / _Point);
    m_EdtTP.Text(IntegerToString(sets.TakeProfit));

    if (ShowATROptions) // Update ATR multiplier after the line was moved by the user.
    {
        double buf[1] = {0};
        if (ATR_handle != INVALID_HANDLE) CopyBuffer(ATR_handle, 0, (int)ATRCandle, 1, buf);
        double atr = buf[0];
        if (atr != 0) sets.ATRMultiplierTP = MathAbs(sets.TakeProfitLevel - sets.EntryLevel) / atr;
        m_EdtATRMultiplierTP.Text(DoubleToString(sets.ATRMultiplierTP, 2));
        // Untick spread adjustment checkbox as TP was set explicitly:
        m_ChkSpreadAdjustmentTP.Checked(false);
        sets.SpreadAdjustmentTP = false;
    }
}

//+------------------------------------------------------------------+
//| Update Additional Fixed TP distance in points if the line got    |
//| moved. Used when multiple TPs are set.                           |
//+------------------------------------------------------------------+
void CPositionSizeCalculator::UpdateAdditionalFixedTP(int i)
{
    double read_value;
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, 0, read_value)) return; // Update only if line exists.
    else sets.TP[i] = NormalizeDouble(read_value, _Digits);

    // Check and adjust for TickSize granularity.
    if (TickSize > 0)
    {
        sets.TP[i] = NormalizeDouble(MathRound(sets.TP[i] / TickSize) * TickSize, _Digits);
        ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.TP[i]);
    }
    string tp_text = "0";
    // If line's value was zero, then points distance should be also zero.
    if (sets.TP[i] != 0) tp_text = IntegerToString((int)MathRound(MathAbs(sets.TP[i] - sets.EntryLevel) / _Point));
    AdditionalTPEdits[i - 1].Text(tp_text);
    TradingTPEdits[i].Text(tp_text);
}

//+------------------------------------------------------------------+
//| Update respective sets structure value after one of the multiple |
//| TP fields has been changed on the Trading tab.                   |
//+------------------------------------------------------------------+
void CPositionSizeCalculator::UpdateTradingTPEdit(int i)
{
    // First, do the formatting.
    double new_value = StringToDouble(TradingTPEdits[i].Text());
    // Adjust for tick size granularity.
    if (TickSize > 0) new_value = NormalizeDouble(MathRound(new_value / TickSize) * TickSize, _Digits);
    string s = DoubleToString(new_value, _Digits);
    TradingTPEdits[i].Text(s);
    // Remember the value.
    new_value = StringToDouble(s);
    sets.TP[i] = NormalizeDouble(new_value, _Digits);
    if (i > 0)
    {
        if (!sets.TPDistanceInPoints) AdditionalTPEdits[i - 1].Text(s); // TP as level.
        else AdditionalTPEdits[i - 1].Text(IntegerToString((int)MathRound(MathAbs(new_value - sets.EntryLevel) / _Point))); // TP as distance.
    }
    else if (sets.ATRMultiplierTP > 0)
    {
        // Untick spread adjustment checkbox as TP was set explicitly:
        m_ChkSpreadAdjustmentTP.Checked(false);
        sets.SpreadAdjustmentTP = false;
    }

    // If it was the first TP field on the Trading tab, and the TP field on the Main tab was empty - fill it and show the line.
    if ((i == 0) && (sets.TakeProfitLevel == 0) && (new_value > 0))
    {
        if (sets.TPDistanceInPoints)
        {
            if (sets.TradeDirection == Long)
                m_EdtTP.Text(IntegerToString((int)MathRound(MathAbs(new_value - sets.EntryLevel) / _Point)));
            else
                m_EdtTP.Text(IntegerToString((int)MathRound(MathAbs(sets.EntryLevel - new_value) / _Point)));
        }
        else
        {
            sets.TakeProfitLevel = new_value;
            m_EdtTP.Text(s);
        }
        OnEndEditEdtTP();
    }

    ProcessLineObjectsAfterUpdatingMultipleTP(i);
}

//+------------------------------------------------------------------+
//| Update respective sets structure value after one of the multiple |
//| TP fields has been changed on the Main tab.                      |
//+------------------------------------------------------------------+
void CPositionSizeCalculator::UpdateAdditionalTPEdit(int i)
{
    // First, do the formatting.
    double new_value = StringToDouble(AdditionalTPEdits[i - 1].Text());

    // TP as level.
    if (!sets.TPDistanceInPoints)
    {
        // Adjust for tick size granularity.
        if (TickSize > 0) new_value = NormalizeDouble(MathRound(new_value / TickSize) * TickSize, _Digits);
        string s = DoubleToString(new_value, _Digits);
        AdditionalTPEdits[i - 1].Text(s);
        TradingTPEdits[i].Text(s);

        // Remember the value.
        new_value = StringToDouble(s);
        sets.TP[i] = NormalizeDouble(new_value, _Digits);
    }
    // TP as distance.
    else
    {
        // Check and adjust for TickSize granularity.
        if (TickSize > 0) new_value = MathRound(MathRound(new_value * _Point / TickSize) * TickSize / _Point);
        double TP = 0;
        if (new_value > 0)
        {
            if (sets.TradeDirection == Long)
            {
                TP = NormalizeDouble(sets.EntryLevel + new_value * _Point, _Digits);
            }
            else
            {
                TP = NormalizeDouble(sets.EntryLevel - new_value * _Point, _Digits);
            }
        }
        AdditionalTPEdits[i - 1].Text(DoubleToString(new_value, 0)); // Fixed granularity.
        TradingTPEdits[i].Text(DoubleToString(TP, _Digits));
        sets.TP[i] = TP;
    }

    ProcessLineObjectsAfterUpdatingMultipleTP(i);
}

//+-------------------------------------------------------------------+
//| Move TP line objects after updating one of the multiple TP fields.|
//+-------------------------------------------------------------------+
void CPositionSizeCalculator::ProcessLineObjectsAfterUpdatingMultipleTP(int i)
{
    string postfix = IntegerToString(i);
    if (i == 0) postfix = "";
    double price = 0;
    if (ArraySize(sets.TP) < 1) price = sets.TakeProfitLevel; // Avoiding error when calling for a single TP case.
    else price = sets.TP[i];
    // Process objects.
    ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_PRICE, price);
    if (price == 0) // Hide.
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_SELECTED, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + postfix, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + postfix, OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
    }
    else // Show.
    {
        if (sets.ShowLines)
        {
            DummyObjectSelect();
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_SELECTED, true);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + postfix, OBJPROP_BACK, false);
            if (ShowLineLabels)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + postfix, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + postfix, OBJPROP_BACK, DrawTextAsBackground);
            }
            if (ShowAdditionalTPLabel)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + postfix, OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + postfix, OBJPROP_BACK, DrawTextAsBackground);
            }
        }
        HideShowMaximize();
    }
}

//+------------------------------------------------------------------+
//| Update respective sets structure value after one of the multiple |
//| TP share fields has been changed.                                |
//+------------------------------------------------------------------+
void CPositionSizeCalculator::UpdateTradingTPShareEdit(int i)
{
    // First, do the formatting.
    int new_value = (int)StringToInteger(TradingTPShareEdits[i].Text());
    if (new_value > 100) new_value = 100;
    else if (new_value < 0) new_value = 0;
    TradingTPShareEdits[i].Text(IntegerToString(new_value));
    // Remember the value.
    sets.TPShare[i] = new_value;

    // Check if the total is good.
    TotalVolumeShare = 0;
    for (int j = 0; j < sets.TakeProfitsNumber; j++)
    {
        TotalVolumeShare += sets.TPShare[j];
    }
    if ((TotalVolumeShare < 99) || (TotalVolumeShare > 100)) // Not good.
    {
        for (int j = 0; j < sets.TakeProfitsNumber; j++)
        {
            TradingTPShareEdits[j].Color(clrRed); // Red color to warn the trader.
        }
    }
    else // Good.
    {
        for (int j = 0; j < sets.TakeProfitsNumber; j++)
        {
            TradingTPShareEdits[j].Color(m_EdtSL.Color()); // Normal color.
        }
    }
}

// Updates .Text() of the given addiotional TP edit on the Trading tab.
void CPositionSizeCalculator::UpdateAdditionalTradingPanelTP(int i)
{
    TradingTPEdits[i].Text(DoubleToString(sets.TP[i], _Digits));
}

void CPositionSizeCalculator::EmulateMinMaxClick()
{
    CBmpButton * minmax_button;
    minmax_button = Control(5); // MinMax button inside Dialog.mqh
    if (IsMinimized())
    {
        Maximize();
        minmax_button.Pressed(false); // Shown as _
    }
    else
    {
        Minimize();
        minmax_button.Pressed(true); // Shown as two small windows.
    }
}

// Check if all required lines exist and restore them if they have been accidentally deleted.
void CPositionSizeCalculator::CheckAndRestoreLines()
{
    bool RestoredSomething = false;
    DummyObjectSelect("DummyObject2"); // Different name to not interfere with an already created dummy.

    if (ObjectFind(ChartID(), ObjectPrefix + "EntryLine") == -1)
    {
        ObjectCreate(0, ObjectPrefix + "EntryLine", OBJ_HLINE, 0, TimeCurrent(), sets.EntryLevel);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_STYLE, entry_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_COLOR, entry_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_WIDTH, entry_line_width);
        ObjectSetString(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TOOLTIP, "Entry");
        if (sets.EntryType == Instant) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, false);
        else
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, true);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
        }
        if (!sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        RestoredSomething = true;
    }

    if (ObjectFind(ChartID(), ObjectPrefix + "StopLossLine") == -1)
    {
        ObjectCreate(0, ObjectPrefix + "StopLossLine", OBJ_HLINE, 0, TimeCurrent(), sets.StopLossLevel);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_STYLE, stoploss_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_COLOR, stoploss_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_WIDTH, stoploss_line_width);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTABLE, true);
        ObjectSetString(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TOOLTIP, TRANSLATION_LABEL_STOPLOSS);
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true);
        if (!sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        RestoredSomething = true;
    }

    if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine") == -1)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
        if ((sets.ShowLines) && ((sets.TakeProfitLevel > 0) || ((sets.ATRMultiplierTP > 0) && (ShowATROptions)))) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_HIDDEN, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
        ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TOOLTIP, TRANSLATION_LABEL_TAKEPROFIT);
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
        RestoredSomething = true;
    }

    // Process multiple TP lines.
    for (int i = 1; i < sets.TakeProfitsNumber; i++)
    {
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i)) == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJ_HLINE, 0, TimeCurrent(), sets.TP[i]);
            if ((sets.ShowLines) && (sets.TP[i] > 0)) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_STYLE, takeprofit_line_style);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_COLOR, takeprofit_line_color);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_WIDTH, takeprofit_line_width);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTABLE, true);
            ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TOOLTIP, TRANSLATION_LABEL_TAKEPROFIT + " #" + IntegerToString(i + 1));
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
            RestoredSomething = true;
        }
    }

    if (!DisableStopLimit)
    {
        if (ObjectFind(ChartID(), ObjectPrefix + "StopPriceLine") == -1)
        {
            ObjectCreate(0, ObjectPrefix + "StopPriceLine", OBJ_HLINE, 0, TimeCurrent(), sets.StopPriceLevel);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_STYLE, stopprice_line_style);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_COLOR, stopprice_line_color);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_WIDTH, stopprice_line_width);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTABLE, true);
            ObjectSetString(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_STOP_PRICE_LINE);
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED, true);
            if ((!sets.ShowLines) || (sets.EntryType != StopLimit)) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            RestoredSomething = true;
        }
    }

    // Put panel on top of the lines that were created later.
    if (RestoredSomething) HideShowMaximize();
}

// Deletes, creates, and selects a dummy chart object to avoid a rather strange MT5 glitch,
// which results in the first created and selected chart object to become deselected after
// calling Hide(), Show(), and Maximize() on a panel.
void CPositionSizeCalculator::DummyObjectSelect(string dummy_name = "DummyObject")
{
    ObjectDelete(0, ObjectPrefix + dummy_name);
    ObjectCreate(0, ObjectPrefix + dummy_name, OBJ_HLINE, 0, TimeCurrent(), 0);
    ObjectSetInteger(ChartID(), ObjectPrefix + dummy_name, OBJPROP_SELECTED, true);
}

void CPositionSizeCalculator::SeekAndDestroyDuplicatePanels()
{
    int ot = ObjectsTotal(ChartID());
    for (int i = ot - 1; i >= 0; i--)
    {
        string object_name = ObjectName(ChartID(), i);
        if (ObjectGetInteger(ChartID(), object_name, OBJPROP_TYPE) != OBJ_LABEL) continue;
        // Found m_LblSnapEquity object.
        if (StringSubstr(object_name, StringLen(object_name) - 12) == "m_LblPosSize")
        {
            string prefix = StringSubstr(object_name, 0, StringLen(Name()));
            // Found m_LblSnapEquity object with prefix different than current.
            if (prefix != Name())
            {
                ObjectsDeleteAll(ChartID(), prefix);
                // Reset object counter.
                ot = ObjectsTotal(ChartID());
                i = ot;
                Print(TRANSLATION_MESSAGE_DELETED_DUPLICATE_PANEL + " = ", prefix, ".");
                continue;
            }
        }
    }
}

//+------------------------------------------------+
//|                                                |
//|              Calculation Functions             |
//|                                                |
//+------------------------------------------------+
//==================================================================================================================
double AccSize, OutputRiskMoney;
double OutputPositionSize, OutputMaxPositionSize;
double StopLoss;

// Will be used in two or more functions.
double tEntryLevel, tStopLossLevel, tTakeProfitLevel, tStopPriceLevel;
// -1 because it is checked in the initialization function.
double TickSize = -1, ContractSize, AccStopoutLevel, TickValue, InitialMargin = 0, MaintenanceMargin = 0, MarginHedging = 0, MinLot, MaxLot, LotStep, UnitCost_reward;
double PreCustomLeverage = -1; // For remembering the leverage that was before we applied CustomLeverage.
string AccountCurrency, MarginCurrency, ProfitCurrency, BaseCurrency;
string CurrencyPairsList[];
bool MarginInUnconvertedMarginCurrency; // This flag is set to true if margin currency could not be converted.
int WarnedAboutZeroUnitCost = 0; // Was there already a warning?

long AccStopoutMode;
int LotStep_digits, AccountCurrencyDigits = 2;
ENUM_SYMBOL_CALC_MODE CalcMode;
ENUM_ACCOUNT_MARGIN_MODE AccountMarginMode;
ENUM_POSITION_TYPE PositionDirection;
ENUM_ORDER_TYPE OrderType;
double CustomLeverage = 0;
double SymbolLeverage = 1;
int SymbolLeverageDecimals = 0;
int CustomLeverageDecimals = 0;
int CommissionDecimals = 2;
bool StopOut;

//-----
string WarningEntry = "", WarningSL = "", WarningTP = "", WarningSP = "", AdditionalWarningTP[];
double DisplayRisk, RiskMoney, PositionMargin, UsedMargin, FutureMargin, PreHedgingPositionMargin, PortfolioLossMoney = 0;
string InputRR, OutputRR, MainOutputRR, PLM, CPR, PRM, CPRew, PPMR, PPR, PPMRew, PPRew, CPL, PPL, CPRRR, PPRRR, AdditionalOutputRR[];
string InputReward;
double OutputReward, AdditionalOutputReward[], MainOutputReward;
string OutputPointValue = "", OutputSwapsType = TRANSLATION_LABEL_UNKNOWN, SwapsTripleDay = "?",
       OutputSwapsDailyLongLot = "?", OutputSwapsDailyShortLot = "?", OutputSwapsDailyLongPS = "?", OutputSwapsDailyShortPS = "?",
       OutputSwapsYearlyLongLot = "?", OutputSwapsYearlyShortLot = "?", OutputSwapsYearlyLongPS = "?", OutputSwapsYearlyShortPS = "?",
       OutputSwapsCurrencyDailyLot = "", OutputSwapsCurrencyDailyPS = "", OutputSwapsCurrencyYearlyLot = "", OutputSwapsCurrencyYearlyPS = "";
int LinesSelectedStatus; // 0 - no change, 1 - flip to selected, 2 - flip to unselected.
double ArrayPositionSize[]; // PS for each trade with multiple TPs.
int TotalVolumeShare = 100; // Holds the sum of volume shares for multiple TPs. Used by UpdateTradingTPShareEdit() and Trade().
string WarnedSymbols[]; // CCY1 + CCY2 + Symbol. Used to store currency combinations and symbols that have already warning on them triggered.

//==================================================================================================================
//+----------------------+
//| Will be called once. |
//+----------------------+
void Initialization()
{
    // If StopLossLevel is between those values, then it is either a first time Initialization is launched or "Waiting for Data" was encountered.
    if ((sets.StopLossLevel >= -_Point) && (sets.StopLossLevel <= _Point))
    {
        if (sets.TradeDirection == Long)
        {
            if (sets.EntryLevel == 0) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            if (DefaultSL > 0) sets.StopLossLevel = sets.EntryLevel - DefaultSL * _Point;
            else sets.StopLossLevel = iLow(Symbol(), Period(), 0);
            if (sets.StopLossLevel == 0) sets.StopLossLevel = sets.EntryLevel - _Point;
            if (DefaultTP > 0) sets.TakeProfitLevel = sets.EntryLevel + DefaultTP * _Point;
            if (sets.EntryLevel == sets.StopLossLevel) sets.StopLossLevel -= _Point;
            if ((sets.EntryType == StopLimit) && (sets.StopPriceLevel == 0))
            {
                sets.StopPriceLevel = sets.EntryLevel + iHigh(Symbol(), Period(), 0) - iLow(Symbol(), Period(), 0);
                if (sets.StopPriceLevel == sets.EntryLevel) sets.StopPriceLevel += _Point;
            }
        }
        else
        {
            if (sets.EntryLevel == 0) sets.EntryLevel = SymbolInfoDouble(Symbol(), SYMBOL_BID);
            if (DefaultSL > 0) sets.StopLossLevel = sets.EntryLevel + DefaultSL * _Point;
            else sets.StopLossLevel = iHigh(Symbol(), Period(), 0);
            if (sets.StopLossLevel == 0) sets.StopLossLevel = sets.EntryLevel + _Point;
            if (DefaultTP > 0) sets.TakeProfitLevel = sets.EntryLevel - DefaultTP * _Point;
            if (sets.EntryLevel == sets.StopLossLevel) sets.StopLossLevel += _Point;
            if ((sets.EntryType == StopLimit) && (sets.StopPriceLevel == 0))
            {
                sets.StopPriceLevel = sets.EntryLevel - (iHigh(Symbol(), Period(), 0) - iLow(Symbol(), Period(), 0));
                if (sets.StopPriceLevel == sets.EntryLevel) sets.StopPriceLevel -= _Point;
            }
        }
        if ((sets.SLDistanceInPoints) && (sets.StopLoss == 0)) sets.StopLoss = (int)MathRound(MathAbs((sets.EntryLevel - sets.StopLossLevel) / _Point));
        if ((sets.TPDistanceInPoints) && (sets.TakeProfit <= 0) && (sets.TakeProfitLevel != 0)) sets.TakeProfit = (int)MathRound(MathAbs((sets.EntryLevel - sets.TakeProfitLevel) / _Point));
    }
    // Loaded template with TP line - delete the line.
    if ((sets.TakeProfit == 0) && (sets.TakeProfitLevel == 0) && (ObjectFind(0, ObjectPrefix + "TakeProfitLine") == 0))
    {
        ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLine");
        ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLabel");
        ObjectDelete(ChartID(), ObjectPrefix + "TPAdditionalLabel");
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i));
            ObjectDelete(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i));
            ObjectDelete(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i));
        }
    }

    // Used to store volume for each TP level. Without additional levels, there is only main TP level.
    ArrayResize(ArrayPositionSize, sets.TakeProfitsNumber);

    // Using TP distance in points but just switched from the TP given as a level on an already attached indicator.
    if ((sets.TPDistanceInPoints) && (sets.TakeProfit == 0) && (sets.TakeProfitLevel != 0)) sets.TakeProfit = (int)MathRound(MathAbs((sets.TakeProfitLevel - sets.EntryLevel) / _Point));
    if (sets.EntryLevel - sets.StopLossLevel == 0)
    {
        Alert(TRANSLATION_MESSAGE_ENTRY_SL_DIFFERENT_NON_ZERO);
        return;
    }

    if (sets.EntryType == Instant)
    {
        double Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        double Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        if ((Ask > 0) && (Bid > 0))
        {
            // SL got inside Ask/Bid range.
            if ((sets.StopLossLevel >= Bid) && (sets.StopLossLevel <= Ask)) sets.StopLossLevel = Bid - _Point;
            // Long entry
            if (sets.StopLossLevel < Bid) sets.EntryLevel = Ask;
            // Short entry
            else if (sets.StopLossLevel > Ask) sets.EntryLevel = Bid;
        }
    }

    // Has to be done for updates to default input parameters to work correctly.
    if (sets.TradeDirection == Long)
    {
        if ((DefaultSL > 0) && (sets.StopLossLevel == 0))  sets.StopLossLevel = sets.EntryLevel - DefaultSL * _Point;
        if ((DefaultTP > 0) && (sets.TakeProfitLevel == 0)) sets.TakeProfitLevel = sets.EntryLevel + DefaultTP * _Point;
    }
    else
    {
        if ((DefaultSL > 0) && (sets.StopLossLevel == 0)) sets.StopLossLevel = sets.EntryLevel + DefaultSL * _Point;
        if ((DefaultTP > 0) && (sets.TakeProfitLevel == 0)) sets.TakeProfitLevel = sets.EntryLevel - DefaultTP * _Point;
    }
    if ((sets.SLDistanceInPoints) && (sets.StopLoss <= 0)) sets.StopLoss = (int)MathRound(MathAbs((sets.EntryLevel - sets.StopLossLevel) / _Point));
    if ((sets.TPDistanceInPoints) && (sets.TakeProfit <= 0) && (sets.TakeProfitLevel != 0)) sets.TakeProfit = (int)MathRound(MathAbs((sets.EntryLevel - sets.TakeProfitLevel) / _Point));

    ExtDialog.DummyObjectSelect(); // To prevent buggy deselection of line objects after indicator parameters change.
    bool line_existed = false; // Will be used to preserve OBJPROP_SELECTED through timeframe changes and the like.
    if (ObjectFind(ChartID(), ObjectPrefix + "EntryLine") == -1)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "EntryLine", OBJ_HLINE, 0, TimeCurrent(), sets.EntryLevel);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_HIDDEN, false);
    }
    else
    {
        line_existed = true;
        ObjectSetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, sets.EntryLevel);
    }
    ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_STYLE, entry_line_style);
    ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_COLOR, entry_line_color);
    ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_WIDTH, entry_line_width);
    ObjectSetString(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TOOLTIP, TRANSLATION_LABEL_ENTRY);
    if (sets.EntryType == Instant) ObjectSetInteger(0, ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, false);
    else
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTABLE, true);
        if (!line_existed)
        {
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
        }
        else
        {
            if (LinesSelectedStatus == 1) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
            else if (LinesSelectedStatus == 2) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, false);
        }
    }

    line_existed = false;
    if (ObjectFind(ChartID(), ObjectPrefix + "StopLossLine") == -1)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "StopLossLine", OBJ_HLINE, 0, TimeCurrent(), sets.StopLossLevel);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_HIDDEN, false) ;
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTABLE, true);
    }
    else
    {
        line_existed = true;
        ObjectSetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, sets.StopLossLevel);
    }
    ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_STYLE, stoploss_line_style);
    ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_COLOR, stoploss_line_color);
    ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_WIDTH, stoploss_line_width);
    ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTABLE, true);
    ObjectSetString(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TOOLTIP, TRANSLATION_LABEL_STOPLOSS);
    if (!line_existed)
    {
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
    }
    else
    {
        if (LinesSelectedStatus == 1) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true);
        else if (LinesSelectedStatus == 2) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, false);
    }
    StopLoss = MathAbs(sets.EntryLevel - sets.StopLossLevel);

    if (ShowLineLabels)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "StopLossLabel", OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_COLOR, clrNONE);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_SELECTABLE, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_HIDDEN, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_BACK, DrawTextAsBackground);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_BACK, DrawTextAsBackground);
        ObjectSetString(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_SL_LABEL);
        if ((ShowAdditionalSLLabel) && (ObjectFind(0, ObjectPrefix + "SLAdditionalLabel") == -1))
        {
            ObjectCreate(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJ_LABEL, 0, 0, 0);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_COLOR, clrNONE);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_SELECTABLE, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
            ObjectSetString(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TOOLTIP, TRANSLATION_LABEL_RISK + ", % ($)");
        }

        ObjectCreate(ChartID(), ObjectPrefix + "EntryLabel", OBJ_LABEL, 0, 0, 0);
        if ((sets.ShowLines) && (sets.EntryType != Instant)) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_COLOR, clrNONE);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_SELECTABLE, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_HIDDEN, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_BACK, DrawTextAsBackground);
        ObjectSetString(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_ENTRY_LABEL);
        if ((ShowAdditionalEntryLabel) && (ObjectFind(0, ObjectPrefix + "EntryAdditionalLabel") == -1))
        {
            ObjectCreate(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJ_LABEL, 0, 0, 0);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_COLOR, clrNONE);
            ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_SELECTABLE, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
            ObjectSetString(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_ENTRY_LABEL_ADDITIONAL);
        }
    }

    if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine") == -1)
    {
        line_existed = false;
        ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine", OBJ_HLINE, 0, TimeCurrent(), sets.TakeProfitLevel);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_HIDDEN, false) ;
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
    }
    else
    {
        line_existed = true;
        ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, sets.TakeProfitLevel);
    }
    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_STYLE, takeprofit_line_style);
    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_COLOR, takeprofit_line_color);
    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_WIDTH, takeprofit_line_width);
    ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTABLE, true);
    ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TOOLTIP, TRANSLATION_LABEL_TAKEPROFIT);
    if (!line_existed)
    {
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
    }
    else
    {
        if (LinesSelectedStatus == 1) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
        else if (LinesSelectedStatus == 2) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, false);
    }
    if (ShowLineLabels)
    {
        ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJ_LABEL, 0, 0, 0);
        if ((sets.TakeProfitLevel > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_COLOR, clrNONE);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_SELECTABLE, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_HIDDEN, false);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_BACK, DrawTextAsBackground);
        ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_TP_LABEL);
        if (ShowAdditionalTPLabel)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJ_LABEL, 0, 0, 0);
            if ((sets.TakeProfitLevel > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_COLOR, clrNONE);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_SELECTABLE, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_BACK, DrawTextAsBackground);
            ObjectSetString(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TOOLTIP, TRANSLATION_LABEL_REWARD + ", % ($), R/R");
        }
    }

    if (!DisableStopLimit)
    {
        if (ObjectFind(ChartID(), ObjectPrefix + "StopPriceLine") == -1)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "StopPriceLine", OBJ_HLINE, 0, TimeCurrent(), sets.StopPriceLevel);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        }
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_STYLE, stopprice_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_COLOR, stopprice_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_WIDTH, stopprice_line_width);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTABLE, true);
        ObjectSetString(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_STOP_PRICE_LINE);
        if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED, true);
        if (ShowLineLabels)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "StopPriceLabel", OBJ_LABEL, 0, 0, 0);
            if ((sets.EntryType == StopLimit) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_COLOR, clrNONE);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_SELECTABLE, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_BACK, DrawTextAsBackground);
            ObjectSetString(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TOOLTIP, TRANSLATION_TOOLTIP_STOP_PRICE_LABEL);
        }
    }
    else
    {
        ObjectDelete(ChartID(), ObjectPrefix + "StopPriceLine");
        if (sets.EntryType == StopLimit) sets.EntryType = Pending;
    }

    if (sets.ShowLines == false)
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
    }
    else
    {
        ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        if (sets.TakeProfitLevel > 0) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        if (sets.EntryType == StopLimit) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else
        {
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED, true);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
    }

    // Process multiple TP lines.
    for (int i = 1; i < sets.TakeProfitsNumber; i++)
    {
        if (ObjectFind(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i)) == -1)
        {
            line_existed = false;
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJ_HLINE, 0, TimeCurrent(), sets.TP[i]);
            if (sets.TP[i] > 0) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        else
        {
            line_existed = true;
            ObjectSetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, sets.TP[i]);
        }
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_STYLE, takeprofit_line_style);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_COLOR, takeprofit_line_color);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_WIDTH, takeprofit_line_width);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTABLE, true);
        ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_HIDDEN, false);
        ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TOOLTIP, TRANSLATION_LABEL_TAKEPROFIT + " #" + IntegerToString(i + 1));
        if (!line_existed)
        {
            if (DefaultLinesSelected) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true); // Only for new lines. Old lines retain their selected status unless default parameter value changed.
        }
        else
        {
            if (LinesSelectedStatus == 1) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
            else if (LinesSelectedStatus == 2) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, false);
        }
        if (ShowLineLabels)
        {
            ObjectCreate(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJ_LABEL, 0, 0, 0);
            if ((sets.TP[i] > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_COLOR, clrNONE);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_SELECTABLE, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_HIDDEN, false);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_CORNER, CORNER_LEFT_UPPER);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
            ObjectSetString(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TOOLTIP, TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_DISTANCE + " #" + IntegerToString(i + 1) + ", " + TRANSLATION_LABEL_TAKEPROFIT_MULTIPLE_POINTS);
                if (ShowAdditionalTPLabel)
            {
                ObjectCreate(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJ_LABEL, 0, 0, 0);
                if ((sets.TP[i] > 0) && (sets.ShowLines)) ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                else ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_COLOR, clrNONE);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_SELECTABLE, false);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_HIDDEN, false);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_CORNER, CORNER_LEFT_UPPER);
                ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_BACK, DrawTextAsBackground);
                ObjectSetString(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TOOLTIP, TRANSLATION_LABEL_REWARD + " #" + IntegerToString(i + 1) + ", $ (%), R/R");
            }
        }
    }

    switch(sets.AccountButton)
    {
    default:
    case Balance:
        if (CustomBalance > 0) AccSize = sets.CustomBalance;
        else AccSize = AccountInfoDouble(ACCOUNT_BALANCE);
        break;
    case Equity:
        AccSize = AccountInfoDouble(ACCOUNT_EQUITY);
        break;
    case Balance_minus_Risk:
        if (CustomBalance > 0) AccSize = sets.CustomBalance;
        else AccSize = AccountInfoDouble(ACCOUNT_BALANCE);
        if (PortfolioLossMoney != DBL_MAX) AccSize = AccSize - PortfolioLossMoney;
        break;
    }
    if (sets.CustomBalance <= 0) AccSize += AdditionalFunds;

    if (sets.ShowLines == false)
    {
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
    }
    else
    {
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        }
    }

    if (sets.TemplateChanged) // Select lines according to the DefaultLinesSelected input parameter.
    {
        if (DefaultLinesSelected)
        {
            if (sets.EntryType != Instant) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_SELECTED, true);
            ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_SELECTED, true);
            ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_SELECTED, true);
            if (sets.EntryType == StopLimit) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_SELECTED, true);
            // Process multiple TP lines.
            for (int i = 1; i < sets.TakeProfitsNumber; i++)
            {
                ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_SELECTED, true);
            }
        }
        sets.TemplateChanged = false;
    }
    
    ChartRedraw();
}

//+------------------------------------------------------------------+
//| Main recalculation function used on every tick and on entry/SL   |
//| line drag.                                                       |
//+------------------------------------------------------------------+
void RecalculatePositionSize()
{
    for (int i = 1; i < sets.TakeProfitsNumber; i++) AdditionalWarningTP[i - 1] = "";

    double Ask, Bid;

    // If could not find account currency, probably not connected. Also check for symbol availability.
    if ((AccountInfoString(ACCOUNT_CURRENCY) == "") || (!TerminalInfoInteger(TERMINAL_CONNECTED) || (!SymbolInfoInteger(Symbol(), SYMBOL_SELECT)))) return;
    else if ((TickSize == -1) || (TickValue == 0))
    {
        GetSymbolAndAccountData();
    }
    Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

    double read_tEntryLevel, read_tStopLossLevel, read_tTakeProfitLevel, read_tStopPriceLevel;
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "EntryLine", OBJPROP_PRICE, 0, read_tEntryLevel)) return; // Line was deleted, waiting for automatic restoration.
    tEntryLevel = Round(read_tEntryLevel, _Digits);
    if (!ObjectGetDouble(ChartID(), ObjectPrefix + "StopLossLine", OBJPROP_PRICE, 0, read_tStopLossLevel)) return;
    tStopLossLevel = Round(read_tStopLossLevel, _Digits);
    if (ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine", OBJPROP_PRICE, 0, read_tTakeProfitLevel)) tTakeProfitLevel = Round(read_tTakeProfitLevel, _Digits);
    else tTakeProfitLevel = 0;
    if (!DisableStopLimit)
    {
        if (!ObjectGetDouble(ChartID(), ObjectPrefix + "StopPriceLine", OBJPROP_PRICE, 0, read_tStopPriceLevel)) return;
        tStopPriceLevel = Round(read_tStopPriceLevel, _Digits);
    }
    
    double StopLevel = SymbolInfoInteger(Symbol(), SYMBOL_TRADE_STOPS_LEVEL) * _Point;
    WarningEntry = "";
    WarningSL = "";
    WarningTP = "";
    WarningSP = "";
    double AskBid = 0;
    if (sets.EntryType == Instant)
    {
        if ((tStopLossLevel < Ask) && (tStopLossLevel > Bid)) WarningSL = " " + TRANSLATION_LABEL_WARNING_WRONG_VALUE;
        else if (tStopLossLevel < Ask) AskBid = Ask;
        else if (tStopLossLevel > Bid) AskBid = Bid;
    }
    else if (sets.EntryType == Pending)
    {
        if (tStopLossLevel < tEntryLevel) AskBid = Ask;
        else if (tStopLossLevel > tEntryLevel) AskBid = Bid;
        if (AskBid)
        {
            if (MathAbs(AskBid - tEntryLevel) < StopLevel) WarningEntry = " " + TRANSLATION_LABEL_WARNING_TOO_CLOSE;
        }
        else WarningSL = " " + TRANSLATION_LABEL_WARNING_WRONG_VALUE;
    }
    else if (sets.EntryType == StopLimit)
    {
        if (tStopLossLevel < tEntryLevel)
        {
            AskBid = Ask;
            // Check if Stop price is above current price for Longs.
            if (tStopPriceLevel <= AskBid) WarningSP = " " + TRANSLATION_LABEL_WARNING_WRONG_VALUE;
        }
        else if (tStopLossLevel > tEntryLevel)
        {
            AskBid = Bid;
            // Check if Stop price is below current price for Shorts.
            if (tStopPriceLevel >= AskBid) WarningSP = " " + TRANSLATION_LABEL_WARNING_WRONG_VALUE;
        }
        if (AskBid)
        {

            // Check whether Stop price isn't too close to the current price.
            if (MathAbs(AskBid - tStopPriceLevel) < StopLevel) WarningSP = " " + TRANSLATION_LABEL_WARNING_TOO_CLOSE;
            // Check whether Limit price isn't too close to the Stop price.
            if (MathAbs(tEntryLevel - tStopPriceLevel) < StopLevel) WarningEntry = " " + TRANSLATION_LABEL_WARNING_TOO_CLOSE;

        }
        else WarningSL = " " + TRANSLATION_LABEL_WARNING_WRONG_VALUE;
    }

    if (MathAbs(tStopLossLevel - tEntryLevel) < StopLevel) WarningSL = " " + TRANSLATION_LABEL_WARNING_TOO_CLOSE;
    if (tTakeProfitLevel > 0)
    {
        if (MathAbs(tTakeProfitLevel - tEntryLevel) < StopLevel) WarningTP = " " + TRANSLATION_LABEL_WARNING_TOO_CLOSE;
    }

    double add_tTakeProfitLevel[];
    ArrayResize(add_tTakeProfitLevel, sets.TakeProfitsNumber - 1);
    for (int i = 1; i < sets.TakeProfitsNumber; i++)
    {
        if (!ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE, 0, add_tTakeProfitLevel[i - 1])) return;
        add_tTakeProfitLevel[i - 1] = Round(add_tTakeProfitLevel[i - 1], _Digits);
        if (add_tTakeProfitLevel[i - 1] > 0)
        {
            if (MathAbs(add_tTakeProfitLevel[i - 1] - tEntryLevel) < StopLevel) AdditionalWarningTP[i - 1] = " " + TRANSLATION_LABEL_WARNING_TOO_CLOSE;
        }
    }

    StopLoss = MathAbs(tEntryLevel - tStopLossLevel);

    switch(sets.AccountButton)
    {
    default:
    case Balance:
        if (sets.CustomBalance > 0) AccSize = sets.CustomBalance;
        else AccSize = AccountInfoDouble(ACCOUNT_BALANCE);
        break;
    case Equity:
        AccSize = AccountInfoDouble(ACCOUNT_EQUITY);
        break;
    case Balance_minus_Risk:
        if (sets.CustomBalance > 0) AccSize = sets.CustomBalance;
        else AccSize = AccountInfoDouble(ACCOUNT_BALANCE);
        if (PortfolioLossMoney != DBL_MAX) AccSize = AccSize - PortfolioLossMoney;
        break;
    }
    if (sets.CustomBalance <= 0) AccSize += AdditionalFunds;

    sets.EntryLevel = tEntryLevel;
    sets.StopLossLevel = tStopLossLevel;
    sets.TakeProfitLevel = tTakeProfitLevel;
    sets.StopPriceLevel = tStopPriceLevel;
    for (int i = 1; i < sets.TakeProfitsNumber; i++) sets.TP[i] = add_tTakeProfitLevel[i - 1];
//!!!!    

    if (StopLoss != 0) CalculateRiskAndPositionSize();

    if (ShowLineLabels)
    {
        DrawLineLabel(ObjectPrefix + "StopLossLabel", IntegerToString((int)MathRound((MathAbs(tStopLossLevel - tEntryLevel) / _Point))), tStopLossLevel, sl_label_font_color);
        if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
        else ObjectSetInteger(ChartID(), ObjectPrefix + "StopLossLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        if (ShowAdditionalSLLabel)
        {
            string label_text;
            if (WarningSL == "")
            {
                string perc_risk;
                if (AccSize > 0) perc_risk = FormatDouble(DoubleToString(Round(OutputRiskMoney / AccSize * 100, 2), 2));
                else perc_risk = "100";
                label_text = perc_risk + "% (" + FormatDouble(DoubleToString(OutputRiskMoney, AccountCurrencyDigits)) + " " + AccountCurrency + ")";
            }
            else label_text = WarningSL;
            DrawLineLabel(ObjectPrefix + "SLAdditionalLabel", label_text, tStopLossLevel, sl_label_font_color, true);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "SLAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        if (ShowAdditionalEntryLabel)
        {
            DrawLineLabel(ObjectPrefix + "EntryAdditionalLabel", FormatDouble(DoubleToString(OutputPositionSize, LotStep_digits), LotStep_digits), tEntryLevel, entry_label_font_color, true);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "EntryAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        if (sets.EntryType != Instant)
        {
            DrawLineLabel(ObjectPrefix + "EntryLabel", IntegerToString((int)MathRound((MathAbs(tEntryLevel - AskBid) / _Point))), tEntryLevel, entry_label_font_color);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "EntryLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
        if (tTakeProfitLevel > 0)
        {
            DrawLineLabel(ObjectPrefix + "TakeProfitLabel", IntegerToString((int)MathRound((MathAbs(tTakeProfitLevel - tEntryLevel) / _Point))), tTakeProfitLevel, tp_label_font_color);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);

            if (ShowAdditionalTPLabel)
            {
                string label_text;
                if ((WarningTP == "") && (MainOutputRR != TRANSLATION_LABEL_WARNING_INVALID_TP))
                {
                    string perc_risk;
                    if (AccSize > 0) perc_risk = FormatDouble(DoubleToString(Round(MainOutputReward / AccSize * 100, 2, RoundDown), 2));
                    else perc_risk = "100";
                    label_text = perc_risk + "% (" + FormatDouble(DoubleToString(MainOutputReward, AccountCurrencyDigits)) + " " + AccountCurrency + ") " + MainOutputRR + "R";
                    // When multiple TPs are used, append correct lot volume for each TP at the beginning of the additional TP label:
                    if (sets.TakeProfitsNumber > 1) label_text = FormatDouble(DoubleToString(ArrayPositionSize[0], LotStep_digits), LotStep_digits) + " Lots " + label_text;
                }
                else
                {
                    label_text = WarningTP;
                    if (MainOutputRR == TRANSLATION_LABEL_WARNING_INVALID_TP) label_text += MainOutputRR;
                }
                DrawLineLabel(ObjectPrefix + "TPAdditionalLabel", label_text, tTakeProfitLevel, tp_label_font_color, true);
                if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                else ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            }
        }
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            //double add_tTakeProfitLevel = Round(ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE), _Digits);
            DrawLineLabel(ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), IntegerToString((int)MathRound((MathAbs(add_tTakeProfitLevel[i - 1] - tEntryLevel) / _Point))), add_tTakeProfitLevel[i - 1], tp_label_font_color);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "TakeProfitLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);

            if (ShowAdditionalTPLabel)
            {
                string label_text;
                if ((AdditionalWarningTP[i - 1] == "") && (AdditionalOutputRR[i - 1] != TRANSLATION_LABEL_WARNING_INVALID_TP))
                {
                    string perc_risk;
                    if (AccSize > 0) perc_risk = FormatDouble(DoubleToString(Round(AdditionalOutputReward[i - 1] / AccSize * 100, 2, RoundDown), 2));
                    else perc_risk = "100";
                    label_text = FormatDouble(DoubleToString(ArrayPositionSize[i], LotStep_digits), LotStep_digits) + " Lots " + perc_risk + "% (" + FormatDouble(DoubleToString(AdditionalOutputReward[i - 1], AccountCurrencyDigits)) + " " + AccountCurrency + ") " + AdditionalOutputRR[i - 1] + "R";
                }
                else
                {
                    label_text = AdditionalWarningTP[i - 1];
                    if (AdditionalOutputRR[i - 1] == TRANSLATION_LABEL_WARNING_INVALID_TP) label_text += AdditionalOutputRR[i - 1];
                }
                DrawLineLabel(ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), label_text, add_tTakeProfitLevel[i - 1], tp_label_font_color, true);
                if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
                else ObjectSetInteger(ChartID(), ObjectPrefix + "TPAdditionalLabel" + IntegerToString(i), OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
            }
        }
        if (sets.EntryType == StopLimit)
        {
            DrawLineLabel(ObjectPrefix + "StopPriceLabel", IntegerToString((int)MathRound((MathAbs(tStopPriceLevel - tEntryLevel) / _Point))), tStopPriceLevel, sp_label_font_color);
            if (sets.ShowLines) ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TIMEFRAMES, OBJ_ALL_PERIODS);
            else ObjectSetInteger(ChartID(), ObjectPrefix + "StopPriceLabel", OBJPROP_TIMEFRAMES, OBJ_NO_PERIODS);
        }
    }

    if (StopLoss == 0)
    {
        Print(TRANSLATION_MESSAGE_ENTRY_SL_DIFFERENT);
        return;
    }

    if ((sets.SelectedTab == MarginTab) && (!sets.IsPanelMinimized)) CalculateSymbolLeverage();

    if ((sets.SelectedTab == SwapsTab) && (!sets.IsPanelMinimized)) GetSwapData();
}

//+------------------------------------------------------------------+
//| Gets basic info on Symbol and Account. It remains unchanged.     |
//+------------------------------------------------------------------+
void GetSymbolAndAccountData()
{
    TickSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
    MinLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
    MaxLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
    LotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
    if (!CalculateUnadjustedPositionSize) LotStep_digits = CountDecimalPlaces(LotStep);
    else LotStep_digits = 8;
    ContractSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
    CalcMode = (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(Symbol(), SYMBOL_TRADE_CALC_MODE);
    AccountMarginMode = (ENUM_ACCOUNT_MARGIN_MODE)AccountInfoInteger(ACCOUNT_MARGIN_MODE);
    MarginHedging = SymbolInfoDouble(Symbol(), SYMBOL_MARGIN_HEDGED);
    AccountCurrency = AccountInfoString(ACCOUNT_CURRENCY);
    AccountCurrencyDigits = (int)AccountInfoInteger(ACCOUNT_CURRENCY_DIGITS);

    // A rough patch for cases when account currency is set as RUR instead of RUB.
    if (AccountCurrency == "RUR") AccountCurrency = "RUB";

    MarginCurrency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_MARGIN);
    if (MarginCurrency == "RUR") MarginCurrency = "RUB";
    ProfitCurrency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_PROFIT);
    if (ProfitCurrency == "RUR") ProfitCurrency = "RUB";
    BaseCurrency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_BASE);
    if (BaseCurrency == "RUR") BaseCurrency = "RUB";

    AccStopoutMode = AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE);
    AccStopoutLevel = AccountInfoDouble(ACCOUNT_MARGIN_SO_SO);
    TickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);

    InitialMargin = SymbolInfoDouble(Symbol(), SYMBOL_MARGIN_INITIAL);
    MaintenanceMargin = SymbolInfoDouble(Symbol(), SYMBOL_MARGIN_MAINTENANCE);
    if (MaintenanceMargin == 0) MaintenanceMargin = InitialMargin;

    SwapsTripleDay = WeekdayToString((int)SymbolInfoInteger(Symbol(), SYMBOL_SWAP_ROLLOVER3DAYS));
}

//+------------------------------------------------------------------+
//| Calculates risk size and position size. Sets object values.      |
//+------------------------------------------------------------------+
void CalculateRiskAndPositionSize()
{
    DisplayRisk = sets.Risk;
    double PositionSize = 0;
    double pre_unitcost = 0;
    double UnitCost;
    double commission = CalculateCommission();

    if (!sets.UseMoneyInsteadOfPercentage)
    {
        RiskMoney = Round(AccSize * sets.Risk / 100, AccountCurrencyDigits, RoundDown);
    }
    else
    {
        RiskMoney = sets.MoneyRisk;
        if (AccSize != 0) DisplayRisk = Round(sets.MoneyRisk / AccSize * 100, 2);
        else DisplayRisk = 0;
    }

    CalculateUnitCost(UnitCost, UnitCost_reward);

    if (tStopLossLevel < tEntryLevel)
    {
        PositionDirection = POSITION_TYPE_BUY;
        OrderType = ORDER_TYPE_BUY;
    }
    else if (tStopLossLevel > tEntryLevel)
    {
        PositionDirection = POSITION_TYPE_SELL;
        OrderType = ORDER_TYPE_SELL;
    }
    else return;

    // If account currency == pair's base currency, adjust UnitCost to future rate (SL). Works only for Forex pairs.
    if ((AccountCurrency == BaseCurrency) && ((CalcMode == SYMBOL_CALC_MODE_FOREX) || (CalcMode == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)) && (tStopLossLevel != 0))
    {
        double future_rate = tStopLossLevel;
        double current_rate = 1;
        if (tStopLossLevel < tEntryLevel)
        {
            current_rate = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
        }
        else if (tStopLossLevel > tEntryLevel)
        {
            current_rate = SymbolInfoDouble(_Symbol, SYMBOL_BID);
        }
        UnitCost *= (current_rate / future_rate);
    }

    if ((StopLoss != 0) && (UnitCost != 0) && (TickSize != 0))
    {
        if (sets.RiskFromPositionSize)
        {
            RiskMoney = Round(OutputPositionSize * (StopLoss * UnitCost / TickSize + 2 * commission), AccountCurrencyDigits);
            sets.MoneyRisk = RiskMoney;
            if (AccSize != 0) DisplayRisk = Round(sets.MoneyRisk / AccSize * 100, 2);
            else DisplayRisk = 0;
            PositionSize = OutputPositionSize;
        }
        else
        {
            PositionSize = Round(RiskMoney / (StopLoss * UnitCost / TickSize + 2 * commission), LotStep_digits, RoundDown);
            OutputPositionSize = PositionSize;
        }
    }

    if (!CalculateUnadjustedPositionSize) // If need to adjust to broker's restrictions.
    {
        if (PositionSize < MinLot) OutputPositionSize = MinLot;
        else if ((PositionSize > MaxLot) && (!SurpassBrokerMaxPositionSize)) OutputPositionSize = MaxLot;
        double steps = OutputPositionSize / LotStep;
        if (MathAbs(MathRound(steps) - steps) < 0.00000001) steps = MathRound(steps);
        if (MathFloor(steps) < steps) OutputPositionSize = MathFloor(steps) * LotStep;
    }

    if (TickSize == 0) return;
    OutputRiskMoney = Round((StopLoss * UnitCost / TickSize + 2 * commission) * OutputPositionSize, AccountCurrencyDigits);

    if ((ShowPointValue) || ((UseCommissionToSetTPDistance) && (commission != 0)))
    {
        OutputPointValue = FormatDouble(DoubleToString(OutputPositionSize * UnitCost * (_Point / TickSize), AccountCurrencyDigits), AccountCurrencyDigits);
    }

    if (StopLoss == 0) return;

    // Calculate adjusted position size shares for use here and in RecalculatePositionSize().
    PositionSizeToArray(OutputPositionSize); // Fills ArrayPositionSize[].

    if (tTakeProfitLevel > 0)
    {
        // If account currency == pair's base currency, adjust UnitCost to future rate (TP). Works only for Forex pairs.
        if ((AccountCurrency == BaseCurrency) && ((CalcMode == SYMBOL_CALC_MODE_FOREX) || (CalcMode == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)))
        {
            double future_rate = tTakeProfitLevel;
            double current_rate = 1;
            if (tStopLossLevel < tEntryLevel)
            {
                current_rate = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
            }
            else if (tStopLossLevel > tEntryLevel)
            {
                current_rate = SymbolInfoDouble(_Symbol, SYMBOL_BID);
            }
            UnitCost_reward *= (current_rate / future_rate);
        }

        double PS_Multiplier = 1; // Position size multiplier for multiple TPs. When single TP is used, it is equal 1.
        if (sets.TakeProfitsNumber > 1) PS_Multiplier = (double)sets.TPShare[0] / 100.0; // Use respective position size share.

        MainOutputReward = Round((MathAbs((tTakeProfitLevel - tEntryLevel) * UnitCost_reward / TickSize) - 2 * commission) * ArrayPositionSize[0], AccountCurrencyDigits, RoundDown);

        // For zero share, just ignore this level.
        if  ((PS_Multiplier == 0) || (ArrayPositionSize[0] == 0))
        {
            InputRR = "";
            MainOutputRR = "";
        }
        // Have valid take-profit level that is above entry for SL below entry, or below entry for SL above entry.
        else if ((((tTakeProfitLevel > tEntryLevel) && (tEntryLevel > tStopLossLevel)) || ((tTakeProfitLevel < tEntryLevel) && (tEntryLevel < tStopLossLevel))) && (OutputRiskMoney != 0))
        {
            InputRR = DoubleToString(Round(MathAbs((tTakeProfitLevel - tEntryLevel) / StopLoss), 2, RoundDown), 2);
            MainOutputRR = DoubleToString(Round(MainOutputReward / (OutputRiskMoney / OutputPositionSize * ArrayPositionSize[0]), 2, RoundDown), 2);
        }
        else
        {
            InputRR = TRANSLATION_LABEL_WARNING_INVALID_TP;
            MainOutputRR = InputRR;
        }
        if (MainOutputRR == InputRR) InputRR = "";
    }
    else MainOutputReward = 0;

    // Multiple TPs.
    for (int i = 1; i < sets.TakeProfitsNumber; i++)
    {
        AdditionalOutputReward[i - 1] = 0;
        double add_tTakeProfitLevel = Round(ObjectGetDouble(ChartID(), ObjectPrefix + "TakeProfitLine" + IntegerToString(i), OBJPROP_PRICE), _Digits);
        if (add_tTakeProfitLevel > 0)
        {
            // If account currency == pair's base currency, adjust UnitCost to future rate (TP). Works only for Forex pairs.
            if ((AccountCurrency == BaseCurrency) && ((CalcMode == SYMBOL_CALC_MODE_FOREX) || (CalcMode == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)))
            {
                double future_rate = add_tTakeProfitLevel;
                double current_rate = 1;
                if (tStopLossLevel < tEntryLevel)
                {
                    current_rate = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
                }
                else if (tStopLossLevel > tEntryLevel)
                {
                    current_rate = SymbolInfoDouble(_Symbol, SYMBOL_BID);
                }
                UnitCost_reward *= (current_rate / future_rate);
            }
            AdditionalOutputReward[i - 1] = Round((MathAbs((add_tTakeProfitLevel - tEntryLevel) * UnitCost_reward / TickSize) - 2 * commission) * ArrayPositionSize[i], AccountCurrencyDigits, RoundDown);
            // For zero share, just ignore this level.
            if ((sets.TPShare[i] == 0) || (ArrayPositionSize[i] == 0))
            {
                AdditionalOutputRR[i - 1] = "";
            }
            // Have valid take-profit level that is above entry for SL below entry, or below entry for SL above entry.
            else if ((((add_tTakeProfitLevel > tEntryLevel) && (tEntryLevel > tStopLossLevel)) || ((add_tTakeProfitLevel < tEntryLevel) && (tEntryLevel < tStopLossLevel))) && (OutputRiskMoney != 0))
            {
                AdditionalOutputRR[i - 1] = DoubleToString(Round(AdditionalOutputReward[i - 1] / (OutputRiskMoney / OutputPositionSize * ArrayPositionSize[i]), 2, RoundDown), 2);
            }
            else
            {
                AdditionalOutputRR[i - 1] = TRANSLATION_LABEL_WARNING_INVALID_TP;
            }
        }
        else AdditionalOutputRR[i - 1] = "";
    }

    double PS_Multiplier = 1; // Position size multiplier for multiple TPs. When single TP is used, it is equal 1.
    if (sets.TakeProfitsNumber > 1) PS_Multiplier = (double)sets.TPShare[0] / 100.0; // Use respective position size share.
    InputReward = DoubleToString(Round(RiskMoney * PS_Multiplier * MathAbs(tTakeProfitLevel - tEntryLevel) / StopLoss, AccountCurrencyDigits, RoundDown), AccountCurrencyDigits);

    // Panel's fields start the same as for the main TP.
    OutputReward = MainOutputReward;
    OutputRR = MainOutputRR;
    // In case of multiple TPs:
    if (sets.TakeProfitsNumber > 1)
    {
        double TotalOutputRisk = 0;
        if (OutputPositionSize != 0) TotalOutputRisk = (OutputRiskMoney / OutputPositionSize * ArrayPositionSize[0]); // Main TP output risk money. If main TP share is zero, start with zero.
        double TotalInputRisk = (RiskMoney * (double)sets.TPShare[0] / 100.0); // Main TP input risk money.
        // Calculate cumulative weighted reward and R/R.
        for (int i = 1; i < sets.TakeProfitsNumber; i++)
        {
            OutputReward += AdditionalOutputReward[i - 1];
            if ((AdditionalOutputRR[i - 1] == TRANSLATION_LABEL_WARNING_INVALID_TP) || (MainOutputRR == TRANSLATION_LABEL_WARNING_INVALID_TP)) OutputRR = TRANSLATION_LABEL_WARNING_INVALID_TP; // At least one Invalid TP means that total RR is also invalid.
            if ((OutputPositionSize > 0) && (ArrayPositionSize[i] > 0)) TotalOutputRisk += (OutputRiskMoney / OutputPositionSize * ArrayPositionSize[i]);
            TotalInputRisk += (RiskMoney * (double)sets.TPShare[i] / 100.0);
            if (sets.TP[i] > 0) InputReward = DoubleToString(StringToDouble(InputReward) + Round(RiskMoney * (double)sets.TPShare[i] / 100.0 * MathAbs(sets.TP[i] - tEntryLevel) / StopLoss, AccountCurrencyDigits, RoundDown), AccountCurrencyDigits);
        }
        if (OutputRR != TRANSLATION_LABEL_WARNING_INVALID_TP)
        {
            if (TotalOutputRisk != 0) OutputRR = DoubleToString(Round(OutputReward / TotalOutputRisk, 2, RoundDown), 2);
            else OutputRR = "";
            if (TotalInputRisk != 0) InputRR = DoubleToString(Round(StringToDouble(InputReward) / TotalInputRisk, 2, RoundDown), 2);
            else InputRR = "";
        }
        if (OutputRR == InputRR) InputRR = ""; // No need to display Input R/R if it is the same as Output R/R.
        OutputRiskMoney = TotalOutputRisk;
        RiskMoney = TotalInputRisk;
    }

    if ((sets.SelectedTab == RiskTab) && (!sets.IsPanelMinimized)) CalculatePortfolioRisk();
    // Should be done even on Main tab to calculate Maximum Position Size and change Main tab's position size field's color.
    if (((sets.SelectedTab == MarginTab) || (sets.SelectedTab == MainTab)) && (!sets.IsPanelMinimized)) CalculateMargin();
}

//+------------------------------------------------------------------+
//| Make sure position size complies with broker's limits.           |
//+------------------------------------------------------------------+
double BrokerizePositionSize(const double position_size)
{
    if (CalculateUnadjustedPositionSize) return position_size; // Do not adjust if the input parameter says so.

    if (position_size < MinLot)
    {
        return 0; // Not taking this trade, so PS = 0.
    }
    else if ((position_size > MaxLot) && (!SurpassBrokerMaxPositionSize))
    {
        return MaxLot;
    }
    double steps = 0;
    if (LotStep != 0) steps = position_size / LotStep;
    if (MathAbs(MathRound(steps) - steps) < 0.00000001) steps = MathRound(steps);
    if (MathFloor(steps) < steps) return(MathFloor(steps) * LotStep);

    return position_size;
}

// Calculates risk size and position size. Sets object values.
// Trading tab mode lets calculate quickly calculate percentage risk either as total or for a given symbol to use when executing a trade. 
void CalculatePortfolioRisk(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab = CALCULATE_RISK_FOR_TRADING_TAB_NO)
{
    PortfolioLossMoney = 0;
    double PortfolioRewardMoney = 0;
    double volume = 0;
    if ((sets.CountPendingOrders) || (calculate_risk_for_trading_tab))
    {
        int total = OrdersTotal();
        for (int i = 0; i < total; i++)
        {
            double PointsLoss = 0;
            double PointsReward = 0;
            // Select an order.
            if (!OrderSelect(OrderGetTicket(i))) continue;

            // Skip orders in other symbols if the ignore checkbox is ticked.
            if (!calculate_risk_for_trading_tab)
            {
                if ((OrderGetString(ORDER_SYMBOL) != Symbol()) && (sets.IgnoreOtherSymbols)) continue;
            }
            else if ((OrderGetString(ORDER_SYMBOL) != Symbol()) && (calculate_risk_for_trading_tab == CALCULATE_RISK_FOR_TRADING_TAB_PER_SYMBOL)) continue;

            // Buy orders.
            if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP))
            {
                // No stop-loss.
                if (OrderGetDouble(ORDER_SL) == 0)
                {
                    // Losing all the current value.
                    if ((!sets.IgnoreOrdersWithoutSL) || (calculate_risk_for_trading_tab)) PointsLoss = OrderGetDouble(ORDER_PRICE_OPEN);
                }
                else
                {
                    // Stop-loss below open price.
                    PointsLoss = OrderGetDouble(ORDER_PRICE_OPEN) - OrderGetDouble(ORDER_SL);
                }
                // No take-profit.
                if (OrderGetDouble(ORDER_TP) == 0)
                {
                    // Potential reward is infinite.
                    if ((!sets.IgnoreOrdersWithoutTP) || (calculate_risk_for_trading_tab)) PointsReward = DBL_MAX;
                }
                else
                {
                    PointsReward = OrderGetDouble(ORDER_TP) - OrderGetDouble(ORDER_PRICE_OPEN);
                }
            }
            // Sell orders.
            else if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP))
            {
                // No stop-loss.
                if (OrderGetDouble(ORDER_SL) == 0)
                {
                    // Potential loss is infinite.
                    if ((!sets.IgnoreOrdersWithoutSL) || (calculate_risk_for_trading_tab)) PointsLoss = DBL_MAX;
                }
                else
                {
                    // Stop-loss above open price.
                    PointsLoss = OrderGetDouble(ORDER_SL) - OrderGetDouble(ORDER_PRICE_OPEN);
                }
                // No take-profit.
                if (OrderGetDouble(ORDER_TP) == 0)
                {
                    // Potential reward is current value.
                    if ((!sets.IgnoreOrdersWithoutTP) || (calculate_risk_for_trading_tab)) PointsReward = OrderGetDouble(ORDER_PRICE_OPEN);
                }
                else
                {
                    PointsReward = OrderGetDouble(ORDER_PRICE_OPEN) - OrderGetDouble(ORDER_TP);
                }
            }

            volume += OrderGetDouble(ORDER_VOLUME_CURRENT);

            if ((PointsLoss != DBL_MAX) && (PortfolioLossMoney != DBL_MAX))
            {
                string Symbol_order = OrderGetString(ORDER_SYMBOL);
                ENUM_SYMBOL_CALC_MODE CalcMode_order = (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(Symbol_order, SYMBOL_TRADE_CALC_MODE);
                double UnitCost;
                if ((CalcMode_order == SYMBOL_CALC_MODE_CFD) || (CalcMode_order == SYMBOL_CALC_MODE_CFDINDEX) || (CalcMode_order == SYMBOL_CALC_MODE_CFDLEVERAGE))
                {
                    UnitCost = SymbolInfoDouble(Symbol_order, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(Symbol_order, SYMBOL_TRADE_CONTRACT_SIZE);
                    string symbol_profit_currency = SymbolInfoString(Symbol_order, SYMBOL_CURRENCY_PROFIT);
                    if (symbol_profit_currency != AccountCurrency)
                    {
                        ENUM_ORDER_TYPE order_type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
                        ENUM_POSITION_TYPE dir = POSITION_TYPE_BUY;
                        if ((order_type == ORDER_TYPE_BUY_LIMIT) || (order_type == ORDER_TYPE_BUY_STOP) || (order_type == ORDER_TYPE_BUY_STOP_LIMIT)) dir = POSITION_TYPE_BUY;
                        else if ((order_type == ORDER_TYPE_SELL_LIMIT) || (order_type == ORDER_TYPE_SELL_STOP) || (order_type == ORDER_TYPE_SELL_STOP_LIMIT)) dir = POSITION_TYPE_SELL;
                        double CCC = CalculateAdjustment(Loss, symbol_profit_currency, AccountCurrency, Symbol_order);
                        // Adjust the unit cost.
                        UnitCost *= CCC;
                    }
                }
                // With Forex instruments, tick value already equals 1 unit cost.
                else UnitCost = SymbolInfoDouble(Symbol_order, SYMBOL_TRADE_TICK_VALUE_LOSS);
                double TickSize_local = SymbolInfoDouble(Symbol_order, SYMBOL_TRADE_TICK_SIZE);
                if (TickSize_local == 0)
                {
                    Print(TRANSLATION_MESSAGE_CANNOT_RETRIEVE_TICKSIZE, Symbol_order, ". " + TRANSLATION_MESSAGE_LOOKS_LIKE);
                }
                else
                {
                    // If account currency == pair's base currency, adjust UnitCost to future rate (SL). Works only for Forex pairs.
                    if ((AccountCurrency == SymbolInfoString(Symbol_order, SYMBOL_CURRENCY_BASE)) && ((CalcMode_order == SYMBOL_CALC_MODE_FOREX) || (CalcMode_order == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)))
                    {
                        double current_rate = 1, future_rate = 1;
                        if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP))
                        {
                            current_rate = SymbolInfoDouble(Symbol_order, SYMBOL_ASK);
                            future_rate = current_rate - PointsLoss;
                        }
                        else if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP))
                        {
                            current_rate = SymbolInfoDouble(Symbol_order, SYMBOL_BID);
                            future_rate = current_rate + PointsLoss;
                        }
                        if (OrderGetDouble(ORDER_PRICE_OPEN) == PointsLoss) PortfolioLossMoney = DBL_MAX; // Zero divide prevention + more accurate potential loss reporting.
                        else UnitCost *= (current_rate / future_rate);
                    }
                    if (PortfolioLossMoney != DBL_MAX) PortfolioLossMoney += OrderGetDouble(ORDER_VOLUME_CURRENT) * PointsLoss * UnitCost / TickSize_local;
                }
            }
            else
            {
                // Infinite loss.
                PortfolioLossMoney = DBL_MAX;
            }
            if ((PointsReward != DBL_MAX) && (PortfolioRewardMoney != DBL_MAX))
            {
                string Symbol_order = OrderGetString(ORDER_SYMBOL);
                ENUM_SYMBOL_CALC_MODE CalcMode_order = (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(Symbol_order, SYMBOL_TRADE_CALC_MODE);
                double UnitCost;
                if ((CalcMode_order == SYMBOL_CALC_MODE_CFD) || (CalcMode_order == SYMBOL_CALC_MODE_CFDINDEX) || (CalcMode_order == SYMBOL_CALC_MODE_CFDLEVERAGE))
                {
                    UnitCost = SymbolInfoDouble(Symbol_order, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(Symbol_order, SYMBOL_TRADE_CONTRACT_SIZE);
                    string symbol_profit_currency = SymbolInfoString(Symbol_order, SYMBOL_CURRENCY_PROFIT);
                    if (symbol_profit_currency != AccountCurrency)
                    {
                        ENUM_ORDER_TYPE order_type = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
                        ENUM_POSITION_TYPE dir = POSITION_TYPE_BUY;
                        if ((order_type == ORDER_TYPE_BUY_LIMIT) || (order_type == ORDER_TYPE_BUY_STOP) || (order_type == ORDER_TYPE_BUY_STOP_LIMIT)) dir = POSITION_TYPE_BUY;
                        else if ((order_type == ORDER_TYPE_SELL_LIMIT) || (order_type == ORDER_TYPE_SELL_STOP) || (order_type == ORDER_TYPE_SELL_STOP_LIMIT)) dir = POSITION_TYPE_SELL;
                        double CCC = CalculateAdjustment(Profit, symbol_profit_currency, AccountCurrency, Symbol_order);
                        // Adjust the unit cost.
                        UnitCost *= CCC;
                    }
                }
                // With Forex instruments, tick value already equals 1 unit cost.
                else UnitCost = SymbolInfoDouble(Symbol_order, SYMBOL_TRADE_TICK_VALUE_PROFIT);
                double TickSize_local = SymbolInfoDouble(Symbol_order, SYMBOL_TRADE_TICK_SIZE);
                if (TickSize_local == 0)
                {
                    Print(TRANSLATION_MESSAGE_CANNOT_RETRIEVE_TICKSIZE, Symbol_order, ". " + TRANSLATION_MESSAGE_LOOKS_LIKE);
                }
                else
                {
                    // If account currency == pair's base currency, adjust UnitCost to future rate (TP). Works only for Forex pairs.
                    if ((AccountCurrency == SymbolInfoString(Symbol_order, SYMBOL_CURRENCY_BASE)) && ((CalcMode_order == SYMBOL_CALC_MODE_FOREX) || (CalcMode_order == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)))
                    {
                        double current_rate = 1, future_rate = 1;
                        if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP))
                        {
                            current_rate = SymbolInfoDouble(Symbol_order, SYMBOL_ASK);
                            future_rate = current_rate + PointsReward;
                        }
                        else if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP))
                        {
                            current_rate = SymbolInfoDouble(Symbol_order, SYMBOL_BID);
                            future_rate = current_rate - PointsReward;
                        }
                        if (OrderGetDouble(ORDER_PRICE_OPEN) == PointsReward) PortfolioRewardMoney = DBL_MAX; // Zero divide prevention + more accurate potential profit reporting.
                        else UnitCost *= (current_rate / future_rate);
                    }
                    if (PortfolioRewardMoney != DBL_MAX) PortfolioRewardMoney += OrderGetDouble(ORDER_VOLUME_CURRENT) * PointsReward * UnitCost / TickSize_local;
                }
            }
            else
            {
                // Infinite profit.
                PortfolioRewardMoney = DBL_MAX;
            }
        }
    }

    int total = PositionsTotal();
    for (int i = 0; i < total; i++)
    {
        double PointsLoss = 0;
        double PointsReward = 0;
        // Works with hedging and netting.
        if (PositionSelectByTicket(PositionGetTicket(i)))
        {
            // Skip orders in other symbols if the ignore checkbox is ticked.
            if (!calculate_risk_for_trading_tab)
            {
                if ((PositionGetString(POSITION_SYMBOL) != Symbol()) && (sets.IgnoreOtherSymbols)) continue;
            }
            else if ((PositionGetString(POSITION_SYMBOL) != Symbol()) && (calculate_risk_for_trading_tab == CALCULATE_RISK_FOR_TRADING_TAB_PER_SYMBOL)) continue;

            // Buy position.
            if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
            {
                // No stop-loss.
                if (PositionGetDouble(POSITION_SL) == 0)
                {
                    // Losing all the current value.
                    if ((!sets.IgnoreOrdersWithoutSL) || (calculate_risk_for_trading_tab)) PointsLoss = PositionGetDouble(POSITION_PRICE_OPEN);
                }
                else
                {
                    // Stop-loss below open price.
                    PointsLoss = PositionGetDouble(POSITION_PRICE_OPEN) - PositionGetDouble(POSITION_SL);
                }
                // No take-profit.
                if (PositionGetDouble(POSITION_TP) == 0)
                {
                    // Potential reward is infinite.
                    if ((!sets.IgnoreOrdersWithoutTP) || (calculate_risk_for_trading_tab)) PointsReward = DBL_MAX;
                }
                else
                {
                    PointsReward = PositionGetDouble(POSITION_TP) - PositionGetDouble(POSITION_PRICE_OPEN);
                }
            }
            // Sell positions.
            else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
            {
                // No stop-loss.
                if (PositionGetDouble(POSITION_SL) == 0)
                {
                    // Potential loss is infinite.
                    if ((!sets.IgnoreOrdersWithoutSL) || (calculate_risk_for_trading_tab)) PointsLoss = DBL_MAX;
                }
                else
                {
                    // Stop-loss above open price.
                    PointsLoss = PositionGetDouble(POSITION_SL) - PositionGetDouble(POSITION_PRICE_OPEN);
                }
                // No take-profit.
                if (PositionGetDouble(POSITION_TP) == 0)
                {
                    // Potential reward is current value.
                    if ((!sets.IgnoreOrdersWithoutTP) || (calculate_risk_for_trading_tab)) PointsReward = PositionGetDouble(POSITION_PRICE_OPEN);
                }
                else
                {
                    PointsReward = PositionGetDouble(POSITION_PRICE_OPEN) - PositionGetDouble(POSITION_TP);
                }
            }

            volume += PositionGetDouble(POSITION_VOLUME);

            if ((PointsLoss != DBL_MAX) && (PortfolioLossMoney != DBL_MAX))
            {
                string Symbol_position = PositionGetString(POSITION_SYMBOL);
                ENUM_SYMBOL_CALC_MODE CalcMode_position = (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(Symbol_position, SYMBOL_TRADE_CALC_MODE);
                double UnitCost;
                if ((CalcMode_position == SYMBOL_CALC_MODE_CFD) || (CalcMode_position == SYMBOL_CALC_MODE_CFDINDEX) || (CalcMode_position == SYMBOL_CALC_MODE_CFDLEVERAGE))
                {
                    UnitCost = SymbolInfoDouble(Symbol_position, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(Symbol_position, SYMBOL_TRADE_CONTRACT_SIZE);
                    string symbol_profit_currency = SymbolInfoString(Symbol_position, SYMBOL_CURRENCY_PROFIT);
                    if (symbol_profit_currency != AccountCurrency)
                    {
                        ENUM_POSITION_TYPE dir = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
                        double CCC = CalculateAdjustment(Loss, symbol_profit_currency, AccountCurrency, Symbol_position);
                        // Adjust the unit cost.
                        UnitCost *= CCC;
                    }
                }
                // With Forex instruments, tick value already equals 1 unit cost.
                else UnitCost = SymbolInfoDouble(Symbol_position, SYMBOL_TRADE_TICK_VALUE_LOSS);
                double TickSize_local = SymbolInfoDouble(Symbol_position, SYMBOL_TRADE_TICK_SIZE);

                // If account currency == pair's base currency, adjust UnitCost to future rate (SL). Works only for Forex pairs.
                if ((AccountCurrency == SymbolInfoString(Symbol_position, SYMBOL_CURRENCY_BASE)) && ((CalcMode_position == SYMBOL_CALC_MODE_FOREX) || (CalcMode_position == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)))
                {
                    double current_rate = 1, future_rate = 1;
                    if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                    {
                        current_rate = SymbolInfoDouble(Symbol_position, SYMBOL_ASK);
                        future_rate = current_rate - PointsLoss;
                    }
                    else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                    {
                        current_rate = SymbolInfoDouble(Symbol_position, SYMBOL_BID);
                        future_rate = current_rate + PointsLoss;
                    }
                    if (PositionGetDouble(POSITION_PRICE_OPEN) == PointsLoss) PortfolioLossMoney = DBL_MAX; // Zero divide prevention + more accurate potential loss reporting.
                    else UnitCost *= (current_rate / future_rate);
                }
                if (PortfolioLossMoney != DBL_MAX) PortfolioLossMoney += PositionGetDouble(POSITION_VOLUME) * PointsLoss * UnitCost / TickSize_local - PositionGetDouble(POSITION_SWAP);
            }
            else // Infinite loss
            {
                PortfolioLossMoney = DBL_MAX;
            }

            if ((PointsReward != DBL_MAX) && (PortfolioRewardMoney != DBL_MAX))
            {
                string Symbol_position = PositionGetString(POSITION_SYMBOL);
                ENUM_SYMBOL_CALC_MODE CalcMode_position = (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(Symbol_position, SYMBOL_TRADE_CALC_MODE);
                double UnitCost;
                if ((CalcMode_position == SYMBOL_CALC_MODE_CFD) || (CalcMode_position == SYMBOL_CALC_MODE_CFDINDEX) || (CalcMode_position == SYMBOL_CALC_MODE_CFDLEVERAGE))
                {
                    UnitCost = SymbolInfoDouble(Symbol_position, SYMBOL_TRADE_TICK_SIZE) * SymbolInfoDouble(Symbol_position, SYMBOL_TRADE_CONTRACT_SIZE);
                    string symbol_profit_currency = SymbolInfoString(Symbol_position, SYMBOL_CURRENCY_PROFIT);
                    if (symbol_profit_currency != AccountCurrency)
                    {
                        ENUM_POSITION_TYPE dir = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
                        double CCC = CalculateAdjustment(Profit, symbol_profit_currency, AccountCurrency, Symbol_position);
                        // Adjust the unit cost.
                        UnitCost *= CCC;
                    }
                }
                // With Forex instruments, tick value already equals 1 unit cost.
                else UnitCost = SymbolInfoDouble(Symbol_position, SYMBOL_TRADE_TICK_VALUE_PROFIT);
                double TickSize_local = SymbolInfoDouble(Symbol_position, SYMBOL_TRADE_TICK_SIZE);

                // If account currency == pair's base currency, adjust UnitCost to future rate (TP). Works only for Forex pairs.
                if ((AccountCurrency == SymbolInfoString(Symbol_position, SYMBOL_CURRENCY_BASE)) && ((CalcMode_position == SYMBOL_CALC_MODE_FOREX) || (CalcMode_position == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)))
                {
                    double current_rate = 1, future_rate = 1;
                    if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                    {
                        current_rate = SymbolInfoDouble(Symbol_position, SYMBOL_ASK);
                        future_rate = current_rate + PointsReward;
                    }
                    else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                    {
                        current_rate = SymbolInfoDouble(Symbol_position, SYMBOL_BID);
                        future_rate = current_rate - PointsReward;
                    }
                    if (PositionGetDouble(POSITION_PRICE_OPEN) == PointsReward) PortfolioRewardMoney = DBL_MAX; // Zero divide prevention + more accurate potential profit reporting.
                    else UnitCost *= (current_rate / future_rate);
                }
                if (PortfolioRewardMoney != DBL_MAX) PortfolioRewardMoney += PositionGetDouble(POSITION_VOLUME) * PointsReward * UnitCost / TickSize_local + PositionGetDouble(POSITION_SWAP);
            }
            else
            {
                // Infinite profit.
                PortfolioRewardMoney = DBL_MAX;
            }
        }
    }

    // If account size did not load yet.
    if (AccSize == 0) return;

    if (PortfolioLossMoney == DBL_MAX) PLM = "\x221E";
    else PLM = FormatDouble(DoubleToString(PortfolioLossMoney, AccountCurrencyDigits), AccountCurrencyDigits);

    if (PortfolioLossMoney == DBL_MAX) CPR = "\x221E";
    else CPR = FormatDouble(DoubleToString(PortfolioLossMoney / AccSize * 100, 2));

    if (PortfolioLossMoney == DBL_MAX) PPMR = "\x221E";
    else PPMR = FormatDouble(DoubleToString(PortfolioLossMoney + OutputRiskMoney, AccountCurrencyDigits), AccountCurrencyDigits);

    if (PortfolioLossMoney == DBL_MAX) PPR = "\x221E";
    else PPR = FormatDouble(DoubleToString((PortfolioLossMoney + OutputRiskMoney) / AccSize * 100, 2));

    if (PortfolioRewardMoney == DBL_MAX) PRM = "\x221E";
    else PRM = FormatDouble(DoubleToString(PortfolioRewardMoney, AccountCurrencyDigits), AccountCurrencyDigits);

    if (PortfolioRewardMoney == DBL_MAX) CPRew = "\x221E";
    else CPRew = FormatDouble(DoubleToString(PortfolioRewardMoney / AccSize * 100, 2));

    if ((PortfolioRewardMoney == DBL_MAX) || (OutputReward == 0)) PPMRew = "\x221E";
    else PPMRew = FormatDouble(DoubleToString(PortfolioRewardMoney + OutputReward, AccountCurrencyDigits), AccountCurrencyDigits);

    if ((PortfolioRewardMoney == DBL_MAX) || (OutputReward == 0)) PPRew = "\x221E";
    else PPRew = FormatDouble(DoubleToString((PortfolioRewardMoney + OutputReward) / AccSize * 100, 2));

    CPL = FormatDouble(DoubleToString(volume, LotStep_digits), LotStep_digits);
    PPL = FormatDouble(DoubleToString(volume + OutputPositionSize, LotStep_digits), LotStep_digits);

    if (PortfolioRewardMoney == DBL_MAX)
    {
        if (PortfolioLossMoney == DBL_MAX) CPRRR = "-";
        else CPRRR = "\x221E";
    }
    else if (PortfolioLossMoney == DBL_MAX) CPRRR = "0.00";
    else if (PortfolioLossMoney == 0)
    {
        if (PortfolioRewardMoney != 0) CPRRR = "\x221E";
        else CPRRR = "-";
    }
    else CPRRR = FormatDouble(DoubleToString(PortfolioRewardMoney / PortfolioLossMoney, 2));

    if ((PortfolioRewardMoney == DBL_MAX) || (OutputReward == 0))
    {
        if (PortfolioLossMoney == DBL_MAX) PPRRR = "-";
        else PPRRR = "\x221E";
    }
    else if (PortfolioLossMoney == DBL_MAX) PPRRR = "0.00";
    else if (PortfolioLossMoney + OutputRiskMoney == 0)
    {
        if (PortfolioRewardMoney + OutputReward != 0) PPRRR = "\x221E";
        else PPRRR = "-";
    }
    else PPRRR = FormatDouble(DoubleToString((PortfolioRewardMoney + OutputReward) / (PortfolioLossMoney + OutputRiskMoney), 2));
}

//+------------------------------------------------------------------+
//| Calculates margin before and after position.                     |
//+------------------------------------------------------------------+
void CalculateMargin()
{
    if (TickValue == 0) return;
    
    double initial_margin_rate = 0, maintenance_margin_rate = 0, max_margin_rate = 0;
    SymbolInfoMarginRate(Symbol(), OrderType, initial_margin_rate, maintenance_margin_rate);
    if (maintenance_margin_rate == 0) maintenance_margin_rate = initial_margin_rate;

    PositionMargin = 0;
    double _PositionMargin = 0; // Based on initial margin requirements - used when needed for Future Free Margin check.
    // Multiplication or division by 1 is safe.
    double CurrencyCorrectionCoefficient = 1;
    double PriceCorrectionCoefficient = 1;
    double Leverage = 1;

    if ((CalcMode == SYMBOL_CALC_MODE_FOREX) || (CalcMode == SYMBOL_CALC_MODE_CFDLEVERAGE))
    {
        Leverage = (double)AccountInfoInteger(ACCOUNT_LEVERAGE);
    }
    else if (CalcMode == SYMBOL_CALC_MODE_CFDINDEX) Leverage = TickSize / TickValue;

    // If custom leverage is given via panel's input.
    if (CustomLeverage > 0)
    {
        PreCustomLeverage = Leverage; // Remember the leverage that was before we applied CustomLeverage.
        Leverage = CustomLeverage;
    }

    // If Initial Margin of the symbol is given, a simple formula is used.
    if (InitialMargin > 0) ContractSize = MaintenanceMargin;
    else if ((CalcMode == SYMBOL_CALC_MODE_CFD) || (CalcMode == SYMBOL_CALC_MODE_CFDINDEX) ||
            (CalcMode == SYMBOL_CALC_MODE_EXCH_STOCKS) || (CalcMode == SYMBOL_CALC_MODE_CFDLEVERAGE))
    {
        MqlTick tick;
        SymbolInfoTick(Symbol(), tick);
        if (PositionDirection == POSITION_TYPE_BUY) PriceCorrectionCoefficient = tick.ask;
        else if (PositionDirection == POSITION_TYPE_SELL) PriceCorrectionCoefficient = tick.bid;
    }

    if (Leverage == 0) return;
    
    PositionMargin = (OutputPositionSize * ContractSize * PriceCorrectionCoefficient / Leverage) * maintenance_margin_rate;

    // Otherwise, no need to adjust margin.
    if (AccountCurrency != MarginCurrency) CurrencyCorrectionCoefficient = CalculateAdjustment(Loss, MarginCurrency, AccountCurrency, Symbol());
    if (CurrencyCorrectionCoefficient == 0) // Couldn't calculate correction coefficient due to the lack of the required currency pair.
    {
        CurrencyCorrectionCoefficient = 1;
        MarginInUnconvertedMarginCurrency = true;
    } else MarginInUnconvertedMarginCurrency = false;
    PositionMargin *= CurrencyCorrectionCoefficient;

    // Maximum position size allowed by current margin.
    double MaxPositionSizeByMargin = -1;
    // Maximum position margin tolerable before stop-out.
    double MaxPositionMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
    // Percentage mode.
    if (AccStopoutMode == ACCOUNT_STOPOUT_MODE_PERCENT)
    {
        double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
        // Slightly above account stop-out level.
        double ML = AccStopoutLevel + 0.01;
        if (ML > 0) MaxPositionMargin = 100 * Equity / ML - AccountInfoDouble(ACCOUNT_MARGIN);
    }
    // Absolute value mode.
    else
    {
        // Slightly above account stop-out level.
        MaxPositionMargin = AccStopoutLevel + 0.01;
    }
    if (AccountInfoDouble(ACCOUNT_MARGIN_FREE) - MaxPositionMargin < 0) MaxPositionMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);

    PreHedgingPositionMargin = PositionMargin;

    // Check netting/hedging

    // Netting:
    if (AccountMarginMode != ACCOUNT_MARGIN_MODE_RETAIL_HEDGING)
    {
        if ((PositionSelect(Symbol())) && (PositionGetInteger(POSITION_TYPE) != PositionDirection))
        {
            double existing_open_price = 1;
            double existing_volume = PositionGetDouble(POSITION_VOLUME);
            ENUM_POSITION_TYPE existing_dir = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            if ((CalcMode == SYMBOL_CALC_MODE_CFD) || (CalcMode == SYMBOL_CALC_MODE_CFDINDEX) ||
                    (CalcMode == SYMBOL_CALC_MODE_EXCH_STOCKS) || (CalcMode == SYMBOL_CALC_MODE_CFDLEVERAGE))
            {
                existing_open_price = PositionGetDouble(POSITION_PRICE_OPEN);
            }

            double ExistingPositionMargin = (existing_volume * ContractSize * existing_open_price / Leverage) * maintenance_margin_rate;

            // Otherwise, no need to adjust margin.
            double CurrencyCorrectionCoefficient_existing = 1;
            if (AccountCurrency != MarginCurrency)
            {
                MqlTick tick;
                SymbolInfoTick(Symbol(), tick);
                // This yields inaccurate margin of existing position, but it is the best we can get so far.
                CurrencyCorrectionCoefficient_existing = (tick.bid != 0) ?  (1 / tick.bid) : -1;
            }
            ExistingPositionMargin *= CurrencyCorrectionCoefficient_existing;

            // If new position will just eat out old margin - adjust it to the previous margin size.
            if (existing_volume >= OutputPositionSize) PositionMargin = -(OutputPositionSize * ContractSize * existing_open_price * CurrencyCorrectionCoefficient_existing / Leverage) * maintenance_margin_rate;
            else PositionMargin = -ExistingPositionMargin + ((OutputPositionSize - existing_volume) * ContractSize * PriceCorrectionCoefficient * CurrencyCorrectionCoefficient / Leverage) * maintenance_margin_rate;

            // If initial margin requirement are bigger than maintenance margin requirement, we need to calculate a separate position margin value
            // to check if we have enough necessary free margin before placing a trade.
            if ((InitialMargin > MaintenanceMargin) || (initial_margin_rate > maintenance_margin_rate))
            {
                if (InitialMargin > 0) ContractSize = InitialMargin;
                ExistingPositionMargin = (existing_volume * ContractSize * existing_open_price / Leverage) * initial_margin_rate;
                ExistingPositionMargin *= CurrencyCorrectionCoefficient_existing;
                if (existing_volume >= OutputPositionSize) _PositionMargin = -(OutputPositionSize * ContractSize * existing_open_price * CurrencyCorrectionCoefficient_existing / Leverage) * initial_margin_rate;
                else _PositionMargin = -ExistingPositionMargin + ((OutputPositionSize - existing_volume) * ContractSize * PriceCorrectionCoefficient * CurrencyCorrectionCoefficient / Leverage) * initial_margin_rate;
                // Adjust MPM with new
                MaxPositionMargin = MaxPositionMargin + ExistingPositionMargin;
            }
            else
            {
                _PositionMargin = PositionMargin;
            }

            // When calculating maximum position margin, we can safely assume that MPM will be greater than or equal to EPM.
            // Thus maximum position margin is simply increased by EPM.
            MaxPositionMargin = MaxPositionMargin + ExistingPositionMargin;
        }
        else if ((InitialMargin > MaintenanceMargin) || (initial_margin_rate > maintenance_margin_rate))
        {
            if (InitialMargin > 0) ContractSize = InitialMargin;
            _PositionMargin = (OutputPositionSize * ContractSize * PriceCorrectionCoefficient / Leverage) * initial_margin_rate;
            _PositionMargin *= CurrencyCorrectionCoefficient;
        }
        else
        {
            _PositionMargin = PositionMargin;
        }
    }
    // Hedging:
    else
    {
        if (ContractSize == 0) return;

        double HedgedRatio = MarginHedging / ContractSize;

        // Hedging on partial or no margin.
        if (NormalizeDouble(HedgedRatio, 2) < 1.00)
        {
            // Cycle through all open orders on this Symbol to find directional volume.
            double volume = 0;
            int type = -1;
            int total = PositionsTotal();
            for (int i = 0; i < total; i++)
            {
                if (!PositionSelectByTicket(PositionGetTicket(i))) continue;

                if (PositionGetString(POSITION_SYMBOL) != Symbol()) continue;

                if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
                {
                    if (type == POSITION_TYPE_BUY) volume += PositionGetDouble(POSITION_VOLUME);
                    else if (type == POSITION_TYPE_SELL)
                    {
                        volume -= PositionGetDouble(POSITION_VOLUME);
                        if (volume < 0)
                        {
                            type = POSITION_TYPE_BUY;
                            volume = -volume;
                        }
                    }
                    else if (type == -1)
                    {
                        volume = PositionGetDouble(POSITION_VOLUME);
                        type = POSITION_TYPE_BUY;
                    }
                }
                else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL)
                {
                    if (type == POSITION_TYPE_SELL) volume += PositionGetDouble(POSITION_VOLUME);
                    else if (type == POSITION_TYPE_BUY)
                    {
                        volume -= PositionGetDouble(POSITION_VOLUME);
                        if (volume < 0)
                        {
                            type = POSITION_TYPE_SELL;
                            volume = -volume;
                        }
                    }
                    else if (type == -1)
                    {
                        volume = PositionGetDouble(POSITION_VOLUME);
                        type = POSITION_TYPE_SELL;
                    }
                }
            }
            // There is position to hedge and new position is in opposite direction.
            if ((volume > 0) && (type != PositionDirection))
            {
                double calculated_volume, margin_rate_to_use;
                if (OutputPositionSize <= volume) calculated_volume = OutputPositionSize * (HedgedRatio - 1);
                else calculated_volume = volume * HedgedRatio + OutputPositionSize - 2 * volume;

                PositionMargin = (calculated_volume * ContractSize * PriceCorrectionCoefficient / Leverage) * maintenance_margin_rate;
                PositionMargin *= CurrencyCorrectionCoefficient;

                // If initial margin requirement are bigger than maintenance margin requirement, we need to calculate a separate position margin value
                // to check if we have enough necessary free margin before placing a trade.
                if ((InitialMargin > MaintenanceMargin) || (initial_margin_rate > maintenance_margin_rate))
                {
                    if (InitialMargin > 0) ContractSize = InitialMargin;
                    _PositionMargin = (calculated_volume * ContractSize * PriceCorrectionCoefficient / Leverage) * initial_margin_rate;
                    _PositionMargin *= CurrencyCorrectionCoefficient;
                    margin_rate_to_use = initial_margin_rate;
                }
                else // Based on maintenance margin.
                {
                    margin_rate_to_use = maintenance_margin_rate;
                }
                // Calculations for maximum position size:
                // 1. Find maximum position size for a given maximum position margin if the size is kept less than or equal to existing opposite volume.
                for (MaxPositionSizeByMargin = 0; MaxPositionSizeByMargin <= volume; MaxPositionSizeByMargin += LotStep)
                {
                    if ((HedgedRatio - 1) * MaxPositionSizeByMargin * ContractSize * PriceCorrectionCoefficient * margin_rate_to_use * CurrencyCorrectionCoefficient / Leverage > MaxPositionMargin)
                    {
                        MaxPositionSizeByMargin -= LotStep;
                        break;
                    }
                }
                // 2. Find maximum position size for a given maximum position margin if the size is greater than existing opposite volume.
                if (PriceCorrectionCoefficient * maintenance_margin_rate * CurrencyCorrectionCoefficient != 0)
                {
                    double MPS_gv = 0;
                    MPS_gv = MaxPositionMargin / (ContractSize * PriceCorrectionCoefficient * margin_rate_to_use * CurrencyCorrectionCoefficient / Leverage) - volume * (HedgedRatio - 2);
                    if (MPS_gv > MaxPositionSizeByMargin) MaxPositionSizeByMargin = MPS_gv;
                }
            }
        }
        if ((InitialMargin > MaintenanceMargin) || (initial_margin_rate > maintenance_margin_rate))
        {
            if (InitialMargin > 0) ContractSize = InitialMargin;
            _PositionMargin = (OutputPositionSize * ContractSize * PriceCorrectionCoefficient / Leverage) * initial_margin_rate;
            _PositionMargin *= CurrencyCorrectionCoefficient;
        }
        else
        {
            _PositionMargin = PositionMargin;
        }
    }

    // Max position size.
    double margin_rate_to_use = maintenance_margin_rate;
    if ((InitialMargin > MaintenanceMargin) || (initial_margin_rate > maintenance_margin_rate)) margin_rate_to_use = initial_margin_rate;
    if ((MaxPositionSizeByMargin == -1) && (ContractSize != 0) && (PriceCorrectionCoefficient != 0) && (margin_rate_to_use != 0) && (CurrencyCorrectionCoefficient != 0))
        MaxPositionSizeByMargin = (MaxPositionMargin * Leverage) / (ContractSize * PriceCorrectionCoefficient * margin_rate_to_use * CurrencyCorrectionCoefficient);

    MaxPositionSizeByMargin = Round(MaxPositionSizeByMargin, LotStep_digits, RoundDown);

    OutputMaxPositionSize = MaxPositionSizeByMargin;
    if (!CalculateUnadjustedPositionSize) // If need to adjust to broker's restrictions.
    {
        if (MaxPositionSizeByMargin < MinLot) OutputMaxPositionSize = 0; // Cannot open any position at all.
        else if ((MaxPositionSizeByMargin > MaxLot) && (!SurpassBrokerMaxPositionSize)) OutputMaxPositionSize = MaxLot;
        double steps = 0;
        if (LotStep != 0) steps = OutputMaxPositionSize / LotStep;
        if (MathAbs(MathRound(steps) - steps) < 0.00000001) steps = MathRound(steps);
        if (MathFloor(steps) < steps) OutputMaxPositionSize = MathFloor(steps) * LotStep;
    }
    // End Max position size.

    UsedMargin = AccountInfoDouble(ACCOUNT_MARGIN) + _PositionMargin;

    StopOut = false;
    FutureMargin = Round(AccountInfoDouble(ACCOUNT_MARGIN_FREE) - PositionMargin, AccountCurrencyDigits, RoundDown);
    double _FutureMargin = Round(AccountInfoDouble(ACCOUNT_MARGIN_FREE) - _PositionMargin, AccountCurrencyDigits, RoundDown);

    // Percentage mode.
    if (AccStopoutMode == ACCOUNT_STOPOUT_MODE_PERCENT)
    {
        double Equity = AccountInfoDouble(ACCOUNT_EQUITY);
        double ML = 0;

        if (UsedMargin != 0) ML = Equity / UsedMargin * 100;
        if ((ML > 0) && (ML <= AccStopoutLevel)) StopOut = true;
    }
    // Absolute value mode.
    else
    {
        if (_FutureMargin <= AccStopoutLevel) StopOut = true;
    }

    if (_FutureMargin < 0) StopOut = true;
}

//+-----------------------------------------------------------------------------------+
//| Calculates necessary adjustments for cases when GivenCurrency != AccountCurrency. |
//| Used in two cases: profit adjustment and margin adjustment.                       |
//| symbol is used only to store information about warnings.                          |
//+-----------------------------------------------------------------------------------+
double CalculateAdjustment(PROFIT_LOSS calc_mode, const string CCY1, const string CCY2, const string symbol)
{
    MqlTick tick;
    string ReferencePair = NULL;

    if (CCY1 != CCY2)
    {
        // Try direct quote.
        ReferencePair = GetSymbolByCurrencies(CCY1, CCY2);
        if (ReferencePair != NULL)
        {
            SymbolInfoTick(ReferencePair, tick);
            if ((tick.ask == 0) || (tick.bid == 0)) return (-1); // Data is not yet ready.
            if (calc_mode == Profit)
            {
                // Using Sell price for direct quote.
                return tick.bid;
            }
            else
            {
                // Using Buy price for direct quote.
                return tick.ask;
            }
        }

        // Try reverse quote.
        ReferencePair = GetSymbolByCurrencies(CCY2, CCY1);
        if (ReferencePair != NULL)
        {
            SymbolInfoTick(ReferencePair, tick);
            if ((tick.ask == 0) || (tick.bid == 0)) return (-1); // Data is not yet ready.
            if (calc_mode == Profit)
            {
                // Using Buy price for reverse quote.
                return (1 / tick.ask);
            }
            else
            {
                // Using Sell price for reverse quote.
                return (1 / tick.bid);
            }
        }

        // Get the cross rate through US dollar, but only if it's not USD it is trying to find the rate for.
        if ((CCY1 != "USD") && (CCY2 != "USD")) return CalculateAdjustment(calc_mode, CCY1, "USD", symbol) * CalculateAdjustment(calc_mode, "USD", CCY2, symbol);
    }
    // Check if there has already been a warning about this case and warn if there hasn't been one.
    bool already_warned = false;
    int array_size = ArraySize(WarnedSymbols);
    string combination = CCY1 + CCY2 + symbol;
    for (int i = 0; i < array_size; i++)
    {
        if (WarnedSymbols[i] == combination) // Already warned.
        {
            already_warned = true;
            break;
        }
    }
    if (!already_warned) // Warn.
    {
        Print(TRANSLATION_MESSAGE_CANNOT_CONVERT, " ", CCY1, " ", TRANSLATION_MESSAGE_CANNOT_CONVERT_TO, " ", CCY2, ". ", TRANSLATION_MESSAGE_CANNOT_CONVERT_CALCULATION, " ", symbol);
        ArrayResize(WarnedSymbols, array_size + 1); // Increase the array size.
        WarnedSymbols[array_size] = combination; // Remember the symbol/currencies combination.
    }
    return 1;
}

//+---------------------------------------------------------------------------+
//| Returns a currency pair with specified base currency and profit currency. |
//+---------------------------------------------------------------------------+
string GetSymbolByCurrencies(string base_currency, string profit_currency)
{
    bool is_custom = false;
    if (SymbolExist(base_currency + profit_currency, is_custom))
    {
        string symbol = base_currency + profit_currency;

        // Select if necessary.
        if (!(bool)SymbolInfoInteger(symbol, SYMBOL_SELECT)) SymbolSelect(symbol, true);

        return symbol;
    }

    int CacheSize = ArraySize(CurrencyPairsList);

    // Cache all currency pairs to speed up further search.
    if (!CacheSize)
    {
        // Cycle through all symbols.
        for (int s = 0; s < SymbolsTotal(false); s++)
        {
            // Get symbol name by number.
            string symbolname = SymbolName(s, false);

            // Skip non-Forex pairs.
            if ((SymbolInfoInteger(symbolname, SYMBOL_TRADE_CALC_MODE) != SYMBOL_CALC_MODE_FOREX) && (SymbolInfoInteger(symbolname, SYMBOL_TRADE_CALC_MODE) != SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)) continue;

            // Add symbol to the cache.
            ArrayResize(CurrencyPairsList, CacheSize + 1, 128);

            CurrencyPairsList[CacheSize++] = symbolname;
        }
    }

    // Cycle through all currency pairs.
    for (int s = 0; s < CacheSize; s++)
    {
        // Get symbol name by number.
        string symbolname = CurrencyPairsList[s];

        // Get its base currency.
        string b_cur = SymbolInfoString(symbolname, SYMBOL_CURRENCY_BASE);

        // Get its profit currency.
        string p_cur = SymbolInfoString(symbolname, SYMBOL_CURRENCY_PROFIT);

        // If the currency pair matches both currencies, select it in Market Watch and return its name.
        if ((b_cur == base_currency) && (p_cur == profit_currency))
        {
            // Select if necessary.
            if (!(bool)SymbolInfoInteger(symbolname, SYMBOL_SELECT)) SymbolSelect(symbolname, true);

            return symbolname;
        }
    }
    return NULL;
}

//+------------------------------------------------------------------+
//| Gets info on overnight swaps.                                               |
//+------------------------------------------------------------------+
void GetSwapData()
{
    ENUM_SYMBOL_SWAP_MODE swap_mode = (ENUM_SYMBOL_SWAP_MODE)SymbolInfoInteger(Symbol(), SYMBOL_SWAP_MODE);
    double swap_long = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_LONG);
    double swap_short = SymbolInfoDouble(Symbol(), SYMBOL_SWAP_SHORT);
    double swap_long_1_lot = EMPTY_VALUE, swap_short_1_lot = EMPTY_VALUE;
    switch(swap_mode)
    {
    // Disabled
    case SYMBOL_SWAP_MODE_DISABLED:
        OutputSwapsType = TRANSLATION_LABEL_DISABLED;
        swap_long_1_lot = 0;
        swap_short_1_lot = 0;
        break;
    // Points
    case SYMBOL_SWAP_MODE_POINTS:
    {
        OutputSwapsType = TRANSLATION_LABEL_POINTS;

        double UnitCost_long, UnitCost_short;

        if (swap_long > 0) UnitCost_long = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE_PROFIT);
        else UnitCost_long = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE_LOSS);
        if (swap_short > 0) UnitCost_short = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE_PROFIT);
        else UnitCost_short = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE_LOSS);

        if ((ProfitCurrency != AccountCurrency) && (CalcMode != SYMBOL_CALC_MODE_FOREX) && (CalcMode != SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE))
        {
            double UnitCost_loss, UnitCost_profit;
            CalculateUnitCost(UnitCost_loss, UnitCost_profit);
            if (swap_long > 0) UnitCost_long = UnitCost_profit;
            else UnitCost_long = UnitCost_loss;
            if (swap_short > 0) UnitCost_short = UnitCost_profit;
            else UnitCost_short = UnitCost_loss;
        }
        swap_long_1_lot = swap_long * UnitCost_long;
        swap_short_1_lot = swap_short * UnitCost_short;
    }
    break;
    // Base or margin currency
    case SYMBOL_SWAP_MODE_CURRENCY_SYMBOL:
    case SYMBOL_SWAP_MODE_CURRENCY_MARGIN:
    {
        string base_or_margin_currency;
        if (swap_mode == SYMBOL_SWAP_MODE_CURRENCY_SYMBOL)
        {
            base_or_margin_currency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_BASE);
            OutputSwapsType = TRANSLATION_LABEL_BASE_CURRENCY + " (" + base_or_margin_currency + ")";
        }
        else
        {
            base_or_margin_currency = SymbolInfoString(Symbol(), SYMBOL_CURRENCY_MARGIN);
            OutputSwapsType = TRANSLATION_LABEL_MARGIN_CURRENCY + " (" + base_or_margin_currency + ")";
        }
        // Simple case:
        if (AccountCurrency == base_or_margin_currency)
        {
            swap_long_1_lot = swap_long;
            swap_short_1_lot = swap_short;
        }
        // Need to find the current BAS/ACC or ACC/BAS rate.
        else
        {
            // Simple case - use Symbol rates for conversion:
            if (AccountCurrency == ProfitCurrency)
            {
                double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                swap_long_1_lot = swap_long * bid;
                swap_short_1_lot = swap_short * bid;
            }
            // Go through Market Watch trying to find the currency pair with both base_currency and account_currency in it.
            else
            {
                double CCC = CalculateAdjustment(Profit, base_or_margin_currency, AccountCurrency, Symbol());
                swap_long_1_lot = swap_long * CCC;
                swap_short_1_lot = swap_short * CCC;
            }
        }
    }
    break;
    // Interest (both cases are equal at the moment of position opening)
    case SYMBOL_SWAP_MODE_INTEREST_OPEN:
    case SYMBOL_SWAP_MODE_INTEREST_CURRENT:
    {
        if (TickSize == 0) return;
        if (swap_mode == SYMBOL_SWAP_MODE_INTEREST_OPEN) OutputSwapsType = TRANSLATION_LABEL_INTEREST_OPEN;
        else if (swap_mode == SYMBOL_SWAP_MODE_INTEREST_CURRENT) OutputSwapsType = TRANSLATION_LABEL_INTEREST_CURRENT;
        double symbol_cost_1_lot_profit, symbol_cost_1_lot_loss;

        // CFD.
        if ((CalcMode == SYMBOL_CALC_MODE_CFD) || (CalcMode == SYMBOL_CALC_MODE_CFDINDEX) || (CalcMode == SYMBOL_CALC_MODE_CFDLEVERAGE))
        {
            // Calculate it by pending order's price.
            if ((sets.EntryType == Pending) || (sets.EntryType == StopLimit))
                symbol_cost_1_lot_loss = ContractSize * sets.EntryLevel;
            // Calculate it by current price of contract - it is impossible to determine potential future price.
            else symbol_cost_1_lot_loss = ContractSize * SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            symbol_cost_1_lot_profit = symbol_cost_1_lot_loss;
            if (ProfitCurrency != AccountCurrency)
            {
                double CCC_loss = CalculateAdjustment(Loss, ProfitCurrency, AccountCurrency, Symbol());
                double CCC_profit = CalculateAdjustment(Profit, ProfitCurrency, AccountCurrency, Symbol());
                // Adjust the unit cost.
                symbol_cost_1_lot_profit = symbol_cost_1_lot_loss * CCC_profit;
                symbol_cost_1_lot_loss = symbol_cost_1_lot_loss * CCC_loss;
            }
        }
        else // Non-CFD.
        {
            double UnitCost_loss, UnitCost_profit;
            CalculateUnitCost(UnitCost_loss, UnitCost_profit);
            // For loss (negative swap):
            // Calculate it by pending order's price.
            if ((sets.EntryType == Pending) || (sets.EntryType == StopLimit))
                symbol_cost_1_lot_loss = UnitCost_loss * sets.EntryLevel / TickSize;
            // Calculate it by current price of contract - it is impossible to determine potential future price.
            else symbol_cost_1_lot_loss = UnitCost_loss * SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize;
            // For profit (positive swap):
            if ((sets.EntryType == Pending) || (sets.EntryType == StopLimit))
                symbol_cost_1_lot_profit = UnitCost_profit * sets.EntryLevel / TickSize;
            // Calculate it by current price of contract - it is impossible to determine potential future price.
            else symbol_cost_1_lot_profit = UnitCost_profit * SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize;
        }

        // Percentage per 360 days.
        if (swap_long > 0) swap_long_1_lot = swap_long * symbol_cost_1_lot_profit / 100 / 360; // Positive swap - point value based profit calcution.
        else if (swap_long < 0) swap_long_1_lot = swap_long * symbol_cost_1_lot_loss / 100 / 360; // Negative swap - point value based loss calcution.
        else swap_long_1_lot = 0;
        if (swap_short > 0) swap_short_1_lot = swap_short * symbol_cost_1_lot_profit / 100 / 360; // Positive swap - point value based profit calcution.
        else if (swap_short < 0) swap_short_1_lot = swap_short * symbol_cost_1_lot_loss / 100 / 360; // Negative swap - point value based loss calcution.
        else swap_short_1_lot = 0;
        // Stupid fix for strange cases when swap is given not in percentage points but in coefficient (?).
        if (MathAbs(swap_long) < 0.1)
        {
            swap_long_1_lot *= 1000;
            swap_short_1_lot *= 1000;
        }
    }
    break;
    // Account currency
    case SYMBOL_SWAP_MODE_CURRENCY_DEPOSIT:
    {
        OutputSwapsType = AccountCurrency;
        swap_long_1_lot = swap_long;
        swap_short_1_lot = swap_short;
    }
    break;
    // Reopen - impossible to predict
    case SYMBOL_SWAP_MODE_REOPEN_CURRENT:
    case SYMBOL_SWAP_MODE_REOPEN_BID:
        OutputSwapsType = TRANSLATION_LABEL_REOPENING;
        break;
    default:
        break;
    }
    if ((swap_long_1_lot != EMPTY_VALUE) && (swap_short_1_lot != EMPTY_VALUE))
    {
        OutputSwapsDailyLongLot = FormatDouble(DoubleToString(swap_long_1_lot, AccountCurrencyDigits), AccountCurrencyDigits);
        OutputSwapsDailyShortLot = FormatDouble(DoubleToString(swap_short_1_lot, AccountCurrencyDigits), AccountCurrencyDigits);
        OutputSwapsCurrencyDailyLot = AccountCurrency + " " + TRANSLATION_LABEL_PER_LOT;
        OutputSwapsDailyLongPS = FormatDouble(DoubleToString(swap_long_1_lot * OutputPositionSize, AccountCurrencyDigits), AccountCurrencyDigits);
        OutputSwapsDailyShortPS = FormatDouble(DoubleToString(swap_short_1_lot * OutputPositionSize, AccountCurrencyDigits), AccountCurrencyDigits);
        OutputSwapsCurrencyDailyPS = AccountCurrency + " " + TRANSLATION_LABEL_PER_PS + " (" + DoubleToString(OutputPositionSize, 2) + ")";

        OutputSwapsYearlyLongLot = FormatDouble(DoubleToString(swap_long_1_lot * 360, AccountCurrencyDigits), AccountCurrencyDigits);
        OutputSwapsYearlyShortLot = FormatDouble(DoubleToString(swap_short_1_lot * 360, AccountCurrencyDigits), AccountCurrencyDigits);
        OutputSwapsCurrencyYearlyLot = AccountCurrency + " " + TRANSLATION_LABEL_PER_LOT;
        OutputSwapsYearlyLongPS = FormatDouble(DoubleToString(swap_long_1_lot * 360 * OutputPositionSize, AccountCurrencyDigits), AccountCurrencyDigits);
        OutputSwapsYearlyShortPS = FormatDouble(DoubleToString(swap_short_1_lot * 360 * OutputPositionSize, AccountCurrencyDigits), AccountCurrencyDigits);
        OutputSwapsCurrencyYearlyPS = AccountCurrency + " " + TRANSLATION_LABEL_PER_PS + " (" + DoubleToString(OutputPositionSize, 2) + ")";
    }
}

//+------------------------------------------------------------------+
//| Round a double value to a given decimal place - down or normal.  |
//+------------------------------------------------------------------+
double Round(const double value, const double digits, bool round_down = false)
{
    int norm = (int)MathPow(10, digits);
    if (!round_down) return(MathRound(value * norm) / norm);
    else return(MathFloor(value * norm) / norm);
}

//+---------------------------------------------------------------------------+
//| Formats double with thousands separator for so many digits after the dot. |
//+---------------------------------------------------------------------------+
string FormatDouble(const string number, const int digits = 2)
{
    // Find "." position.
    int pos = StringFind(number, ".");
    string integer = number;
    string decimal = "";
    if (pos > -1)
    {
        integer = StringSubstr(number, 0, pos);
        decimal = StringSubstr(number, pos, digits + 1);
    }
    string formatted = "";
    string comma = "";

    while (StringLen(integer) > 3)
    {
        int length = StringLen(integer);
        string group = StringSubstr(integer, length - 3);
        formatted = group + comma + formatted;
        comma = ",";
        integer = StringSubstr(integer, 0, length - 3);
    }
    if (integer == "-") comma = "";
    if (integer != "") formatted = integer + comma + formatted;

    return(formatted + decimal);
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
//| Draws a label for a line with a geiven text.                     |
//+------------------------------------------------------------------+
void DrawLineLabel(const string label, const string text, const double price, const color col, bool above = false, int font_size_modifier = 0)
{
    // Data not loaded yet.
    if (Bars(Symbol(), Period()) <= 0) return;

    int x, y;
    long real_x;
    uint w, h;

    ObjectSetString(0, label, OBJPROP_TEXT, text);
    ObjectSetInteger(0, label, OBJPROP_FONTSIZE, font_size + font_size_modifier);
    ObjectSetString(0, label, OBJPROP_FONT, font_face);
    ObjectSetInteger(0, label, OBJPROP_COLOR, col);
    real_x = ChartGetInteger(0, CHART_WIDTH_IN_PIXELS) - 2;
    // Needed only for y, x is derived from the chart width.
    ChartTimePriceToXY(0, 0, iTime(Symbol(), Period(), 0), price, x, y);
    // Get the width of the text based on font and its size. Negative because OS-dependent, *10 because set in 1/10 of pt.
    TextSetFont(font_face, (font_size + font_size_modifier) * -10);
    TextGetSize(text, w, h);
    ObjectSetInteger(0, label, OBJPROP_XDISTANCE, real_x - w);
    if (above) y -= int(h + 1);
    ObjectSetInteger(0, label, OBJPROP_YDISTANCE, y);
    ChartRedraw();
}


//+------------------------------------------------------------------+
//| Calculates symbol leverage value based on required margin           |
//| and current rates.                                                      |
//+------------------------------------------------------------------+
void CalculateSymbolLeverage()
{
    // UnitCost can be different from tickValue in some cases.
    double UnitCost_loss, UnitCost_profit;
    CalculateUnitCost(UnitCost_loss, UnitCost_profit);
    if ((TickSize == 0) || (UnitCost_loss == 0)) return;
    double lotValue = SymbolInfoDouble(Symbol(), SYMBOL_ASK) / TickSize * UnitCost_loss;
    if (PreHedgingPositionMargin == 0) return;
    double margin = PreHedgingPositionMargin;
    if ((PreCustomLeverage > 0) && (CustomLeverage > 0)) margin = margin * CustomLeverage / PreCustomLeverage; // Recalculate margin using the original leverage, not the custom leverage.
    SymbolLeverage = lotValue / margin * OutputPositionSize;
    if ((SymbolLeverage - MathRound(SymbolLeverage)) / SymbolLeverage < 0.01) SymbolLeverageDecimals = 0; // Avoid resiudual decimal places when they are too small.
    else SymbolLeverageDecimals = CountDecimalPlaces(SymbolLeverage);
    
    if (SymbolLeverageDecimals > 2) SymbolLeverageDecimals = 2; // Avoid too much precision here.
}

//+----------------------------------------------------------------------+
//| Calculates unit cost for loss and unit cost for reward calculations. |
//+----------------------------------------------------------------------+
void CalculateUnitCost(double &UnitCost_loss, double &UnitCost_profit)
{
    // No-Forex.
    if ((CalcMode != SYMBOL_CALC_MODE_FOREX) && (CalcMode != SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE) && (CalcMode != SYMBOL_CALC_MODE_FUTURES) && (CalcMode != SYMBOL_CALC_MODE_EXCH_FUTURES) && (CalcMode != SYMBOL_CALC_MODE_EXCH_FUTURES_FORTS))
    {
        UnitCost_loss = TickSize * ContractSize;
        UnitCost_profit = UnitCost_loss;
        // If profit currency is different from account currency.
        if (ProfitCurrency != AccountCurrency)
        {
            double CCC = CalculateAdjustment(Loss, ProfitCurrency, AccountCurrency, Symbol());
            // Adjust the unit cost.
            UnitCost_loss *= CCC;
            CCC = CalculateAdjustment(Profit, ProfitCurrency, AccountCurrency, Symbol());
            UnitCost_profit *= CCC;
        }
    }
    // With Forex instruments, tick value already equals 1 unit cost.
    else
    {
        UnitCost_loss = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE_LOSS);
        UnitCost_profit = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE_PROFIT);
        if ((UnitCost_loss == 0) || (UnitCost_profit == 0)) WarnAboutZeroUnitCost();
    }
}

// Moves an element with the name to the index position in the list.
void CPanelList::MoveListElementByName(const string name, const int index)
{
    CStringForList * obj;
    for (obj = GetFirstNode(); obj != NULL; obj = GetNextNode())
    {
        if (obj.Name == name)
        {
            MoveToIndex(index);
            return;
        }
    }
}

// Delete an element by its name.
void CPanelList::DeleteListElementByName(const string name)
{
    for (CStringForList * obj = GetFirstNode(); obj != NULL; obj = GetNextNode())
    {
        if (obj.Name == name)
        {
            DeleteCurrent();
            return;
        }
    }
}

// Creates an element in the list using the name and object.
void CPanelList::CreateListElementByName(CObject &obj, const string name)
{
    CStringForList *node = new CStringForList;
    node.Name = name;
    node.Obj = GetPointer(obj);
    Add(node);
}

void CPanelList::SetHiddenByName(const string name, const bool hidden)
{
    for (CStringForList * obj = GetFirstNode(); obj != NULL; obj = GetNextNode())
    {
        if (obj.Name == name)
        {
            obj.Hidden = hidden;
            return;
        }
    }
}

void DissectHotKeyCombination(const string hotkey, bool &shift_required, bool &ctrl_required, uchar &main_key)
{
    ushort separator;
    // Set these to false because they could be set to true during previous EA initialization.
    shift_required = false;
    ctrl_required = false; 
    if (StringFind(hotkey, "+") > -1) separator = StringGetCharacter("+", 0);
    else if (StringFind(hotkey, "-") > -1) separator = StringGetCharacter("-", 0);
    else separator = 0;
    string keys[];
    int n = StringSplit(hotkey, separator, keys);
    if (n < 1) return; // Wrong or empty.
    if (n > 1) // A key with a modifier.
    {
        for (int i = 0; i < n - 1; i++)
        {
            StringToUpper(keys[i]);
            if (keys[i] == "SHIFT") shift_required = true;
            else if (keys[i] == "CTRL") ctrl_required = true;
        }
    }
    StringToUpper(keys[n - 1]);
    if (keys[n - 1] == "TAB") main_key = 9;
    else if ((keys[n - 1] == "ESC") || (keys[n - 1] == "ESCAPE")) main_key = 27;
    else if ((keys[n - 1] == "BACKSPACE") || (keys[n - 1] == "BACK") || (keys[n - 1] == "BS") || (keys[n - 1] == "BKSP")) main_key = 8;
    else if ((keys[n - 1] == "CAPS") || (keys[n - 1] == "CAPS LOCK") || (keys[n - 1] == "CAPSLOCK") || (keys[n - 1] == "CAPSLK")) main_key = 20;
    else main_key = (uchar)StringGetCharacter(keys[n - 1], 0);
    if (main_key == 96) main_key = 192; // A hack to use ` as a hotkey.
}

void WarnAboutZeroUnitCost()
{
    if (WarnedAboutZeroUnitCost == 1) // Issue the actual alert only after the first dry run, to avoid sending an alert when symbol data is still loading.
    {
        if (WarnedAboutZeroUnitCost != 2) Alert(TRANSLATION_MESSAGE_MISCONFIGURED_SYMBOL);
        WarnedAboutZeroUnitCost = 2;
        return;
    }
    if (WarnedAboutZeroUnitCost != 2) WarnedAboutZeroUnitCost = 1;
}

double CalculateCommission()
{
    double commission = sets.CommissionPerLot; // If commission type is set to currency units. Very easy.
    if (sets.CommissionType == COMMISSION_PERCENT) // Commission in %. Tricky.
    {
        // Need to convert this commission to currency units. The result may be incorrect in some cases.
        double contract_size = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_CONTRACT_SIZE);
        double ContractValue = 0;
        if ((CalcMode == SYMBOL_CALC_MODE_FOREX) || (CalcMode == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)) // Forex.
        {
            if (BaseCurrency == AccountCurrency) // E.g. USD/CAD.
            {
                ContractValue = contract_size;
            }
            else
            {
                if (ProfitCurrency == AccountCurrency) // E.g., EUR/USD.
                {
                    ContractValue = contract_size * SymbolInfoDouble(Symbol(), SYMBOL_ASK);
                }
                else // E.g., GBP/JPY.
                {
                    // Conversion needed:
                    double ccc = CalculateAdjustment(Loss, BaseCurrency, AccountCurrency, Symbol());
                    ContractValue = contract_size * ccc;
                }
            }
        }
        else // Everything non-Forex.
        {
            // Let's consider that the contract price is in the profit currency (which isn't strictly true unfortunately).
            if (ProfitCurrency == AccountCurrency) // E.g., trading US500 on a USD account.
            {
                ContractValue = contract_size * SymbolInfoDouble(Symbol(), SYMBOL_ASK);
            }
            else // E.g., trading Nikkei on a USD account.
            {
                // Conversion needed:
                double ccc = CalculateAdjustment(Loss, BaseCurrency, AccountCurrency, Symbol());
                ContractValue = contract_size * ccc;
            }
        }
        commission = ContractValue * sets.CommissionPerLot / 100;
    }
    return commission;
}

string WeekdayToString(int weekday)
{
    switch(weekday)
    {
        case 0: return TRANSLATION_EDIT_WEEKDAY_SUNDAY;
        case 1: return TRANSLATION_EDIT_WEEKDAY_MONDAY;
        case 2: return TRANSLATION_EDIT_WEEKDAY_TUESDAY;
        case 3: return TRANSLATION_EDIT_WEEKDAY_WEDNESDAY;
        case 4: return TRANSLATION_EDIT_WEEKDAY_THURSDAY;
        case 5: return TRANSLATION_EDIT_WEEKDAY_FRIDAY;
        case 6: return TRANSLATION_EDIT_WEEKDAY_SATURDAY;
    }
    return TRANSLATION_MESSAGE_ERROR;
}

// Calculate adjusted position size shares for use in Position Sizer.mqh and Position Sizer Trading.mhq.
void PositionSizeToArray(double ps)
{
    if (sets.TakeProfitsNumber > 1)
    {
        // Calculate volume for each partial trade.
        // The goal is to use normal rounded down values for all TPs and then gradually distribute the remainder.
        double AccumulatedPositionSize = 0; // Total PS used by additional TPs.
        // Divide everything equally, but rounding down. There will be a remainder.
        for (int i = sets.TakeProfitsNumber - 1; i >= 0; i--)
        {
            double position_size = BrokerizePositionSize(ps * (double)sets.TPShare[i] / 100.0);
            AccumulatedPositionSize = NormalizeDouble(AccumulatedPositionSize + position_size, LotStep_digits);
            ArrayPositionSize[i] = position_size;
        }
        // Distribute remaining position size if/while there is a remainder to distribute.
        while (ps - AccumulatedPositionSize > 0) 
        {
            for (int i = 0; i < sets.TakeProfitsNumber; i++)
            {
                ArrayPositionSize[i] = NormalizeDouble(ArrayPositionSize[i] + LotStep, LotStep_digits);
                AccumulatedPositionSize = NormalizeDouble(AccumulatedPositionSize + LotStep, LotStep_digits);
                if (AccumulatedPositionSize >= ps) break;
            }            
        }
    }
    else ArrayPositionSize[0] = ps;
}
//+------------------------------------------------------------------+