import 'dart:async';
import 'dart:developer';

import 'package:easy_dictionary_latest/Provider/premium_feature_controller.dart';
import 'package:easy_dictionary_latest/Screen/mainPage.dart';
import 'package:easy_dictionary_latest/main.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';

class InAppPurchaseController with ChangeNotifier {
  final InAppPurchase inAppPurchaseInstance;
  PremiumFeatureController _premiumFeatureController;
  static final Logger _log = Logger('InAppPurchases');

  InAppPurchaseController({
    required this.inAppPurchaseInstance,
    required PremiumFeatureController premiumFeatureController,
  }) : _premiumFeatureController = premiumFeatureController;

  // Use this controller to access PremiumFeatureController logic
  PremiumFeatureController get premiumC => _premiumFeatureController;

  // Product IDs
  final Set<String> _inAppPurchaseId = {
    "aidictionary_monthly",
    "aidictionary_yearly"
  };

  bool isYearlyPurchased = false;
  bool isMonthlyPurchased = false;

  String data = "";
  bool isLoaded = false;

  List<ProductDetails> productDetailsList = [];

  ProductDetails? monthlyProduct;
  ProductDetails? yearlyProduct;
  bool isMonthlyFreeTrial = false;
  bool isYearlyFreeTrial = false;

  // Subscription stream
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> getData() async {
    try {
      isLoaded = true;
      notifyListeners(); // Notify listeners about state change

      final response =
          await inAppPurchaseInstance.queryProductDetails(_inAppPurchaseId);

      if (response.productDetails.isNotEmpty) {
        productDetailsList.clear();
        for (var product in response.productDetails) {
          productDetailsList.add(product);
          if (product.id == 'aidictionary_monthly' &&
              !product.price.contains("Free")) {
            monthlyProduct = product;
          } else if (product.id == 'aidictionary_yearly' &&
              !product.price.contains("Free")) {
            yearlyProduct = product;
          }
          if (product.id == 'aidictionary_monthly' &&
              product.price.contains("Free")) {
            isMonthlyFreeTrial = true;
          } else if (product.id == 'aidictionary_yearly' &&
              product.price.contains("Free")) {
            isYearlyFreeTrial = true;
          }
        }

        // Assuming PremiumFeatureController handles the premium plan selection
        premiumC.changeSelectedPlan(monthlyProduct!.id);
      } else {
        data = "No Plan Found!";
      }
    } catch (e) {
      data = "Error fetching product details: $e";
      _log.severe("Error in getData(): $e");
    }

    isLoaded = false;
    notifyListeners(); // Notify listeners when data is loaded
  }

  Future<void> buy(String inAppPurchaseId) async {
    if (!await inAppPurchaseInstance.isAvailable()) {
      _reportError('InAppPurchase.instance not available');
      return;
    }

    final response =
        await inAppPurchaseInstance.queryProductDetails({inAppPurchaseId});
    if (response.error != null) {
      _reportError(
          'There was an error when making the purchase: ${response.error}');
      return;
    }

    if (response.productDetails.isEmpty) {
      _reportError('No product details found for $inAppPurchaseId');
      return;
    }

    final productDetails = response.productDetails[0];
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    try {
      final success = await inAppPurchaseInstance.buyNonConsumable(
          purchaseParam: purchaseParam);
      log('buyNonConsumable() request was sent with success: $success');
    } catch (e) {
      _log.severe('Error in buying product: $e');
    }
  }

  Future<void> restorePurchases() async {
    if (!await inAppPurchaseInstance.isAvailable()) {
      _reportError('InAppPurchase.instance not available');
      return;
    }

    try {
      await inAppPurchaseInstance.restorePurchases();
      log('Purchases restored');
      notifyListeners();
    } catch (e) {
      _log.severe('Could not restore purchases: $e');
    }
  }

  void initialize() {
    _subscription?.cancel();
    _subscription = inAppPurchaseInstance.purchaseStream.listen(
      (purchaseDetailsList) {
        listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (dynamic error) {
        _log.severe('Error occurred in purchaseStream: $error');
      },
    );
  }

  Future<void> listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (!_inAppPurchaseId.contains(purchaseDetails.productID)) {
        log("The product ID '${purchaseDetails.productID}' is not implemented.");
        // continue;
      }

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.purchased:
          if (purchaseDetails.productID == "aidictionary_monthly") {
            if (purchaseDetails.status == PurchaseStatus.purchased) {
              isMonthlyPurchased = true;
              // Navigate without context
              navigatorKey.currentState
                  ?.pushReplacementNamed(MainPage.routeName);
            }

            log('Subscribed to Monthly offer: ${purchaseDetails.productID}');
          } else if (purchaseDetails.productID == "aidictionary_yearly") {
            if (purchaseDetails.status == PurchaseStatus.purchased) {
              isYearlyPurchased = true;
              // Navigate without context
              navigatorKey.currentState
                  ?.pushReplacementNamed(MainPage.routeName);
              log('Subscribed to Yearly offer: ${purchaseDetails.productID}');
            }
          }
        case PurchaseStatus.restored:
          if (purchaseDetails.productID == "aidictionary_monthly") {
            if (purchaseDetails.status == PurchaseStatus.restored) {
              isMonthlyPurchased = true;
              log('Subscribed to Monthly offer: ${purchaseDetails.productID}');
            }
          } else if (purchaseDetails.productID == "aidictionary_yearly") {
            if (purchaseDetails.status == PurchaseStatus.restored) {
              isYearlyPurchased = true;
              log('Subscribed to Yearly offer: ${purchaseDetails.productID}');
            }
          }
          break;
        case PurchaseStatus.error:
          log('Purchase error: ${purchaseDetails.error}');
          break;
        case PurchaseStatus.canceled:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await inAppPurchaseInstance.completePurchase(purchaseDetails);
      }

      // Notify listeners after processing purchase details
      notifyListeners();
    }
  }

  void _reportError(String message) {
    _log.severe(message);
    log(message);
  }
}
