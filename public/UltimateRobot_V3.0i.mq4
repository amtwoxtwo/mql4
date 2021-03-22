#property copyright "Copyright Sutera Gemilang Resources@2009"
#property link      "http://www.thebestrobot.tk & www.ultimaterobot.tk"

#include <WinUser32.mqh>

int gi_76 = 2576447;
string gs_80 = "2020.03.13 00:00";
extern string InitialAccountSet = "Initial account balance";
extern int InitialAccount = 2500;
extern string TradeComment = "Syah Demo";
extern string NumberPortionSet = "Account Portion";
extern int Portion = 1;
extern bool UseEquityProtection = TRUE;
extern double FloatPercent = 50.0;
extern bool UsePowerOutSL = FALSE;
extern bool UseMM = FALSE;
extern string LotAdjustmentSet = "Only with MM enabled. (.01 - 5.0)";
extern double LAF = 1.0;
extern string AccountTypeSet = "1=standard, 10=mini for penny/pip)";
extern int Accounttype = 10;
extern string ManuallotSet = "Lots used if MM is off";
extern double lot = 0.07;
extern string LotHedgeSet = "Hedge Multiplier.  Adjust by +/-.01 intervals ";
extern double Multiplier = 1.4;
extern string AutoParametersSet = "Autocalculates the Grid based on ATR";
extern bool AutoCal = FALSE;
extern string AutoGridAdjust = "Widens/squishes grid (.5 - 3.0)";
extern double GAF = 1.0;
extern string GridSet = "Default Grid size in Pips";
extern int GridSet1 = 25;
extern int TP_Set1 = 50;
extern int GridSet2 = 50;
extern int TP_Set2 = 100;
extern int GridSet3 = 100;
extern int TP_Set3 = 200;
extern string TimeGridSet = "Default grid set time in seconds";
extern int TimeGrid = 2400;
extern string MarketConditionSet = "Set MC to 2 for Ranging Market";
extern int MC = 2;
extern string MovingAverageSet = "Changes MC for correct trend (up/down)";
extern bool MCbyMA = TRUE;
extern int MA_Period = 100;
extern string MaxLevelSet = "Default of 4 on each level, change sparingly";
extern int Set1Count = 4;
extern int Set2Count = 4;
extern int MaxLevel = 12;
extern int BELevel = 15;
extern int slippage = 5;
bool gi_328 = FALSE;
string gs_332 = "UltimateRobot V3.0i";
int g_magic_340 = 0;
double g_slippage_344 = 0.0;
int gi_352 = 5;
double gd_356 = 0.0;
string g_str_concat_364;
int gi_372 = 1;
string gs_376 = "No";
bool gi_384;

int init() {
   if (Symbol() == "AUDCADm" || Symbol() == "AUDCAD") g_magic_340 = 101101;
   if (Symbol() == "AUDJPYm" || Symbol() == "AUDJPY") g_magic_340 = 101102;
   if (Symbol() == "AUDNZDm" || Symbol() == "AUDNZD") g_magic_340 = 101103;
   if (Symbol() == "AUDUSDm" || Symbol() == "AUDUSD") g_magic_340 = 101104;
   if (Symbol() == "CHFJPYm" || Symbol() == "CHFJPY") g_magic_340 = 101105;
   if (Symbol() == "EURAUDm" || Symbol() == "EURAUD") g_magic_340 = 101106;
   if (Symbol() == "EURCADm" || Symbol() == "EURCAD") g_magic_340 = 101107;
   if (Symbol() == "EURCHFm" || Symbol() == "EURCHF") g_magic_340 = 101108;
   if (Symbol() == "EURGBPm" || Symbol() == "EURGBP") g_magic_340 = 101109;
   if (Symbol() == "EURJPYm" || Symbol() == "EURJPY") g_magic_340 = 101110;
   if (Symbol() == "EURUSDm" || Symbol() == "EURUSD") g_magic_340 = 101111;
   if (Symbol() == "GBPCHFm" || Symbol() == "GBPCHF") g_magic_340 = 101112;
   if (Symbol() == "GBPJPYm" || Symbol() == "GBPJPY") g_magic_340 = 101113;
   if (Symbol() == "GBPUSDm" || Symbol() == "GBPUSD") g_magic_340 = 101114;
   if (Symbol() == "NZDJPYm" || Symbol() == "NZDJPY") g_magic_340 = 101115;
   if (Symbol() == "NZDUSDm" || Symbol() == "NZDUSD") g_magic_340 = 101116;
   if (Symbol() == "USDCHFm" || Symbol() == "USDCHF") g_magic_340 = 101117;
   if (Symbol() == "USDJPYm" || Symbol() == "USDJPY") g_magic_340 = 101118;
   if (Symbol() == "USDCADm" || Symbol() == "USDCAD") g_magic_340 = 101119;
   if (g_magic_340 == 0) g_magic_340 = 701999;
   if (Digits == 3 || Digits == 5) gi_372 = 10;
   g_str_concat_364 = StringConcatenate(gs_332 + "_", Symbol(), "_", Period(), "_M", ".txt");
   return (0);
}

