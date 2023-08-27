part of 'domain_name_suggestions_bloc.dart';

@immutable
abstract class DomainNameSuggestionsEvent {}

class FetchSuggestionsEvent extends DomainNameSuggestionsEvent {
  final String keyword;

  FetchSuggestionsEvent(this.keyword);
}

class CheckDomainAvailabilityEvent extends DomainNameSuggestionsEvent {
  final String domainName;

  CheckDomainAvailabilityEvent(this.domainName);
}

class InitializeSuggestionsEvent extends DomainNameSuggestionsEvent {
  final List<String> suggestions;

  InitializeSuggestionsEvent(this.suggestions);
}

class CheckDomainAvailabilitySuccess extends DomainNameSuggestionsEvent {
  final String domainName;
  final bool isAvailable;

  CheckDomainAvailabilitySuccess({
    required this.domainName,
    required this.isAvailable,
  });
}

class CheckDomainAvailabilityError extends DomainNameSuggestionsEvent {
  final String domainName;
  final String error;

  CheckDomainAvailabilityError({
    required this.domainName,
    required this.error,
  });
}