//+------------------------------------------------------------------+
//|                                                PortfolioRisk.mqh |
//|                                  Copyright © 2026, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
// Portfolio risk and reward calculation based on the Risk Calculator indicator's algorithm.
// For each symbol, the open positions and the pending orders (with their SL/TP) are simulated along all possible price paths:
// a pending order is executed when the price reaches it, an SL/TP closes its position, and the minimum (maximum) profit over
// all the paths is the maximum loss (maximum reward). Hedged and otherwise entangled positions are thus accounted for exactly.
// Works with both netting (one position per symbol, orders merge into it) and hedging accounts. Supports stop-limit orders.
// The results include the accrued swaps and the commission still to be charged (the exit of each position, both deals of each pending order).
// Known issues:
// 1. Too many pending orders with SL/TP on one symbol may be too slow to process (see PR_MAX_ITERATIONS).
// 2. Assumes constant spread.
// 3. Ignores lack of margin for order execution.
// 4. Ignores correlations of currency pairs.
// 5. Does not take into account price slippage.

#define PR_UNLIMITED -DBL_MAX // Unlimited loss (or reward).
#define PR_UNDEFINED DBL_MAX // Nothing has been calculated yet.
#define PR_MAX_ITERATIONS 100000 // Maximum number of simulated price path nodes per symbol and mode. Prevents the panel from freezing on too many entangled orders.
#define PR_OVERFLOW_MEMORY 16 // Number of remembered order sets that exceeded PR_MAX_ITERATIONS. Prevents repeating the same too long simulation on every tick.
#define PR_PLANNED_TICKET ((long)1 << 62) // Tickets of the planned trade's orders start here - far above any real ticket, so that they are processed after the real orders at the same price.

enum PR_ORDER_STATUS {PR_Pending, PR_SLTP, PR_StopLimit, PR_Inactive};
enum PR_ORDER_TYPE {PR_Buy, PR_Sell};
enum PR_ORDER_KIND {PR_KIND_LIMIT, PR_KIND_STOP, PR_KIND_STOP_LIMIT}; // The kind of a pending order. Needed by the margin calculation (PortfolioMargin.mqh).
enum PR_MODE {PR_Risk, PR_Reward};

//+------------------------------------------------------------------+
//| Structure PR_SymbolContext.                                      |
//| Purpose: Symbol data used by the iterator to convert profit/loss |
//|          into the account currency.                              |
//+------------------------------------------------------------------+
struct PR_SymbolContext
{
    double point;        // The symbol's point. Needed to accurately compare doubles.
    int    digits;       // The symbol's digits. Needed to normalize the spread-shifted levels.
    double spread;       // The current spread in price units. Assumed constant.
    double unit_cost;    // Account currency per 1.0 of price movement per 1 lot at the current rate.
    double current_rate; // The symbol's current price, which the unit cost corresponds to.
    bool   future_rate;  // If true, profit/loss is converted at the exit price instead of the current one (Forex pairs whose base currency is the account currency).
};
PR_SymbolContext PR_Ctx;

// Converts profit/loss given in price units multiplied by lots into the account currency. at_price - the price at which it is realized.
double PR_ToMoney(const double units, const double at_price)
{
    if ((!PR_Ctx.future_rate) || (at_price <= 0)) return units * PR_Ctx.unit_cost;
    return units * PR_Ctx.unit_cost * PR_Ctx.current_rate / at_price;
}

//+------------------------------------------------------------------+
//| Class CDOMObject.                                                |
//| Purpose: Base class for storing simulated orders.                |
//+------------------------------------------------------------------+
class CDOMObject
{
private:
    CDOMObject      *m_prev; // Previous item in the list.
    CDOMObject      *m_next; // Next item in the list.

protected:
    long             ticket;
    double           price;
    double           volume;
    PR_ORDER_TYPE    type;
    double           sl;
    double           tp;

public:
                     CDOMObject(): m_prev(NULL), m_next(NULL) {}
                     CDOMObject(long t, double p, double v, PR_ORDER_TYPE order_type, double order_sl, double order_tp);
                    ~CDOMObject() {}

    CDOMObject       *Prev() const {return m_prev;}
    void             Prev(CDOMObject *node) {m_prev = node;}
    CDOMObject       *Next() const {return m_next;}
    void             Next(CDOMObject *node) {m_next = node;}
    virtual double   Price() {return price;}
    virtual double   Vol() {return volume;}
    virtual double   SL() {return sl;}
    virtual double   TP() {return tp;}
    virtual long     Ticket() {return ticket;}
    virtual PR_ORDER_TYPE Type() {return type;}
    virtual PR_ORDER_STATUS Status() {return PR_Pending;}
    virtual long     Origin() {return -1;}
    virtual double   StopLimit() {return 0;}
    virtual PR_ORDER_KIND Kind() {return PR_KIND_LIMIT;}
};

CDOMObject::CDOMObject(long t, double p, double v, PR_ORDER_TYPE order_type, double order_sl, double order_tp)
{
    ticket = t;
    price = p;
    volume = v;
    type = order_type;
    sl = order_sl;
    tp = order_tp;
    m_prev = NULL;
    m_next = NULL;
}

//+------------------------------------------------------------------+
//| Class CStatusObject                                              |
//| Purpose: Basic class for status order description.               |
//+------------------------------------------------------------------+
class CStatusObject : public CDOMObject
{
public:
                     CStatusObject(double p, double v, PR_ORDER_TYPE order_type, double order_sl, double order_tp): CDOMObject(0, p, v, order_type, order_sl, order_tp) {};
                     CStatusObject(long t, double p, double v, PR_ORDER_TYPE order_type, double order_sl, double order_tp): CDOMObject(t, p, v, order_type, order_sl, order_tp) {};

    // Methods of setting (netting mode).
    void             SetType(PR_ORDER_TYPE new_type) {type = new_type;}
    void             SetPrice(double new_price) {price = new_price;}
    void             SetVolume(double new_volume) {volume = new_volume;}
    void             SetSL(double new_sl) {sl = new_sl;}
    void             SetTP(double new_tp) {tp = new_tp;}
};

//+------------------------------------------------------------------+
//| Class CRemainingOrderObject                                      |
//| Purpose: Basic class for remaining order description.            |
//+------------------------------------------------------------------+
class CRemainingOrderObject : public CDOMObject
{
protected:
    PR_ORDER_STATUS  status;
    long             origin;     // Ticket of the position an SL/TP belongs to, or of the stop-limit order an inactive limit order belongs to.
    double           stop_limit; // For a stop-limit order: the price of its limit order (Bid terms).
    PR_ORDER_KIND    kind;       // For a pending order: limit, stop, or stop-limit. The limit order of a stop-limit is a limit one.

public:
                     CRemainingOrderObject(long t, double p, double v, PR_ORDER_TYPE order_type, double order_sl, double order_tp, PR_ORDER_STATUS st, long o, double s_l): CDOMObject(t, p, v, order_type, order_sl, order_tp), status(st), origin(o), stop_limit(s_l), kind(PR_KIND_LIMIT) {};
                    ~CRemainingOrderObject() {}

    virtual PR_ORDER_STATUS Status() {return status;}
    virtual long     Origin() {return origin;}
    virtual double   StopLimit() {return stop_limit;}
    virtual PR_ORDER_KIND Kind() {return kind;}
    void             SetStatus(PR_ORDER_STATUS new_status) {status = new_status;}
    void             SetKind(PR_ORDER_KIND new_kind) {kind = new_kind;}
};

//+------------------------------------------------------------------+
//| Class COrderMap                                                  |
//| Purpose: Provides the possibility of working with the map of     |
//|          CDOMObject (and inherited classes) instances. Nodes are |
//|          sorted by price (descending), then by ticket.           |
//+------------------------------------------------------------------+
class COrderMap : public CDOMObject
{
protected:
    CDOMObject      *m_first_node; // Pointer to the first element of the list.
    CDOMObject      *m_last_node;  // Pointer to the last element of the list.
    CDOMObject      *m_curr_node;  // Pointer to the current element of the list.
    int              m_curr_idx;   // Index of the currently selected list item.
    int              m_data_total; // Number of elements in the list.

public:
                     COrderMap(): m_first_node(NULL), m_last_node(NULL), m_curr_node(NULL), m_curr_idx(-1), m_data_total(0) {}
                    ~COrderMap() {Clear();}

    int              Total() const {return m_data_total;}

    int              Add(CDOMObject *new_node);

    int              IndexOf(CDOMObject *node);
    CDOMObject      *GetNodeAtIndex(int index);
    CDOMObject      *GetFirstNode();
    CDOMObject      *GetCurrentNode() {return m_curr_node;}
    CDOMObject      *GetNextNode();
    CDOMObject      *GetFirstNodeAtPrice(double order_price);
    CDOMObject      *GetNodeByTicket(long order_ticket);

    CDOMObject      *DetachCurrent();
    bool             DeleteCurrent();
    bool             Delete(int index);
    void             Clear();
};

// Index of the element specified via the pointer to the list item.
int COrderMap::IndexOf(CDOMObject *node)
{
    if (!CheckPointer(node) || !CheckPointer(m_curr_node)) return -1;
    if (node == m_curr_node) return m_curr_idx;
    if (GetFirstNode() == node) return 0;
    for (int i = 1; i < m_data_total; i++)
        if (GetNextNode() == node) return i;
    return -1;
}

// Adds a new element to the right place - no need to sort. Among the nodes with the same price, the one with the smaller ticket goes first:
// SL/TP (ticket 0) before pending orders, old pending orders before new ones.
int COrderMap::Add(CDOMObject *new_node)
{
    if (!CheckPointer(new_node)) return -1;

    if (m_first_node == NULL)
    {
        m_first_node = new_node;
        m_last_node = new_node;
        m_curr_idx = 0;
    }
    else
    {
        CDOMObject *node;
        for (node = GetFirstNode(), m_curr_idx = 0; node != NULL; node = GetNextNode(), m_curr_idx++)
        {
            // New node should be put before 'node'.
            if (node.Price() < new_node.Price())
            {
                // If the previous nodes have the same price as the new one, cycle back while their ticket is greater.
                while ((node.Prev() != NULL) && (node.Prev().Price() == new_node.Price()) && (node.Prev().Ticket() > new_node.Ticket()))
                {
                    node = node.Prev();
                    m_curr_idx--;
                }
                if (node == m_first_node)
                {
                    new_node.Next(m_first_node);
                    m_first_node.Prev(new_node);
                    m_first_node = new_node;
                    break;
                }
                else
                {
                    node.Prev().Next(new_node);
                    new_node.Prev(node.Prev());
                    new_node.Next(node);
                    node.Prev(new_node);
                    break;
                }
            }
        }
        // Did not add during the cycle. New node's price is lower than any node in the list.
        if (node == NULL)
        {
            m_last_node.Next(new_node);
            new_node.Prev(m_last_node);
            m_last_node = new_node;
            m_curr_idx = m_data_total;
        }
    }
    m_curr_node = new_node;
    m_data_total++;

    return m_data_total;
}

