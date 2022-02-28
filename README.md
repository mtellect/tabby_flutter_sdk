<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart
const like = 'sample';

  void testTabby() async {
    final tabbySdk = Tabby.TabbyFlutterSdk();
    tabbySdk.setApiKey("pk_test_151a3aa8-1675-4441-bfea-b8ba9d880bfe");

    final payload = Tabby.TabbyCheckoutPayload(
        merchantCode: "eyewa",
        lang: Tabby.Language.en,
        payment: Tabby.Payment(
            amount: "100",
            description: "Just a dest payment",
            currency: Tabby.Currency.AED,
            buyer: Tabby.Buyer(
                email: "successful.payment@tabby.ai",
                phone: "500000001",
                name: "Test Name"),
            order: Tabby.Order(
                referenceId: "#xxxx-xxxxxx-xxxx",
                items: [
                  Tabby.OrderItem(
                      description: "Jersey",
                      productUrl: "https://tabby.store/p/SKU123",
                      quantity: 1,
                      referenceId: "SKU123",
                      title: "Pink jersey",
                      unitPrice: "300")
                ],
                shippingAmount: "50",
                taxAmount: "100"),
            shippingAddress: Tabby.ShippingAddress(
                address: "Sample Address #2", city: "Dubai")));

    tabbySdk.makePayment(context, payload).then((value) {
      print("tabbySdk result $value");

      if (value == Tabby.TabbyResult.authorized) {
        showToast(context, "Payment has been authorized", success: true);
        return;
      }
      showToast(
        context,
        "Payment is ${value.name}",
      );
    });
  }

```

## Additional information

TODO: Tell users more about the package: where to find more information, how to 
contribute to the package, how to file issues, what response they can expect 
from the package authors, and more.
