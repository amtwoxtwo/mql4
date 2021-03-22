#property copyright "Copyright © 2009, Eracash.com"
#property link      "http://www.eracash.com"
#property show_inputs

int Gi_76 = 1;
bool Gi_80 = FALSE;
bool Gi_84 = TRUE;
double Gd_88 = 1.2;
double G_slippage_96 = 5.0;
extern double Lots = 0.01;
double Gd_112 = 1.0;
extern double TakeProfit = 13.0;
double G_pips_128 = 0.0;
double Gd_136 = 3.0;
double Gd_144 = 3.0;
extern double Step = 10.0;
extern int MaxTrades = 20;
extern bool Buy = TRUE;
extern bool Sell = FALSE;
extern bool Trailing = FALSE;
bool Gi_176 = FALSE;
double Gd_180 = 20.0;
bool Gi_188 = TRUE;
bool Gi_192 = FALSE;
double Gd_196 = 0.0;
bool Gi_204 = FALSE;
extern bool UseHourTrade = FALSE;
extern int StartHour = 0;
extern int EndHour = 8;
extern int MagicNumber = 12324;
double G_price_224;
double Gd_232;
double Gd_unused_240;
double Gd_unused_248;
double G_price_256;
double G_bid_264;
double G_ask_272;
double Gd_280;
double Gd_288;
double Gd_296;
bool Gi_304;
string Gs_308 = "";
datetime G_time_316 = 0;
int Gi_320;
int Gi_324 = 0;
double Gd_328;
int G_pos_336 = 0;
int Gi_340;
double Gd_344 = 0.0;
bool Gi_352 = FALSE;
bool Gi_356 = FALSE;
bool Gi_360 = FALSE;
int Gi_364;
bool Gi_368 = FALSE;
int G_datetime_372 = 0;
int G_datetime_376 = 0;
double Gd_380;
double Gd_388;
double point;

int init() {
   Gd_296 = MarketInfo(Symbol(), MODE_SPREAD) * Point;
   if (IsTesting() == TRUE) f0_8();
   if (IsTesting() == FALSE) f0_8();
   if(Digits==3 || Digits==5) point=10*Point;
  else point=Point;
   return (0);
}


int deinit() {
   return (0);
}