// Gets a pointer to the element at the given position in the list.
CDOMObject *COrderMap::GetNodeAtIndex(int index)
{
    int i;
    bool reverse;
    CDOMObject *result;

    if (index >= m_data_total) return NULL;
    if (index == m_curr_idx) return m_curr_node;

    if (index < m_curr_idx)
    {
        if (m_curr_idx - index < index) // Closer to the current index.
        {
            i = m_curr_idx;
            reverse = true;
            result = m_curr_node;
        }
        else // Closer to the top of the list.
        {
            i = 0;
            reverse = false;
            result = m_first_node;
        }
    }
    else
    {
        if (index - m_curr_idx < m_data_total - index - 1) // Closer to the current index.
        {
            i = m_curr_idx;
            reverse = false;
            result = m_curr_node;
        }
        else // Closer to the end of the list.
        {
            i = m_data_total - 1;
            reverse = true;
            result = m_last_node;
        }
    }

    if (!CheckPointer(result)) return NULL;

    if (reverse)
    {
        for (; i > index; i--)
        {
            result = result.Prev();
            if (result == NULL) return NULL;
        }
    }
    else
    {
        for (; i < index; i++)
        {
            result = result.Next();
            if (result == NULL) return NULL;
        }
    }
    m_curr_idx = index;

    return(m_curr_node = result);
}

CDOMObject *COrderMap::GetFirstNode()
{
    if (!CheckPointer(m_first_node)) return NULL;
    m_curr_idx = 0;
    return(m_curr_node = m_first_node);
}

CDOMObject *COrderMap::GetNextNode()
{
    if (!CheckPointer(m_curr_node) || m_curr_node.Next() == NULL) return NULL;
    m_curr_idx++;
    return(m_curr_node = m_curr_node.Next());
}

// Gets a pointer to the first (left-most) node with the given price.
CDOMObject *COrderMap::GetFirstNodeAtPrice(double order_price)
{
    if (!CheckPointer(m_first_node)) return NULL;

    for (m_curr_node = m_first_node, m_curr_idx = 0; m_curr_idx < m_data_total; m_curr_node = m_curr_node.Next(), m_curr_idx++)
    {
        if (MathAbs(m_curr_node.Price() - order_price) < PR_Ctx.point / 2) return m_curr_node;
        else if (m_curr_node.Price() < order_price) return NULL; // Not found.
    }

    m_curr_idx = 0;
    m_curr_node = m_first_node;
    return NULL;
}

// Gets a pointer to the node with the given ticket number.
CDOMObject *COrderMap::GetNodeByTicket(long order_ticket)
{
    if (!CheckPointer(m_first_node)) return NULL;

    if ((CheckPointer(m_curr_node)) && (m_curr_node.Ticket() == order_ticket)) return m_curr_node;

    for (m_curr_node = m_first_node, m_curr_idx = 0; m_curr_idx < m_data_total; m_curr_node = m_curr_node.Next(), m_curr_idx++)
        if (m_curr_node.Ticket() == order_ticket) return m_curr_node;

    m_curr_idx = 0;
    m_curr_node = m_first_node;
    return NULL;
}

// Detaches the current item from the list.
CDOMObject *COrderMap::DetachCurrent()
{
    CDOMObject *tmp_node, *result = NULL;

    if (!CheckPointer(m_curr_node)) return result;

    result = m_curr_node;
    m_curr_node = NULL;

    // If the deleted item was not the last one, pull up the "tail" of the list.
    if ((tmp_node = result.Next()) != NULL)
    {
        tmp_node.Prev(result.Prev());
        m_curr_node = tmp_node;
    }

    // If the deleted item was not the first one, pull up the "head" of the list.
    if ((tmp_node = result.Prev()) != NULL)
    {
        tmp_node.Next(result.Next());
        if (m_curr_node == NULL) // The last node was removed - move the current pointer to the end of the list.
        {
            m_curr_node = tmp_node;
            m_curr_idx = m_data_total - 2;
        }
    }

    m_data_total--;

    if (m_first_node == result) m_first_node = result.Next();
    if (m_last_node == result) m_last_node = result.Prev();

    result.Prev(NULL);
    result.Next(NULL);

    return result;
}

bool COrderMap::DeleteCurrent()
{
    CDOMObject *result = DetachCurrent();
    if (result == NULL) return false;
    if (CheckPointer(result) == POINTER_DYNAMIC) delete result;
    return true;
}

bool COrderMap::Delete(int index)
{
    if (GetNodeAtIndex(index) == NULL) return false;
    return DeleteCurrent();
}

void COrderMap::Clear()
{
    GetFirstNode();
    while (m_data_total != 0)
        if (!DeleteCurrent()) break;
}

//+------------------------------------------------------------------+
//| Class COrderIterator                                             |
//| Purpose: Iterates through orders recursively to find minimum     |
//|          profit (maximum loss). Works in account currency.       |
//|          The path walk is reused by CMarginIterator              |
//|          (PortfolioMargin.mqh) via the virtual methods.          |
//+------------------------------------------------------------------+
class COrderIterator
{
public:
    CStatusObject   *Status;        // The open position (netting mode).
    COrderMap       *StatusHedging; // Open positions (hedging mode).
    COrderMap       *RO;            // Remaining orders: pending orders, stop-limit orders with their inactive limit orders, and SL/TP levels.
    double           current_price;
    double           unrealized_profit;
    double           realized_profit;
    static double    min_profit; // Same value across all instances. Serves as max_profit for the Reward calculation.
    static int       iterations; // Number of processed nodes. Checked against PR_MAX_ITERATIONS.
    static bool      overflow;   // Set to true when PR_MAX_ITERATIONS is exceeded.
    static bool      hedging;    // Same value across all instances.

    PR_MODE          mode; // Risk or Reward.

    bool             skip_above;
    bool             skip_below;
    double           op_above;
    double           op_below;

                     COrderIterator(CStatusObject *input_Status, COrderMap &input_RO, double input_current_price, double input_unrealized_profit, double input_realized_profit, PR_MODE input_mode);
                     COrderIterator(COrderMap *input_Status, COrderMap &input_RO, double input_current_price, double input_unrealized_profit, double input_realized_profit, PR_MODE input_mode);
                     COrderIterator(void): Status(NULL), StatusHedging(NULL), RO(NULL), current_price(0), unrealized_profit(0), realized_profit(0), mode(PR_Risk), skip_above(false), skip_below(false), op_above(PR_UNDEFINED), op_below(PR_UNDEFINED)
    {
        if (hedging) StatusHedging = new COrderMap;
        RO = new COrderMap;
    }
                    ~COrderIterator(void)
    {
        if (CheckPointer(Status) != POINTER_INVALID) delete Status;
        if (CheckPointer(StatusHedging) != POINTER_INVALID) delete StatusHedging;
        delete RO;
    }

    void             Iterate(double order_price);
    virtual COrderIterator *NewChild(); // Creates the iterator for a recursion branch - of the same class as this one.
    virtual void     Evaluate(); // Records what the calculation is looking for at the current node: the profit (risk/reward) or the used margin.
    bool             CheckSimplicity();
    void             CheckPairedOrders();
    double           FindPriceAbove();
    double           FindPriceBelow();
    void             ProcessOrder(double order_price);
    virtual void     CalculateMaxUp();
    virtual void     CalculateMaxDown();
    void             AddExecutedOrderToStatus(CRemainingOrderObject &RO_order);
    double           OpenPrice(CRemainingOrderObject &RO_order);
    void             AddSLTPtoRO(CRemainingOrderObject &RO_order);
    void             AddBasicSLTPtoRO(double price, long origin);
    void             RemoveOrderFromRO(CRemainingOrderObject &RO_order);
    void             RemoveOrderFromStatus(CRemainingOrderObject &RO_order);
    void             CalculateUnrealizedProfit();
    void             ActivatePendingOrder(CRemainingOrderObject &RO_order);

    // Netting only.
    void             RemoveCurrentSLTP();
    void             RemoveCurrentSL();
    void             RemoveCurrentTP();
    void             RemoveSecondExit(double price);
};

double COrderIterator::min_profit = PR_UNDEFINED;
int COrderIterator::iterations = 0;
bool COrderIterator::overflow = false;
bool COrderIterator::hedging = false;

// Constructor for the recursion branches (netting). Copies the position and the list.
COrderIterator::COrderIterator(CStatusObject *input_Status, COrderMap &input_RO, double input_current_price, double input_unrealized_profit, double input_realized_profit, PR_MODE input_mode)
{
    RO = new COrderMap;
    StatusHedging = NULL;
    CDOMObject *order;

    if (CheckPointer(input_Status) != POINTER_INVALID) Status = new CStatusObject(input_Status.Price(), input_Status.Vol(), input_Status.Type(), input_Status.SL(), input_Status.TP());
    else Status = NULL;

    for (order = input_RO.GetFirstNode(); order != NULL; order = input_RO.GetNextNode())
    {
        CRemainingOrderObject *new_RO_order = new CRemainingOrderObject(order.Ticket(), order.Price(), order.Vol(), order.Type(), order.SL(), order.TP(), order.Status(), order.Origin(), order.StopLimit());
        new_RO_order.SetKind(order.Kind());
        RO.Add(new_RO_order);
    }

    current_price = input_current_price;
    unrealized_profit = input_unrealized_profit;
    realized_profit = input_realized_profit;
    skip_above = false;
    skip_below = false;
    op_above = PR_UNDEFINED;
    op_below = PR_UNDEFINED;
    mode = input_mode;
}

// Constructor for the recursion branches (hedging). Copies the lists.
COrderIterator::COrderIterator(COrderMap *input_Status, COrderMap &input_RO, double input_current_price, double input_unrealized_profit, double input_realized_profit, PR_MODE input_mode)
{
    RO = new COrderMap;
    StatusHedging = new COrderMap;
    Status = NULL;
    CDOMObject *order, *new_order;

    for (order = input_Status.GetFirstNode(); order != NULL; order = input_Status.GetNextNode())
    {
        new_order = new CStatusObject(order.Ticket(), order.Price(), order.Vol(), order.Type(), order.SL(), order.TP());
        StatusHedging.Add(new_order);
    }

    for (order = input_RO.GetFirstNode(); order != NULL; order = input_RO.GetNextNode())
    {
        CRemainingOrderObject *new_RO_order = new CRemainingOrderObject(order.Ticket(), order.Price(), order.Vol(), order.Type(), order.SL(), order.TP(), order.Status(), order.Origin(), order.StopLimit());
        new_RO_order.SetKind(order.Kind());
        RO.Add(new_RO_order);
    }

    current_price = input_current_price;
    unrealized_profit = input_unrealized_profit;
    realized_profit = input_realized_profit;
    skip_above = false;
    skip_below = false;
    op_above = PR_UNDEFINED;
    op_below = PR_UNDEFINED;
    mode = input_mode;
}

