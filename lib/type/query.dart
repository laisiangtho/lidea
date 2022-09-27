part of lidea.type;

/// This use to format search suggestion type
/// Map<String, Object?>
class SuggestionType<T> {
  final String query;
  final int total;
  final int type;
  final List<T> raw;

  const SuggestionType({
    this.query = '',
    this.total = 0,
    this.type = 0,
    this.raw = const [],
  });

  bool get emptyQuery => query.isEmpty;
  bool get emptyResult => raw.isEmpty;
}

/// This use to format search result type
/// Map<String, dynamic>
class ConclusionType<T> {
  final String query;
  final List<T> raw;
  const ConclusionType({
    this.query = '',
    this.raw = const [],
  });

  bool get emptyQuery => query.isEmpty;
  bool get emptyResult => raw.isEmpty;
}

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

// /// This use to format search suggestion type
// class SuggestionType {
//   final String query;
//   final List<Map<String, Object?>> raw;
//   const SuggestionType({
//     this.query = '',
//     this.raw = const [],
//   });
// }

// /// This use to format search result type
// class ConclusionType {
//   final String query;
//   final List<Map<String, dynamic>> raw;
//   const ConclusionType({
//     this.query = '',
//     this.raw = const [],
//   });
// }

// class SuggestionTypeModel<T> {
//   final String query;
//   final List<T> raw;
//   const SuggestionTypeModel({
//     this.query = '',
//     this.raw = const [],
//   });
// }

// class SuggestionTypeTest {
//   void abc() {
//     // final ab = SuggestionTypeModel<Map<String, SuggestionType>>();
//     final ac = SuggestionTypeModel<SuggestionType>(query: 'abc', raw: [SuggestionType()] );
//   }
// }