int start() {
   double order_lots_0;
   double order_lots_8;
   double iclose_16;
   double iclose_24;
   if (UseHourTrade) {
      if (!Hour() >= StartHour && Hour() <= EndHour) {
         f0_3();
         Comment("Non-Trading Hours!");
         return (0);
      }
   }
   string Ls_32 = "false";
   string Ls_40 = "false";
   if (Gi_204 == FALSE || (Gi_204 && (EndHour > StartHour && (Hour() >= StartHour && Hour() <= EndHour)) || (StartHour > EndHour && (!Hour() >= EndHour && Hour() <= StartHour)))) Ls_32 = "true";
   if (Gi_204 && (EndHour > StartHour && (!Hour() >= StartHour && Hour() <= EndHour)) || (StartHour > EndHour && (Hour() >= EndHour && Hour() <= StartHour))) Ls_40 = "true";
   if (Trailing == TRUE)
      if (Gi_188) f0_15(Gd_136, Gd_144, G_price_256);
   if (Gi_192) {
      if (TimeCurrent() >= Gi_320) {
         f0_3();
         Print("Closed All due to TimeOut");
      }
   }
   if (G_time_316 == Time[0]) return (0);
   G_time_316 = Time[0];
   double Ld_48 = f0_5();
   if (Gi_176) {
      if (Ld_48 < 0.0 && MathAbs(Ld_48) > Gd_180 / 100.0 * f0_7()) {
         f0_3();
         Print("Closed All due to Stop Out");
         Gi_368 = FALSE;
      }
   }
   Gi_340 = f0_13();
   if (Gi_340 == 0) Gi_304 = FALSE;
   for (G_pos_336 = OrdersTotal() - 1; G_pos_336 >= 0; G_pos_336--) {
      OrderSelect(G_pos_336, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY) {
            Gi_356 = TRUE;
            Gi_360 = FALSE;
            order_lots_0 = OrderLots();
            break;
         }
      }
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_SELL) {
            Gi_356 = FALSE;
            Gi_360 = TRUE;
            order_lots_8 = OrderLots();
            break;
         }
      }
   }
   if (Gi_340 > 0 && Gi_340 <= MaxTrades) {
      RefreshRates();
      Gd_280 = f0_2();
      Gd_288 = f0_6();
      if (Gi_356 && Gd_280 - Ask >= Step * point) Gi_352 = TRUE;
      if (Gi_360 && Bid - Gd_288 >= Step * point) Gi_352 = TRUE;
   }
   if (Gi_340 < 1) {
      Gi_360 = FALSE;
      Gi_356 = FALSE;
      Gi_352 = TRUE;
      Gd_232 = AccountEquity();
   }
   if (Gi_352) {
      Gd_280 = f0_2();
      Gd_288 = f0_6();
      if (Gi_360) {
         if (Gi_80 || Ls_40 == "true") {
            f0_1(0, 1);
            Gd_328 = NormalizeDouble(Gd_88 * order_lots_8, Gd_112);
         } else Gd_328 = f0_11(OP_SELL);
         if (Gi_84 && Ls_32 == "true") {
            Gi_324 = Gi_340;
            if (Gd_328 > 0.0) {
               RefreshRates();
               Gi_364 = f0_12(1, Gd_328, Bid, G_slippage_96, Ask, 0, 0, Gs_308 + "-" + Gi_324, MagicNumber, 0, HotPink);
               if (Gi_364 < 0) {
                  Print("Error: ", GetLastError());
                  return (0);
               }
               Gd_288 = f0_6();
               Gi_352 = FALSE;
               Gi_368 = TRUE;
            }
         }
      } else {
         if (Gi_356) {
            if (Gi_80 || Ls_40 == "true") {
               f0_1(1, 0);
               Gd_328 = NormalizeDouble(Gd_88 * order_lots_0, Gd_112);
            } else Gd_328 = f0_11(OP_BUY);
            if (Gi_84 && Ls_32 == "true") {
               Gi_324 = Gi_340;
               if (Gd_328 > 0.0) {
                  Gi_364 = f0_12(0, Gd_328, Ask, G_slippage_96, Bid, 0, 0, Gs_308 + "-" + Gi_324, MagicNumber, 0, Lime);
                  if (Gi_364 < 0) {
                     Print("Error: ", GetLastError());
                     return (0);
                  }
                  Gd_280 = f0_2();
                  Gi_352 = FALSE;
                  Gi_368 = TRUE;
               }
            }
         }
      }
   }
   if (Gi_352 && Gi_340 < 1) {
      iclose_16 = iClose(Symbol(), 0, 2);
      iclose_24 = iClose(Symbol(), 0, 1);
      G_bid_264 = Bid;
      G_ask_272 = Ask;
      if ((!Gi_360) && (!Gi_356) && Ls_32 == "true") {
         Gi_324 = Gi_340;
         if (iclose_16 > iclose_24) {
            Gd_328 = f0_11(OP_SELL);
            if (Gd_328 > 0.0 && Sell == TRUE) {
               Gi_364 = f0_12(1, Gd_328, G_bid_264, G_slippage_96, G_bid_264, 0, 0, Gs_308 + "-" + Gi_324, MagicNumber, 0, HotPink);
               if (Gi_364 < 0) {
                  Print(Gd_328, "Error: ", GetLastError());
                  return (0);
               }
               Gd_280 = f0_2();
               Gi_368 = TRUE;
            }
         } else {
            Gd_328 = f0_11(OP_BUY);
            if (Gd_328 > 0.0 && Buy == TRUE) {
               Gi_364 = f0_12(0, Gd_328, G_ask_272, G_slippage_96, G_ask_272, 0, 0, Gs_308 + "-" + Gi_324, MagicNumber, 0, Lime);
               if (Gi_364 < 0) {
                  Print(Gd_328, "Error: ", GetLastError());
                  return (0);
               }
               Gd_288 = f0_6();
               Gi_368 = TRUE;
            }
         }
      }
      if (Gi_364 > 0) Gi_320 = TimeCurrent() + 60.0 * (60.0 * Gd_196);
      Gi_352 = FALSE;
   }
   Gi_340 = f0_13();
   G_price_256 = 0;
   double Ld_56 = 0;
   for (G_pos_336 = OrdersTotal() - 1; G_pos_336 >= 0; G_pos_336--) {
      OrderSelect(G_pos_336, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) {
            G_price_256 += OrderOpenPrice() * OrderLots();
            Ld_56 += OrderLots();
         }
      }
   }
   if (Gi_340 > 0) G_price_256 = NormalizeDouble(G_price_256 / Ld_56, Digits);
   if (Gi_368) {
      for (G_pos_336 = OrdersTotal() - 1; G_pos_336 >= 0; G_pos_336--) {
         OrderSelect(G_pos_336, SELECT_BY_POS, MODE_TRADES);
         if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) {
               G_price_224 = G_price_256 + TakeProfit * point;
               Gd_unused_240 = G_price_224;
               Gd_344 = G_price_256 - G_pips_128 * point;
               Gi_304 = TRUE;
            }
         }
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_SELL) {
               G_price_224 = G_price_256 - TakeProfit * point;
               Gd_unused_248 = G_price_224;
               Gd_344 = G_price_256 + G_pips_128 * point;
               Gi_304 = TRUE;
            }
         }
      }
   }
   if (Gi_368) {
      if (Gi_304 == TRUE) {
         for (G_pos_336 = OrdersTotal() - 1; G_pos_336 >= 0; G_pos_336--) {
            OrderSelect(G_pos_336, SELECT_BY_POS, MODE_TRADES);
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) OrderModify(OrderTicket(), G_price_256, OrderStopLoss(), G_price_224, 0, Yellow);
            Gi_368 = FALSE;
         }
      }
   }
   return (0);
}

