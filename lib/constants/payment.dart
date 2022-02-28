part of 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart';

/*interface ShippingAddress {
city: string;
address: string;
zip: string;
}*/

class ShippingAddress {
  final String city;
  final String address;
  final String? zip;

  ShippingAddress({required this.city, required this.address, this.zip});

  Map get json {
    return {"address": address, "city": city, if (null != zip) "zip": zip};
  }
}

/*
interface OrderHistoryItem {
purchased_at: string; // "2019-08-24T14:15:22Z";
amount: string; // "0.00";
payment_method: "card" | "cod";
status:
| "new"
| "processing"
| "complete"
| "refunded"
| "canceled"
| "unknown";
buyer: Buyer;
shipping_address: ShippingAddress;
items: OrderItem[];
}*/

enum PaymentMethod { card, cod }
enum TabbyResult { authorized, rejected, close, expired, error }

enum Status { NEW, PROCESSING, COMPLETE, REFUNDED, CANCELED, UNKNOWN }

class OrderHistoryItem {
  final String purchasedAt;
  final String amount;
  final PaymentMethod paymentMethod;
  final Status status;
  final Buyer buyer;
  final ShippingAddress shippingAddress;
  final List<OrderItem> items;

  OrderHistoryItem(
      {required this.purchasedAt,
      required this.amount,
      required this.paymentMethod,
      required this.status,
      required this.buyer,
      required this.shippingAddress,
      required this.items});
}

/*
interface BuyerHistory {
registered_since: string; // "2019-08-24T14:15:22Z";
loyalty_level: number; // 0;
wishlist_count: number; //0;
is_social_networks_connected: boolean; // true;
is_phone_number_verified: boolean; // true;
is_email_verified: boolean; // true;
}*/

class BuyerHistory {
  final String registeredSince;
  final int loyaltyLevel;
  final int wishlistCount;
  final bool isSocialNetworksConnected;
  final bool isPhoneNumberVerified;
  final bool isEmailVerified;

  BuyerHistory(
      {required this.registeredSince,
      required this.loyaltyLevel,
      required this.wishlistCount,
      required this.isSocialNetworksConnected,
      required this.isPhoneNumberVerified,
      required this.isEmailVerified});
}

/*interface OrderItem {
description: string; // 'To be displayed in tabby order information'
product_url: string; // https://tabby.store/p/SKU123
quantity: number; // 1
reference_id: string; // 'SKU123'
title: string; // 'Sample Item #1'
unit_price: string; // '300'
category: string; // jeans / dress / shorts / etc
}*/

class OrderItem {
  final String description;
  final String productUrl;
  final int quantity;
  final String referenceId;
  final String title;
  final String unitPrice;
  final String? category;

  OrderItem(
      {required this.description,
      required this.productUrl,
      required this.quantity,
      required this.referenceId,
      required this.title,
      required this.unitPrice,
      this.category});

  Map get json {
    return {
      "description": description,
      "product_url": productUrl,
      "quantity": quantity,
      "reference_id": referenceId,
      "title": title,
      "unit_price": unitPrice,
      if (null != category) "category": category
    };
  }
}

/*interface Order {
reference_id: string; // #xxxx-xxxxxx-xxxx
items: OrderItem[];
shipping_amount?: string; // '50'
tax_amount?: string; // '500'
discount_amount?: string; // '500'
}*/

class Order {
  final String referenceId;
  final List<OrderItem> items;
  final String shippingAmount;
  final String taxAmount;
  final String? discountAmount;

  Order(
      {required this.referenceId,
      required this.items,
      required this.shippingAmount,
      required this.taxAmount,
      this.discountAmount});

  Map get json {
    return {
      "reference_id": referenceId,
      "items": items.map((e) => e.json).toList(),
      "shipping_amount": shippingAmount,
      "tax_amount": taxAmount
    };
  }
}

/*interface Buyer {
email: string;
phone: string;
name: string;
dob: string; // "2019-08-24"
}*/

class Buyer {
  final String email;
  final String phone;
  final String name;
  final String? dob;

  Buyer(
      {required this.email, required this.phone, required this.name, this.dob});

  Map get json {
    return {
      "email": email,
      "phone": phone,
      "name": name,
      if (null != dob) "dob": dob
    };
  }
}

// https://docs.tabby.ai/#operation/postCheckoutSession
/*
export interface Payment {
amount: string;
currency: Currency; // ISO 4217 currency code for the payment amount.
description?: string;
buyer: Buyer;
buyer_history?: BuyerHistory;
order: Order;
order_history?: OrderHistoryItem[];
shipping_address?: ShippingAddress;
}*/