// Creates the iterator for a recursion branch with the current state.
COrderIterator *COrderIterator::NewChild()
{
    if (!hedging) return new COrderIterator(Status, RO, current_price, unrealized_profit, realized_profit, mode);
    return new COrderIterator(StatusHedging, RO, current_price, unrealized_profit, realized_profit, mode);
}

// Records the profit at the current node and checks it against the minimum (maximum) found so far.
void COrderIterator::Evaluate()
{
    CalculateUnrealizedProfit();
}

// Main recursion function. Processes upper and lower orders and calls itself again.
void COrderIterator::Iterate(const double order_price)
{
    if (overflow) return;
    if (++iterations > PR_MAX_ITERATIONS)
    {
        overflow = true;
        return;
    }

    if (order_price != PR_UNDEFINED) ProcessOrder(order_price);
    Evaluate();

    op_above = FindPriceAbove();
    op_below = FindPriceBelow();

    bool skip = false;
    skip_below = false;
    // skip_above is set via class property.

    if ((op_above != PR_UNDEFINED) && (op_below != PR_UNDEFINED))
    {
        // Returns true if the orders at the immediate prices above and below qualify as simple and do not require full recursion to process.
        skip = CheckSimplicity();
        // No need to do it if we are already skipping the upper half via the function call argument.
        if ((!skip) && (!skip_above))
        {
            // Check if we are inside of the SL/TP of one or more orders and there is a clear minimum profit decision at this point, so we won't run the recursion.
            CheckPairedOrders();
        }
    }

    if (!skip_above)
    {
        if (op_above != PR_UNDEFINED)
        {
            COrderIterator *OI_new_a = NewChild();
            OI_new_a.Iterate(op_above);
            delete OI_new_a;
        }
        else
        {
            CalculateMaxUp();
        }
    }

    if (op_below != PR_UNDEFINED)
    {
        if (!skip_below)
        {
            COrderIterator *OI_new_b = NewChild();
            // Simple orders above and below: after going down, there is no need to come back up - the branch that went up first covers those states.
            // Hedging only: in netting mode, the order in which orders merge into the position matters, so both ways have to be walked.
            if (hedging) OI_new_b.skip_above = skip;
            OI_new_b.Iterate(op_below);
            delete OI_new_b;
        }
    }
    else
    {
        // Calculate Max Down only if we do not have an indefinite loss path already. MaxDown will always be worse than the indefinite loss from MaxUp.
        if (min_profit != PR_UNLIMITED) CalculateMaxDown();
    }
}

// Checks whether orders above and below are simple and thus qualify for shorter recursion instead of full.
// Orders are considered simple if any of these conditions is true:
// 1. Plain buy/sell without SL or TP.
// 2. An SL or TP of some order, which does not have a paired TP or SL among the orders immediately below the current price.
// 3. Non-plain buy/sell in case the SL/TP does not lie within [OP1; OP2] range.
//    In netting mode, there is a nuance: orders have to be of the same type, otherwise, the case is not simple.
//    The same is necessary for stop-limit orders - the stop-limit price should not lie within [OP1; OP2] range.
// It is enough to check SLs and TPs in the top orders. Bottom SL/TP orders will not contain any pairs for the top ones, if top ones did not have such orders.
bool COrderIterator::CheckSimplicity()
{
    CRemainingOrderObject *RO_order;
    CStatusObject *Status_order;
    int types_found = 0; // 0 - none, 1 - buy, 2 - sell, 3 - both.
    for (RO_order = RO.GetFirstNodeAtPrice(op_above); (RO_order != NULL) && (MathAbs(RO_order.Price() - op_above) < PR_Ctx.point / 2); RO_order = RO.GetNextNode())
    {
        // If the order is an SL or a TP of some other order, check if its origin has a TP or an SL at the op_below price.
        if (RO_order.Status() == PR_SLTP)
        {
            if (hedging)
            {
                long ticket = RO_order.Origin();
                Status_order = StatusHedging.GetNodeByTicket(ticket);
                if (Status_order == NULL)
                {
                    Print(__FUNCTION__, ": origin order not found by ticket: ", ticket, ".");
                    return false;
                }
            }
            else
            {
                if (CheckPointer(Status) == POINTER_INVALID) return false;
                Status_order = Status;
            }
            // Partner SL/TP found - the situation is not simple.
            if ((MathAbs(Status_order.TP() - op_below) < PR_Ctx.point / 2) || (MathAbs(Status_order.SL() - op_below) < PR_Ctx.point / 2)) return false;
        }
        else if (RO_order.Status() == PR_Pending)
        {
            if (RO_order.Type() == PR_Buy)
            {
                if (types_found == 0) types_found = 1;
                else if (types_found == 2) types_found = 3;
            }
            else
            {
                if (types_found == 0) types_found = 2;
                else if (types_found == 1) types_found = 3;
            }
            if ((RO_order.SL() != 0) && (RO_order.SL() <= op_above) && (RO_order.SL() >= op_below)) return false;
            if ((RO_order.TP() != 0) && (RO_order.TP() <= op_above) && (RO_order.TP() >= op_below)) return false;
        }
        else if (RO_order.Status() == PR_StopLimit)
        {
            if ((RO_order.StopLimit() <= op_above) && (RO_order.StopLimit() >= op_below)) return false;
        }
    }
    for (RO_order = RO.GetFirstNodeAtPrice(op_below); (RO_order != NULL) && (MathAbs(RO_order.Price() - op_below) < PR_Ctx.point / 2); RO_order = RO.GetNextNode())
    {
        if (RO_order.Status() == PR_Pending)
        {
            if (!hedging)
            {
                // Not simple, if we have different pending order types on op_below and op_above.
                if (types_found == 3) return false;
                if ((RO_order.Type() == PR_Buy) && (types_found == 2)) return false;
                if ((RO_order.Type() == PR_Sell) && (types_found == 1)) return false;
            }
            if ((RO_order.SL() != 0) && (RO_order.SL() <= op_above) && (RO_order.SL() >= op_below)) return false;
            if ((RO_order.TP() != 0) && (RO_order.TP() <= op_above) && (RO_order.TP() >= op_below)) return false;
        }
        else if (RO_order.Status() == PR_StopLimit)
        {
            if ((RO_order.StopLimit() <= op_above) && (RO_order.StopLimit() >= op_below)) return false;
        }
    }

    return true;
}

// Iterates through op_above orders and checks if all are SLs and TPs that have counterparts and those counterparts are located at op_below.
// Does the same for op_below orders.
// Calculates possible minimum (maximum) profit for the case of going to op_above and op_below. Unlike the indicator, in money and with volumes.
// Sets skips depending on where was the worst (best) result. After either exit, the remaining orders are the same, so only the exit itself matters.
// In netting mode, all SL/TP nodes belong to the one position, so the same decision applies to its SL and TP.
void COrderIterator::CheckPairedOrders()
{
    long ticket;
    CStatusObject *Status_order;
    CRemainingOrderObject *RO_order;
    bool same_order_sl_tp = false;
    double min_profit_above = 0; // Serves as max_profit_above for mode == PR_Reward.
    double min_profit_below = 0; // Serves as max_profit_below for mode == PR_Reward.
    skip_above = false;
    skip_below = false;
    for (RO_order = RO.GetFirstNodeAtPrice(op_above); (RO_order != NULL) && (MathAbs(RO_order.Price() - op_above) < PR_Ctx.point / 2); RO_order = RO.GetNextNode())
    {
        if (RO_order.Status() == PR_SLTP)
        {
            if (hedging)
            {
                ticket = RO_order.Origin();
                Status_order = StatusHedging.GetNodeByTicket(ticket);
                if (Status_order == NULL)
                {
                    Print(__FUNCTION__, ": origin order not found by ticket: ", ticket, ".");
                    return;
                }
            }
            else
            {
                if (CheckPointer(Status) == POINTER_INVALID) return;
                Status_order = Status;
            }
            // Partner SL/TP found.
            if ((MathAbs(Status_order.TP() - op_below) < PR_Ctx.point / 2) || (MathAbs(Status_order.SL() - op_below) < PR_Ctx.point / 2))
            {
                same_order_sl_tp = true;
                // The upper order can only be an SL for a Sell.
                if (Status_order.Type() == PR_Sell)
                    min_profit_above += PR_ToMoney(Status_order.Vol() * (Status_order.Price() - op_above - PR_Ctx.spread), op_above + PR_Ctx.spread);
                // The upper order can only be a TP for a Buy.
                else
                    min_profit_above += PR_ToMoney(Status_order.Vol() * (op_above - Status_order.Price()), op_above);
            }
            else return; // SL/TP without a counterpart at op_below is a different case.
        }
        else if (RO_order.Status() != PR_Inactive) return; // Any other order (except Inactive) would make it a much more difficult case.
    }
    // Do the same for the lower orders only if the upper ones did not fail.
    if (same_order_sl_tp) for (RO_order = RO.GetFirstNodeAtPrice(op_below); (RO_order != NULL) && (MathAbs(RO_order.Price() - op_below) < PR_Ctx.point / 2); RO_order = RO.GetNextNode())
    {
        if (RO_order.Status() == PR_SLTP)
        {
            if (hedging)
            {
                ticket = RO_order.Origin();
                Status_order = StatusHedging.GetNodeByTicket(ticket);
                if (Status_order == NULL)
                {
                    Print(__FUNCTION__, ": origin order not found by ticket: ", ticket, ".");
                    return;
                }
            }
            else Status_order = Status; // Checked above.
            // Partner SL/TP found.
            if ((MathAbs(Status_order.TP() - op_above) < PR_Ctx.point / 2) || (MathAbs(Status_order.SL() - op_above) < PR_Ctx.point / 2))
            {
                // The lower order can only be an SL for a Buy.
                if (Status_order.Type() == PR_Buy)
                    min_profit_below += PR_ToMoney(Status_order.Vol() * (op_below - Status_order.Price()), op_below);
                // The lower order can only be a TP for a Sell.
                else
                    min_profit_below += PR_ToMoney(Status_order.Vol() * (Status_order.Price() - op_below - PR_Ctx.spread), op_below + PR_Ctx.spread);
            }
            else return; // SL/TP without a counterpart at op_above is a different case.
        }
        else if (RO_order.Status() != PR_Inactive) return; // Any other order (except Inactive) would make it a much more difficult case.
    }
    // We can now calculate the optimal direction.
    if (same_order_sl_tp)
    {
        if (mode == PR_Risk)
        {
            if (min_profit_above <= min_profit_below) skip_below = true; // Do only op_above.
            else skip_above = true; // Do only op_below.
        }
        else
        {
            if (min_profit_above > min_profit_below) skip_below = true; // Do only op_above.
            else skip_above = true; // Do only op_below.
        }
    }
}

