part of 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart';

class TabbyPaymentWebView extends StatefulWidget {
  final String loadUrl;

  const TabbyPaymentWebView({Key? key, required this.loadUrl})
      : super(key: key);
  @override
  _TabbyPaymentWebViewState createState() => _TabbyPaymentWebViewState();
}

class _TabbyPaymentWebViewState extends State<TabbyPaymentWebView> {
  late WebViewController webViewController;
  List<StreamSubscription> subs = [];

  late String loadUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    loadUrl = widget.loadUrl;
  }

  @override
  dispose() {
    super.dispose();
    // for (var s in subs) s?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: getScreenHeight(context, .1)),
      padding: EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
      ),
      alignment: Alignment.center,
      // padding: EdgeInsets.all(15),
      child: Column(
        children: [
          addGapHeight(20),
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
          Expanded(
            child: WebView(
              initialUrl: loadUrl,
              gestureRecognizers: {
                Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer())
              },
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (wc) {
                webViewController = wc;
                if (mounted) setState(() {});
              },
              onWebResourceError: (e) {},
              javascriptChannels: <JavascriptChannel>{
                javascriptChannelListener(context),
              },
              /*onPageFinished: (String url) {
                          connectGame();
                        },*/
              gestureNavigationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }

  JavascriptChannel javascriptChannelListener(BuildContext context) {
    return JavascriptChannel(
        name: 'tabbyMobileSDK',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
          switch (message.message) {
            case "authorized":
              Navigator.pop(context, TabbyResult.authorized);
              break;
            case "rejected":
              Navigator.pop(context, TabbyResult.rejected);
              break;

            case "close":
              Navigator.pop(context, TabbyResult.close);
              break;
            case "expired":
              Navigator.pop(context, TabbyResult.expired);
          }
        });
  }
}
