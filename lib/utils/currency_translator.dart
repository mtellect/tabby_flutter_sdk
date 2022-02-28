part of 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart';

// enum Currency { AED, SAR, KWD, BDH }

String currencyTranslator(Currency currency) {
  switch (currency) {
    case Currency.AED:
      return "د.إ";
    case Currency.BDH:
      return "د.ب";
    case Currency.KWD:
      return "د.ك";
    case Currency.SAR:
      return "ر.س";
  }
}

/*
import { Currency } from "../../constants/payment";

export const currencyTranslator = (currency: Currency) => {
switch (currency) {
case "AED":
return "د.إ";
case "BDH":
return "د.ب";
case "KWD":
return "د.ك";
case "SAR":
return "ر.س";
}
};

export type Currency = "AED" | "SAR" | "KWD" | "BDH";
*/
