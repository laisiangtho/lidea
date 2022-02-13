import 'package:lidea/hive.dart';
import 'package:lidea/util/main.dart';
import 'package:lidea/extension.dart';

part 'environment.dart';
part 'query.dart';
part 'product.dart';

part 'setting.dart';
part 'purchase.dart';
part 'recent_search.dart';

/// SuggestionType<Map<String, Object?>>;
/// ConclusionType<OfRawType>;
/// ConclusionRawType; SuggestionRawType
/// type: 0 = track, 1 = album, 2 = artist
class OfRawType {
  final String term;
  final int count;
  final int limit;
  final int type;

  /// List of int
  final List<int> kid;

  /// List of String
  final List<String> uid;

  // indexs ids uid uid, kid kid

  OfRawType({
    this.term = '',
    this.count = 0,
    this.limit = 0,
    this.type = 0,
    this.kid = const [],
    this.uid = const [],
  });
}
