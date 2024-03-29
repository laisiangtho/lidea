import 'dart:async';

import 'package:sqflite/sqflite.dart';

// import 'package:lidea/nest/main.dart';
// import 'package:lidea/type/main.dart';

// String queryCountTable = "SELECT count(*) as count FROM sqlite_master WHERE type = 'table';";
abstract class UnitSQLite {
  // final DataNest data;

  // UnitSQLite({required this.data});

  String queryDatabaseList = 'PRAGMA database_list;';

  Database? _instance;
  Database get client => _instance!;

  Future<Database> get db async {
    _instance ??= await init();
    return _instance!;
  }

  Future<String> get file async => '';
  Future<int> get version async => 1;

  FutureOr<Database> init() async {
    return await openDatabase(
      await file,
      version: await version,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
      // readOnly: false,
      // singleInstance: false,
    );
  }

  Future<String> get databasePath => getDatabasesPath();

  // SqfliteDatabaseException (DatabaseException(Cannot perform this operation because there is no current transaction.) sql 'COMMIT' args [])
  FutureOr<void> onConfigure(Database e) async {
    // ALTER TABLE table_name ADD PRIMARY KEY(col1, col2,...)
    // await doIndex(e);
  }

  FutureOr<void> onCreate(Database e, int v) {
    return doIndex(e);
  }

  FutureOr<void> onUpgrade(Database e, int ov, int nv) {
    return doIndex(e);
  }

  FutureOr<void> onDowngrade(Database e, int ov, int nv) {
    return doIndex(e);
  }

  /// doIndex executed onConfigure, onCreate, onUpgrade and onDowngrade by default
  Future<void> doIndex(Database e) async {
    // await e.transaction((txn) async {
    //   Batch batch = txn.batch();
    //   batch.execute(_wordContext.createIndex!);
    //   debugPrint('e.onDowngrade');
    //   await batch.commit(noResult: true);
    // });
  }

  /// `PRAGMA database_list;`
  /// `{seq: 0, name: main, file: /}`
  /// `DETACH DATABASE ?;` `ATTACH DATABASE / as ?;`
  FutureOr<void> onOpen(Database e) async {
    // final ath = await e.rawQuery(queryDatabaseList);
    // Batch batch = e.batch();
    // for (var item in collection.secondary) {
    //   // final bool notAttached = ath.firstWhere((e) => e['name'] == item.uid, orElse:()=> null) == null;
    //   final notAttached = ath.firstWhere(
    //     (e) => e['name'].toString() == item.uid,
    //     orElse: () => <String, dynamic>{},
    //   );
    //   if (notAttached.isEmpty) {
    //     String _filePath = await UtilDocument.fileName(item.local);
    //     // await db.rawQuery("DETACH DATABASE ${item.uid};");
    //     await db.rawQuery("ATTACH DATABASE '$_filePath' AS ${item.uid};").then((_) {
    //       if (item.createIndex != null && item.createIndex!.isNotEmpty) {
    //         // PRAGMA INDEX_LIST('table_name');
    //         // final ath = await db.rawQuery("PRAGMA INDEX_LIST('${item.uid}');");
    //         // debugPrint('createIndex $ath');
    //         batch.execute(item.createIndex!);
    //       }
    //     }).catchError((e) {
    //       debugPrint(e.toString());
    //     });
    //   } else {
    //     // debugPrint('attached ${item.local}');
    //   }
    // }
    // await batch.commit(noResult: true);
  }

  // Future<void> test() async {
  //   Stopwatch stopwatch = new Stopwatch()..start();
  //   try {
  //     // await client.transaction((txn) async {
  //     //   Batch batch = txn.batch();
  //     //   for (APIType item in collection.env.secondary) {
  //     //     if (item.createIndex != null && item.createIndex.isNotEmpty){
  //     //       debugPrint('item.createIndex ${item.createIndex}');
  //     //       batch.execute(item.createIndex);
  //     //     }
  //     //   }
  //     //   await batch.commit(noResult: true);
  //     // });
  //     // await client.rawQuery("SELECT count(*) as count FROM sense.sqlite_master WHERE type = 'table';").then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //     // sense.list_sense
  //     // await client.rawQuery("SELECT * FROM $_senseTable LIMIT 1;").then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //     // await search('love').then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //     // await rootWord('love').then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e);
  //     //   // debugPrint(e.toString());
  //     // });
  //     // await baseWord('loved').then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //     await thesaurus('love').then(
  //       (v) {
  //         debugPrint(v.toString());
  //       }
  //     ).catchError((e){
  //       debugPrint(e.toString());
  //     });
  //     // var client = await this.db;
  //     // await client.rawQuery("SELECT * FROM $_wordTable LIMIT 1").then(
  //     //   (v) {
  //     //     debugPrint(v.toString());
  //     //   }
  //     // ).catchError((e){
  //     //   debugPrint(e.toString());
  //     // });
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  //   debugPrint('sql.test() executed in ${stopwatch.elapsedMilliseconds} Milliseconds');
  // }

