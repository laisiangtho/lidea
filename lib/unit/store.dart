import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import "package:lidea/type/main.dart";

// enum productDetail { item, hasPurchased, title, description }

abstract class UnitStore {
  late void Function() notify;

  late bool kAutoConsume;
  late List<ProductsType> kProducts;

  // String get offlineAccessId => kProducts.firstWhere((e) => e.name == "offline").cart;
  // org: _kConsumableId: consumable
  // String get consumableId => kProducts.firstWhere((e) => e.name == "donate").cart;
  // org: _kUpgradeId: upgrade
  // String get upgradeId => kProducts.firstWhere((e) => e.name == "upgrade").cart;

  // String get _silverSubscription => kProducts.firstWhere((e) => e.name == "silver").cart;
  // String get _goldSubscription => kProducts.firstWhere((e) => e.name == "gold").cart;

  /// List of ProductId
  late final List<String> _kProductIds = kProducts.map((e) => e.cart).toList();

  /// By ProductId
  ProductsType itemOfProduct(String id) => kProducts.firstWhere((e) => e.cart == id);

  /// List of consumable ProductId NOT PurchaseId
  late final _kConsumableIds = kProducts
      .where(
        (e) => e.type == "consumable",
      )
      .map(
        (e) => e.cart,
      );

  /// By ProductId, if id is type of consumable
  bool isConsumable(String productId) => _kConsumableIds.contains(productId);

  /// @override to check Purchase by PurchaseId
  MapEntry<dynamic, PurchaseType> purchaseDataExist(String? purchaseId) {
    return MapEntry(null, PurchaseType());
  }

  /// @override to delete Purchase by PurchaseId
  bool purchaseDataDelete(String purchaseId) {
    return purchaseId.isNotEmpty;
  }

  /// @override to add Purchase data
  void purchaseDataInsert(PurchaseType value) {}

  /// @override to clear Purchase data, use only when restore
  /// to reset test purchase data, refund
  /// by default, return 0
  Future<int> purchaseDataClear() {
    return Future.value(0);
  }

  Future<void> doConsume(String purchaseId) async {
    // await ConsumableStore.consume(purchaseId);
    // final List<String> consumables = await ConsumableStore.load();
    // // setState(() { });
    // _consumables = consumables;
    purchaseDataDelete(purchaseId);
    notify();
  }

  Future<void> doRestore() async {
    await purchaseDataClear();
    await _api.restorePurchases();
    // notify();
  }

  ProductDetails? productItem(String productId) {
    final items = listOfProductDetail.where((e) => e.id == productId);
    if (items.isNotEmpty) {
      return items.first;
    }
    return null;
  }

  ProductDetails? productButton(String productId) {
    final item = productItem(productId);
    if (item != null) {
      if (!purchasedCheck(item.id)) {
        return item;
      }
    }
    return null;
  }

  Future<void> doPurchase(ProductDetails item) async {
    late PurchaseParam param;

    _processing(item.id);

    if (Platform.isAndroid) {
      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
      // verify the latest status of you your subscription by using server side receipt validation
      // and update the UI accordingly. The subscription purchase status shown
      // inside the app may not be accurate.
      final oldSubscription = _getOldSubscription(item);

      param = GooglePlayPurchaseParam(
          productDetails: item,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                  prorationMode: ProrationMode.immediateWithTimeProration,
                )
              : null);
    } else {
      param = PurchaseParam(productDetails: item, applicationUserName: null);
    }