// Is there an order above the current price in the remaining orders. Returns either price or PR_UNDEFINED.
// A price with only inactive limit orders is ignored.
double COrderIterator::FindPriceAbove()
{
    double prev_price = PR_UNDEFINED, prev_valid_price = PR_UNDEFINED;
    bool all_orders_are_inactive = false;

    for (CRemainingOrderObject *RO_order = RO.GetFirstNode(); RO_order != NULL; RO_order = RO.GetNextNode())
    {
        if (RO_order.Price() < current_price) break;
        // Check if all the orders at the current price are inactive. If so, the price should be ignored.
        if (RO_order.Status() == PR_Inactive)
        {
            // Switched to true only if it is a new price. Otherwise, remains the same as it was before, lest it changes to true when there were non-inactive orders before at that price.
            if (MathAbs(prev_price - RO_order.Price()) > PR_Ctx.point / 2) all_orders_are_inactive = true;
        }
        else
        {
            // A non-inactive order resets to false in any case.
            all_orders_are_inactive = false;
        }
        if (!all_orders_are_inactive) prev_valid_price = RO_order.Price();
        prev_price = RO_order.Price();
    }
    return prev_valid_price;
}

// Is there an order below the current price in the remaining orders. Returns either price or PR_UNDEFINED.
// A price with only inactive limit orders is ignored.
double COrderIterator::FindPriceBelow()
{
    CRemainingOrderObject *RO_order;
    for (RO_order = RO.GetFirstNode(); RO_order != NULL; RO_order = RO.GetNextNode())
    {
        if (RO_order.Price() < current_price)
        {
            // Find the first such price which contains a non-inactive order.
            if (RO_order.Status() != PR_Inactive) break;
        }
    }

    if ((RO_order == NULL) || (RO_order.Price() > current_price)) return PR_UNDEFINED;
    else return RO_order.Price();
}

// Processes one or more orders located at the given price level.
// In MT5, it is necessary to process orders in certain order: first - SL/TP, second - pending orders in order of ascending ticket, i.e. old first (FIFO).
// The level is re-scanned until nothing is left on it: executing an order can add its SL/TP at this very price (an SL one spread away from a Buy's entry),
// and a stop-limit can activate a limit order at this price. COrderMap sorts equal prices by ticket, so such a node may land before the node being
// processed and would otherwise be missed by the cycle.
void COrderIterator::ProcessOrder(double order_price)
{
    bool processed;
    do
    {
        processed = false;
        if (!hedging) // Netting mode: the position's SL/TP first.
        {
            if (CheckPointer(Status) != POINTER_INVALID)
            {
                if ((MathAbs(Status.SL() - order_price) < PR_Ctx.point / 2) || (MathAbs(Status.TP() - order_price) < PR_Ctx.point / 2))
                {
                    for (CRemainingOrderObject *RO_order = RO.GetFirstNodeAtPrice(order_price); (RO_order != NULL) && (MathAbs(RO_order.Price() - order_price) < PR_Ctx.point / 2); RO_order = RO.GetNextNode())
                    {
                        if (RO_order.Status() == PR_SLTP)
                        {
                            RemoveOrderFromStatus(RO_order);
                            RemoveOrderFromRO(RO_order);
                            processed = true;
                            break;
                        }
                    }
                }
            }
        }

        // Then everything else at this price. Cycle movement is defined inside the cycle.
        for (CRemainingOrderObject *RO_order = RO.GetFirstNodeAtPrice(order_price); (RO_order != NULL) && (MathAbs(RO_order.Price() - order_price) < PR_Ctx.point / 2); )
        {
            // Inactive limit orders are skipped - GetNextNode(). Otherwise, the node gets deleted and the list is shifted - GetCurrentNode().
            if (RO_order.Status() == PR_Inactive)
            {
                RO_order = RO.GetNextNode();
                continue;
            }
            if (RO_order.Status() == PR_StopLimit)
            {
                // Activate the relevant limit order.
                ActivatePendingOrder(RO_order);
            }
            else if (RO_order.Status() == PR_SLTP)
            {
                // Netting: the position's SL/TP have been processed above. An SL/TP without a position is stale and is only removed.
                if (hedging) RemoveOrderFromStatus(RO_order); // Also calculates the realized profit.
            }
            else // Pending.
            {
                // Open new order, pushing it to Status, removing old SL/TP entries if needed and adding new SL/TP entries to RO if needed.
                AddExecutedOrderToStatus(RO_order);
            }
            RemoveOrderFromRO(RO_order);
            processed = true;
            RO_order = RO.GetCurrentNode();
        }
    }
    while (processed);
    // Switch the current price.
    current_price = order_price;
}

// Calculates the minimum profit (maximum loss) attainable from going all way up with the current orders.
void COrderIterator::CalculateMaxUp()
{
    if (!hedging)
    {
        if (CheckPointer(Status) == POINTER_INVALID) return;
        // A Sell loses without limit (Risk); a Buy gains without limit (Reward).
        if (((mode == PR_Risk) && (Status.Type() == PR_Sell)) || ((mode == PR_Reward) && (Status.Type() == PR_Buy)))
        {
            unrealized_profit = PR_UNLIMITED;
            min_profit = PR_UNLIMITED;
        }
        return;
    }

    // Volume of the uncovered sell position. If <= 0 - nothing to do.
    double sell_volume = 0;
    for (CStatusObject *Status_order = StatusHedging.GetFirstNode(); Status_order != NULL; Status_order = StatusHedging.GetNextNode())
    {
        if (Status_order.Type() == PR_Sell) sell_volume += Status_order.Vol();
        else sell_volume -= Status_order.Vol();
    }

    if (mode == PR_Risk)
    {
        if (sell_volume <= 0) return; // There is no uncovered sell volume.
    }
    else
    {
        if (sell_volume >= 0) return; // There is no uncovered buy volume.
    }

    unrealized_profit = PR_UNLIMITED;
    min_profit = PR_UNLIMITED;
}

// Calculates the minimum profit (maximum loss) attainable from going all way down with the current orders.
void COrderIterator::CalculateMaxDown()
{
    double buy_volume = 0; // Volume of the uncovered buy position. If <= 0 - nothing to do.
    if (!hedging)
    {
        if (CheckPointer(Status) == POINTER_INVALID) return;
        if (Status.Type() == PR_Buy) buy_volume = Status.Vol();
        else buy_volume = -Status.Vol();
    }
    else
    {
        for (CStatusObject *Status_order = StatusHedging.GetFirstNode(); Status_order != NULL; Status_order = StatusHedging.GetNextNode())
        {
            if (Status_order.Type() == PR_Buy) buy_volume += Status_order.Vol();
            else buy_volume -= Status_order.Vol();
        }
    }

    if (mode == PR_Risk)
    {
        if (buy_volume <= 0) return; // There is no uncovered buy volume.
    }
    else
    {
        if (buy_volume >= 0) return; // There is no uncovered sell volume.
    }

    // If the account currency is the pair's base currency, the loss (profit) in the account currency grows without limit as the price approaches zero.
    if (PR_Ctx.future_rate)
    {
        unrealized_profit = PR_UNLIMITED;
        min_profit = PR_UNLIMITED;
        return;
    }
    double profit = unrealized_profit + realized_profit - PR_ToMoney(buy_volume * current_price, current_price);
    if (mode == PR_Risk)
    {
        if (profit < min_profit) min_profit = profit;
    }
    else
    {
        if (((min_profit == PR_UNDEFINED) || (profit > min_profit)) && (min_profit != PR_UNLIMITED)) min_profit = profit;
    }
}

// Adds a newly executed order to the Status (netting: merges it into the position) and its SL/TP to RO if needed.
void COrderIterator::AddExecutedOrderToStatus(CRemainingOrderObject &RO_order)
{
    if (!hedging)
    {
        // New position.
        if (CheckPointer(Status) == POINTER_INVALID)
        {
            Status = new CStatusObject(OpenPrice(RO_order), RO_order.Vol(), RO_order.Type(), RO_order.SL(), RO_order.TP());
            AddSLTPtoRO(RO_order);
        }
        // Same type - update SL/TP (the order's ones replace the position's, zero included), price, and volume.
        else if (Status.Type() == RO_order.Type())
        {
            if (MathAbs(Status.SL() - RO_order.SL()) > PR_Ctx.point / 2)
            {
                RemoveCurrentSL();
                Status.SetSL(RO_order.SL());
                if (Status.SL() != 0) AddBasicSLTPtoRO(Status.SL(), 0);
            }
            if (MathAbs(Status.TP() - RO_order.TP()) > PR_Ctx.point / 2)
            {
                RemoveCurrentTP();
                Status.SetTP(RO_order.TP());
                if (Status.TP() != 0) AddBasicSLTPtoRO(Status.TP(), 0);
            }
            // Calculate the price based on the volume weight.
            Status.SetPrice(((Status.Vol() * Status.Price()) + (RO_order.Vol() * OpenPrice(RO_order))) / (Status.Vol() + RO_order.Vol()));
            Status.SetVolume(Status.Vol() + RO_order.Vol());
        }
        // Types are different.
        else
        {
            // Calculate the realized profit. A Sell order closes at the Bid (its price), a Buy order closes at the Ask (its price plus the spread).
            if (Status.Type() == PR_Buy) realized_profit += PR_ToMoney(MathMin(RO_order.Vol(), Status.Vol()) * (RO_order.Price() - Status.Price()), RO_order.Price());
            else realized_profit += PR_ToMoney(MathMin(RO_order.Vol(), Status.Vol()) * (Status.Price() - RO_order.Price() - PR_Ctx.spread), RO_order.Price() + PR_Ctx.spread);

            // Equal volumes. The position is closed.
            if (MathAbs(RO_order.Vol() - Status.Vol()) < 0.00000001)
            {
                // First, need to delete old SL/TP if any.
                RemoveCurrentSLTP();
                delete Status;
            }
            else
            {
                // The existing position absorbs the new order. Its SL/TP remain.
                if (RO_order.Vol() < Status.Vol())
                {
                    Status.SetVolume(Status.Vol() - RO_order.Vol());
                }
                // The new order absorbs the existing position.
                else
                {
                    Status.SetType(RO_order.Type());
                    Status.SetVolume(RO_order.Vol() - Status.Vol());
                    // First, need to delete old SL/TP if any.
                    RemoveCurrentSLTP();
                    Status.SetSL(RO_order.SL());
                    Status.SetTP(RO_order.TP());
                    AddSLTPtoRO(RO_order);
                    Status.SetPrice(OpenPrice(RO_order));
                }
            }
        }
    }
    else // Hedging mode.
    {
        CStatusObject *Status_order = new CStatusObject(RO_order.Ticket(), OpenPrice(RO_order), RO_order.Vol(), RO_order.Type(), RO_order.SL(), RO_order.TP());
        StatusHedging.Add(Status_order);
        AddSLTPtoRO(RO_order);
    }
}

