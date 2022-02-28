library tabby_flutter_sdk;

import 'dart:ui';

import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter/gestures.dart';

part 'constants/urls.dart';
part 'constants/payment.dart';
part 'widgets/tabby_payment.dart';
part 'widgets/tabby_payment_webview.dart';
part 'utils/colors.dart';
part 'utils/currency_translator.dart';
part 'utils/edge_alert.dart';
part 'utils/navigation.dart';
part 'utils/size.dart';
part 'utils/gap.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

/*
export type TabbySession = {
sessionId: string;
paymentId: string;
availableProducts: TabbyProduct[];
};
*/

class TabbySession {
  final String sessionId;
  final String paymentId;
  final List<TabbyProduct> availableProducts;

  TabbySession(
      {required this.sessionId,
      required this.paymentId,
      required this.availableProducts});
}

/*
export type TabbyProduct = {
type: TabbyPurchaseType;
webUrl: string;
};
*/

class TabbyProduct {
  final TabbyPurchaseType type;
  final String webUrl;

  TabbyProduct({required this.type, required this.webUrl});
}

class TabbyFlutterSdk {
  // private static apiHost: string = 'https://api.tabby.ai/api/v2/checkout';
  // public apiKey: string | null = null;

  static String apiHost = 'https://api.tabby.ai/api/v2/checkout';
  late String apiKey;

/*
public setApiKey(withApiKey: string) {
  this.apiKey = withApiKey;
  }
  */

  void setApiKey(String withApiKey) {
    apiKey = withApiKey;
  }

  Future<TabbyResult> makePayment(
      BuildContext context, TabbyCheckoutPayload payload) async {
    final response =
        await pushSheetRawResponse(context, TabbyPayment(payload: payload));
    if (null == response) return TabbyResult.close;
    return response;
  }

  Future<CheckoutSession> createSession(TabbyCheckoutPayload payload) async {
    print(jsonEncode(payload.json));

    final response = await http.post(Uri.parse(apiHost),
        headers: {
          "Accept": 'application/json',
          'Content-Type': 'application/json',
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode(payload.json));

    print(response.body);

    if (response.statusCode != HttpStatus.ok) {
      throw '⛔️ Error creating session';
    }
    Map json = jsonDecode(response.body);
    return CheckoutSession.fromJson(json);
  }
}

// void main() {}
