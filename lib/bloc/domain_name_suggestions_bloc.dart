import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
part 'domain_name_suggestions_event.dart';
part 'domain_name_suggestions_state.dart';

class DomainNameSuggestionsBloc
    extends Bloc<DomainNameSuggestionsEvent, DomainNameSuggestionsState> {
  DomainNameSuggestionsBloc() : super(DomainNameSuggestionsInitial()){
    on<CheckDomainAvailabilityEvent>((event, emit) {
      _handleCheckDomainAvailability(event.domainName, emit);
    });
  }



  @override
  Stream<DomainNameSuggestionsState> mapEventToState(
      DomainNameSuggestionsEvent event,
      ) async* {
    if (event is InitializeSuggestionsEvent) {
      yield* _mapInitializeSuggestionsToState(event.suggestions);
    } else if (event is CheckDomainAvailabilityEvent) {
      yield* _mapCheckDomainAvailabilityToState(event.domainName);
    }
  }

  Stream<DomainNameSuggestionsState> _mapInitializeSuggestionsToState(
      List<String> suggestions,
      ) async* {
    yield DomainNameSuggestionsLoaded(
      suggestions: suggestions,
      availabilityStatus: {}, // Initialize the availabilityStatus map as an empty map
    );
  }

  Stream<DomainNameSuggestionsState> _mapCheckDomainAvailabilityToState(
      String domainName,
      ) async* {
    yield DomainNameSuggestionsLoading();
    try {
      bool isAvailable = await _checkDomainAvailability(domainName);
      if (state is DomainNameSuggestionsLoaded) {
        var currentState = state as DomainNameSuggestionsLoaded;
        yield DomainNameSuggestionsLoaded(
          suggestions: currentState.suggestions,
          availabilityStatus: {
            ...currentState.availabilityStatus,
            domainName: isAvailable,
          },
        );
      }
    } catch (e) {
      yield DomainNameSuggestionsError(error: e.toString());
    }
  }

  Future<void> _handleCheckDomainAvailability(
      String domainName,
      Emitter<DomainNameSuggestionsState> emit,
      ) async {
    emit(DomainNameSuggestionsLoading());
    try {
      bool isAvailable = await _checkDomainAvailability(domainName);
        var currentState = state as DomainNameSuggestionsLoaded;
        emit(DomainNameSuggestionsLoaded(
          suggestions: currentState.suggestions,
          availabilityStatus: {
            ...currentState.availabilityStatus,
            domainName: isAvailable,
          },
        ));

    } catch (e) {
      emit(DomainNameSuggestionsError(error: e.toString()));
    }
  }
}



Future<bool> _checkDomainAvailability(String domainName) async {
    final url = Uri.https('whoisapi-whois-v2-v1.p.rapidapi.com', '/whoisserver/WhoisService', {
      'domainName': domainName,
      'apiKey': 'at_L8cXL0McklArM2JNi6u7eq4MrN2CB',
      'outputFormat': 'JSON',
      'da': '0',
      'ipwhois': '0',
      'thinWhois': '0',
      '_parse': '0',
      'preferfresh': '0',
      'checkproxydata': '0',
      'ip': '0',
    });

    final headers = {
      'X-RapidAPI-Key': 'd123286b8fmsh1ca56e8df693db6p165e41jsn22cbd4cec967',
      'X-RapidAPI-Host': 'whoisapi-whois-v2-v1.p.rapidapi.com',
    };

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['WhoisRecord']['dataError'] == 'MISSING_WHOIS_DATA';
    } else {
      throw Exception('Failed to check domain availability.');
    }
  }






