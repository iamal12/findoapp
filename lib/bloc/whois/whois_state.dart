part of 'whois_bloc.dart';

@immutable
abstract class WhoisState {}

class WhoisInitial extends WhoisState {}

class WhoisLoading extends WhoisState {}

class WhoisLoaded extends WhoisState {
  final Map<String, dynamic> whoisData;

  WhoisLoaded(this.whoisData);
}

class WhoisError extends WhoisState {
  final String errorMessage;

  WhoisError(this.errorMessage);
}