library lidea.type;

// import 'package:rxdart/rxdart.dart';
// import 'package:intl/intl.dart';
// import 'package:intl/date_symbol_data_local.dart';
export 'package:lidea/firebase/core.dart';
export 'package:lidea/firebase/firestore.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lidea/hive.dart';
import 'package:lidea/nest/main.dart';
import 'package:lidea/extension.dart';
import 'package:lidea/audio.dart';

part 'environment.dart';
part 'query.dart';
part 'product.dart';
part 'audio.dart';
part 'gist.dart';
part 'poll.dart';
part 'user.dart';

part 'box/main.dart';
// NOTE: typeId: 100
part 'box/settings.dart';
// NOTE: typeId: 101
part 'box/recent_search.dart';
// NOTE: typeId: 102 (dictionary)
part 'box/favorite_word.dart';
// NOTE: typeId: 103 (music, dictionary)
part 'box/purchases.dart';