// 9A116C50D133C8648404081885194300
double f0_9(double Ad_0) {
   return (NormalizeDouble(Ad_0, Digits));
}

// 169720DB8C7DA7F48F483E787B4A2725
int f0_1(bool Ai_0 = TRUE, bool Ai_4 = TRUE) {
   int Li_ret_8 = 0;
   for (int pos_12 = OrdersTotal() - 1; pos_12 >= 0; pos_12--) {
      if (OrderSelect(pos_12, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY && Ai_0) {
               RefreshRates();
               if (!IsTradeContextBusy()) {
                  if (!OrderClose(OrderTicket(), OrderLots(), f0_9(Bid), 5, CLR_NONE)) {
                     Print("Error close BUY " + OrderTicket());
                     Li_ret_8 = -1;
                  }
               } else {
                  if (G_datetime_372 == iTime(NULL, 0, 0)) return (-2);
                  G_datetime_372 = iTime(NULL, 0, 0);
                  Print("Need close BUY " + OrderTicket() + ". Trade Context Busy");
                  return (-2);
               }
            }
            if (OrderType() == OP_SELL && Ai_4) {
               RefreshRates();
               if (!IsTradeContextBusy()) {
                  if (!(!OrderClose(OrderTicket(), OrderLots(), f0_9(Ask), 5, CLR_NONE))) continue;
                  Print("Error close SELL " + OrderTicket());
                  Li_ret_8 = -1;
                  continue;
               }
               if (G_datetime_376 == iTime(NULL, 0, 0)) return (-2);
               G_datetime_376 = iTime(NULL, 0, 0);
               Print("Need close SELL " + OrderTicket() + ". Trade Context Busy");
               return (-2);
            }
         }
      }
   }
   return (Li_ret_8);
}

