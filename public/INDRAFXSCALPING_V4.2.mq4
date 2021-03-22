#property copyright "Copyright © 2008, IndrafxScalping V4.2"
#property link      "http://mediacakrawala.com"

extern int MaxTrades = 8;
extern int Pips = 20;
extern double TakeProfit = 23.0;
extern double TrailingStop = 15.0;
extern double InitialStop = 0.0;
extern bool RunNonStop = FALSE;
extern string Note1 = "Valid TimeFrames: 60";
extern int MACDTimeFrame = 60;
extern bool MoneyManagement1 = FALSE;
extern string Note2 = "Use MoneyManagement1 for Micro cent and Standard";
extern bool MoneyManagement2 = FALSE;
extern string Note3 = "Use MoneyManagement2 for Mini start 0.01 Lot";
extern string nameEA = "IndrafxScalping V4.2";
int gi_156 = 10;
int gi_160 = 10;
int gi_164 = 15;
int gi_168 = 20;
int gi_172 = 25;
int gi_176 = 30;
int gi_180 = 35;
int gi_184 = 40;
int gi_188 = 45;
int gi_192 = 50;
int gi_196 = 0;
int gi_200 = 8;
int gi_204 = 0;
extern double FirstOrderLots = 0.1;
int g_count_216 = 0;
int g_pos_220 = 0;
double g_lots_224 = 0.1;
int g_slippage_232 = 3;
double g_price_236 = 0.0;
double g_price_244 = 0.0;
double g_ask_252 = 0.0;
double g_bid_260 = 0.0;
double gd_268 = 0.0;
int g_cmd_276 = OP_BUY;
int gi_280 = 0;
bool gi_284 = TRUE;
double g_ord_open_price_288 = 0.0;
int gi_296 = 0;
double gd_300 = 0.0;
int g_ticket_308 = 0;
int gi_312 = 0;
double g_price_316 = 0.0;
double g_ord_lots_324 = 0.0;
double g_tickvalue_332 = 0.0;
string gs_unused_340 = "";
string gs_348 = "";
double gd_356 = 0.0;
double gd_364 = 12.0;
double gd_372 = 0.0;

