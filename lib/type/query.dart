part of 'main.dart';

/// This use to format search suggestion type
class SuggestionType {
  final String query;
  final List<Map<String, Object?>> raw;
  const SuggestionType({
    this.query = '',
    this.raw = const [],
  });
}

/// This use to format search result type
class ConclusionType {
  final String query;
  final List<Map<String, dynamic>> raw;
  const ConclusionType({
    this.query = '',
    this.raw = const [],
  });
}
