part of '../main.dart';

class BoxOfPurchases<E> extends BoxOfAbstract<PurchasesType> {
  // MapEntry<dynamic, PurchasesType> boxOfPurchaseExistPurchaseId(String? id) {
  //   return PurchasesType.toMap().entries.firstWhere(
  //         (e) => stringCompare(e.value.purchaseId, id!),
  //         orElse: () => MapEntry(null, PurchasesType()),
  //       );
  // }

  // bool boxOfPurchaseDeleteByPurchaseId(String id) {
  //   if (id.isNotEmpty) {
  //     final purchase = boxOfPurchaseExistPurchaseId(id);
  //     if (purchase.key != null) {
  //       // this.boxOfRecentSearch.deleteAt(history.key);
  //       PurchasesType.delete(purchase.key);
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // void boxOfPurchaseInsert({
  //   required String productId,
  //   required String purchaseId,
  //   bool? completePurchase,
  //   required String transactionDate,
  //   bool? consumable,
  // }) {
  //   PurchasesType.add(PurchasesType(
  //     productId: productId,
  //     purchaseId: purchaseId,
  //     completePurchase: completePurchase,
  //     transactionDate: transactionDate,
  //     consumable: consumable,
  //   ));
  // }
}

// item.productID == consumableId
// purchaseID
// transactionDate
// pendingCompletePurchase

@HiveType(typeId: 103)
class PurchasesType {
  @HiveField(0)
  String productId;

  @HiveField(1)
  String? purchaseId;

  @HiveField(2)
  bool? completePurchase;

  @HiveField(3)
  String? transactionDate;

  @HiveField(4)
  bool? consumable;

  PurchasesType({
    this.productId = '',
    this.purchaseId,
    this.completePurchase = false,
    this.transactionDate,
    this.consumable = false,
  });

  factory PurchasesType.fromJSON(Map<String, dynamic> o) {
    return PurchasesType(
      productId: o['productId'] as String,
      purchaseId: o['purchaseId'] as String,
      completePurchase: o['completePurchase'] as bool,
      transactionDate: o['transactionDate'] as String,
      consumable: o['consumable'] as bool,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'productId': productId,
      'purchaseId': purchaseId,
      'completePurchase': completePurchase,
      'transactionDate': transactionDate,
      'consumable': consumable
    };
  }
}

class PurchasesAdapter extends TypeAdapter<PurchasesType> {
  @override
  final int typeId = 103;

  @override
  PurchasesType read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchasesType()
      ..productId = fields[0] as String
      ..purchaseId = fields[1] as String
      ..completePurchase = fields[2] as bool
      ..transactionDate = fields[3] as String
      ..consumable = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, PurchasesType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.purchaseId)
      ..writeByte(2)
      ..write(obj.completePurchase)
      ..writeByte(3)
      ..write(obj.transactionDate)
      ..writeByte(4)
      ..write(obj.consumable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchasesAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