// Returns the price a pending order is filled at. Buy orders are kept at their Bid-terms trigger (entry minus spread), so they are filled one spread higher.
double COrderIterator::OpenPrice(CRemainingOrderObject &RO_order)
{
    if (RO_order.Type() == PR_Buy) return RO_order.Price() + PR_Ctx.spread;
    return RO_order.Price();
}

// Adds stop-loss and take-profit to the Remaining Orders list.
void COrderIterator::AddSLTPtoRO(CRemainingOrderObject &RO_order)
{
    if (RO_order.SL() != 0) AddBasicSLTPtoRO(RO_order.SL(), RO_order.Ticket());
    if (RO_order.TP() != 0) AddBasicSLTPtoRO(RO_order.TP(), RO_order.Ticket());
}

// Adds stop-loss or take-profit to the Remaining Orders list. origin - the ticket of the position (hedging mode).
void COrderIterator::AddBasicSLTPtoRO(double price, long origin)
{
    CRemainingOrderObject *RO_new_order = new CRemainingOrderObject(0, price, 0, PR_Buy, 0, 0, PR_SLTP, origin, 0);
    RO.Add(RO_new_order);
}

// Removes an order from the Remaining Orders list.
void COrderIterator::RemoveOrderFromRO(CRemainingOrderObject &RO_order)
{
    CDOMObject *RO_order_pointer = GetPointer(RO_order);
    RO.Delete(RO.IndexOf(RO_order_pointer));
}

// Removes existing SL/TP (if they exist) of the current position. Netting mode.
void COrderIterator::RemoveCurrentSLTP()
{
    RemoveCurrentSL();
    RemoveCurrentTP();
}

// Removes the existing SL of the current position. Netting mode: all existing SL/TP in RO belong to the current position.
void COrderIterator::RemoveCurrentSL()
{
    if (Status.SL() == 0) return;
    for (CRemainingOrderObject *RO_order = RO.GetFirstNodeAtPrice(Status.SL()); (RO_order != NULL) && (MathAbs(RO_order.Price() - Status.SL()) < PR_Ctx.point / 2); RO_order = RO.GetNextNode())
    {
        if (RO_order.Status() == PR_SLTP)
        {
            RO.DeleteCurrent();
            return;
        }
    }
}

// Removes the existing TP of the current position. Netting mode.
void COrderIterator::RemoveCurrentTP()
{
    if (Status.TP() == 0) return;
    for (CRemainingOrderObject *RO_order = RO.GetFirstNodeAtPrice(Status.TP()); (RO_order != NULL) && (MathAbs(RO_order.Price() - Status.TP()) < PR_Ctx.point / 2); RO_order = RO.GetNextNode())
    {
        if (RO_order.Status() == PR_SLTP)
        {
            RO.DeleteCurrent();
            return;
        }
    }
}

// Removes an RO_order's origin from the Status and its second exit from RO (if necessary). Also calculates the realized profit.
// Sells' levels are kept in Bid terms (shifted by the spread), so their actual exit price is one spread higher.
void COrderIterator::RemoveOrderFromStatus(CRemainingOrderObject &RO_order)
{
    if (!hedging)
    {
        if (CheckPointer(Status) == POINTER_INVALID) return;
        RemoveSecondExit(RO_order.Price());

        if (Status.Type() == PR_Buy) realized_profit += PR_ToMoney(Status.Vol() * (RO_order.Price() - Status.Price()), RO_order.Price());
        else realized_profit += PR_ToMoney(Status.Vol() * (Status.Price() - RO_order.Price() - PR_Ctx.spread), RO_order.Price() + PR_Ctx.spread);

        delete Status;
        return;
    }

    CStatusObject *Status_order = StatusHedging.GetNodeByTicket(RO_order.Origin());
    if (Status_order == NULL)
    {
        Print(__FUNCTION__, ": origin order not found by ticket: ", RO_order.Origin(), ".");
        return;
    }
    // Remove the second exit if any.
    if ((Status_order.SL() != 0) && (Status_order.TP() != 0))
    {
        double second_exit_price = Status_order.SL(); // SL is the second exit...
        if (MathAbs(Status_order.TP() - RO_order.Price()) > PR_Ctx.point / 2) second_exit_price = Status_order.TP(); // ...unless this is the SL.
        for (CRemainingOrderObject *RO_second_exit = RO.GetFirstNodeAtPrice(second_exit_price); (RO_second_exit != NULL) && (MathAbs(RO_second_exit.Price() - second_exit_price) < PR_Ctx.point / 2); RO_second_exit = RO.GetNextNode())
        {
            if ((RO_second_exit.Status() == PR_SLTP) && (RO_second_exit.Origin() == Status_order.Ticket()))
            {
                RO.DeleteCurrent();
                break;
            }
        }
    }

    if (Status_order.Type() == PR_Buy) realized_profit += PR_ToMoney(Status_order.Vol() * (RO_order.Price() - Status_order.Price()), RO_order.Price());
    else realized_profit += PR_ToMoney(Status_order.Vol() * (Status_order.Price() - RO_order.Price() - PR_Ctx.spread), RO_order.Price() + PR_Ctx.spread);

    // Remove the position from Status. The node is the current one after GetNodeByTicket().
    if (StatusHedging.GetNodeByTicket(Status_order.Ticket()) == NULL) return;
    if (!StatusHedging.DeleteCurrent()) Print(__FUNCTION__, ": could not delete the node.");
}

// Removes the second exit of the position from RO if required. Netting mode.
void COrderIterator::RemoveSecondExit(double price)
{
    // Do not continue if either SL or TP is absent.
    if ((Status.SL() == 0) || (Status.TP() == 0)) return;

    // We hit the position's SL or TP, now the remaining one should be canceled too.
    double op2;
    if (MathAbs(Status.SL() - price) > PR_Ctx.point / 2) op2 = Status.SL();
    else op2 = Status.TP();

    for (CRemainingOrderObject *RO_order = RO.GetFirstNodeAtPrice(op2); (RO_order != NULL) && (MathAbs(RO_order.Price() - op2) < PR_Ctx.point / 2); RO_order = RO.GetNextNode())
    {
        if (RO_order.Status() == PR_SLTP)
        {
            RO.DeleteCurrent();
            return;
        }
    }
}

// Calculates unrealized profit based on the Status.
void COrderIterator::CalculateUnrealizedProfit()
{
    unrealized_profit = 0;

    if (!hedging)
    {
        if (CheckPointer(Status) != POINTER_INVALID)
        {
            if (Status.Type() == PR_Buy) unrealized_profit += PR_ToMoney(Status.Vol() * (current_price - Status.Price()), current_price);
            else unrealized_profit += PR_ToMoney(Status.Vol() * (Status.Price() - current_price - PR_Ctx.spread), current_price + PR_Ctx.spread);
        }
    }
    else
    {
        for (CStatusObject *Status_order = StatusHedging.GetFirstNode(); Status_order != NULL; Status_order = StatusHedging.GetNextNode())
        {
            if (Status_order.Type() == PR_Buy) unrealized_profit += PR_ToMoney(Status_order.Vol() * (current_price - Status_order.Price()), current_price);
            else unrealized_profit += PR_ToMoney(Status_order.Vol() * (Status_order.Price() - current_price - PR_Ctx.spread), current_price + PR_Ctx.spread);
        }
    }

    double profit = unrealized_profit + realized_profit;
    if (mode == PR_Risk)
    {
        if (profit < min_profit) min_profit = profit; // A new maximum loss.
    }
    else
    {
        if (((min_profit == PR_UNDEFINED) || (profit > min_profit)) && (min_profit != PR_UNLIMITED)) min_profit = profit; // A new maximum profit.
    }
}

// Activates the limit order of a stop-limit order whose stop price has been reached.
void COrderIterator::ActivatePendingOrder(CRemainingOrderObject &RO_order)
{
    for (CRemainingOrderObject *RO_inactive_order = RO.GetFirstNodeAtPrice(RO_order.StopLimit()); (RO_inactive_order != NULL) && (MathAbs(RO_inactive_order.Price() - RO_order.StopLimit()) < PR_Ctx.point / 2); RO_inactive_order = RO.GetNextNode())
    {
        if ((RO_inactive_order.Status() == PR_Inactive) && (RO_inactive_order.Origin() == RO_order.Ticket()))
        {
            RO_inactive_order.SetStatus(PR_Pending);
            return;
        }
    }
}

//+------------------------------------------------------------------+
//| Feeding the Position Sizer's positions and orders in.            |
//+------------------------------------------------------------------+

// Checks whether the currently selected position should be included. The Risk tab's filters apply in every mode;
// the Trading tab's per-symbol mode additionally restricts the calculation to the trading symbol.
// check_sltp - whether the "ignore orders without SL/TP" filters apply (they do not for the margin calculation).
bool PR_PositionIncluded(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const bool check_sltp = true)
{
    if ((calculate_risk_for_trading_tab == CALCULATE_RISK_FOR_TRADING_TAB_PER_SYMBOL) && (PositionGetString(POSITION_SYMBOL) != SymbolForTrading)) return false;

    if (sets.IncludeOrders == INCLUDE_ORDERS_PENDING) return false;

    bool is_buy = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
    if ((is_buy) && (sets.IncludeDirections == INCLUDE_DIRECTIONS_SELL)) return false;
    if ((!is_buy) && (sets.IncludeDirections == INCLUDE_DIRECTIONS_BUY)) return false;

    if ((PositionGetString(POSITION_SYMBOL) != SymbolForTrading) && (sets.IncludeSymbols == INCLUDE_SYMBOLS_CURRENT)) return false;
    if ((PositionGetString(POSITION_SYMBOL) == SymbolForTrading) && (sets.IncludeSymbols == INCLUDE_SYMBOLS_OTHER)) return false;

    if (!check_sltp) return true;
    if ((PositionGetDouble(POSITION_SL) == 0) && (sets.IgnoreOrdersWithoutSL)) return false;
    if ((PositionGetDouble(POSITION_TP) == 0) && (sets.IgnoreOrdersWithoutTP)) return false;

    return true;
}