    if (isConsumable(item.id)) {
      // debugPrint('buyConsumable: ${item.id}');
      _api.buyConsumable(
        purchaseParam: param,
        autoConsume: kAutoConsume || Platform.isIOS,
      );
    } else {
      // debugPrint('buyNonConsumable ${item.id}');
      _api.buyNonConsumable(purchaseParam: param);
    }
  }

  /// This loading previous purchases code is just a demo. Please do not use this as it is.
  /// In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
  /// We recommend that you use your own server to verify the purchase data.
  Map<String, PurchaseDetails> get purchasedItem {
    return Map.fromEntries(
      listOfPurchaseDetail.map(
        (PurchaseDetails item) {
          if (item.pendingCompletePurchase) {
            _api.completePurchase(item);
          }
          return MapEntry<String, PurchaseDetails>(item.productID, item);
        },
      ),
    );
  }

  bool purchasedCheck(String productId) {
    return purchasedItem[productId] != null;
  }

  UnitStore({required this.notify, this.kAutoConsume = true});

  final InAppPurchase _api = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _listener;
  late ProductDetailsResponse _response;

  /// List of productId that are not available
  List<String> get listOfNotFoundId => _response.notFoundIDs;

  /// List of all available products
  List<ProductDetails> get listOfProductDetail => _response.productDetails;
  String get errorMessage => _response.error == null ? '' : _response.error!.message;

  /// List of purchased products??
  List<PurchaseDetails> listOfPurchaseDetail = [];

  bool isPending = false;
  bool isLoading = true;
  final List<String> listOfProcess = [];
  bool isAvailable = false;

  Future<void> init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated = _api.purchaseStream;
    _listener = purchaseUpdated.listen((purchaseDetailsList) {
      _listenPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _listener.cancel();
    }, onError: (error) {
      // handle error here.
    });

    isAvailable = await _api.isAvailable();
    isLoading = false;

    if (isAvailable) {
      if (Platform.isIOS) {
        final ios = _api.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await ios.setDelegate(ExamplePaymentQueueDelegate());
      }

      _response = await _api.queryProductDetails(_kProductIds.toSet());
    }

    notify();
  }

  void dispose() {
    if (Platform.isIOS) {
      final ios = _api.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      ios.setDelegate(null);
    }
    _listener.cancel();
  }

  void _listenPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    isPending = false;
    purchaseDetailsList.forEach((PurchaseDetails item) async {
      if (item.status == PurchaseStatus.pending) {
        isPending = true;
        handlePending(item.productID);
      } else {
        if (item.status == PurchaseStatus.error) {
          handleError(item.error!);
        } else if (item.status == PurchaseStatus.purchased ||
            item.status == PurchaseStatus.restored) {
          bool valid = await verifyPurchase(item);
          if (valid) {
            handleDeliverProduct(item);
          } else {
            invalidPurchase(item);
          }
        }
        if (Platform.isAndroid) {
          // if (kAutoConsume && isConsumable(item.productID)) {}
          // working
          if (isConsumable(item.productID)) {
            final android = _api.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
            await android.consumePurchase(item);
            // debugPrint('auto consumePurchase ${item.productID}');
          }
        }
        if (item.pendingCompletePurchase) {
          await _api.completePurchase(item);
        }
      }
      _processed();
    });
  }

  void _processing(String productId) {
    if (!listOfProcess.contains(productId)) {
      listOfProcess.add(productId);
    }

    notify();
  }

  void _processed() {
    listOfProcess.clear();
    notify();
  }

  void handlePending(String productId) {}

  void handleError(IAPError error) {}

  // IMPORTANT!! Always verify purchase details before delivering the product.
  void handleDeliverProduct(PurchaseDetails item) async {
    final complete = item.pendingCompletePurchase && item.status == PurchaseStatus.purchased;
    final consumable = isConsumable(item.productID);

    if (consumable == false) {
      listOfPurchaseDetail.add(item);
    }

    final hasPurchased = purchaseDataExist(item.purchaseID);
    if (hasPurchased.key == null) {
      purchaseDataInsert(PurchaseType(
        productId: item.productID,
        purchaseId: item.purchaseID,
        completePurchase: complete,
        transactionDate: item.transactionDate,
        // check: is it consumable
        consumable: consumable,
      ));
    }

    notify();
  }

  /// @override to verify purchase. Always verify a purchase before delivering the product.
  Future<bool> verifyPurchase(PurchaseDetails item) {
    return Future<bool>.value(true);
  }

  /// @override to handle invalid purchase, if  `verifyPurchase` failed.
  void invalidPurchase(PurchaseDetails item) {
    _processed();
  }

  /// Useless method for real world app
  Future<void> doConfirmPriceChange() async {
    if (Platform.isAndroid) {
      final android = _api.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      var result = await android.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (result.responseCode == BillingResponse.ok) {
        // debugPrint('Price change accepted');
      } else {
        // debugPrint("Price change failed with code ${result.responseCode}");
      }
    }
    if (Platform.isIOS) {
      final ios = _api.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await ios.showPriceConsentIfNeeded();
    }
  }

  // This is just to demonstrate a subscription upgrade or downgrade.
  // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
  // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
  // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
  // Please remember to replace the logic of finding the old subscription Id as per your app.
  // The old subscription is only required on Android since Apple handles this internally
  // by using the subscription group feature in iTunesConnect.
  // purchasedItem
  // , Map<String, PurchaseDetails> y
  GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails item) {
    return null;

    // GooglePlayPurchaseDetails? oldSubscription;
    // if (item.id == _silverSubscription && purchasedItem[_goldSubscription] != null) {
    //   oldSubscription = purchasedItem[_goldSubscription] as GooglePlayPurchaseDetails;
    // } else if (item.id == _goldSubscription && purchasedItem[_silverSubscription] != null) {
    //   oldSubscription = purchasedItem[_silverSubscription] as GooglePlayPurchaseDetails;
    // }
    // return oldSubscription;
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
