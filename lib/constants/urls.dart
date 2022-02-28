part of 'package:tabby_flutter_sdk/tabby_flutter_sdk.dart';

enum Language { en, ar }

Map<Language, String> webViewUrls = {
  Language.en: 'https://checkout.tabby.ai/promos/product-page/installments/en/',
  Language.ar: 'https://checkout.tabby.ai/promos/product-page/installments/ar/',
};

String? getWebViewUrls(Language language) {
  return webViewUrls[language];
}

// export const webViewUrls = {
//   en: 'https://checkout.tabby.ai/promos/product-page/installments/en/',
//   ar: 'https://checkout.tabby.ai/promos/product-page/installments/ar/',
// };
