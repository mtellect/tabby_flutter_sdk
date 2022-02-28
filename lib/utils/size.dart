part of 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart';

double getScreenWidth(BuildContext context, [double ratio = 1]) {
  return (MediaQuery.of(context).size.width) * ratio;
}

double getScreenHeight(BuildContext context, [double ratio = 1]) {
  return (MediaQuery.of(context).size.height) * ratio;
}
