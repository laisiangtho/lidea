library data.core;

import 'package:flutter/material.dart';

// NOTE: Preference
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// NOTE: Authentication
// import 'package:lidea/firebase/auth.dart';
import 'package:lidea/unit/authenticate.dart';

// NOTE: Core notify and Initializing properties
import 'package:lidea/unit/core.dart';

// NOTE: Analytics
import 'package:lidea/unit/analytics.dart';

// NOTE: Store
import 'package:lidea/unit/store.dart';

// NOTE: view ???
import 'package:lidea/view/main.dart' show ViewScroll, ViewData;
export 'package:lidea/view/main.dart';

// NOTE: route
import '/view/routes.dart' show RouteDelegate;
// show MainDelegate, NestDelegate, NestedView, RouteNotifier, RouteParser
export '/view/routes.dart';

// NOTE: scroll ???
// import '../unit/view.md' show ScrollNotifier;
// export '../unit/view.md' show ScrollNotifier;

// NOTE: Nest and Type
import '/type/main.dart';
export '/type/main.dart';

part 'abstract.dart';
part 'mock.dart';
part 'search.dart';
part 'view.dart';

part 'preference.dart';
part 'authenticate.dart';
part 'analytics.dart';

part 'store.dart';

class Core extends _Search {
  Future<void> initialized(BuildContext context) async {
    Stopwatch initWatch = Stopwatch()..start();
    preference.setContext(context);

    await Future.delayed(const Duration(milliseconds: 1000));

    // await Future.microtask(() => null);

    await prepareInitialized();

    await store.init();
    // await sql.init();
    // await poll.init();

    // await mockTest();

    data.suggestQuery = data.searchQuery;
    // switchIdentifyPrimary();

    // await primaryInit.catchError((e) {
    //   debugPrint('scripturePrimary: $e');
    // });

    // switchIdentifyParallel();

    // await scriptureParallel.init().catchError((e) {
    //   debugPrint('scriptureParallel: $e');
    // });

    message.value = '';

    debugPrint('Initiated in ${initWatch.elapsedMilliseconds} ms');
  }
}
