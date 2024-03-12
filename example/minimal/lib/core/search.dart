part of 'main.dart';

abstract class _Search extends _Mock {
  // SuggestionType? _cacheSuggestion;
  SuggestionType _cacheSuggestion = const SuggestionType();
  ConclusionType _cacheConclusion = const ConclusionType();

  // SuggestionType get cacheSuggestion => const SuggestionType();
  // ConclusionType get cacheConclusion => const ConclusionType();
  /// ```dart
  /// [query: String, raw: List<Map<String, Object?>>]
  /// ```
  /// typeof [SuggestionType]
  // Future<void> suggestionGenerate() async {}
  Future<void> suggestionGenerate() async {
    _cacheSuggestion = SuggestionType(
      query: data.suggestQuery,
    );
  }

  SuggestionType get cacheSuggestion {
    return _cacheSuggestion;
  }

  Future<void> conclusionGenerate() async {
    _cacheConclusion = ConclusionType(
      query: data.searchQuery,
    );
    data.boxOfRecentSearch.update(data.searchQuery);
  }

  ConclusionType get cacheConclusion {
    return _cacheConclusion;
  }
}