int deinit() {
   return (0);
}

int start() {
   double ld_84;
   double l_lots_92;
   double l_ord_open_price_100;
   double l_ord_lots_108;
   double l_ord_takeprofit_116;
   double ld_124;
   double ld_132;
   double ld_140;
   double l_price_148;
   double ld_164;
   int l_ticket_172;
   double ld_176;
   int li_208;
   double l_tickvalue_212;
   double ld_224;
   double ld_232;
   double ld_240;
   double ld_248;
   double ld_256;
   string ls_272;
   int l_count_4 = 0;
   int l_count_8 = 0;
   int l_count_12 = 0;
   int l_count_16 = 0;
   int l_count_20 = 0;
   int l_count_24 = 0;
   double ld_28 = 0;
   double ld_36 = 0;
   double ld_44 = 0;
   double ld_52 = 0;
   double l_price_60 = 0;
   double l_price_68 = 0;
   double ld_76 = 0;
   double ld_156 = 0;
   for (int l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
      OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
      if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_BUY) {
         l_count_4++;
         ld_156 += OrderProfit();
         ld_28 += OrderLots();
      }
      if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_SELL) {
         l_count_8++;
         ld_156 += OrderProfit();
         ld_36 += OrderLots();
      }
      if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_BUYLIMIT) l_count_12++;
      if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_SELLLIMIT) l_count_16++;
      if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_BUYSTOP) l_count_20++;
      if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_SELLSTOP) l_count_24++;
      ld_44 = ld_28 + ld_36;
      ld_52 = l_count_4 + l_count_8;
   }
   if (UseEquityProtection) EquityProtection(NormalizeDouble(ld_156, 0));
   double ld_192 = NormalizeDouble(AccountBalance() / Portion, 0);
   double ld_200 = InitialAccount / Portion;
   if (ld_192 < ld_200) {
      PlaySound("alert.wav");
      MessageBox("Account Balance is less than Initial Account Balance on " + Symbol() + Period(), "UltimateRobot V3.0i 2: Warning", MB_ICONEXCLAMATION);
      return (0);
   }
   if (UsePowerOutSL) {
      gs_376 = "Yes";
      li_208 = 1;
      l_tickvalue_212 = MarketInfo(Symbol(), MODE_TICKVALUE);
      if (Accounttype == 1 && l_tickvalue_212 < 5.0) li_208 = 10;
      if (ld_44 == 0.0) {
         ld_76 = 600;
         if (Digits == 3 || Digits == 5) ld_76 = 10.0 * ld_76;
         l_price_60 = Ask - ld_76 * Point;
         l_price_68 = Bid + ld_76 * Point;
      }
      if (ld_44 > 0.0) {
         ld_76 = NormalizeDouble(ld_192 * (FloatPercent + 1.0) / 100.0 / (l_tickvalue_212 * ld_44 * li_208), 0);
         if (ld_76 > 600.0) ld_76 = 600;
         if (Digits == 3 || Digits == 5) ld_76 = 10.0 * ld_76;
         l_price_60 = Ask - ld_76 * Point;
         l_price_68 = Bid + ld_76 * Point;
      }
      if (ld_52 == 0.0) gi_384 = FALSE;
      if (ld_52 > 0.0 && ld_52 > gi_384) {
         for (int l_pos_220 = 0; l_pos_220 < OrdersTotal(); l_pos_220++) {
            OrderSelect(l_pos_220, SELECT_BY_POS, MODE_TRADES);
            if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_BUY) OrderModify(OrderTicket(), OrderOpenPrice(), l_price_60, OrderTakeProfit(), 0, Purple);
            if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_SELL) OrderModify(OrderTicket(), OrderOpenPrice(), l_price_68, OrderTakeProfit(), 0, Purple);
         }
      }
      gi_384 = ld_52;
   }
   if (UseMM) {
      ld_224 = AccountBalance() / 10000.0 / Portion;
      ld_232 = Multiplier + MathPow(Multiplier, 2) + MathPow(Multiplier, 3) + MathPow(Multiplier, 4) + MathPow(Multiplier, 5) + MathPow(Multiplier, 6);
      ld_240 = LAF * Accounttype * (ld_224 / (ld_232 + 1.0));
      lot = NormalizeDouble(ld_240, 2);
      if (ld_240 < 0.01) lot = 0.01;
      if (ld_240 > 100 / MathPow(Multiplier, 6) && Accounttype == 1) lot = NormalizeDouble(100 / MathPow(Multiplier, 6), 2);
      if (ld_240 > 50 / MathPow(Multiplier, 6) && Accounttype == 10) lot = NormalizeDouble(50 / MathPow(Multiplier, 6), 2);
   }
   double l_iatr_264 = iATR(NULL, PERIOD_D1, 21, 0);
   if (AutoCal == TRUE) {
      if (Digits == 2 || Digits == 3) ld_256 = 100.0 * l_iatr_264;
      if (Digits == 4 || Digits == 5) ld_256 = 10000.0 * l_iatr_264;
      ld_248 = 2.0 * ld_256 / 10.0;
      GridSet1 = ld_248;
      TP_Set1 = ld_248 + GridSet1;
      GridSet2 = TP_Set1;
      TP_Set2 = 2.0 * (ld_248 + GridSet1);
      GridSet3 = TP_Set2;
      TP_Set3 = 4.0 * (ld_248 + GridSet1);
   }
   if (MCbyMA) {
      MC = -1;
      if (Bid < iMA(Symbol(), 0, MA_Period, 0, MODE_EMA, PRICE_CLOSE, 0)) MC = 1;
      if (Bid > iMA(Symbol(), 0, MA_Period, 0, MODE_EMA, PRICE_CLOSE, 0)) MC = 0;
   }
   if (l_count_8 == 0 && l_count_4 == 0 && l_count_20 == 0 && l_count_12 == 0 && l_count_24 == 0 && l_count_16 == 0) gi_328 = FALSE;
   g_slippage_344 = NormalizeDouble(slippage * gi_372, 0);
   if ((l_count_4 >= BELevel || l_count_8 >= BELevel && ld_156 > 0.0) || gi_328) {
      gi_328 = TRUE;
      for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
         OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
         if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_BUY || OrderType() == OP_SELL) OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), g_slippage_344, Lime);
         if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP) OrderDelete(OrderTicket(), White);
      }
   } else {
      gi_352 = gi_352;
      if (gi_372 == 10) gi_352 = 50;
      ld_132 = GridSet1;
      ld_140 = TP_Set1;
      if (l_count_4 >= Set1Count || l_count_8 >= Set1Count) {
         ld_132 = GridSet2;
         ld_140 = TP_Set2;
      }
      if (l_count_4 >= Set2Count + Set1Count || l_count_8 >= Set2Count + Set1Count) {
         ld_132 = GridSet3;
         ld_140 = TP_Set3;
      }
      if (gi_372 == 10) {
         ld_132 = 10.0 * ld_132;
         ld_140 = 10.0 * ld_140;
      }
      ld_132 = NormalizeDouble(ld_132 * GAF, 0);
      ld_140 = NormalizeDouble(ld_140 * GAF, 0);
      if (l_count_4 == 0 && l_count_8 == 0) {
         for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
            OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
            if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderLots() > lot) OrderDelete(OrderTicket());
         }
         if (MC == 0) {
            if (l_count_20 == 0) {
               ld_84 = MathMod(Ask / Point, ld_132);
               if (ld_132 - ld_84 + gi_352 > MarketInfo(Symbol(), MODE_STOPLEVEL) && LoginNumber() && kadaluarsa()) {
                  OrderSend(Symbol(), OP_BUYSTOP, lot, 2.0 * Ask - Bid + (ld_132 - ld_84 + gi_352) * Point, 0, l_price_60, 2.0 * Ask - Bid + (ld_132 - ld_84 + gi_352 + ld_140) * Point, TradeComment, g_magic_340, 0, CLR_NONE);
                  Print("s2");
                  return;
               }
            }
            if (l_count_12 == 0) {
               ld_84 = MathMod(Ask / Point, ld_132);
               if (ld_84 + gi_352 > MarketInfo(Symbol(), MODE_STOPLEVEL) && LoginNumber() && kadaluarsa()) {
                  OrderSend(Symbol(), OP_BUYLIMIT, lot, 2.0 * Ask - Bid - (ld_84 + gi_352) * Point, 0, l_price_60, 2.0 * Ask - Bid - (ld_84 + gi_352 - ld_140) * Point, TradeComment, g_magic_340, 0, CLR_NONE);
                  Print("s1");
                  return;
               }
            }
         }
         if (MC == 1) {
            if (l_count_16 == 0) {
               ld_84 = MathMod(Bid / Point, ld_132);
               if (ld_132 - ld_84 - gi_352 > MarketInfo(Symbol(), MODE_STOPLEVEL) && LoginNumber() && kadaluarsa()) {
                  OrderSend(Symbol(), OP_SELLLIMIT, lot, Bid + (ld_132 - ld_84 - gi_352) * Point, 0, l_price_68, Bid + (ld_132 - ld_84 - gi_352 - ld_140) * Point, TradeComment, g_magic_340, 0, CLR_NONE);
                  Print("s2");
                  return;
               }
            }
            if (l_count_24 == 0) {
               ld_84 = MathMod(Bid / Point, ld_132);
               if (ld_84 + gi_352 > MarketInfo(Symbol(), MODE_STOPLEVEL) && LoginNumber() && kadaluarsa()) {
                  OrderSend(Symbol(), OP_SELLSTOP, lot, Bid - (ld_84 + gi_352) * Point, 0, l_price_68, Bid - (ld_84 + gi_352 + ld_140) * Point, TradeComment, g_magic_340, 0, CLR_NONE);
                  Print("s1");
                  return;
               }
            }
         }
         if (MC == 2) {
            if (l_count_24 == 0) {
               ld_84 = MathMod(Bid / Point, ld_132);
               if (ld_84 + gi_352 > MarketInfo(Symbol(), MODE_STOPLEVEL) && LoginNumber() && kadaluarsa()) {
                  OrderSend(Symbol(), OP_SELLSTOP, lot, Bid - (ld_84 + gi_352) * Point, 0, l_price_68, Bid - (ld_84 + gi_352 + ld_140) * Point, TradeComment, g_magic_340, 0, CLR_NONE);
                  Print("s1");
                  return;
               }
            }
            if (l_count_20 == 0) {
               ld_84 = MathMod(Ask / Point, ld_132);
               if (ld_132 - ld_84 + gi_352 > MarketInfo(Symbol(), MODE_STOPLEVEL) && LoginNumber() && kadaluarsa()) {
                  OrderSend(Symbol(), OP_BUYSTOP, lot, 2.0 * Ask - Bid + (ld_132 - ld_84 + gi_352) * Point, 0, l_price_60, 2.0 * Ask - Bid + (ld_132 - ld_84 + gi_352 + ld_140) * Point, TradeComment, g_magic_340, 0, CLR_NONE);
                  Print("s2");
                  return;
               }
            }
         }
      }
      if (l_count_4 > 0 || l_count_8 > 0) {
         for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
            OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
            if (OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderType() != OP_SELL && OrderType() != OP_BUY && OrderLots() == lot) OrderDelete(OrderTicket());
         }
      }
      if (l_count_4 > 0) {
         ld_164 = 0;
         ld_176 = 0;
         for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
            OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
            if (OrderMagicNumber() != g_magic_340 || OrderType() != OP_BUY || OrderSymbol() != Symbol()) continue;
            l_ord_open_price_100 = OrderOpenPrice();
            l_ord_lots_108 = OrderLots();
            l_ord_takeprofit_116 = OrderTakeProfit();
            ld_124 = OrderOpenTime();
            l_ticket_172 = OrderTicket();
            ld_164 += l_ord_lots_108;
            ld_176 += l_ord_lots_108 * l_ord_open_price_100;
         }
         ld_176 /= ld_164;
         if (TimeCurrent() - TimeGrid > ld_124 && l_count_4 < MaxLevel) {
            if (l_ord_open_price_100 > Ask) l_price_148 = NormalizeDouble(l_ord_open_price_100 - (MathRound((l_ord_open_price_100 - Ask) / Point / ld_132) + 1.0) * ld_132 * Point, Digits);
            else l_price_148 = NormalizeDouble(l_ord_open_price_100 - ld_132 * Point, Digits);
            if (l_ord_lots_108 <= 0.01) l_lots_92 = NormalizeDouble(2.0 * l_ord_lots_108 + gd_356, 2);
            else l_lots_92 = NormalizeDouble(l_ord_lots_108 * Multiplier + gd_356, 2);
            if (l_count_12 == 0 && LoginNumber() && kadaluarsa()) {
               OrderSend(Symbol(), OP_BUYLIMIT, l_lots_92, l_price_148, 0, l_price_60, l_price_148 + ld_140 * Point, TradeComment, g_magic_340);
               Print("s3");
               return;
            }
            if (l_count_12 == 1) {
               for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
                  OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
                  if (OrderType() == OP_BUYLIMIT && OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && l_price_148 - OrderOpenPrice() > ld_132 / 2.0 * Point) {
                     OrderModify(OrderTicket(), l_price_148, l_price_60, l_price_148 + ld_140 * Point, 0);
                     Print("mo1");
                  }
               }
            }
         }
         for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
            OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
            if (OrderMagicNumber() != g_magic_340 || OrderType() != OP_BUY || MathAbs(OrderTakeProfit() - l_ord_takeprofit_116) < Point || OrderSymbol() != Symbol()) continue;
            OrderModify(OrderTicket(), OrderOpenPrice(), l_price_60, l_ord_takeprofit_116, 0, Blue);
            Print("m1");
            return;
         }
      }
      if (l_count_8 > 0) {
         ld_164 = 0;
         ld_176 = 0;
         for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
            OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
            if (OrderMagicNumber() != g_magic_340 || OrderType() != OP_SELL || OrderSymbol() != Symbol()) continue;
            l_ord_open_price_100 = OrderOpenPrice();
            l_ord_lots_108 = OrderLots();
            l_ord_takeprofit_116 = OrderTakeProfit();
            ld_124 = OrderOpenTime();
            l_ticket_172 = OrderTicket();
            ld_164 += l_ord_lots_108;
            ld_176 += l_ord_lots_108 * l_ord_open_price_100;
         }
         ld_176 /= ld_164;
         if (TimeCurrent() - TimeGrid > ld_124 && l_count_8 < MaxLevel) {
            if (Bid > l_ord_open_price_100) l_price_148 = NormalizeDouble(l_ord_open_price_100 + (MathRound(((-l_ord_open_price_100) + Bid) / Point / ld_132) + 1.0) * ld_132 * Point, Digits);
            else l_price_148 = NormalizeDouble(l_ord_open_price_100 + ld_132 * Point, Digits);
            if (l_ord_lots_108 <= 0.01) l_lots_92 = NormalizeDouble(2.0 * l_ord_lots_108 + gd_356, 2);
            else l_lots_92 = NormalizeDouble(l_ord_lots_108 * Multiplier + gd_356, 2);
            if (l_count_16 == 0 && LoginNumber() && kadaluarsa()) {
               OrderSend(Symbol(), OP_SELLLIMIT, l_lots_92, l_price_148, 0, l_price_68, l_price_148 - ld_140 * Point, TradeComment, g_magic_340);
               Print("s4");
               return;
            }
            if (l_count_16 == 1) {
               for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
                  OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
                  if (OrderType() == OP_SELLLIMIT && OrderMagicNumber() == g_magic_340 && OrderSymbol() == Symbol() && OrderOpenPrice() - l_price_148 > ld_132 / 2.0 * Point) {
                     OrderModify(OrderTicket(), l_price_148, l_price_68, l_price_148 - ld_140 * Point, 0);
                     Print("mo2");
                  }
               }
            }
         }
         for (l_pos_0 = 0; l_pos_0 < OrdersTotal(); l_pos_0++) {
            OrderSelect(l_pos_0, SELECT_BY_POS, MODE_TRADES);
            if (OrderMagicNumber() != g_magic_340 || OrderType() != OP_SELL || MathAbs(OrderTakeProfit() - l_ord_takeprofit_116) < Point || OrderSymbol() != Symbol()) continue;
            OrderModify(OrderTicket(), OrderOpenPrice(), l_price_68, l_ord_takeprofit_116, 0, Blue);
            Print("m2");
            return;
         }
      }
      ls_272 = "                " + gs_332 
         + "\n" 
         + "                            Current Time is      " + TimeToStr(TimeCurrent(), TIME_SECONDS) 
         + "\n" 
         + "\n" 
         + "                            Initial Account Set              " + DoubleToStr(InitialAccount, 0) 
         + "\n" 
         + "                            Equity Protection % Set      " + DoubleToStr(FloatPercent, 0) 
         + "\n" 
         + "\n" 
         + "                            Power Off Stop Loss on?         " + gs_376 
         + "\n" 
         + "\n" 
         + "                            Starting lot size                   " + DoubleToStr(lot, 2) 
         + "\n" 
         + "\n" 
         + "                            Portion P/L                        " + DoubleToStr(ld_156, 2) 
         + "\n" 
         + "\n" 
         + "                            Buy   " + l_count_4 + "  Sell   " + l_count_8 
         + "\n" 
         + "\n" 
         + "                            Account Portion   " + DoubleToStr(Portion, 0) + "   Total Risk on Account Percent  " + DoubleToStr(FloatPercent / Portion, 0) 
         + "\n" 
      + "                            Portion Balance      " + DoubleToStr(ld_192, 2);
      Comment(ls_272);
   }
   return (0);
}

