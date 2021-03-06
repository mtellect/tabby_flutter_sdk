# TabbyFlutterSdk

## Features
Shop now.
Pay later.
Earn cash.
With tabby, shopping is more rewarding. Split your purchases into 4 interest-free payments or earn cashback at your favourite stores (or both).


## Getting started

Get in touch && get your ApiKeys for Tabby [Visit Tabby website](https://tabby.ai/)


TODO: List prerequisites and provide or point to information on how to
start using the package.

## How to use

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder. 

```dart

  void testTabby() async {
    final tabbySdk = Tabby.TabbyFlutterSdk();
    tabbySdk.setApiKey("Your Public Key");

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