// Checks whether the currently selected pending order should be included. The Risk tab's filters apply in every mode;
// the Trading tab's per-symbol mode additionally restricts the calculation to the trading symbol. Market orders in flight are never included.
// check_sltp - whether the "ignore orders without SL/TP" filters apply (they do not for the margin calculation).
bool PR_PendingIncluded(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const bool check_sltp = true)
{
    ENUM_ORDER_TYPE ot = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
    bool is_buy = ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_STOP_LIMIT));
    bool is_sell = ((ot == ORDER_TYPE_SELL_LIMIT) || (ot == ORDER_TYPE_SELL_STOP) || (ot == ORDER_TYPE_SELL_STOP_LIMIT));
    if ((!is_buy) && (!is_sell)) return false;

    if ((calculate_risk_for_trading_tab == CALCULATE_RISK_FOR_TRADING_TAB_PER_SYMBOL) && (OrderGetString(ORDER_SYMBOL) != SymbolForTrading)) return false;

    if (sets.IncludeOrders == INCLUDE_ORDERS_OPEN) return false;

    if ((is_buy) && (sets.IncludeDirections == INCLUDE_DIRECTIONS_SELL)) return false;
    if ((is_sell) && (sets.IncludeDirections == INCLUDE_DIRECTIONS_BUY)) return false;

    if ((OrderGetString(ORDER_SYMBOL) != SymbolForTrading) && (sets.IncludeSymbols == INCLUDE_SYMBOLS_CURRENT)) return false;
    if ((OrderGetString(ORDER_SYMBOL) == SymbolForTrading) && (sets.IncludeSymbols == INCLUDE_SYMBOLS_OTHER)) return false;

    if (!check_sltp) return true;
    if ((OrderGetDouble(ORDER_SL) == 0) && (sets.IgnoreOrdersWithoutSL)) return false;
    if ((OrderGetDouble(ORDER_TP) == 0) && (sets.IgnoreOrdersWithoutTP)) return false;

    return true;
}

// Hedging or netting account. In netting mode, there is one position per symbol and executed orders merge into it.
bool PR_IsHedging()
{
    return (AccountInfoInteger(ACCOUNT_MARGIN_MODE) == ACCOUNT_MARGIN_MODE_RETAIL_HEDGING);
}

// Prepares the symbol context (point, spread, unit cost in the account currency) for the given mode. Returns false if the symbol's data cannot be retrieved.
bool PR_PrepareSymbol(const string cp, const PR_MODE mode)
{
    PR_Ctx.point = SymbolInfoDouble(cp, SYMBOL_POINT);
    PR_Ctx.digits = (int)SymbolInfoInteger(cp, SYMBOL_DIGITS);
    PR_Ctx.spread = SymbolInfoDouble(cp, SYMBOL_ASK) - SymbolInfoDouble(cp, SYMBOL_BID);
    if (PR_Ctx.spread < 0) PR_Ctx.spread = 0;
    PR_Ctx.current_rate = SymbolInfoDouble(cp, SYMBOL_BID);

    double tick_size = SymbolInfoDouble(cp, SYMBOL_TRADE_TICK_SIZE);
    if ((tick_size == 0) || (PR_Ctx.point == 0))
    {
        Print(TRANSLATION_MESSAGE_CANNOT_RETRIEVE_TICKSIZE, cp, ". " + TRANSLATION_MESSAGE_LOOKS_LIKE);
        return false;
    }

    ENUM_SYMBOL_CALC_MODE calc_mode = (ENUM_SYMBOL_CALC_MODE)SymbolInfoInteger(cp, SYMBOL_TRADE_CALC_MODE);
    double unit_cost;
    if ((calc_mode == SYMBOL_CALC_MODE_CFD) || (calc_mode == SYMBOL_CALC_MODE_CFDINDEX) || (calc_mode == SYMBOL_CALC_MODE_CFDLEVERAGE))
    {
        unit_cost = tick_size * SymbolInfoDouble(cp, SYMBOL_TRADE_CONTRACT_SIZE);
        string symbol_profit_currency = SymbolInfoString(cp, SYMBOL_CURRENCY_PROFIT);
        if (symbol_profit_currency != AccountCurrency) unit_cost *= CalculateAdjustment(mode == PR_Risk ? Loss : Profit, symbol_profit_currency, AccountCurrency, cp);
    }
    // With Forex instruments, tick value already equals 1 unit cost.
    else if (mode == PR_Risk) unit_cost = SymbolInfoDouble(cp, SYMBOL_TRADE_TICK_VALUE_LOSS);
    else unit_cost = SymbolInfoDouble(cp, SYMBOL_TRADE_TICK_VALUE_PROFIT);
    PR_Ctx.unit_cost = unit_cost / tick_size;
    // If the account currency is the pair's base currency, the P/L converts at the exit price rather than at the current one. Forex pairs only.
    PR_Ctx.future_rate = ((AccountCurrency == SymbolInfoString(cp, SYMBOL_CURRENCY_BASE)) && ((calc_mode == SYMBOL_CALC_MODE_FOREX) || (calc_mode == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)));
    return true;
}

// One-way per-lot commission of a trade on the given symbol in the account currency, the way the Main tab calculates it for the planned trade:
// the broker's commission rules when AutoCommission is on, the Commission field's value (per lot, or a percentage of the contract value) otherwise.
// is_buy - the direction of the entry deal, volume and price - the trade's own (for the volume- and value-based tiers), tp - its take-profit or 0.
double PR_CommissionPerLot(const string symbol, const bool is_buy, const double volume, const double price, const double tp, const PR_MODE mode)
{
    if (AutoCommission)
    {
        double reward = 0;
        bool profit_only = false;
        double risk = CalculateAutoCommissionForSymbol(symbol, is_buy, volume, price, tp, reward, profit_only);
        if (risk >= 0) // A negative value means the rules could not be fetched - fall back to the Commission field value.
        {
            if (risk > 0 && NormalizeDouble(risk, AccountCurrencyDigits) == 0) risk = MathPow(0.1, AccountCurrencyDigits); // Even if commission gets calculated as sub-cent, 1 cent will still be charged.
            if (mode == PR_Risk) return risk;
            return reward;
        }
    }
    if (sets.CommissionType == COMMISSION_PERCENT) return CalculateContractValueForSymbol(symbol, price) * sets.CommissionPerLot / 100;
    return sets.CommissionPerLot;
}

// Order sets that exceeded PR_MAX_ITERATIONS. The simple per-order sum is used for them until the orders change.
string PR_OverflowKeys[PR_OVERFLOW_MEMORY];
int PR_OverflowNext = 0;

// Checks whether the order set is already known to exceed PR_MAX_ITERATIONS.
bool PR_IsKnownOverflow(const string key)
{
    for (int i = 0; i < PR_OVERFLOW_MEMORY; i++)
        if (PR_OverflowKeys[i] == key) return true;
    return false;
}

// Remembers the order set that exceeded PR_MAX_ITERATIONS.
void PR_RememberOverflow(const string key)
{
    PR_OverflowKeys[PR_OverflowNext] = key;
    PR_OverflowNext = (PR_OverflowNext + 1) % PR_OVERFLOW_MEMORY;
}

//+------------------------------------------------------------------+
//| The planned trade - the one being calculated on the Main tab.    |
//+------------------------------------------------------------------+
// One entry per take-profit, the way the Trading tab would send the orders.
struct PR_PlannedOrder
{
    ENTRY_TYPE    entry_type;  // Instant (an open position), Pending, or StopLimit.
    bool          is_stop;     // A pending order is a stop one (otherwise a limit one), as Trade() places it.
    PR_ORDER_TYPE type;
    double        price;       // The actual entry price (the limit price for a stop-limit order).
    double        stop_price;  // The stop price of a stop-limit order.
    double        volume;
    double        sl;          // Actual levels, 0 if absent. Shifted into Bid terms for sells when added to the simulation.
    double        tp;
};
PR_PlannedOrder PR_Planned[];
int PR_PlannedTotal = 0;
string PR_PlannedKey = ""; // Identifies the planned trade's structure in the overflow memory. Volumes and the current price are left out so that the memory works between ticks.

// Builds the planned trade from the panel's current values: direction, entry type and levels, stop-loss, take-profits, and the position sizes
// per take-profit (ArrayPositionSize[]). Mirrors Trade(): orders below the broker's minimum volume are skipped, take-profits on the wrong side
// are dropped, and on a netting account a single order with the main take-profit is sent for the whole volume. The stop-loss and take-profit
// levels are used even if DoNotApplyStopLoss/DoNotApplyTakeProfit are set - same as in the Main tab's risk and reward calculation.
// Returns the total planned volume.
double PR_BuildPlannedTrade()
{
    PR_PlannedTotal = 0;
    PR_PlannedKey = "";
    if ((OutputPositionSize <= 0) || (sets.StopLossLevel <= 0)) return 0; // Nothing to trade or no stop-loss - no position size either.
    bool is_buy = (sets.TradeDirection == Long);
    double entry, stop_price = 0;
    if (sets.EntryType == Instant) entry = is_buy ? SymbolInfoDouble(SymbolForTrading, SYMBOL_ASK) : SymbolInfoDouble(SymbolForTrading, SYMBOL_BID);
    else entry = sets.EntryLevel; // The limit price for a stop-limit order.
    bool is_stop = false; // A stop order when the entry is beyond the current price - same as in Trade().
    if (sets.EntryType == Pending)
    {
        if (is_buy) is_stop = (entry > SymbolInfoDouble(SymbolForTrading, SYMBOL_ASK));
        else is_stop = (entry < SymbolInfoDouble(SymbolForTrading, SYMBOL_BID));
    }
    if (sets.EntryType == StopLimit) stop_price = sets.StopPriceLevel;
    if ((entry <= 0) || ((sets.EntryType == StopLimit) && (stop_price <= 0))) return 0;
    double sl = RealStopLossLevelFromBase(sets.StopLossLevel); // Spread-adjusted when SA-SL is on.
    if ((is_buy) && (sl >= entry)) sl = 0; // Wrong side - ignored.
    else if ((!is_buy) && (sl <= entry)) sl = 0;

    PR_PlannedKey = "P:" + EnumToString(sets.EntryType);
    if (is_buy) PR_PlannedKey += "B";
    else PR_PlannedKey += "S";
    if (sets.EntryType != Instant) PR_PlannedKey += DoubleToString(entry, 8) + "/" + DoubleToString(stop_price, 8);
    PR_PlannedKey += ":" + DoubleToString(sl, 8);
    double total = 0;
    int orders = sets.TakeProfitsNumber;
    if (!PR_IsHedging()) orders = 1; // Netting - no multiple TPs, a single TP for 100% of the volume.
    ArrayResize(PR_Planned, orders);
    for (int j = 0; j < orders; j++)
    {
        double volume = 0;
        if (orders == sets.TakeProfitsNumber)
        {
            if (j < ArraySize(ArrayPositionSize)) volume = ArrayPositionSize[j];
        }
        else // The whole volume in one order.
        {
            for (int k = 0; (k < sets.TakeProfitsNumber) && (k < ArraySize(ArrayPositionSize)); k++) volume += ArrayPositionSize[k];
            volume = NormalizeDouble(volume, LotStep_digits);
        }
        if (volume < MinLot) continue; // Calculated PS < broker's minimum - Trade() skips such orders.
        double tp = sets.TakeProfitLevel;
        if (orders > 1) tp = sets.TP[j];
        tp = RealTakeProfitLevelFromBase(tp); // Spread-adjusted when SA-TP is on.
        if (tp != 0)
        {
            if ((is_buy) && (tp <= entry)) tp = 0; // Do not apply TP if it is invalid. Same as in Trade().
            else if ((!is_buy) && (tp >= entry)) tp = 0;
        }
        PR_Planned[PR_PlannedTotal].entry_type = sets.EntryType;
        PR_Planned[PR_PlannedTotal].is_stop = is_stop;
        PR_Planned[PR_PlannedTotal].type = is_buy ? PR_Buy : PR_Sell;
        PR_Planned[PR_PlannedTotal].price = entry;
        PR_Planned[PR_PlannedTotal].stop_price = stop_price;
        PR_Planned[PR_PlannedTotal].volume = volume;
        PR_Planned[PR_PlannedTotal].sl = sl;
        PR_Planned[PR_PlannedTotal].tp = tp;
        PR_PlannedTotal++;
        total += volume;
        PR_PlannedKey += ":" + DoubleToString(tp, 8);
    }
    return total;
}

