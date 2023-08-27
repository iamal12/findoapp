part of 'domain_name_suggestions_bloc.dart';

@immutable
abstract class DomainNameSuggestionsState {}

class DomainNameSuggestionsInitial extends DomainNameSuggestionsState {}

class DomainNameSuggestionsLoading extends DomainNameSuggestionsState {}

class DomainNameSuggestionsLoaded extends DomainNameSuggestionsState {
  final List<String> suggestions;
  final Map<String, bool> availabilityStatus;
  DomainNameSuggestionsLoaded({
    required this.suggestions,
    required this.availabilityStatus,
  });

  @override
  List<Object> get props => [suggestions, availabilityStatus];
}

class DomainNameSuggestionsError extends DomainNameSuggestionsState {
  final String error;

  DomainNameSuggestionsError({required this.error});
}
