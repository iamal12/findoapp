import 'package:findo/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DomainNameSuggestionsEvent {}

class GenerateSuggestionsEvent extends DomainNameSuggestionsEvent {
  final String keyword;

  GenerateSuggestionsEvent(this.keyword);
}

class DomainNameSuggestionsState {
  final bool isLoading;
  final List<String> suggestions;

  DomainNameSuggestionsState({
    required this.isLoading,
    required this.suggestions,
  });

  factory DomainNameSuggestionsState.initial() {
    return DomainNameSuggestionsState(
      isLoading: false,
      suggestions: [],
    );
  }

  DomainNameSuggestionsState copyWith({
    bool? isLoading,
    List<String>? suggestions,
  }) {
    return DomainNameSuggestionsState(
      isLoading: isLoading ?? this.isLoading,
      suggestions: suggestions ?? this.suggestions,
    );
  }
}


class DomainNameGenerator {
  static Future<List<String>> generateSuggestions(String keyword) async {
    List<String> suggestions = [];

    for (int i = 1; i < keyword.length; i++) {
      String suffix = keyword.substring(i);
      List<String> words = await ApiService.getWordsStartWith(suffix);
      for (String word in words) {
        String suggestion = keyword + word.substring(suffix.length);
        suggestions.add(suggestion);
      }
    }

    for (int i = 1; i < keyword.length; i++) {
      String prefix = keyword.substring(0, keyword.length - i);
      List<String> words = await ApiService.getWordsEndWith(prefix);
      for (String word in words) {
        String suggestion = word.substring(0, word.length - prefix.length) + keyword;
        suggestions.add(suggestion);
      }
    }

    return suggestions;
  }
}
