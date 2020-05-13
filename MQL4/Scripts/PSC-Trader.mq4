//+------------------------------------------------------------------+
//|                                                 	PSC-Trader.mq4 |
//|                               Copyright 2015-2020, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015-2020, EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/Position-Size-Calculator/#Trading_script"
#property version   "1.07"
#property strict
#include <stdlib.mqh>

/*

This script works with Position Size Calculator indicator:
https://www.earnforex.com/metatrader-indicators/Position-Size-Calculator/
It works both with the new version (graphical panel) and legacy version (text labels).

It can open pending or instant orders using the position size calculated by PSC.

Works with Market Execution (ECN) too - first opens the order, then sets SL/TP.

You can control script settings via Position Size Calculator panel (Script tab).

*/

bool DisableTradingWhenLinesAreHidden, SubtractPositions, SubtractPendingOrders, DoNotApplyStopLoss, DoNotApplyTakeProfit;
int MaxSlippage = 0, MaxSpread, MaxEntrySLDistance, MinEntrySLDistance, MagicNumber = 0;
double MaxPositionSize;

string Commentary = "PSC-Trader";

enum ENTRY_TYPE
{
   Instant,
   Pending
};

//+------------------------------------------------------------------+
//| Script execution function.                                       |
//+------------------------------------------------------------------+
void OnStart()
{
   int Window;

   string ps = ""; // Position size string.
   double el = 0, sl = 0, tp = 0; // Entry level, stop-loss, and take-profit.
   int ot; // Order type.
   ENTRY_TYPE entry_type;

   Window = WindowFind("Position Size Calculator" + IntegerToString(ChartID()));
   if (Window == -1)
   {
      // Trying to find the new version's position size object.
      ps = FindEditObjectByPostfix("m_EdtPosSize");
      ps = ObjectGetString(0, ps, OBJPROP_TEXT);
      // Trying to find the legacy version's position size object.
     	if (StringLen(ps) == 0) ps = ObjectGetString(0, "PositionSize", OBJPROP_TEXT);
	   if (StringLen(ps) == 0)
      {
         Alert("Position Size Calculator not found!");
         return;
      }
   }

	if (StringLen(ps) == 0)
	{
		// Trying to find the new version's position size object.
	   ps = FindEditObjectByPostfix("m_EdtPosSize");
	   ps = ObjectGetString(0, ps, OBJPROP_TEXT);
	   // Trying to find the legacy version's position size object.
	   if (StringLen(ps) == 0) ps = ObjectGetString(0, "PositionSize", OBJPROP_TEXT);
		if (StringLen(ps) == 0)
	   {
	      Alert("Position Size object not found!");
	      return;
	   }
	}
   int len = StringLen(ps);
   string ps_proc = "";
   for (int i = len - 1; i >= 0; i--)
   {
      string c = StringSubstr(ps, i, 1);
      if (c != " ") ps_proc = c + ps_proc;
      else break;
   }
   
   double PositionSize = StringToDouble(ps_proc);
   int ps_decimals = CountDecimalPlaces(PositionSize);
      
   Print("Detected position size: ", DoubleToString(PositionSize, ps_decimals), ".");

   if (PositionSize <= 0)
   {
      Print("Wrong position size value!");
      return;
   }
   
   el = ObjectGetDouble(0, "EntryLine", OBJPROP_PRICE);
   if (el <= 0)
   {
      Alert("Entry Line not found!");
      return;
   }
   
   el = NormalizeDouble(el, Digits);
   Print("Detected entry level: ", DoubleToString(el, Digits), ".");

   RefreshRates();
   
   if ((el == Ask) || (el == Bid)) entry_type = Instant;
   else entry_type = Pending;
   
   Print("Detected entry type: ", EnumToString(entry_type), ".");
   
   sl = ObjectGetDouble(0, "StopLossLine", OBJPROP_PRICE);
   if (sl <= 0)
   {
      Alert("Stop-Loss Line not found!");
      return;
   }
   
   sl = NormalizeDouble(sl, Digits);
   Print("Detected stop-loss level: ", DoubleToString(sl, Digits), ".");
   
   tp = ObjectGetDouble(0, "TakeProfitLine", OBJPROP_PRICE);
   if (tp > 0)
   {
      tp = NormalizeDouble(tp, Digits);
      Print("Detected take-profit level: ", DoubleToString(tp, Digits), ".");
   }
   else Print("No take-profit detected.");
   
	// Magic number
   string EdtMagicNumber = FindEditObjectByPostfix("m_EdtMagicNumber");
   if (EdtMagicNumber != "") MagicNumber = (int)StringToInteger(ObjectGetString(0, EdtMagicNumber, OBJPROP_TEXT));
   Print("Magic number = ", MagicNumber);

	// Order commentary
   string EdtScriptCommentary = FindEditObjectByPostfix("m_EdtScriptCommentary");
   if (EdtScriptCommentary != "") Commentary = ObjectGetString(0, EdtScriptCommentary, OBJPROP_TEXT);
   Print("Order commentary = ", Commentary);

   // Checkbox for disabling trading when hidden lines
   string ChkDisableTradingWhenLinesAreHidden = FindCheckboxObjectByPostfix("m_ChkDisableTradingWhenLinesAreHiddenButton");
   if (ChkDisableTradingWhenLinesAreHidden != "") DisableTradingWhenLinesAreHidden = ObjectGetInteger(0, ChkDisableTradingWhenLinesAreHidden, OBJPROP_STATE);
   Print("Disable trading when lines are hidden = ", DisableTradingWhenLinesAreHidden);

	// Entry line
   bool EntryLineHidden = false;
   int EL_Hidden = (int)ObjectGetInteger(0, "EntryLine", OBJPROP_TIMEFRAMES);
   if (EL_Hidden == OBJ_NO_PERIODS) EntryLineHidden = true; 
   Print("Entry line hidden = ", EntryLineHidden);

	if ((DisableTradingWhenLinesAreHidden) && (EntryLineHidden))
	{
		Print("Not taking a trade - lines are hidden, and indicator says not to trade when they are hidden.");
		return;
	}

	// Other fuses
   string EdtMaxSlippage = FindEditObjectByPostfix("m_EdtMaxSlippage");
   if (EdtMaxSlippage != "") MaxSlippage = (int)StringToInteger(ObjectGetString(0, EdtMaxSlippage, OBJPROP_TEXT));
   Print("Max slippage = ", MaxSlippage);

   string EdtMaxSpread = FindEditObjectByPostfix("m_EdtMaxSpread");
   if (EdtMaxSpread != "") MaxSpread = (int)StringToInteger(ObjectGetString(0, EdtMaxSpread, OBJPROP_TEXT));
   Print("Max spread = ", MaxSpread);
   
   if (MaxSpread > 0)
   {
	   int spread = (int)((Ask - Bid) / Point);
	   if (spread > MaxSpread)
	   {
			Print("Not taking a trade - current spread (", spread, ") > maximum spread (", MaxSpread, ").");
			return;
	   }
	}
	
   string EdtMaxEntrySLDistance = FindEditObjectByPostfix("m_EdtMaxEntrySLDistance");
   if (EdtMaxEntrySLDistance != "") MaxEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMaxEntrySLDistance, OBJPROP_TEXT));
   Print("Max Entry/SL distance = ", MaxEntrySLDistance);

   if (MaxEntrySLDistance > 0)
   {
	   int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point);
	   if (CurrentEntrySLDistance > MaxEntrySLDistance)
	   {
			Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") > maximum Entry/SL distance (", MaxEntrySLDistance, ").");
			return;
	   }
	}
	
   string EdtMinEntrySLDistance = FindEditObjectByPostfix("m_EdtMinEntrySLDistance");
   if (EdtMinEntrySLDistance != "") MinEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMinEntrySLDistance, OBJPROP_TEXT));
   Print("Min Entry/SL distance = ", MinEntrySLDistance);

   if (MinEntrySLDistance > 0)
   {
	   int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point);
	   if (CurrentEntrySLDistance < MinEntrySLDistance)
	   {
			Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") < minimum Entry/SL distance (", MinEntrySLDistance, ").");
			return;
	   }
	}
	
   string EdtMaxPositionSize = FindEditObjectByPostfix("m_EdtMaxPositionSize");
   if (EdtMaxPositionSize != "") MaxPositionSize = StringToDouble(ObjectGetString(0, EdtMaxPositionSize, OBJPROP_TEXT));
   Print("Max position size = ", DoubleToString(MaxPositionSize, ps_decimals));
	   
   // Checkbox for subtracting open positions volume from the position size.
   string ChkSubtractPositions = FindCheckboxObjectByPostfix("m_ChkSubtractPositionsButton");
   if (ChkSubtractPositions != "") SubtractPositions = ObjectGetInteger(0, ChkSubtractPositions, OBJPROP_STATE);
   Print("Subtract open positions volume = ", SubtractPositions);

   // Checkbox for subtracting pending orders volume from the position size.
   string ChkSubtractPendingOrders = FindCheckboxObjectByPostfix("m_ChkSubtractPendingOrdersButton");
   if (ChkSubtractPendingOrders != "") SubtractPendingOrders = ObjectGetInteger(0, ChkSubtractPendingOrders, OBJPROP_STATE);
   Print("Subtract pending orders volume = ", SubtractPendingOrders);
   
   // Checkbox for not applying stop-loss to the position.
   string ChkDoNotApplyStopLoss = FindCheckboxObjectByPostfix("m_ChkDoNotApplyStopLossButton");
   if (ChkDoNotApplyStopLoss != "") DoNotApplyStopLoss = ObjectGetInteger(0, ChkDoNotApplyStopLoss, OBJPROP_STATE);
   Print("Do not apply stop-loss = ", DoNotApplyStopLoss);

   // Checkbox for not applying take-profit to the position.
   string ChkDoNotApplyTakeProfit = FindCheckboxObjectByPostfix("m_ChkDoNotApplyTakeProfitButton");
   if (ChkDoNotApplyTakeProfit != "") DoNotApplyTakeProfit = ObjectGetInteger(0, ChkDoNotApplyTakeProfit, OBJPROP_STATE);
   Print("Do not apply take-profit = ", DoNotApplyTakeProfit);

	ENUM_SYMBOL_TRADE_EXECUTION Execution_Mode = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(Symbol(), SYMBOL_TRADE_EXEMODE);
	Print("Execution mode: ", EnumToString(Execution_Mode));

   if (entry_type == Pending)
   {
      // Sell
      if (sl > el)
      {
         // Stop
         if (el < Bid) ot = OP_SELLSTOP;
         // Limit
         else ot = OP_SELLLIMIT;
      }
      // Buy
      else
      {
         // Stop
         if (el > Ask) ot = OP_BUYSTOP;
         // Limit
         else ot = OP_BUYLIMIT;
      }
   }
   // Instant
   else
   {
      // Sell
      if (sl > el) ot = OP_SELL;
      // Buy
      else ot = OP_BUY;
   }
   
   double order_sl = sl;
   double order_tp = tp;      

	// Market execution mode - preparation.
	if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant))
	{
		// No SL/TP allowed on instant orders.
		order_sl = 0;
		order_tp = 0;
	}
   if (DoNotApplyStopLoss)
   {
      sl = 0;
      order_sl = 0;
   }
   if (DoNotApplyTakeProfit)
   {
      tp = 0;
      order_tp = 0;
   }

	if ((SubtractPendingOrders) || (SubtractPositions))
	{
	   double existing_volume_buy = 0, existing_volume_sell = 0;
	   CalculateOpenVolume(existing_volume_buy, existing_volume_sell);
	   Print("Found existing buy volume = ", DoubleToString(existing_volume_buy, ps_decimals));
	   Print("Found existing sell volume = ", DoubleToString(existing_volume_sell, ps_decimals));
	   if ((ot == OP_BUY) || (ot == OP_BUYLIMIT) || (ot == OP_BUYSTOP)) PositionSize -= existing_volume_buy;
	   else PositionSize -= existing_volume_sell;
	   Print("Adjusted position size = ", DoubleToString(PositionSize, ps_decimals));
	   if (PositionSize < 0)
	   {
	      Print("Adjusted position size is less than zero. Not executing any trade.");
	      return;
	   }
	}
	
   if (MaxPositionSize > 0)
   {
	   if (PositionSize > MaxPositionSize)
	   {
			Print("Position size (", DoubleToString(PositionSize, ps_decimals), ") > maximum position size (", DoubleToString(MaxPositionSize, ps_decimals), "). Setting position size to ", DoubleToString(MaxPositionSize, ps_decimals), ".");
			PositionSize = MaxPositionSize;
	   }
	}

   int ticket = OrderSend(Symbol(), ot, PositionSize, el, MaxSlippage, order_sl, order_tp, Commentary, MagicNumber);
   if (ticket == -1)
   {
      int error = GetLastError();
      Print("Execution failed. Error: ", IntegerToString(error), " - ", ErrorDescription(error), ".");
   }
   else Print("Order executed. Ticket: ", ticket, ".");

	// Market execution mode - applying SL/TP.
	if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant) && (ticket != -1) && ((sl != 0) || (tp != 0)))
	{
		if (!OrderSelect(ticket, SELECT_BY_TICKET))
		{
			Print("Failed to find the order to apply SL/TP.");
			return;
		}
		for (int i = 0; i < 10; i++)
		{
		   bool result = OrderModify(ticket, OrderOpenPrice(), sl, tp, OrderExpiration());
		   if (result) break;
		   else Print("Error modifying the order: ", GetLastError());
		}
	}
}

