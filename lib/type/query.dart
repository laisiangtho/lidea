part of 'main.dart';

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
