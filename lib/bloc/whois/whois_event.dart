part of 'whois_bloc.dart';

abstract class WhoisEvent {}

class FetchWhois extends WhoisEvent {
  final String domainName;

  FetchWhois(this.domainName);
}

class ResetWhois extends WhoisEvent {}