// BD1F338B493E3233DF78411E167716E8
double f0_11(int A_cmd_0) {
   double lots_4;
   int datetime_12;
   switch (Gi_76) {
   case 0:
      lots_4 = Lots;
      break;
   case 1:
      lots_4 = NormalizeDouble(Lots * MathPow(Gd_88, Gi_324), Gd_112);
      break;
   case 2:
      datetime_12 = 0;
      lots_4 = Lots;
      for (int pos_20 = OrdersHistoryTotal() - 1; pos_20 >= 0; pos_20--) {
         if (OrderSelect(pos_20, SELECT_BY_POS, MODE_HISTORY)) {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
               if (datetime_12 < OrderCloseTime()) {
                  datetime_12 = OrderCloseTime();
                  if (OrderProfit() < 0.0) {
                     lots_4 = NormalizeDouble(OrderLots() * Gd_88, Gd_112);
                     continue;
                  }
                  lots_4 = Lots;
               }
            }
         } else return (-3);
      }
   }
   if (AccountFreeMarginCheck(Symbol(), A_cmd_0, lots_4) <= 0.0) return (-1);
   if (GetLastError() == 134/* NOT_ENOUGH_MONEY */) return (-2);
   return (lots_4);
}

// CBBD1151F6D49BC6C817A0B96D15036D
int f0_13() {
   int count_0 = 0;
   for (int pos_4 = OrdersTotal() - 1; pos_4 >= 0; pos_4--) {
      OrderSelect(pos_4, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count_0++;
   }
   return (count_0);
}

// 41BB59E8D36C416E4C62910D9E765220
void f0_3() {
   for (int pos_0 = OrdersTotal() - 1; pos_0 >= 0; pos_0--) {
      OrderSelect(pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() == Symbol()) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) {
            if (OrderType() == OP_BUY) OrderClose(OrderTicket(), OrderLots(), Bid, G_slippage_96, Blue);
            if (OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), Ask, G_slippage_96, Red);
         }
         Sleep(1000);
      }
   }
}

