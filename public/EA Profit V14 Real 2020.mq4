/*
   G e n e r a t e d  by ex4-to-mq4 decompiler FREEWARE 4.0.509.5
   Website: HT T P:// w W W.M e tAQ UOtes.Ne t
   E-mail :  SuP p ORt @ m E T aqu Ot eS .nEt
*/
#property copyright "Copyright 2017, Onlinemoneythai"
#property link      "http://www.onlinemoneythai.com"

extern string RunEAonTimeframe = "H4";
extern string Productskey = "V14R-Al22-EDFG-POLM-FRED-BN56";
extern string Products = "EA Profit V14 Real";
extern int MagicNumber = 1556;
extern string SettingeaComment = "Set eaComment";
extern bool eaComment = TRUE;
extern string OptionOrder = "SetOptionOrder";
extern bool OderBuy = TRUE;
extern bool OderSell = TRUE;
extern string SettingOrder = "SettingOrder";
extern double Lots = 0.01;
extern int StopLoss = 50;
extern int TakeProfit = 25;
extern int TrailingStop = 0;
extern int MaxOrder = 1;
extern double LotExponent = 3.0;
extern double Maxlot = 99.0;
extern string SetEMA = "Set Moving Average ";
extern int PeriodEMA = 3;
extern string BreakEven = "Set BreakEvenPoint";
extern bool UseBreakEven = FALSE;
extern int Break_Even_After_X_Pips = 25;
extern int XpipsAboveBE = 20;
extern string MoneyManagement = "AutoMoneyManagement";
extern bool AutoMoneyManagement = FALSE;
extern double PercentToRisk = 1.0;
extern double PercentSafety = 100.0;
string Gs_unused_240 = "Spread&Bar";

// E37F0136AA3FFAF149B351F6A4C948E9
int init() {
   if (Digits == 5) {
      Break_Even_After_X_Pips = 10 * Break_Even_After_X_Pips;
      XpipsAboveBE = 10 * XpipsAboveBE;
      TrailingStop = 10 * TrailingStop;
      TakeProfit = 10 * TakeProfit;
      StopLoss = 10 * StopLoss;
   }
   return (0);
}

// EA2B2676C28C0DB26D39331A336C6B92
int start() {
   double Ld_0;
   double bid_8;
   double ima_16;
   double order_lots_24;
   double order_profit_32;
   double lots_40;
   if (Productskey != "V14R-Al22-EDFG-POLM-FRED-BN56") Comment("\n ERROR :: Invalid Productskey !");
   if (Productskey != "V14R-Al22-EDFG-POLM-FRED-BN56") return (0);
   if (Year() > 2020) Comment("\n ERROR :: EA Expire Please Update New Version !");
   if (Year() > 2020) return (0);
   if (Period() != PERIOD_H4) Comment("\n ERROR :: Invalid Timeframe, Please Switch to H4 !");
   if (Period() != PERIOD_H4) return (0);
   if (eaComment == TRUE) f0_1();
   f0_2();
   f0_0();
   if (OrdersTotal() < MaxOrder) {
      Ld_0 = PercentToRisk / 1000.0;
      if (AutoMoneyManagement) Lots = NormalizeDouble(AccountBalance() * Ld_0 / PercentSafety / MarketInfo(Symbol(), MODE_TICKVALUE), 2);
      if (Lots > Maxlot) Lots = Maxlot;
      bid_8 = Bid;
      ima_16 = iMA(NULL, 0, PeriodEMA, 0, MODE_EMA, PRICE_CLOSE, 0);
      OrderSelect(OrdersHistoryTotal() - 1, SELECT_BY_POS, MODE_HISTORY);
      order_lots_24 = OrderLots();
      order_profit_32 = OrderProfit();
      lots_40 = order_lots_24 * LotExponent;
      if (order_profit_32 < 0.0 && lots_40 < Maxlot) {
         if (OderSell == TRUE && ima_16 > bid_8) OrderSend(Symbol(), OP_SELL, lots_40, Bid, 3, Bid + Point * StopLoss, Bid - Point * TakeProfit, "EA-PO-V14 Real", MagicNumber, 0, Red);
         if (OderBuy == TRUE && ima_16 < bid_8) OrderSend(Symbol(), OP_BUY, lots_40, Ask, 3, Ask - Point * StopLoss, Ask + Point * TakeProfit, "EA-PO-V14 Real", MagicNumber, 0, Green);
      } else {
         if (OderSell == TRUE && ima_16 > bid_8) OrderSend(Symbol(), OP_SELL, Lots, Bid, 3, Bid + Point * StopLoss, Bid - Point * TakeProfit, "EA-PO-V14 Real", MagicNumber, 0, Red);
         if (OderBuy == TRUE && ima_16 < bid_8) OrderSend(Symbol(), OP_BUY, Lots, Ask, 3, Ask - Point * StopLoss, Ask + Point * TakeProfit, "EA-PO-V14 Real", MagicNumber, 0, Green);
      }
   }
   return (0);
}

// 3AB2799732588E34138D987B460B8019
void f0_0() {
   for (int pos_0 = 0; pos_0 < OrdersTotal(); pos_0++) {
      OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() == OP_BUY) {
         if (TrailingStop > 0) {
            if (Bid - OrderOpenPrice() > TrailingStop * Point)
               if (OrderStopLoss() == 0.0 || Bid - OrderStopLoss() > TrailingStop * Point) OrderModify(OrderTicket(), OrderOpenPrice(), Bid - TrailingStop * Point, OrderTakeProfit(), 0, Blue);
         }
      }
      if (OrderType() == OP_SELL) {
         if (TrailingStop > 0) {
            if (OrderOpenPrice() - Ask > TrailingStop * Point)
               if (OrderStopLoss() == 0.0 || OrderStopLoss() - Ask > TrailingStop * Point) OrderModify(OrderTicket(), OrderOpenPrice(), Ask + TrailingStop * Point, OrderTakeProfit(), 0, Red);
         }
      }
   }
}

