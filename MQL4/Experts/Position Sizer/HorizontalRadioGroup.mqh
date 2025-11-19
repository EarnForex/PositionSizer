//+------------------------------------------------------------------+
//|                                         HorizontalRadioGroup.mqh |
//|                                  Copyright © 2025, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                             Based on RadioGroup.mqh by MQL5.com. |
//|                             Copyright 2000-2025, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <Controls\WndClient.mqh>
#include <Controls\RadioButton.mqh>
#include <Arrays\ArrayString.mqh>
#include <Arrays\ArrayLong.mqh>

//+------------------------------------------------------------------+
//| Class HorizontalRadioGroup                                       |
//| Usage: horizontal radio group without scrollbars.                |
//+------------------------------------------------------------------+
class CHorizontalRadioGroup : public CWndClient
{
private:
    //--- dependent controls
    CRadioButton      m_columns[];           // array of the columnobjects
    //--- set up
    int               m_total;               // number of columns
    long              m_total_width;         // total sum of widthsof all columns
    //--- data
    CArrayString      m_strings;             // array of columns
    CArrayLong        m_values;              // array of values
    CArrayLong        m_widths;              // array of widths
    int               m_current;             // index of current column in array of columns

public:
    CHorizontalRadioGroup();
    ~CHorizontalRadioGroup(void);
    //--- create
    virtual bool      Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2);
    virtual void      Destroy(const int reason = 0);
    //--- chart event handler
    virtual bool      OnEvent(const int id, const long &lparam, const double &dparam, const string &sparam);
    //--- fill
    virtual bool      AddItem(const string item, const long value, const long item_width);
    //--- data
    long              Value(void) const
    {
        return(m_values.At(m_current));
    }
    bool              Value(const long value);
    bool              ValueCheck(long value) const;
    //--- state
    //--- methods for working with files
    virtual bool      Save(const int file_handle);
    virtual bool      Load(const int file_handle);

protected:
    //--- create dependent controls
    bool              CreateButton(const int index, const long item_width);
    //--- handlers of the dependent controls events
    virtual bool      OnChangeItem(const int column_index);
    //--- redraw
    bool              ColumnState(const int index, const bool select);
    void              Select(const int index);
};

//+------------------------------------------------------------------+
//| Common handler of chart events                                   |
//+------------------------------------------------------------------+
EVENT_MAP_BEGIN(CHorizontalRadioGroup)
ON_INDEXED_EVENT(ON_CHANGE, m_columns, OnChangeItem)
EVENT_MAP_END(CWndClient)

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CHorizontalRadioGroup::CHorizontalRadioGroup() :
    m_total(0),
    m_total_width(0), // Should be set via 
    m_current(CONTROLS_INVALID_INDEX)
{
}

//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CHorizontalRadioGroup::~CHorizontalRadioGroup(void)
{
}

//+------------------------------------------------------------------+
//| Create a control                                                 |
//+------------------------------------------------------------------+
bool CHorizontalRadioGroup::Create(const long chart, const string name, const int subwin, const int x1, const int y1, const int x2, const int y2)
{
//--- call method of the parent class
    if (!CWndClient::Create(chart, name, subwin, x1, y1, x2, y2))
        return false;
//--- set up
    if (!m_background.ColorBackground(CONTROLS_RADIOGROUP_COLOR_BG))
        return false;
    if (!m_background.ColorBorder(CONTROLS_RADIOGROUP_COLOR_BG))
        return false;
//--- succeed
    return true;
}
//+------------------------------------------------------------------+
//| Delete group of controls                                         |
//+------------------------------------------------------------------+
void CHorizontalRadioGroup::Destroy(const int reason)
{
//--- call of the method of the parent class
    CWndClient::Destroy(reason);
//--- clear items
    m_strings.Clear();
    m_values.Clear();
    m_widths.Clear();
}

//+------------------------------------------------------------------+
//| Create "column"                                                  |
//+------------------------------------------------------------------+
bool CHorizontalRadioGroup::CreateButton(const int index, const long item_width)
{
//--- calculate coordinates
    int x1 = CONTROLS_BORDER_WIDTH + (int)m_total_width;
    int y1 = CONTROLS_BORDER_WIDTH;
    int x2 = x1 + (int)item_width;
    int y2 = Height() - CONTROLS_BORDER_WIDTH;
//--- create
    if (!m_columns[index].Create(m_chart_id, m_name + "Item" + IntegerToString(index), m_subwin, x1, y1, x2, y2))
        return false;
    if (!m_columns[index].Text(m_strings[index]))
        return false;
    if (!Add(m_columns[index]))
        return false;
// Increment total width of all items.
    m_total_width += item_width;
//---
    return true;
}

//+------------------------------------------------------------------+
//| Add item (column)                                                |
//+------------------------------------------------------------------+
bool CHorizontalRadioGroup::AddItem(const string item, const long value, const long item_width)
{
//--- check value
    if (value != 0 && !ValueCheck(value))
        return false;
//--- add
    if (!m_strings.Add(item))
        return false;
    if (!m_values.Add(value))
        return false;
    if (!m_widths.Add(item_width))
        return false;

    m_total++;

//--- create dependent controls
    ArrayResize(m_columns, m_total);
    if (!CreateButton(m_total - 1, item_width))
        return false;

    return true;
}

bool CHorizontalRadioGroup::Value(const long value)
{
    int total = m_values.Total();
//---
    for(int i = 0; i < total; i++)
        if (m_values.At(i) == value)
            Select(i);
//---
    return true;
}

bool CHorizontalRadioGroup::ValueCheck(long value) const
{
    int total = m_values.Total();
//---
    for(int i = 0; i < total; i++)
        if (m_values.At(i) == value)
            return false;
//---
    return true;
}

bool CHorizontalRadioGroup::Save(const int file_handle)
{
//--- check
    if (file_handle == INVALID_HANDLE)
        return false;
//---
    FileWriteLong(file_handle, Value());
//--- succeed
    return true;
}

bool CHorizontalRadioGroup::Load(const int file_handle)
{
//--- check
    if (file_handle == INVALID_HANDLE)
        return false;
//---
    if (!FileIsEnding(file_handle))
        Value(FileReadLong(file_handle));
//--- succeed
    return true;
}

void CHorizontalRadioGroup::Select(const int index)
{
//--- disable the "ON" state
    if (m_current != -1)
        ColumnState(m_current, false);
//--- enable the "ON" state
    if (index != -1)
        ColumnState(index, true);
//--- save value
    m_current = index;
}

//+------------------------------------------------------------------+
//| Change state                                                     |
//+------------------------------------------------------------------+
bool CHorizontalRadioGroup::ColumnState(const int index, const bool select)
{
//--- check index
    if (index < 0 || index >= ArraySize(m_columns))
        return true;
//--- change state
    return(m_columns[index].State(select));
}

//+------------------------------------------------------------------+
//| Handler of changing a "column" state                             |
//+------------------------------------------------------------------+
bool CHorizontalRadioGroup::OnChangeItem(const int column_index)
{
//--- select "column"
    Select(column_index);
//--- send notification
    EventChartCustom(INTERNAL_EVENT, ON_CHANGE, m_id, 0.0, m_name);
//--- handled
    return true;
}
//+------------------------------------------------------------------+