class Payment {
  final String amount;
  final Currency currency;
  final String description;
  final Buyer buyer;
  final BuyerHistory? buyerHistory;
  final Order order;
  final List<OrderHistoryItem>? orderHistory;
  final ShippingAddress shippingAddress;

  Payment(
      {required this.amount,
      required this.description,
      required this.currency,
      required this.buyer,
      this.buyerHistory,
      required this.order,
      this.orderHistory,
      required this.shippingAddress});

  Map get json {
    return {
      "amount": amount,
      "currency": describeEnum(currency),
      "description": description,
      "buyer": buyer.json,
      // if (null != buyerHistory) "buyer_history": buyerHistory.json,
      "order": order.json,
      "shipping_address": shippingAddress.json
    };
  }
}

/*export type TabbyPurchaseType =
| "pay_later"
| "installments"
| "monthly_billing";*/

enum TabbyPurchaseType { payLater, installments, monthlyBilling }

/*export type Currency = "AED" | "SAR" | "KWD" | "BDH";*/

enum Currency { AED, SAR, KWD, BDH }

/*
export interface TabbyCheckoutPayload {
merchant_code: string; // 'ae',
lang: string; // 'en' | 'ar,
payment: Payment;
}*/

class TabbyCheckoutPayload {
  final String merchantCode;
  final Language lang;
  final Payment payment;

  TabbyCheckoutPayload(
      {required this.merchantCode, required this.lang, required this.payment});

  Map get json {
    return {
      "merchant_code": merchantCode,
      "lang": describeEnum(lang),
      "payment": payment.json
    };
  }
}

class Installments {
  final String dueDate;
  final String amount;

  Installments(Map item)
      : dueDate = item["due_date"],
        amount = item["amount"];
}

/*export type ProductWebURL = { web_url: string };*/

class Products {
  final String downPayment;
  final String downPaymentPercent;
  final String amountToPay;
  final String nextPaymentDate;
  final List<Installments> installments;
  final bool payAfterDelivery;
  final String webUrl;
  final int id;
  final int installmentsCount;
  final String installmentPeriod;
  final String serviceFee;

  Products(Map items)
      : downPayment = items["downpayment"],
        downPaymentPercent = items["downpayment_percent"],
        amountToPay = items["amount_to_pay"],
        nextPaymentDate = items["next_payment_date"],
        installments = List.from(items["installments"] ?? [])
            .map((e) => Installments(e))
            .toList(),
        payAfterDelivery = items["pay_after_delivery"],
        webUrl = items["web_url"],
        id = items["id"],
        installmentsCount = items["installments_count"],
        installmentPeriod = items["installment_period"],
        serviceFee = items["service_fee"];
}

/*
export interface CheckoutSession {
id: string;
configuration: {
available_products: {
installments?: ProductWebURL[];
pay_later?: ProductWebURL[];
monthly_billing?: ProductWebURL[];
};
};
payment: {
id: string;
};
}*/

class CheckoutSession {
  final String id;
  final String paymentId;
  final Map<TabbyPurchaseType, List<Products>> configuration;

  CheckoutSession(
      {required this.id, required this.paymentId, required this.configuration});

  static CheckoutSession fromJson(Map json) {
    String id = json["id"];
    String paymentId = json["payment"]["id"];
    Map mapConfiguration = Map.from(json["configuration"]);
    Map availableProducts = Map.from(mapConfiguration["available_products"]);

    final configuration = {
      TabbyPurchaseType.installments:
          List.from(availableProducts["installments"] ?? [])
              .map((e) => Products(e))
              .toList(),
      TabbyPurchaseType.payLater:
          List.from(availableProducts["pay_later"] ?? [])
              .map((e) => Products(e))
              .toList(),
      TabbyPurchaseType.monthlyBilling:
          List.from(availableProducts["monthly_billing"] ?? [])
              .map((e) => Products(e))
              .toList(),
    };

    return CheckoutSession(
        id: id, paymentId: paymentId, configuration: configuration);
  }

