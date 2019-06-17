//+------------------------------------------------------------------+
//|                                                 	PSC-Trader.mq4 |
//|                               Copyright 2015-2018, EarnForex.com |
//|                                       https://www.earnforex.com/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015-2018, EarnForex.com"
#property link      "https://www.earnforex.com/metatrader-indicators/Position-Size-Calculator/#Trading_script"
#property version   "1.06"
#include <Trade/Trade.mqh>

/*

This script works with Position Size Calculator indicator:
https://www.earnforex.com/metatrader-indicators/Position-Size-Calculator/
It works both with the new version (graphical panel) and legacy version (text labels).

It can open pending or instant orders using the position size calculated by PSC.

Works with Market Execution (ECN) too - first opens the order, then sets SL/TP.

You can control script settings via Position Size Calculator panel (Script tab).

*/

bool DisableTradingWhenLinesAreHidden, SubtractPositions, SubtractPendingOrders;
int MaxSlippage = 0, MaxSpread, MaxEntrySLDistance, MinEntrySLDistance, MagicNumber = 0;
double MaxPositionSize;

string Commentary = "PSC-Trader";

enum ENTRY_TYPE
{
   Instant,
   Pending
};

CTrade *Trade;

//+------------------------------------------------------------------+
//| Script execution function.                                       |
//+------------------------------------------------------------------+
void OnStart()
{
   double Window;

   string ps = ""; // Position size string.
   double el = 0, sl = 0, tp = 0; // Entry level, stop-loss, and take-profit.
   ENUM_ORDER_TYPE ot; // Order type.
   ENTRY_TYPE entry_type;

   Window = ChartWindowFind(0, "Position Size Calculator" + IntegerToString(ChartID()));
   
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
   
   el = NormalizeDouble(el, _Digits);
   Print("Detected entry level: ", DoubleToString(el, _Digits), ".");

   double Ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   double Bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   
   if ((el == Ask) || (el == Bid)) entry_type = Instant;
   else entry_type = Pending;
   
   Print("Detected entry type: ", EnumToString(entry_type), ".");
   
   sl = ObjectGetDouble(0, "StopLossLine", OBJPROP_PRICE);
   if (sl <= 0)
   {
      Alert("Stop-Loss Line not found!");
      return;
   }
   
   sl = NormalizeDouble(sl, _Digits);
   Print("Detected stop-loss level: ", DoubleToString(sl, _Digits), ".");
   
   
   tp = ObjectGetDouble(0, "TakeProfitLine", OBJPROP_PRICE);
   if (tp > 0)
   {
      tp = NormalizeDouble(tp, _Digits);
      Print("Detected take-profit level: ", DoubleToString(tp, _Digits), ".");
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

   // Checkbox
   string ChkDisableTradingWhenLinesAreHidden = FindCheckboxObjectByPostfix("m_ChkDisableTradingWhenLinesAreHiddenButton");
   if (StringLen(ChkDisableTradingWhenLinesAreHidden) > 0) DisableTradingWhenLinesAreHidden = ObjectGetInteger(0, ChkDisableTradingWhenLinesAreHidden, OBJPROP_STATE);
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

	// Edits
   string EdtMaxSlippage = FindEditObjectByPostfix("m_EdtMaxSlippage");
   if (StringLen(EdtMaxSlippage) > 0) MaxSlippage = (int)StringToInteger(ObjectGetString(0, EdtMaxSlippage, OBJPROP_TEXT));
   Print("Max slippage = ", MaxSlippage);

   string EdtMaxSpread = FindEditObjectByPostfix("m_EdtMaxSpread");
   if (StringLen(EdtMaxSpread) > 0) MaxSpread = (int)StringToInteger(ObjectGetString(0, EdtMaxSpread, OBJPROP_TEXT));
   Print("Max spread = ", MaxSpread);
   
   if (MaxSpread > 0)
   {
	   int spread = (int)SymbolInfoInteger(Symbol(), SYMBOL_SPREAD);
	   if (spread > MaxSpread)
	   {
			Print("Not taking a trade - current spread (", spread, ") > maximum spread (", MaxSpread, ").");
			return;
	   }
	}
	
   string EdtMaxEntrySLDistance = FindEditObjectByPostfix("m_EdtMaxEntrySLDistance");
   if (StringLen(EdtMaxEntrySLDistance) > 0) MaxEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMaxEntrySLDistance, OBJPROP_TEXT));
   Print("Max Entry/SL distance = ", MaxEntrySLDistance);

   if (MaxEntrySLDistance > 0)
   {
	   int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point());
	   if (CurrentEntrySLDistance > MaxEntrySLDistance)
	   {
			Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") > maximum Entry/SL distance (", MaxEntrySLDistance, ").");
			return;
	   }
	}
	
   string EdtMinEntrySLDistance = FindEditObjectByPostfix("m_EdtMinEntrySLDistance");
   if (StringLen(EdtMinEntrySLDistance) > 0) MinEntrySLDistance = (int)StringToInteger(ObjectGetString(0, EdtMinEntrySLDistance, OBJPROP_TEXT));
   Print("Min Entry/SL distance = ", MinEntrySLDistance);

   if (MinEntrySLDistance > 0)
   {
	   int CurrentEntrySLDistance = (int)(MathAbs(sl - el) / Point());
	   if (CurrentEntrySLDistance < MinEntrySLDistance)
	   {
			Print("Not taking a trade - current Entry/SL distance (", CurrentEntrySLDistance, ") < minimum Entry/SL distance (", MinEntrySLDistance, ").");
			return;
	   }
	}
	
   string EdtMaxPositionSize = FindEditObjectByPostfix("m_EdtMaxPositionSize");
   if (StringLen(EdtMaxPositionSize) > 0) MaxPositionSize = StringToDouble(ObjectGetString(0, EdtMaxPositionSize, OBJPROP_TEXT));
   Print("Max position size = ", DoubleToString(MaxPositionSize, ps_decimals));
	   
   // Checkbox for subtracting open positions volume from the position size
   string ChkSubtractPositions = FindCheckboxObjectByPostfix("m_ChkSubtractPositionsButton");
   if (StringLen(ChkSubtractPositions) > 0) SubtractPositions = ObjectGetInteger(0, ChkSubtractPositions, OBJPROP_STATE);
   Print("Subtract open positions volume = ", SubtractPositions);

   // Checkbox for subtracting pending orders volume from the position size
   string ChkSubtractPendingOrders = FindCheckboxObjectByPostfix("m_ChkSubtractPendingOrdersButton");
   if (StringLen(ChkSubtractPendingOrders) > 0) SubtractPendingOrders = ObjectGetInteger(0, ChkSubtractPendingOrders, OBJPROP_STATE);
   Print("Subtract pending orders volume = ", SubtractPendingOrders);

   Trade = new CTrade;
   Trade.SetDeviationInPoints(MaxSlippage);
   if (MagicNumber > 0) Trade.SetExpertMagicNumber(MagicNumber);

	ENUM_SYMBOL_TRADE_EXECUTION Execution_Mode = (ENUM_SYMBOL_TRADE_EXECUTION)SymbolInfoInteger(Symbol(), SYMBOL_TRADE_EXEMODE);
	Print("Execution mode: ", EnumToString(Execution_Mode));

   if (SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE) == SYMBOL_FILLING_FOK)
   {
      Print("Order filling mode: Fill or Kill.");
      Trade.SetTypeFilling(ORDER_FILLING_FOK);
   }
   else if (SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE) == SYMBOL_FILLING_IOC)
   {
      Print("Order filling mode: Immediate or Cancel.");
      Trade.SetTypeFilling(ORDER_FILLING_IOC);
   }

	double existing_volume_buy = 0, existing_volume_sell = 0;
	if ((SubtractPendingOrders) || (SubtractPositions))
	{
	   CalculateOpenVolume(existing_volume_buy, existing_volume_sell);
	   Print("Found existing buy volume = ", DoubleToString(existing_volume_buy, ps_decimals));
	   Print("Found existing sell volume = ", DoubleToString(existing_volume_sell, ps_decimals));
	}

   if (entry_type == Pending)
   {
      // Sell
      if (sl > el)
      {
         // Stop
         if (el < Bid) ot = ORDER_TYPE_SELL_STOP;
         // Limit
         else ot = ORDER_TYPE_SELL_LIMIT;
      }
      // Buy
      else
      {
         // Stop
         if (el > Ask) ot = ORDER_TYPE_BUY_STOP;
         // Limit
         else ot = ORDER_TYPE_BUY_LIMIT;
      }

   	if ((SubtractPendingOrders) || (SubtractPositions))
   	{
   	   if ((ot == ORDER_TYPE_BUY_LIMIT) || (ot == ORDER_TYPE_BUY_STOP)) PositionSize -= existing_volume_buy;
   	   else PositionSize -= existing_volume_sell;
   	   Print("Adjusted position size = ", DoubleToString(PositionSize, 2));
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

      if (!Trade.OrderOpen(Symbol(), ot, PositionSize, 0, el, sl, tp, 0, 0, Commentary))
      {
         Print("Error sending order: ", Trade.ResultRetcodeDescription() + ".");
      }
      else Print("Order executed. Ticket: ", Trade.ResultOrder(), ".");
   }
   // Instant
   else
   {
      // Sell
      if (sl > el) ot = ORDER_TYPE_SELL;
      // Buy
      else ot = ORDER_TYPE_BUY;

	   double order_sl = sl;
	   double order_tp = tp;      
	
		// Market execution mode - preparation.
		if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant))
		{
			// No SL/TP allowed on instant orders.
			order_sl = 0;
			order_tp = 0;
		}

   	if ((SubtractPendingOrders) || (SubtractPositions))
   	{
   	   if (ot == ORDER_TYPE_BUY) PositionSize -= existing_volume_buy;
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

      if (!Trade.PositionOpen(Symbol(), ot, PositionSize, el, order_sl, order_tp, Commentary))
      {
         Print("Error sending order: ", Trade.ResultRetcodeDescription() + ".");
      }
      else
      {
      	MqlTradeResult result;
      	Trade.Result(result);
      	if ((Trade.ResultRetcode() != 10008) && (Trade.ResultRetcode() != 10009) && (Trade.ResultRetcode() != 10010))
      	{
      	   Print("Error opening a position. Return code: ", Trade.ResultRetcodeDescription());
      	   return;
      	}
      	
         Print("Initial return code: ", Trade.ResultRetcodeDescription());

         ulong order = result.order;
         Print("Order ID: ", order);

         ulong deal = result.deal;
         Print("Deal ID: ", deal);

			// Market execution mode - application of SL/TP.
			if ((Execution_Mode == SYMBOL_TRADE_EXECUTION_MARKET) && (entry_type == Instant))
			{
	   		// Not all brokers return deal.
	   		if (deal != 0)
	   		{
   	   		if (HistorySelect(TimeCurrent() - 60, TimeCurrent()))
   	   		{
   		   		if (HistoryDealSelect(deal))
   		   		{
   						long position = HistoryDealGetInteger(deal, DEAL_POSITION_ID);
   			      	Print("Position ID: ", position);
   		
   			      	if (!Trade.PositionModify(position, sl, tp)) Print("Error modifying position: ", GetLastError());
   			      	else Print("SL/TP applied successfully.");
   			      }
   			      else Print("Error selecting deal: ", GetLastError());
     			   }
   			   else Print("Error selecting deal history: ", GetLastError());
  			   }
			   // Wait for position to open then find it using the order ID.
			   else
			   {
			      // Run a waiting cycle until the order becomes a positoin.
			      for (int i = 0; i < 10; i++)
			      {
			         Print("Waiting...");
			         Sleep(1000);
			         if (PositionSelectByTicket(order)) break;
			      }
			      if (!PositionSelectByTicket(order)) Print("Error selecting position: ", GetLastError());
			      else
			      {
                  if (!Trade.PositionModify(order, sl, tp)) Print("Error modifying position: ", GetLastError());
			      	else Print("SL/TP applied successfully.");
			      }
			   }
			}
      }
   }

   delete Trade;
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
   if (SubtractPendingOrders)
   {
      int total = OrdersTotal();
      for (int i = 0; i < total; i++)
      {
         // Select an order.
         if (!OrderSelect(OrderGetTicket(i))) continue;
         // Skip orders with a different trading instrument.
         if (OrderGetString(ORDER_SYMBOL) != _Symbol) continue;
         // If magic number is given via PSC panel and order's magic number is different - skip.
         if ((MagicNumber != 0) && (OrderGetInteger(ORDER_MAGIC) != MagicNumber)) continue;

         // Buy orders
         if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_BUY_STOP)) volume_buy += OrderGetDouble(ORDER_VOLUME_CURRENT);
         // Sell orders
         else if ((OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_LIMIT) || (OrderGetInteger(ORDER_TYPE) == ORDER_TYPE_SELL_STOP)) volume_sell += OrderGetDouble(ORDER_VOLUME_CURRENT);
      }
   }

   if (SubtractPositions)
   {
      int total = PositionsTotal();
      for (int i = 0; i < total; i++)
      {
         // Works with hedging and netting.
         if (!PositionSelectByTicket(PositionGetTicket(i))) continue;
         // Skip positions with a different trading instrument.
         if (PositionGetString(POSITION_SYMBOL) != _Symbol) continue;
         // If magic number is given via PSC panel and position's magic number is different - skip.
         if ((MagicNumber != 0) && (PositionGetInteger(POSITION_MAGIC) != MagicNumber)) continue;

         // Long positions
         if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY) volume_buy += PositionGetDouble(POSITION_VOLUME);
         // Short positions
         else if (PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL) volume_sell += PositionGetDouble(POSITION_VOLUME);
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