// Adds an order (a real one or a planned one) to the simulation. price - the actual entry price (the limit price for a stop-limit order),
// stop_price - the stop price of a stop-limit order, sl and tp - the actual levels or 0.
// All levels are kept in Bid terms: a Sell's SL/TP and a Buy's entry are triggered by the Ask, so they are shifted down by the spread
// (a Buy still opens at its actual price - see OpenPrice()). The shifted levels are normalized to compare equal to the untouched levels at the same price.
// An open position goes to the Status; in netting mode, it is merged into the symbol's position the way a filled order would be.
// is_stop - a pending order is a stop one (otherwise a limit one). Only the margin calculation tells them apart.
void PR_AddOrder(COrderIterator *OrderIterator, const long ticket, const ENTRY_TYPE entry_type, const PR_ORDER_TYPE type, const double price, const double stop_price, const double volume, double sl, double tp, const bool is_stop = false)
{
    CRemainingOrderObject *order;
    if (type == PR_Sell)
    {
        if (sl != 0) sl = NormalizeDouble(sl - PR_Ctx.spread, PR_Ctx.digits);
        if (tp != 0) tp = NormalizeDouble(tp - PR_Ctx.spread, PR_Ctx.digits);
    }
    double trigger = price; // The entry in Bid terms.
    if (type == PR_Buy) trigger = NormalizeDouble(price - PR_Ctx.spread, PR_Ctx.digits);
    if (entry_type == Instant)
    {
        CRemainingOrderObject *filled = new CRemainingOrderObject(ticket, trigger, volume, type, sl, tp, PR_Pending, 0, 0);
        OrderIterator.AddExecutedOrderToStatus(filled);
        delete filled;
    }
    else if (entry_type == Pending)
    {
        order = new CRemainingOrderObject(ticket, trigger, volume, type, sl, tp, PR_Pending, 0, 0);
        if (is_stop) order.SetKind(PR_KIND_STOP);
        OrderIterator.RO.Add(order);
    }
    else // Stop-limit: the stop order, and its inactive limit order at the limit price.
    {
        double stop_trigger = stop_price;
        if (type == PR_Buy) stop_trigger = NormalizeDouble(stop_price - PR_Ctx.spread, PR_Ctx.digits);
        order = new CRemainingOrderObject(ticket, stop_trigger, volume, type, sl, tp, PR_StopLimit, 0, trigger);
        order.SetKind(PR_KIND_STOP_LIMIT);
        OrderIterator.RO.Add(order);
        order = new CRemainingOrderObject(ticket, trigger, volume, type, sl, tp, PR_Inactive, ticket, trigger); // A limit order once activated.
        OrderIterator.RO.Add(order);
    }
}

// Adds the currently selected real position to the simulation.
void PR_AddSelectedPosition(COrderIterator *OrderIterator)
{
    PR_ORDER_TYPE type = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) ? PR_Buy : PR_Sell;
    PR_AddOrder(OrderIterator, (long)PositionGetInteger(POSITION_TICKET), Instant, type, PositionGetDouble(POSITION_PRICE_OPEN), 0, PositionGetDouble(POSITION_VOLUME), PositionGetDouble(POSITION_SL), PositionGetDouble(POSITION_TP));
}

// Adds the currently selected real pending order to the simulation.
void PR_AddSelectedOrder(COrderIterator *OrderIterator)
{
    ENUM_ORDER_TYPE ot = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
    PR_ORDER_TYPE type = ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_STOP_LIMIT)) ? PR_Buy : PR_Sell;
    if ((ot == ORDER_TYPE_BUY_STOP_LIMIT) || (ot == ORDER_TYPE_SELL_STOP_LIMIT))
        PR_AddOrder(OrderIterator, (long)OrderGetInteger(ORDER_TICKET), StopLimit, type, OrderGetDouble(ORDER_PRICE_STOPLIMIT), OrderGetDouble(ORDER_PRICE_OPEN), OrderGetDouble(ORDER_VOLUME_CURRENT), OrderGetDouble(ORDER_SL), OrderGetDouble(ORDER_TP));
    else
        PR_AddOrder(OrderIterator, (long)OrderGetInteger(ORDER_TICKET), Pending, type, OrderGetDouble(ORDER_PRICE_OPEN), 0, OrderGetDouble(ORDER_VOLUME_CURRENT), OrderGetDouble(ORDER_SL), OrderGetDouble(ORDER_TP), (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_SELL_STOP));
}

// One order's own worst (best) case in the account currency for the simple calculation. level - its SL (PR_Risk) or TP (PR_Reward).
// Returns DBL_MAX if unlimited.
double PR_SimpleOrder(const bool is_buy, const double open, const double level, const double volume, const PR_MODE mode)
{
    if (level == 0)
    {
        // Going all way up: a Sell's loss or a Buy's profit is unlimited. Going all way down: the whole value is lost (gained),
        // which is unlimited in money terms when the account currency is the pair's base currency.
        if (((!is_buy) && (mode == PR_Risk)) || ((is_buy) && (mode == PR_Reward)) || (PR_Ctx.future_rate)) return DBL_MAX;
        return PR_ToMoney(volume * open, open);
    }
    double units = is_buy ? (level - open) : (open - level); // The order's profit at the level.
    if (mode == PR_Risk) units = -units; // The loss.
    return PR_ToMoney(volume * units, level);
}

// Fallback for a symbol whose order set is too entangled for the exact simulation: the sum of each included order's own worst (best) case,
// as the Position Sizer calculated it before. Hedges are ignored, so it is an upper bound of the exact value.
// Returns money in the account currency or DBL_MAX if unlimited.
double PR_SimpleSymbol(const string cp, const PR_MODE mode, const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const bool include_planned)
{
    double result = 0;
    int total = PositionsTotal();
    for (int i = 0; i < total; i++)
    {
        if (PositionGetTicket(i) == 0) continue;
        if (PositionGetString(POSITION_SYMBOL) != cp) continue;
        if (!PR_PositionIncluded(calculate_risk_for_trading_tab)) continue;
        bool is_buy = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
        double level = (mode == PR_Risk) ? PositionGetDouble(POSITION_SL) : PositionGetDouble(POSITION_TP); // The exit relevant for the mode.
        double money = PR_SimpleOrder(is_buy, PositionGetDouble(POSITION_PRICE_OPEN), level, PositionGetDouble(POSITION_VOLUME), mode);
        if (money == DBL_MAX) return DBL_MAX;
        result += money;
    }
    total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (OrderGetTicket(i) == 0) continue;
        if (OrderGetString(ORDER_SYMBOL) != cp) continue;
        if (!PR_PendingIncluded(calculate_risk_for_trading_tab)) continue;
        ENUM_ORDER_TYPE ot = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
        bool is_buy = ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_STOP_LIMIT));
        double open = OrderGetDouble(ORDER_PRICE_OPEN);
        if ((ot == ORDER_TYPE_BUY_STOP_LIMIT) || (ot == ORDER_TYPE_SELL_STOP_LIMIT)) open = OrderGetDouble(ORDER_PRICE_STOPLIMIT); // The limit price is the entry.
        double level = (mode == PR_Risk) ? OrderGetDouble(ORDER_SL) : OrderGetDouble(ORDER_TP);
        double money = PR_SimpleOrder(is_buy, open, level, OrderGetDouble(ORDER_VOLUME_CURRENT), mode);
        if (money == DBL_MAX) return DBL_MAX;
        result += money;
    }
    if (include_planned)
    {
        for (int j = 0; j < PR_PlannedTotal; j++)
        {
            double level = (mode == PR_Risk) ? PR_Planned[j].sl : PR_Planned[j].tp;
            double money = PR_SimpleOrder(PR_Planned[j].type == PR_Buy, PR_Planned[j].price, level, PR_Planned[j].volume, mode);
            if (money == DBL_MAX) return DBL_MAX;
            result += money;
        }
    }
    return result;
}