  _payload() {
    var item = {
      "id": "109c2a64-35f4-4b0e-820c-ba92dc1ba54b",
      "warnings": null,
      "configuration": {
        "currency": "AED",
        "app_type": "one_click",
        "new_customer": true,
        "available_limit": null,
        "min_limit": null,
        "available_products": {
          "installments": [
            {
              "downpayment": "0.00",
              "downpayment_percent": "25",
              "amount_to_pay": "100.00",
              "next_payment_date": "2022-03-28T00:00:00Z",
              "installments": [
                {"due_date": "2022-03-28", "amount": "33.33"},
                {"due_date": "2022-04-28", "amount": "33.33"},
                {"due_date": "2022-05-28", "amount": "33.34"}
              ],
              "pay_after_delivery": false,
              "pay_per_installment": "33.33",
              "web_url":
                  "https://checkout.tabby.ai/?sessionId=109c2a64-35f4-4b0e-820c-ba92dc1ba54b&apiKey=pk_test_151a3aa8-1675-4441-bfea-b8ba9d880bfe&product=installments&merchantCode=eyewa",
              "id": 185,
              "installments_count": 3,
              "installment_period": "P1M",
              "service_fee": "0.00"
            }
          ],
          "pay_later": [
            {
              "downpayment": "0.00",
              "downpayment_percent": "25",
              "amount_to_pay": "100.00",
              "next_payment_date": "2022-03-14T00:00:00Z",
              "installments": [
                {"due_date": "2022-03-14", "amount": "100.00"}
              ],
              "pay_after_delivery": false,
              "pay_per_installment": "100.00",
              "web_url":
                  "https://checkout.tabby.ai/?sessionId=109c2a64-35f4-4b0e-820c-ba92dc1ba54b&apiKey=pk_test_151a3aa8-1675-4441-bfea-b8ba9d880bfe&product=pay_later&merchantCode=eyewa",
              "id": 184,
              "installments_count": 1,
              "installment_period": "P2W",
              "service_fee": "0.00"
            }
          ]
        },
        "country": "ARE",
        "expires_at": "2022-02-28T08:44:12Z",
        "is_bank_card_required": false,
        "blocked_until": null,
        "products": {
          "installments": {
            "type": "installments",
            "is_available": true,
            "rejection_reason": null
          },
          "pay_later": {
            "type": "pay_later",
            "is_available": true,
            "rejection_reason": null
          }
        }
      },
      "api_url": "https://tabby.ai/s/1i6xm4l",
      "token": null,
      "flow": "web",
      "payment": {
        "id": "3a769eec-19f7-45ab-830a-68d48134322c",
        "created_at": "2022-02-28T08:25:12Z",
        "expires_at": "2022-02-28T08:44:12Z",
        "test": true,
        "is_expired": false,
        "status": "CREATED",
        "cancelable": false,
        "currency": "AED",
        "amount": "100",
        "description": "Just a dest payment",
        "buyer": {
          "id": "",
          "name": "Test Name",
          "email": "successful.payment@tabby.ai",
          "phone": "+971500000001",
          "dob": null
        },
        "product": {
          "type": "",
          "installments_count": 0,
          "installment_period": "P0D"
        },
        "shipping_address": {
          "city": "Dubai",
          "address": "Sample Address #2",
          "zip": ""
        },
        "order": {
          "reference_id": "#xxxx-xxxxxx-xxxx",
          "updated_at": "0001-01-01T00:00:00Z",
          "tax_amount": "100",
          "shipping_amount": "50",
          "discount_amount": "0",
          "items": [
            {
              "reference_id": "SKU123",
              "title": "Pink jersey",
              "description": "Jersey",
              "quantity": 1,
              "unit_price": "300",
              "image_url": "",
              "product_url": "https://tabby.store/p/SKU123"
            }
          ]
        },
        "captures": [],
        "refunds": [],
        "buyer_history": {
          "registered_since": "0001-01-01T00:00:00Z",
          "loyalty_level": 0,
          "wishlist_count": 0,
          "is_social_networks_connected": null,
          "is_phone_number_verified": null,
          "is_email_verified": null
        },
        "order_history": [],
        "meta": null
      },
      "status": "created",
      "customer": {"id": null},
      "juicyscore": {
        "session_id": "",
        "referrer": "",
        "time_zone": "",
        "useragent": ""
      },
      "merchant_urls": {"success": "", "cancel": "", "failure": ""},
      "product_type": null,
      "lang": "ara",
      "sift_session_id": null,
      "merchant": {
        "name": "Eyewa",
        "address": "a, a",
        "logo":
            "https://storage.googleapis.com/tabby-assets/asset-20201110-f70e7eba-ecec-42c7-843b-44878bb844d7.png"
      },
      "merchant_code": "",
      "terms_accepted": false
    };
  }
}