string FindEditObjectByPostfix(const string postfix)
{
	int obj_total = ObjectsTotal(0, 0, OBJ_EDIT);
	string name = "";
	bool found = false;
	for (int i = 0; i < obj_total; i++)
	{
		name = ObjectName(0, i, 0, OBJ_EDIT);
		string pattern = StringSubstr(name, StringLen(name) - StringLen(postfix));
		if (StringCompare(pattern, postfix) == 0)
		{
			found = true;
			break;
		}
	}
	if (found) return(name);
	else return("");
}

string FindCheckboxObjectByPostfix(const string postfix)
{
	int obj_total = ObjectsTotal(0, 0, OBJ_BITMAP_LABEL);
	string name = "";
	bool found = false;
	for (int i = 0; i < obj_total; i++)
	{
		name = ObjectName(0, i, 0, OBJ_BITMAP_LABEL);
		string pattern = StringSubstr(name, StringLen(name) - StringLen(postfix));
		if (StringCompare(pattern, postfix) == 0)
		{
			found = true;
			break;
		}
	}
	if (found) return(name);
	else return("");
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
      // If magic number is given via PSC panel and order's magic number is different - skip.
      if ((MagicNumber != 0) && (OrderMagicNumber() != MagicNumber)) continue;

      if (SubtractPositions)
      {
         // Buy orders
         if (OrderType() == ORDER_TYPE_BUY) volume_buy += OrderLots();
         // Sell orders
         else if (OrderType() == ORDER_TYPE_SELL) volume_sell += OrderLots();
      }
      if (SubtractPendingOrders)
      {
         // Buy orders
         if ((OrderType() == ORDER_TYPE_BUY_LIMIT) || (OrderType() == ORDER_TYPE_BUY_STOP)) volume_buy += OrderLots();
         // Sell orders
         else if ((OrderType() == ORDER_TYPE_SELL_LIMIT) || (OrderType() == ORDER_TYPE_SELL_STOP)) volume_sell += OrderLots();
      }
   }
}

//+------------------------------------------------------------------+
//| Counts decimal places.                                           |
//+------------------------------------------------------------------+
int CountDecimalPlaces(double number)
{
   // 100 as maximum length of number.
   for (int i = 0; i < 100; i++)
   {
      if (MathAbs(MathRound(number) - number) / MathPow(10, i) <= FLT_EPSILON) return(i);
      number *= 10;
   }
   return(-1);
}
//+------------------------------------------------------------------+