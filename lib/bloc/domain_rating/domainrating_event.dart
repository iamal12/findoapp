part of 'domainrating_bloc.dart';

abstract class DomainRatingEvent {}

class FetchDomainRating extends DomainRatingEvent {
  final String domain;

  FetchDomainRating(this.domain);
}