part of 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart';

class TabbyPayment extends StatefulWidget {
  const TabbyPayment({Key? key, required this.payload}) : super(key: key);

  final TabbyCheckoutPayload payload;

  @override
  _TabbyPaymentState createState() => _TabbyPaymentState();
}

class _TabbyPaymentState extends State<TabbyPayment> {
  late WebViewController webViewController;
  List<StreamSubscription> subs = [];

  late String loadUrl;
  bool isBusy = true;
  bool hasError = false;
  String errorMessage = "";

  final tabbySdk = TabbyFlutterSdk();
  late TabbyCheckoutPayload payload;
  late CheckoutSession checkoutSession;

  List get cardColors => [
        {"title": "Installments", "color": primaryColor300},
        {"title": "PayLater", "color": orangeColor400},
        {"title": "MonthlyBilling", "color": textColor300},
      ];

  int selectedCardColor = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payload = widget.payload;
    tabbySdk.setApiKey("pk_test_151a3aa8-1675-4441-bfea-b8ba9d880bfe");

    createSession();
  }

  @override
  dispose() {
    super.dispose();
    // for (var s in subs) s?.cancel();
  }

  createSession() async {
    try {
      checkoutSession = await tabbySdk.createSession(payload);
      isBusy = false;
      if (mounted) setState(() {});
    } catch (e) {
      isBusy = false;
      hasError = true;
      errorMessage = e.toString();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getScreenHeight(context, .6)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.2),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          addGapHeight(20),
          Text(
            "How do you want to pay?",
            style: TextStyle(
                fontSize: 20,
                // fontFamily: "PPMonumentExtended",
                fontWeight: FontWeight.w500),
          ),
          addGapHeight(10),
          Expanded(
            child: Builder(builder: (c) {
              if (isBusy) {
                return Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                    ),
                  ),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    List.generate(checkoutSession.configuration.length, (p) {
                  final config = checkoutSession.configuration[p];
                  bool active = selectedCardColor == p;
                  final color = cardColors[p]["color"];
                  final title = cardColors[p]["title"];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        selectedCardColor = active ? -1 : p;
                        setState(() {});
                      },
                      child: Container(
                        height: 120,
                        // width: 100,
                        margin: EdgeInsets.all(10),
                        child: Material(
                          shadowColor: active ? color : Colors.transparent,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                  color: active
                                      ? color
                                      : Colors.black.withOpacity(.09))),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: active
                                        ? color
                                        : Colors.black.withOpacity(.09)),
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      color: color, shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.check_circle_outline,
                                    size: 20,
                                    color: Colors.white
                                        .withOpacity(active ? 1 : 0),
                                  ),
                                ),
                                addGapHeight(5),
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: textColor300),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
          addGapHeight(10),
          if (selectedCardColor != -1)
            Container(
              height: 60,
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  final key = checkoutSession.configuration.keys
                      .toList()[selectedCardColor];
                  final productConfig =
                      checkoutSession.configuration[key]!.first;

                  pushSheet(context,
                      TabbyPaymentWebView(loadUrl: productConfig.webUrl),
                      result: (_) {
                    Navigator.pop(context, _);
                  });
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    // padding: Edgei,
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                child: Center(
                    child: Text(
                  "PAY ${payload.payment.amount}(${describeEnum(payload.payment.currency)} )",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
              ),
            )
        ],
      ),
    );
  }
}