int init() {
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   if (MoneyManagement1 == TRUE) {
      if (AccountBalance() > 40000.0) FirstOrderLots = 0.2;
      if (AccountBalance() < 20000.0) FirstOrderLots = 0.1;
      if (AccountBalance() > 80000.0) FirstOrderLots = 0.3;
      if (AccountBalance() > 120000.0) FirstOrderLots = 0.4;
      if (AccountBalance() > 150000.0) FirstOrderLots = 0.5;
   }
   if (MoneyManagement2 == TRUE) {
      if (AccountBalance() < 2000.0) FirstOrderLots = 0.01;
      if (AccountBalance() > 4000.0) FirstOrderLots = 0.02;
      if (AccountBalance() > 8000.0) FirstOrderLots = 0.03;
   }
   if (gd_372 == 1.0) {
      if (gd_356 != 0.0) gd_268 = MathCeil(AccountBalance() * gd_364 / 10000.0);
      else gd_268 = g_lots_224;
   } else {
      if (gd_356 != 0.0) gd_268 = MathCeil(AccountBalance() * gd_364 / 10000.0) / 10.0;
      else gd_268 = g_lots_224;
   }
   gd_268 = FirstOrderLots;
   if (gd_268 > 100.0) gd_268 = 100;
   if (gd_268 < 0.01) gd_268 = 0.1;
   g_count_216 = 0;
   for (g_pos_220 = 0; g_pos_220 < OrdersTotal(); g_pos_220++) {
      OrderSelect(g_pos_220, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) g_count_216++;
   }
   g_tickvalue_332 = MarketInfo(Symbol(), MODE_TICKVALUE);
   if (g_tickvalue_332 == 0.0) g_tickvalue_332 = 5;
   if (gi_296 > g_count_216) {
      for (g_pos_220 = OrdersTotal(); g_pos_220 >= 0; g_pos_220--) {
         OrderSelect(g_pos_220, SELECT_BY_POS, MODE_TRADES);
         g_cmd_276 = OrderType();
         if (OrderSymbol() == Symbol()) {
            if (g_cmd_276 == OP_BUY) OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), g_slippage_232, Blue);
            if (g_cmd_276 == OP_SELL) OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), g_slippage_232, Red);
            return (0);
         }
      }
   }
   gi_296 = g_count_216;
   if (g_count_216 >= MaxTrades) gi_284 = FALSE;
   else gi_284 = TRUE;
   if (g_ord_open_price_288 == 0.0) {
      for (g_pos_220 = 0; g_pos_220 < OrdersTotal(); g_pos_220++) {
         OrderSelect(g_pos_220, SELECT_BY_POS, MODE_TRADES);
         g_cmd_276 = OrderType();
         if (OrderSymbol() == Symbol()) {
            g_ord_open_price_288 = OrderOpenPrice();
            if (g_cmd_276 == OP_BUY) gi_280 = 2;
            if (g_cmd_276 == OP_SELL) gi_280 = 1;
         }
      }
   }
   if (g_count_216 < 1) {
      if (RunNonStop == TRUE && Hour() >= 0) {
         Comment("OPEN TRADE RUNNING 24 HOURS", "  ", "SERVER TIME", ": ", Hour(), ":", Minute(), "  ", "BALANCE", " :", AccountCurrency(), " ", AccountBalance(), "  ", "FLOATING P/L", " :", AccountCurrency(), " ", AccountProfit(), " ", "PAIR", ":", Symbol(), " ", "P/L Percent", " : ", 100.0 * (AccountProfit() / AccountBalance()), "%", 
            "\n", 
            "\n", 
            "\n", 
            "\n", 
            "\n", 
            "\n                                            USE INDRAFXSCALPING V4.2 ONLY USD/JPY TimeFrame H1", 
            "\n", 
            "\n                                           REGISTRASI ACCOUNT : ", AccountName(), "  ", AccountNumber(), "  ", 
         "\n                                           BROKER :", " ", AccountCompany(), "  ", "SERVER :", " ", AccountServer());
         gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 2;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 1;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) == iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iStochastic(NULL, PERIOD_H4, 7, 3, 1, MODE_SMA, 20, MODE_MAIN, 0) > iStochastic(NULL, 0, 7, 3, 1, MODE_SMA, 80, MODE_MAIN, 1)) gi_280 = 2;
         if (iStochastic(NULL, PERIOD_H4, 7, 3, 1, MODE_SMA, 20, MODE_MAIN, 0) < iStochastic(NULL, 0, 7, 3, 1, MODE_SMA, 80, MODE_MAIN, 1)) gi_280 = 1;
         if (iHigh(NULL, 0, 0) > iLow(NULL, 0, 0)) gi_280 = 2;
         if (iHigh(NULL, 0, 0) < iLow(NULL, 0, 0)) gi_280 = 1;
         if (iSAR(NULL, 0, 0.009, 0.2, 0) > iSAR(NULL, 0, 0.009, 0.2, 1)) gi_280 = 2;
         if (iSAR(NULL, 0, 0.009, 0.2, 0) < iSAR(NULL, 0, 0.009, 0.2, 1)) gi_280 = 1;
         if (gi_204 == 1) {
            if (gi_280 == 1) gi_280 = 2;
            else
               if (gi_280 == 2) gi_280 = 1;
         }
      }
   }
   if (g_count_216 < 1) {
      if (RunNonStop == FALSE && Hour() >= 0) {
         Comment("OPEN TRADE IN ASIA MARKET TIME", "  ", "SERVER TIME", ": ", Hour(), ":", Minute(), "  ", "BALANCE", " :", AccountCurrency(), " ", AccountBalance(), "  ", "FLOATING P/L", " :", AccountCurrency(), " ", AccountProfit(), " ", "PAIR", ":", Symbol(), " ", "P/L Percent", " : ", 100.0 * (AccountProfit() / AccountBalance()), "%", 
            "\n", 
            "\n", 
            "\n", 
            "\n", 
            "\n", 
            "\n                                            USE INDRAFXSCALPING V4.2 ONLY USD/JPY TimeFrame H1", 
            "\n                                           REGISTRASI ACCOUNT : ", AccountName(), "  ", AccountNumber(), "  ", 
         "\n                                           BROKER :", " ", AccountCompany(), "  ", "SERVER :", " ", AccountServer());
         gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 2;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 1;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) == iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iStochastic(NULL, PERIOD_H4, 7, 3, 1, MODE_SMA, 20, MODE_MAIN, 0) > iStochastic(NULL, 0, 7, 3, 1, MODE_SMA, 80, MODE_MAIN, 1)) gi_280 = 2;
         if (iStochastic(NULL, PERIOD_H4, 7, 3, 1, MODE_SMA, 20, MODE_MAIN, 0) < iStochastic(NULL, 0, 7, 3, 1, MODE_SMA, 80, MODE_MAIN, 1)) gi_280 = 1;
         if (iHigh(NULL, 0, 0) > iLow(NULL, 0, 0)) gi_280 = 2;
         if (iHigh(NULL, 0, 0) < iLow(NULL, 0, 0)) gi_280 = 1;
         if (iSAR(NULL, 0, 0.009, 0.2, 0) > iSAR(NULL, 0, 0.009, 0.2, 1)) gi_280 = 2;
         if (iSAR(NULL, 0, 0.009, 0.2, 0) < iSAR(NULL, 0, 0.009, 0.2, 1)) gi_280 = 1;
         if (gi_204 == 1) {
            if (gi_280 == 1) gi_280 = 2;
            else
               if (gi_280 == 2) gi_280 = 1;
         }
      }
   }
   if (g_count_216 < 1) {
      if (RunNonStop == FALSE && Hour() >= 8) {
         Comment("CLOSE TRADE IN OPEN EUROPA MARKET & NEWS TIME", " ", "PAIR", ":", Symbol(), "  ", "Floating  :", AccountCurrency(), "  ", AccountProfit(), "  ", "Balance", " :", AccountCurrency(), " ", AccountBalance(), "  ", "Server Time", " : ", Hour(), ":", Minute(), " ", "P/L Percent", " : ", 100.0 * (AccountProfit() / AccountBalance()), "%", 
            "\n", 
         "\n                                           EA INDRAFXSCALPING V4.2 WILL RUNNING AGAIN AFTER NEWS");
         gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) == iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (gi_204 == 1) {
            if (gi_280 == 1) gi_280 = 2;
            else
               if (gi_280 == 2) gi_280 = 1;
         }
      }
   }
   if (g_count_216 < 1) {
      if (RunNonStop == FALSE && Hour() >= 12) {
         Comment("OPEN TRADE IN EUROPA MARKET TIME", "  ", "SERVER TIME", ": ", Hour(), ":", Minute(), "  ", "BALANCE", " :", AccountCurrency(), " ", AccountBalance(), "  ", "FLOATING P/L", " :", AccountCurrency(), " ", AccountProfit(), " ", "PAIR", ":", Symbol(), " ", "P/L Percent", " : ", 100.0 * (AccountProfit() / AccountBalance()), "%", 
            "\n", 
            "\n", 
            "\n", 
            "\n", 
            "\n", 
            "\n                                           USE INDRAFXSCALPING V4.2 ONLY USD/JPY TimeFrame H1", 
            "\n", 
            "\n                                           REGISTRASI ACCOUNT : ", AccountName(), "  ", AccountNumber(), "  ", 
         "\n                                           BROKER :", " ", AccountCompany(), "  ", "SERVER :", " ", AccountServer());
         gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 2;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 1;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) == iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iStochastic(NULL, PERIOD_H4, 7, 3, 1, MODE_SMA, 20, MODE_MAIN, 0) > iStochastic(NULL, 0, 7, 3, 1, MODE_SMA, 80, MODE_MAIN, 1)) gi_280 = 2;
         if (iStochastic(NULL, PERIOD_H4, 7, 3, 1, MODE_SMA, 20, MODE_MAIN, 0) < iStochastic(NULL, 0, 7, 3, 1, MODE_SMA, 80, MODE_MAIN, 1)) gi_280 = 1;
         if (iHigh(NULL, 0, 0) > iLow(NULL, 0, 0)) gi_280 = 2;
         if (iHigh(NULL, 0, 0) < iLow(NULL, 0, 0)) gi_280 = 1;
         if (iSAR(NULL, 0, 0.009, 0.2, 0) > iSAR(NULL, 0, 0.009, 0.2, 1)) gi_280 = 2;
         if (iSAR(NULL, 0, 0.009, 0.2, 0) < iSAR(NULL, 0, 0.009, 0.2, 1)) gi_280 = 1;
         if (gi_204 == 1) {
            if (gi_280 == 1) gi_280 = 2;
            else
               if (gi_280 == 2) gi_280 = 1;
         }
      }
   }
   if (g_count_216 < 1) {
      if (RunNonStop == FALSE && Hour() >= 13) {
         Comment("CLOSE TRADE IN OPEN USA MARKET & NEWS TIME", " ", "PAIR", ":", Symbol(), "  ", "Floating  :", AccountCurrency(), "  ", AccountProfit(), "  ", "Balance", " :", AccountCurrency(), " ", AccountBalance(), "  ", "Server Time", " : ", Hour(), ":", Minute(), " ", "P/L Percent", " : ", 100.0 * (AccountProfit() / AccountBalance()), "%", 
            "\n", 
         "\n                                           EA INDRAFXSCALPING V4.2 WILL RUNNING AGAIN AFTER NEWS");
         gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) == iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (gi_204 == 1) {
            if (gi_280 == 1) gi_280 = 2;
            else
               if (gi_280 == 2) gi_280 = 1;
         }
      }
   }
   if (g_count_216 < 1) {
      if (RunNonStop == FALSE && Hour() >= 18) {
         Comment("OPEN TRADE IN USA MARKET TIME", "  ", "SERVER TIME", ": ", Hour(), ":", Minute(), "  ", "BALANCE", " :", AccountCurrency(), " ", AccountBalance(), "  ", "FLOATING P/L", " :", AccountCurrency(), " ", AccountProfit(), " ", "PAIR", ":", Symbol(), " ", "P/L Percent", " : ", 100.0 * (AccountProfit() / AccountBalance()), "%", 
            "\n", 
            "\n", 
            "\n", 
            "\n", 
            "\n", 
            "\n                                           USE INDRAFXSCALPING V4.2 ONLY USD/JPY TimeFrame H1", 
            "\n", 
            "\n                                           REGISTRASI ACCOUNT : ", AccountName(), "  ", AccountNumber(), "  ", 
         "\n                                           BROKER :", " ", AccountCompany(), "  ", "SERVER :", " ", AccountServer());
         gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 2;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 1;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) == iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iStochastic(NULL, PERIOD_H4, 7, 3, 1, MODE_SMA, 20, MODE_MAIN, 0) > iStochastic(NULL, 0, 7, 3, 1, MODE_SMA, 80, MODE_MAIN, 1)) gi_280 = 2;
         if (iStochastic(NULL, PERIOD_H4, 7, 3, 1, MODE_SMA, 20, MODE_MAIN, 0) < iStochastic(NULL, 0, 7, 3, 1, MODE_SMA, 80, MODE_MAIN, 1)) gi_280 = 1;
         if (iHigh(NULL, 0, 0) > iLow(NULL, 0, 0)) gi_280 = 2;
         if (iHigh(NULL, 0, 0) < iLow(NULL, 0, 0)) gi_280 = 1;
         if (iSAR(NULL, 0, 0.009, 0.2, 0) > iSAR(NULL, 0, 0.009, 0.2, 1)) gi_280 = 2;
         if (iSAR(NULL, 0, 0.009, 0.2, 0) < iSAR(NULL, 0, 0.009, 0.2, 1)) gi_280 = 1;
         if (gi_204 == 1) {
            if (gi_280 == 1) gi_280 = 2;
            else
               if (gi_280 == 2) gi_280 = 1;
         }
      }
   }
   if (g_count_216 < 1) {
      if (DayOfWeek() == 5 && Hour() >= 13) {
         Comment("CLOSE TRADE ON FRIDAY", " ", "PAIR", ":", Symbol(), "  ", "Floating  :", AccountCurrency(), "  ", AccountProfit(), "  ", "Balance", " :", AccountCurrency(), " ", AccountBalance(), "  ", "Server Time", " : ", Hour(), ":", Minute(), " ", "P/L Percent", " : ", 100.0 * (AccountProfit() / AccountBalance()), "%", 
            "\n", 
         "\n                                           EA INDRAFXSCALPING V4.2 WILL RUNNING AGAIN AT MONDAY");
         gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) > iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) < iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (iMACD(NULL, MACDTimeFrame, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 0) == iMACD(NULL, 0, 14, 26, 9, PRICE_CLOSE, MODE_MAIN, 1)) gi_280 = 3;
         if (gi_204 == 1) {
            if (gi_280 == 1) gi_280 = 2;
            else
               if (gi_280 == 2) gi_280 = 1;
         }
      }
   }
   for (g_pos_220 = OrdersTotal(); g_pos_220 >= 0; g_pos_220--) {
      OrderSelect(g_pos_220, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderType() == OP_SELL) {
            if (TrailingStop > 0.0) {
               if (OrderOpenPrice() - Ask >= (TrailingStop + Pips) * Point) {
                  if (OrderStopLoss() > Ask + Point * TrailingStop) {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Ask + Point * TrailingStop, OrderClosePrice() - TakeProfit * Point - TrailingStop * Point, 800, Purple);
                     return (0);
                  }
               }
            }
         }
         if (OrderType() == OP_BUY) {
            if (TrailingStop > 0.0) {
               if (Bid - OrderOpenPrice() >= (TrailingStop + Pips) * Point) {
                  if (OrderStopLoss() < Bid - Point * TrailingStop) {
                     OrderModify(OrderTicket(), OrderOpenPrice(), Bid - Point * TrailingStop, OrderClosePrice() + TakeProfit * Point + TrailingStop * Point, 800, Yellow);
                     return (0);
                  }
               }
            }
         }
      }
   }
   gd_300 = 0;
   g_ticket_308 = 0;
   gi_312 = FALSE;
   g_price_316 = 0;
   g_ord_lots_324 = 0;
   for (g_pos_220 = 0; g_pos_220 < OrdersTotal(); g_pos_220++) {
      OrderSelect(g_pos_220, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         g_ticket_308 = OrderTicket();
         if (OrderType() == OP_BUY) gi_312 = FALSE;
         if (OrderType() == OP_SELL) gi_312 = TRUE;
         g_price_316 = OrderClosePrice();
         g_ord_lots_324 = OrderLots();
         if (gi_312 == FALSE) {
            if (OrderClosePrice() < OrderOpenPrice()) gd_300 -= (OrderOpenPrice() - OrderClosePrice()) * OrderLots() / Point;
            if (OrderClosePrice() > OrderOpenPrice()) gd_300 += (OrderClosePrice() - OrderOpenPrice()) * OrderLots() / Point;
         }
         if (gi_312 == TRUE) {
            if (OrderClosePrice() > OrderOpenPrice()) gd_300 -= (OrderClosePrice() - OrderOpenPrice()) * OrderLots() / Point;
            if (OrderClosePrice() < OrderOpenPrice()) gd_300 += (OrderOpenPrice() - OrderClosePrice()) * OrderLots() / Point;
         }
      }
   }
   gd_300 *= g_tickvalue_332;
   gs_348 = "Profit: $" + DoubleToStr(gd_300, 2) + " +/-";
   if (g_count_216 >= MaxTrades - gi_200 && gi_196 == 1) {
      if (gd_300 >= gi_156) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_160) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_164) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_168) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_172) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_176) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_180) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_184) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_188) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
      }
      if (gd_300 >= gi_192) {
         OrderClose(g_ticket_308, g_ord_lots_324, g_price_316, g_slippage_232, Yellow);
         gi_284 = FALSE;
         return (0);
      }
   }
   if (!IsTesting())
      if (gi_280 == 3) gs_unused_340 = "                         ";
   if (gi_280 == 1 && gi_284) {
      if (Bid - g_ord_open_price_288 >= Pips * Point || g_count_216 < 1) {
         g_bid_260 = Bid;
         g_ord_open_price_288 = 0;
         if (TakeProfit == 0.0) g_price_244 = 0;
         else g_price_244 = g_bid_260 - TakeProfit * Point;
         if (InitialStop == 0.0) g_price_236 = 0;
         else g_price_236 = g_bid_260 + InitialStop * Point;
         if (g_count_216 != 0) {
            g_lots_224 = gd_268;
            for (g_pos_220 = 1; g_pos_220 <= g_count_216; g_pos_220++) {
               if (MaxTrades > 12) g_lots_224 = NormalizeDouble(1.5 * g_lots_224, 2);
               else g_lots_224 = NormalizeDouble(2.0 * g_lots_224, 2);
            }
         } else g_lots_224 = gd_268;
         if (g_lots_224 > 100.0) g_lots_224 = 100;
         OrderSend(Symbol(), OP_SELL, g_lots_224, g_bid_260, g_slippage_232, g_price_236, g_price_244, "Indrafxs-SELL", 0, 0, Red);
         return (0);
      }
   }
   if (gi_280 == 2 && gi_284) {
      if (g_ord_open_price_288 - Ask >= Pips * Point || g_count_216 < 1) {
         g_ask_252 = Ask;
         g_ord_open_price_288 = 0;
         if (TakeProfit == 0.0) g_price_244 = 0;
         else g_price_244 = g_ask_252 + TakeProfit * Point;
         if (InitialStop == 0.0) g_price_236 = 0;
         else g_price_236 = g_ask_252 - InitialStop * Point;
         if (g_count_216 != 0) {
            g_lots_224 = gd_268;
            for (g_pos_220 = 1; g_pos_220 <= g_count_216; g_pos_220++) {
               if (MaxTrades > 12) g_lots_224 = NormalizeDouble(1.5 * g_lots_224, 2);
               else g_lots_224 = NormalizeDouble(2.0 * g_lots_224, 2);
            }
         } else g_lots_224 = gd_268;
         if (g_lots_224 > 100.0) g_lots_224 = 100;
         OrderSend(Symbol(), OP_BUY, g_lots_224, g_ask_252, g_slippage_232, g_price_236, g_price_244, "Indrafxs-Buy", 0, 0, Blue);
         return (0);
      }
   }
   return (0);
}