// ECA0C6738B65E9F87506B97B27E56358
void f0_2() {
   for (int pos_4 = 0; pos_4 < OrdersTotal(); pos_4++) {
      if (UseBreakEven == TRUE) {
         OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES);
         if ((OrderProfit() - OrderCommission()) / OrderLots() / MarketInfo(OrderSymbol(), MODE_TICKVALUE) >= Break_Even_After_X_Pips) {
            if (OrderType() == OP_SELL) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() - XpipsAboveBE * Point, OrderTakeProfit(), 0, Red);
            if (OrderType() == OP_BUY) OrderModify(OrderTicket(), OrderOpenPrice(), OrderOpenPrice() + XpipsAboveBE * Point, OrderTakeProfit(), 0, Blue);
         }
      }
   }
}

// BD787A2F340C4AC21BA083035209F751
void f0_1() {
   int spread_0 = MarketInfo(Symbol(), MODE_SPREAD);
   ObjectCreate("EAname", OBJ_LABEL, 0, 0, 0);
   ObjectSet("EAname", OBJPROP_CORNER, 1);
   ObjectSet("EAname", OBJPROP_XDISTANCE, 20);
   ObjectSet("EAname", OBJPROP_YDISTANCE, 20);
   ObjectSetText("EAname", "EA Profit V14 Real" + "(" + Symbol() + ")", 30, "Browallia New", Gold);
   ObjectCreate("klc20", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc20", "Forex Server :: " + AccountServer(), 16, "Browallia New", Gold);
   ObjectSet("klc20", OBJPROP_CORNER, 1);
   ObjectSet("klc20", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc20", OBJPROP_YDISTANCE, 60);
   ObjectCreate("klc19", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc19", "AccountNumber :: " + AccountNumber(), 16, "Browallia New", Gold);
   ObjectSet("klc19", OBJPROP_CORNER, 1);
   ObjectSet("klc19", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc19", OBJPROP_YDISTANCE, 80);
   ObjectCreate("klc21", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc21", "Lots :: " + DoubleToStr(Lots, 2), 16, "Browallia New", Gold);
   ObjectSet("klc21", OBJPROP_CORNER, 1);
   ObjectSet("klc21", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc21", OBJPROP_YDISTANCE, 100);
   ObjectCreate("klc22", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc22", "Balance :: " + DoubleToStr(AccountBalance(), 2), 16, "Browallia New", Gold);
   ObjectSet("klc22", OBJPROP_CORNER, 1);
   ObjectSet("klc22", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc22", OBJPROP_YDISTANCE, 120);
   ObjectCreate("klc23", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc23", "Equity :: " + DoubleToStr(AccountEquity(), 2), 16, "Browallia New", Gold);
   ObjectSet("klc23", OBJPROP_CORNER, 1);
   ObjectSet("klc23", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc23", OBJPROP_YDISTANCE, 140);
   ObjectCreate("klc24", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc24", "TotalProfit :: " + DoubleToStr(AccountProfit(), 2), 16, "Browallia New", Gold);
   ObjectSet("klc24", OBJPROP_CORNER, 1);
   ObjectSet("klc24", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc24", OBJPROP_YDISTANCE, 160);
   ObjectCreate("klc27", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc27", "OrdersTotal :: " + OrdersTotal(), 16, "Browallia New", Gold);
   ObjectSet("klc27", OBJPROP_CORNER, 1);
   ObjectSet("klc27", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc27", OBJPROP_YDISTANCE, 180);
   ObjectCreate("klc29", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc29", "DayOfWeek :: " + DayOfWeek(), 16, "Browallia New", Gold);
   ObjectSet("klc29", OBJPROP_CORNER, 1);
   ObjectSet("klc29", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc29", OBJPROP_YDISTANCE, 200);
   ObjectCreate("klc26", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc26", "Timeserver :: " + TimeToStr(TimeCurrent(), TIME_DATE|TIME_MINUTES), 16, "Browallia New", Gold);
   ObjectSet("klc26", OBJPROP_CORNER, 1);
   ObjectSet("klc26", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc26", OBJPROP_YDISTANCE, 220);
   ObjectCreate("klc30", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc30", "EA Expireyear :: " + 2020, 16, "Browallia New", Gold);
   ObjectSet("klc30", OBJPROP_CORNER, 1);
   ObjectSet("klc30", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc30", OBJPROP_YDISTANCE, 240);
   ObjectCreate("klc31", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc31", "EA Productskey :: " + Productskey, 16, "Browallia New", Gold);
   ObjectSet("klc31", OBJPROP_CORNER, 1);
   ObjectSet("klc31", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc31", OBJPROP_YDISTANCE, 260);
   ObjectCreate("klc32", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc32", "" + "Copyright © 2017 onlinemoneythai.com", 16, "Browallia New", Gold);
   ObjectSet("klc32", OBJPROP_CORNER, 1);
   ObjectSet("klc32", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc32", OBJPROP_YDISTANCE, 280);
   ObjectCreate("klc28", OBJ_LABEL, 0, 0, 0);
   ObjectSetText("klc28", "SPREAD :: " + Symbol() + " = " + DoubleToStr(spread_0, 0), 16, "Browallia New", Gold);
   ObjectSet("klc28", OBJPROP_CORNER, 1);
   ObjectSet("klc28", OBJPROP_XDISTANCE, 10);
   ObjectSet("klc28", OBJPROP_YDISTANCE, 300);
}