// C159FD8BED695B6E6A109D3B72C199C3
int f0_12(int Ai_0, double A_lots_4, double A_price_12, int A_slippage_20, double Ad_24, int Ai_unused_32, int Ai_36, string A_comment_40, int A_magic_48, int A_datetime_52, color A_color_56) {
   int ticket_60 = 0;
   int error_64 = 0;
   int count_68 = 0;
   int Li_72 = 100;
   switch (Ai_0) {
   case 2:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_10(Ad_24, G_pips_128), f0_14(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(1000);
      }
      break;
   case 4:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_BUYSTOP, A_lots_4, A_price_12, A_slippage_20, f0_10(Ad_24, G_pips_128), f0_14(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 0:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         RefreshRates();
         ticket_60 = OrderSend(Symbol(), OP_BUY, A_lots_4, Ask, A_slippage_20, f0_10(Bid, G_pips_128), f0_14(Ask, Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 3:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLLIMIT, A_lots_4, A_price_12, A_slippage_20, f0_0(Ad_24, G_pips_128), f0_4(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 5:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELLSTOP, A_lots_4, A_price_12, A_slippage_20, f0_0(Ad_24, G_pips_128), f0_4(A_price_12, Ai_36), A_comment_40, A_magic_48, A_datetime_52,
            A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
      break;
   case 1:
      for (count_68 = 0; count_68 < Li_72; count_68++) {
         ticket_60 = OrderSend(Symbol(), OP_SELL, A_lots_4, Bid, A_slippage_20, f0_0(Ask, G_pips_128), f0_4(Bid, Ai_36), A_comment_40, A_magic_48, A_datetime_52, A_color_56);
         error_64 = GetLastError();
         if (error_64 == 0/* NO_ERROR */) break;
         if (!((error_64 == 4/* SERVER_BUSY */ || error_64 == 137/* BROKER_BUSY */ || error_64 == 146/* TRADE_CONTEXT_BUSY */ || error_64 == 136/* OFF_QUOTES */))) break;
         Sleep(5000);
      }
   }
   return (ticket_60);
}

// A04259EF619300E271488B8ABD9DF8A9
double f0_10(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * point);
}

// 0D578CA46072792DE50D5B9F5F5F8784
double f0_0(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * point);
}

// CE75B31DDDC1519B313C4C612EF22D86
double f0_14(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 + Ai_8 * point);
}

// 4347D7B92E8469B198EAA742F66BBE62
double f0_4(double Ad_0, int Ai_8) {
   if (Ai_8 == 0) return (0);
   return (Ad_0 - Ai_8 * point);
}

// 4A186EA1A04A05E39FD2E7A94BB28576
double f0_5() {
   double Ld_ret_0 = 0;
   for (G_pos_336 = OrdersTotal() - 1; G_pos_336 >= 0; G_pos_336--) {
      OrderSelect(G_pos_336, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_BUY || OrderType() == OP_SELL) Ld_ret_0 += OrderProfit();
   }
   return (Ld_ret_0);
}

// FDD5E0C68EEEAC73C07299767285F173
void f0_15(int Ai_0, int Ai_4, double A_price_8) {
   int Li_16;
   double order_stoploss_20;
   double price_28;
   if (Ai_4 != 0) {
      for (int pos_36 = OrdersTotal() - 1; pos_36 >= 0; pos_36--) {
         if (OrderSelect(pos_36, SELECT_BY_POS, MODE_TRADES)) {
            if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
            if (OrderSymbol() == Symbol() || OrderMagicNumber() == MagicNumber) {
               if (OrderType() == OP_BUY) {
                  Li_16 = NormalizeDouble((Bid - A_price_8) / point, 0);
                  if (Li_16 < Ai_0) continue;
                  order_stoploss_20 = OrderStopLoss();
                  price_28 = Bid - Ai_4 * point;
                  if (order_stoploss_20 == 0.0 || (order_stoploss_20 != 0.0 && price_28 > order_stoploss_20)) OrderModify(OrderTicket(), A_price_8, price_28, OrderTakeProfit(), 0, Aqua);
               }
               if (OrderType() == OP_SELL) {
                  Li_16 = NormalizeDouble((A_price_8 - Ask) / point, 0);
                  if (Li_16 < Ai_0) continue;
                  order_stoploss_20 = OrderStopLoss();
                  price_28 = Ask + Ai_4 * point;
                  if (order_stoploss_20 == 0.0 || (order_stoploss_20 != 0.0 && price_28 < order_stoploss_20)) OrderModify(OrderTicket(), A_price_8, price_28, OrderTakeProfit(), 0, Red);
               }
            }
            Sleep(1000);
         }
      }
   }
}

// 91C97865111C4DD6B44C584F4B9358BB
double f0_7() {
   if (f0_13() == 0) Gd_380 = AccountEquity();
   if (Gd_380 < Gd_388) Gd_380 = Gd_388;
   else Gd_380 = AccountEquity();
   Gd_388 = AccountEquity();
   return (Gd_380);
}

// 262336F736ADFEEC641C03BB3514631C
double f0_2() {
   double order_open_price_0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_BUY) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}

// 599A26C25DF2561FBAA884F47E1B315C
double f0_6() {
   double order_open_price_0;
   int ticket_8;
   double Ld_unused_12 = 0;
   int ticket_20 = 0;
   for (int pos_24 = OrdersTotal() - 1; pos_24 >= 0; pos_24--) {
      OrderSelect(pos_24, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber && OrderType() == OP_SELL) {
         ticket_8 = OrderTicket();
         if (ticket_8 > ticket_20) {
            order_open_price_0 = OrderOpenPrice();
            Ld_unused_12 = order_open_price_0;
            ticket_20 = ticket_8;
         }
      }
   }
   return (order_open_price_0);
}

// 938363B042E987609BD8B876255B9679
void f0_8() {
   Comment("Robot Forex 2015 Profesional version II\n", "Copyright © 2015, Eracash.com\n", "Visit: www.eracash.com\n", "This system not for sale or Share\n", "Forex Account Server:", AccountServer(), 
      "\n", "Lots:  ", Lots, 
      "\n", "Symbol: ", Symbol(), 
      "\n", "Price:  ", NormalizeDouble(Bid, 4), 
      "\n", "Date: ", Month(), "-", Day(), "-", Year(), " Server Time: ", Hour(), ":", Minute(), ":", Seconds(), 
   "\n");
}