  /// get suggestion
  // Future<List<Map<String, Object?>>> suggestion() async {
  //   // return await _instance.query(_senseTable, columns:['word'],where: 'word LIKE ?',whereArgs: [keyword+'%'] ,orderBy: 'word',limit: 10);
  //   // return await _instance.rawQuery("SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word LIMIT 10;",[keyword+'%']);
  //   return await db.then(
  //     (e) => e.rawQuery(
  //       "SELECT word FROM $_senseTable WHERE word LIKE ? GROUP BY word ORDER BY word ASC LIMIT 30;",
  //       ['$suggestQuery%'],
  //     ),
  //   );
  // }

  /// get definition
  // Future<List<Map<String, Object?>>> search(String keyword) async {
  //   return await db.then(
  //     (e) => e.rawQuery(
  //       "SELECT word, wrte, sense, exam FROM $_senseTable WHERE word LIKE ? ORDER BY wrte, wseq;",
  //       [keyword],
  //     ),
  //   );
  // }

  /// get root
  /// [d.word, c.wrte, c.dete, c.wirg, w.word AS derived]
  // Future<List<Map<String, Object?>>> rootWord(String keyword) async {
  //   var client = await db;
  //   return client.rawQuery(
  //     """SELECT
  //       d.word, c.wrte, c.dete, c.wirg, w.word AS derived
  //     FROM $_wordTable AS w
  //       INNER JOIN $_deriveTable c ON w.id = c.wrid
  //         INNER JOIN $_wordTable d ON c.id = d.id
  //     WHERE w.word = ?;
  //     """,
  //     [keyword],
  //   );
  // }

  /// get base
  /// [w.word, c.wrte, c.dete, c.wirg, d.word AS derived]
  // Future<List<Map<String, Object?>>> baseWord(String keyword) async {
  //   var client = await db;
  //   return client.rawQuery(
  //     """SELECT
  //       w.word, c.wrte, c.dete, c.wirg, d.word AS derived
  //     FROM $_wordTable AS w
  //       INNER JOIN $_deriveTable c ON w.id = c.id
  //         INNER JOIN $_wordTable d ON c.wrid = d.id
  //     WHERE w.word = ?;
  //     """,
  //     [keyword],
  //   );
  // }

  /// get thesaurus
  /// [w.id AS root, c.wlid AS wrid, d.word, d.derived]
  // Future<List<Map<String, Object?>>> thesaurus(String keyword) async {
  //   var client = await db;
  //   return client.rawQuery(
  //     """SELECT
  //       d.word, d.derived
  //     FROM $_wordTable AS w
  //       INNER JOIN $_thesaurusTable c ON w.id = c.wrid
  //         INNER JOIN $_wordTable d ON c.wlid = d.id
  //     WHERE w.word = ?;
  //     """,
  //     [keyword],
  //   );
  // }

  /// sqlite_master
  /// sense.sqlite_master
  /// thesaurus.sqlite_master
  Future<List<Map<String, Object?>>> checkTypeIndex({String table = ''}) async {
    await db;
    // return client.rawQuery('SELECT * FROM ? WHERE type =?;', [_senseTable, 'index']);
    var name = table.isEmpty ? 'sqlite_master' : '$table.sqlite_master';
    return client.query(
      name,
      columns: ['*'],
      where: 'type =?',
      whereArgs: ['index'],
    );
  }

  /// temp: get number of tables
  Future<List<Map<String, Object?>>> countTable() async {
    var client = await db;
    // return db.then(
    //   (e) => e.rawQuery(
    //     "SELECT count(*) as count FROM sqlite_master WHERE type = 'table';",
    //   ),
    // );
    return client.rawQuery("SELECT count(*) as count FROM sqlite_master WHERE type = 'table';");
  }
}