// Runs the simulation for one symbol. Returns the maximum loss (PR_Risk) or the maximum profit (PR_Reward) in the account currency,
// DBL_MAX if it is unlimited, or 0 if there are no included positions and orders on the symbol.
// include_planned - add the planned trade (PR_Planned[]) to the symbol's orders. Only makes sense for the trading symbol.
double PR_ProcessSymbol(const string cp, const PR_MODE mode, const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const bool include_planned)
{
    if (!PR_PrepareSymbol(cp, mode)) return 0;

    COrderIterator::min_profit = PR_UNDEFINED;
    COrderIterator::iterations = 0;
    COrderIterator::overflow = false;
    COrderIterator::hedging = PR_IsHedging();
    COrderIterator *OrderIterator = new COrderIterator();
    OrderIterator.mode = mode;
    int included = 0;
    string key = cp + "|" + EnumToString(mode) + "|"; // Identifies the order set in the overflow memory.

    // Positions first: in netting mode, pending orders merge into the position.
    int total = PositionsTotal();
    for (int i = 0; i < total; i++)
    {
        if (PositionGetTicket(i) == 0) continue;
        if (PositionGetString(POSITION_SYMBOL) != cp) continue;
        if (!PR_PositionIncluded(calculate_risk_for_trading_tab)) continue;
        included++;
        key += IntegerToString(PositionGetInteger(POSITION_TICKET)) + ":" + DoubleToString(PositionGetDouble(POSITION_PRICE_OPEN), 8) + ":" + DoubleToString(PositionGetDouble(POSITION_SL), 8) + ":" + DoubleToString(PositionGetDouble(POSITION_TP), 8) + ":" + DoubleToString(PositionGetDouble(POSITION_VOLUME), 8) + ";";
        PR_AddSelectedPosition(OrderIterator);
    }

    total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (OrderGetTicket(i) == 0) continue;
        if (OrderGetString(ORDER_SYMBOL) != cp) continue;
        if (!PR_PendingIncluded(calculate_risk_for_trading_tab)) continue;
        included++;
        key += IntegerToString(OrderGetInteger(ORDER_TICKET)) + ":" + DoubleToString(OrderGetDouble(ORDER_PRICE_OPEN), 8) + ":" + DoubleToString(OrderGetDouble(ORDER_PRICE_STOPLIMIT), 8) + ":" + DoubleToString(OrderGetDouble(ORDER_SL), 8) + ":" + DoubleToString(OrderGetDouble(ORDER_TP), 8) + ":" + DoubleToString(OrderGetDouble(ORDER_VOLUME_CURRENT), 8) + ";";
        PR_AddSelectedOrder(OrderIterator);
    }

    if (include_planned)
    {
        for (int j = 0; j < PR_PlannedTotal; j++)
            PR_AddOrder(OrderIterator, PR_PLANNED_TICKET + j, PR_Planned[j].entry_type, PR_Planned[j].type, PR_Planned[j].price, PR_Planned[j].stop_price, PR_Planned[j].volume, PR_Planned[j].sl, PR_Planned[j].tp, PR_Planned[j].is_stop);
        included += PR_PlannedTotal;
        key += PR_PlannedKey;
    }

    if (included == 0)
    {
        delete OrderIterator;
        return 0;
    }

    // This order set is already known to exceed PR_MAX_ITERATIONS.
    if (PR_IsKnownOverflow(key))
    {
        delete OrderIterator;
        return PR_SimpleSymbol(cp, mode, calculate_risk_for_trading_tab, include_planned);
    }

    OrderIterator.current_price = SymbolInfoDouble(cp, SYMBOL_BID);
    OrderIterator.Iterate(PR_UNDEFINED);
    delete OrderIterator;

    if (COrderIterator::overflow)
    {
        PR_RememberOverflow(key);
        Print(__FUNCTION__, ": ", cp, " - too many order combinations for the exact ", (mode == PR_Risk ? "risk" : "reward"), " calculation (more than ", PR_MAX_ITERATIONS, " price paths). Using the simple per-order sum until the orders change.");
        return PR_SimpleSymbol(cp, mode, calculate_risk_for_trading_tab, include_planned);
    }
    double mp = COrderIterator::min_profit;
    if ((mp == PR_UNLIMITED) || (mp == PR_UNDEFINED)) return DBL_MAX;
    if (mode == PR_Risk) return -mp; // The maximum loss as a positive number (negative when a profit is guaranteed).
    return mp; // The maximum profit.
}

// Adds two amounts of money, DBL_MAX (unlimited) absorbing everything.
double PR_Sum(const double a, const double b)
{
    if ((a == DBL_MAX) || (b == DBL_MAX)) return DBL_MAX;
    return a + b;
}

// Adds a symbol to the list if it is not there yet.
void PR_AddSymbol(string &symbols[], const string symbol)
{
    int n = ArraySize(symbols);
    for (int j = 0; j < n; j++)
        if (symbols[j] == symbol) return;
    ArrayResize(symbols, n + 1, 10);
    symbols[n] = symbol;
}

// Calculates the portfolio risk and reward over all included positions and orders. Outputs the maximum loss and the maximum profit in the account
// currency (DBL_MAX = unlimited) for the current orders (loss_money, reward_money) and for the current orders together with the planned trade
// (potential_loss_money, potential_reward_money), and the total volume of the included positions and orders.
// Both pairs include the swaps already accrued on the included positions and the commission still to be charged on them: the exit deal of each
// position and both deals of each pending order (the entry deals' commission has already been deducted from the balance), plus the round-trip
// commission of the planned trade for the potential values.
void PR_CalculatePortfolio(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, double &loss_money, double &reward_money, double &volume, double &potential_loss_money, double &potential_reward_money)
{
    volume = 0;
    double charged = 0; // Swaps already accrued. Negative values when charged.
    double commission_risk = 0, commission_reward = 0; // Commission still to be charged in the losing and in the winning scenario.
    string symbols[];

    int total = PositionsTotal();
    for (int i = 0; i < total; i++)
    {
        if (PositionGetTicket(i) == 0) continue;
        if (!PR_PositionIncluded(calculate_risk_for_trading_tab)) continue;
        string symbol = PositionGetString(POSITION_SYMBOL);
        bool is_buy = (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY);
        double position_volume = PositionGetDouble(POSITION_VOLUME);
        volume += position_volume;
        charged += PositionGetDouble(POSITION_SWAP);
        // The exit deal is still to be paid for.
        commission_risk += PR_CommissionPerLot(symbol, is_buy, position_volume, PositionGetDouble(POSITION_PRICE_OPEN), PositionGetDouble(POSITION_TP), PR_Risk) * position_volume;
        commission_reward += PR_CommissionPerLot(symbol, is_buy, position_volume, PositionGetDouble(POSITION_PRICE_OPEN), PositionGetDouble(POSITION_TP), PR_Reward) * position_volume;
        PR_AddSymbol(symbols, symbol);
    }
    total = OrdersTotal();
    for (int i = 0; i < total; i++)
    {
        if (OrderGetTicket(i) == 0) continue;
        if (!PR_PendingIncluded(calculate_risk_for_trading_tab)) continue;
        string symbol = OrderGetString(ORDER_SYMBOL);
        ENUM_ORDER_TYPE ot = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
        bool is_buy = ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP) || (ot == ORDER_TYPE_BUY_STOP_LIMIT));
        double order_volume = OrderGetDouble(ORDER_VOLUME_CURRENT);
        double price = OrderGetDouble(ORDER_PRICE_OPEN);
        if ((ot == ORDER_TYPE_BUY_STOP_LIMIT) || (ot == ORDER_TYPE_SELL_STOP_LIMIT)) price = OrderGetDouble(ORDER_PRICE_STOPLIMIT); // The limit price is the entry.
        volume += order_volume;
        // Both the entry and the exit deals are still to be paid for.
        commission_risk += 2 * PR_CommissionPerLot(symbol, is_buy, order_volume, price, OrderGetDouble(ORDER_TP), PR_Risk) * order_volume;
        commission_reward += 2 * PR_CommissionPerLot(symbol, is_buy, order_volume, price, OrderGetDouble(ORDER_TP), PR_Reward) * order_volume;
        PR_AddSymbol(symbols, symbol);
    }

    double planned_volume = PR_BuildPlannedTrade();

    // Symbols are treated as independent, so their worst (best) cases add up. The trading symbol is kept apart because the planned trade is added to it.
    double others_loss = 0, others_reward = 0, chart_loss = 0, chart_reward = 0;
    int symbols_total = ArraySize(symbols);
    for (int i = 0; i < symbols_total; i++)
    {
        double risk = PR_ProcessSymbol(symbols[i], PR_Risk, calculate_risk_for_trading_tab, false);
        double reward = PR_ProcessSymbol(symbols[i], PR_Reward, calculate_risk_for_trading_tab, false);
        if (symbols[i] == SymbolForTrading)
        {
            chart_loss = risk;
            chart_reward = reward;
        }
        else
        {
            others_loss = PR_Sum(others_loss, risk);
            others_reward = PR_Sum(others_reward, reward);
        }
    }
    loss_money = PR_Sum(others_loss, chart_loss);
    reward_money = PR_Sum(others_reward, chart_reward);

    if (planned_volume > 0)
    {
        // Round-trip commission of the planned trade, as in the Main tab's risk and reward. CalculateCommission() also refreshes CommissionReward.
        double commission_risk = 2 * CalculateCommission() * planned_volume;
        double commission_reward = 2 * CommissionReward * planned_volume;
        potential_loss_money = PR_Sum(others_loss, PR_ProcessSymbol(SymbolForTrading, PR_Risk, calculate_risk_for_trading_tab, true));
        potential_reward_money = PR_Sum(others_reward, PR_ProcessSymbol(SymbolForTrading, PR_Reward, calculate_risk_for_trading_tab, true));
        if (potential_loss_money != DBL_MAX) potential_loss_money += commission_risk;
        if (potential_reward_money != DBL_MAX) potential_reward_money -= commission_reward;
    }
    else
    {
        potential_loss_money = loss_money;
        potential_reward_money = reward_money;
    }

    // The accrued swaps and the commission still to be charged increase the loss and decrease the profit.
    if (loss_money != DBL_MAX) loss_money += commission_risk - charged;
    if (reward_money != DBL_MAX) reward_money -= commission_reward - charged;
    if (potential_loss_money != DBL_MAX) potential_loss_money += commission_risk - charged;
    if (potential_reward_money != DBL_MAX) potential_reward_money -= commission_reward - charged;
}

// Potential risk of the trading symbol with the planned trade at the current ArrayPositionSize[], in the account currency (DBL_MAX = unlimited).
// Includes the planned trade's round-trip commission. The only part of the portfolio that depends on the planned volume - see PR_FindMaxVolume().
double PR_ChartPotentialRisk(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab)
{
    double planned_volume = PR_BuildPlannedTrade();
    double risk = PR_ProcessSymbol(SymbolForTrading, PR_Risk, calculate_risk_for_trading_tab, planned_volume > 0);
    if ((risk != DBL_MAX) && (planned_volume > 0)) risk += 2 * CalculateCommission() * planned_volume;
    return risk;
}

// Finds the largest position size, a multiple of the lot step not above max_volume, whose potential portfolio risk doesn't exceed limit_money.
// Used by the Trading tab's risk fuses when LessRestrictiveMaxLimits is on. current_loss_money - the current portfolio risk (has to be finite
// and within the limit, which the caller checks). Only the trading symbol is re-simulated for each probed size; the rest of the portfolio
// is taken from current_loss_money once.
// The potential risk is a convex function of the planned volume (the maximum over the price paths of amounts linear in the volume), so it crosses
// the limit only once and a bisection finds the boundary. Fills ArrayPositionSize[] for the returned size. Returns 0 if no size fits.
double PR_FindMaxVolume(const CALCULATE_RISK_FOR_TRADING_TAB calculate_risk_for_trading_tab, const double limit_money, const double max_volume, const double current_loss_money)
{
    if (LotStep <= 0) return 0;
    double base = current_loss_money - PR_ProcessSymbol(SymbolForTrading, PR_Risk, calculate_risk_for_trading_tab, false); // The other symbols, the accrued swaps, and the commission of the existing trades.
    int lo = 0; // Fits.
    int hi = (int)MathRound(max_volume / LotStep); // Doesn't fit.
    while (hi - lo > 1)
    {
        int mid = (lo + hi) / 2;
        PositionSizeToArray(NormalizeDouble(mid * LotStep, LotStep_digits)); // Re-fills ArrayPositionSize[], which the planned trade is built from.
        double potential_loss = PR_ChartPotentialRisk(calculate_risk_for_trading_tab);
        if ((potential_loss != DBL_MAX) && (base + potential_loss <= limit_money)) lo = mid;
        else hi = mid;
    }
    double result = NormalizeDouble(lo * LotStep, LotStep_digits);
    PositionSizeToArray(result);
    return result;
}
//+------------------------------------------------------------------+