part of 'domainrating_bloc.dart';

@immutable
abstract class DomainRatingState {}

class DomainRatingInitial extends DomainRatingState {}

class DomainRatingLoading extends DomainRatingState {}

class DomainRatingLoaded extends DomainRatingState {
  final int rating;

  DomainRatingLoaded(this.rating);
}

class DomainRatingError extends DomainRatingState {
  final String errorMessage;

  DomainRatingError(this.errorMessage);
}