void EquityProtection(int ai_0) {
   double ld_4 = NormalizeDouble(AccountBalance() / Portion, 0);
   double ld_12 = NormalizeDouble(ld_4 + ai_0, 0);
   for (int l_pos_20 = 0; l_pos_20 < OrdersTotal(); l_pos_20++) {
      if (OrderSelect(l_pos_20, SELECT_BY_POS, MODE_TRADES)) {
         if (OrderSymbol() == Symbol() && OrderMagicNumber() == g_magic_340 && OrderComment() == TradeComment) {
            g_slippage_344 = NormalizeDouble(slippage * gi_372, 0);
            if (OrderType() == OP_BUY)
               if (ld_4 - ld_12 >= ld_4 * FloatPercent / 100.0) OrderClose(OrderTicket(), OrderLots(), Bid, g_slippage_344, Red);
            if (OrderType() == OP_SELL)
               if (ld_4 - ld_12 >= ld_4 * FloatPercent / 100.0) OrderClose(OrderTicket(), OrderLots(), Ask, g_slippage_344, Red);
         }
      }
   }
}

int LoginNumber() {
   if (AccountNumber() != 0 || gi_76 == 0) return (1);
   Alert("Illigal duplication is not allowed");
   return (0);
}

int kadaluarsa() {
   int l_str2time_0 = StrToTime(gs_80);
   if (TimeCurrent() > l_str2time_0) {
      Alert("Demo ROBOT has been expired. For unlimited used, please purchase full package. Call Sales rep now..");
      return (0);
   }
   return (1);
}