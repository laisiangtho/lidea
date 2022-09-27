part of lidea.type;

abstract class BoxOfAbstract<E> {
  /// Global constant to access Hive.
  late final instance = Hive;

  /// Opens a box.
  late final openBox = instance.openBox;

  /// Register a [TypeAdapter] to announce it to Hive.
  /// ```dart
  /// Hive.registerAdapter(SettingsAdapter())
  /// ```
  late final registerAdapter = instance.registerAdapter;

  // void registerAdapter<T>(TypeAdapter<T> adapter, {bool internal = false, bool override = false}) {
  //   Hive.registerAdapter(adapter, internal: internal, override: override);
  // }

  /// bridge
  String _name = '';

  Box<E> get box => instance.box<E>(_name);

  bool get isOpening => instance.isBoxOpen(_name);
  Future<Box<E>> open(String name) async {
    _name = name;
    if (!instance.isBoxOpen(_name)) {
      await openBox<E>(name);
    }
    return box;
  }

  /// listener
  /// ValueListenable<Box<E>> Function({List<dynamic>? keys})
  late final listen = box.listenable;

  /// Stream<BoxEvent> Function({dynamic key})
  late final watch = box.watch;
  //  get watch => box.watch;

  Iterable<E> get values => box.values;
  Iterable<MapEntry<dynamic, E>> get entries => box.toMap().entries;

  // indexAtValues indexOfValues valuesOfWhere entriesOfWhere valuesOfIndex
  // entryOfWhere
  // entriesOfWhere
  // valuesOfWhere valueOfWhere
  // valuesOfIndex deleteAtIndex indexOfvalues whereAtValues valuesWhere entriesWhere

  Future<void> deleteAtIndex(int index) {
    return box.deleteAt(index);
  }

  Future<void> deleteAtKey(dynamic key) {
    return box.delete(key);
  }

  Future<void> deleteAll(Iterable<dynamic> keys) {
    return box.deleteAll(keys);
  }

  Future<int> clearAll() {
    return box.clear();
  }

  Iterable<E> valuesWhere(bool Function(E) test) {
    return values.where(test);
  }

  // Iterable<MapEntry<dynamic, E>> entriesWhere(bool Function(MapEntry<dynamic, E>) test) {
  //   return entries.where(test);
  // }

  int indexOfvalues(bool Function(E) test) {
    return values.toList().indexWhere(test);
  }

  void tmp() {}

  bool get plural => values.length > 1;

  bool get isEmpty => values.isEmpty;
  bool get isNotEmpty => values.isNotEmpty;

  /// if box should be reorderable, should provide old and new index
  /// where to switch
  void reorderable(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    if (oldIndex == newIndex) return;

    final items = values.toList();
    items.insert(newIndex, items.removeAt(oldIndex));
    box.putAll(items.asMap());

    // final oldItem = box.getAt(oldIndex)!.copyWith(order:oldIndex);
    // final newItem = box.getAt(newIndex)!.copyWith(order:newIndex);
    // box.putAt(oldIndex, newItem);
    // box.putAt(newIndex, oldItem);

    // final items = box.toMap().values.toList();
    // final items = box.values.toList();
    // items.insert(newIndex, items.removeAt(oldIndex));
    // box.putAll(items.asMap());
  }
}

// abstract class BoxOfAbstract<E> {
//   /// bridge
//   final Box<E> box;
//   late Box<E> boxTmp;

//   /// listener
//   /// ValueListenable<Box<E>> Function({List<dynamic>? keys})
//   late final listen = box.listenable;
//   // late final watch = box.watch;
//   Stream<BoxEvent> Function({dynamic key}) get watch => box.watch;

//   BoxOfAbstract(this.box);

//   Future<Box<E>> openBox(String name) async {
//     return boxTmp = await Hive.openBox<E>(name);
//   }

//   Iterable<E> get values => box.values;
//   Iterable<MapEntry<dynamic, E>> get entries => box.toMap().entries;

//   Iterable<E> where(bool Function(E) test) {
//     return values.where(test);
//   }
// }


// class BoxOfTest<E> extends BoxOfAbstractTmp<PurchasesType> {
//   // BoxOfTest(Box<PurchasesType> box) : super(box);
// }

// void tmp() async {
//   // final tmp = BoxOfSettings(await Hive.openBox<SettingsType>('tmp-working'));
//   // final fee = await Hive.openBox<SettingsType>('tmp-working');
//   // final tmps = BoxOfTest<PurchasesType>(await Hive.openBox<PurchasesType>('tmp-working'));
//   // final tmps = BoxOfTest<PurchasesType>(await Hive.openBox<PurchasesType>('tmp-working'));
//   // final tmp1 = BoxOfTest(await Hive.openBox<PurchasesType>('tmp-working'));
//   // final fe = tmps.box.watch();

//   final db = BoxOfTest<SettingsType>();
//   db.open('tmp-working');

//   db.

//   // Stream<BoxEvent>
//   final f1 = tmps.watch;
//   final f2 = tmp1.watch;
// }
