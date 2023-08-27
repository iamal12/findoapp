import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'whois_event.dart';
part 'whois_state.dart';

class WhoisBloc extends Bloc<WhoisEvent, WhoisState> {
  WhoisBloc() : super(WhoisInitial()) {
    on<FetchWhois>(_onFetchWhois);
    on<ResetWhois>((event, emit) {
      emit(WhoisInitial());
    });
  }
  void _onFetchWhois(FetchWhois event, Emitter<WhoisState> emit) async {
    emit(WhoisLoading());
    try {
      final whoisData = await _fetchWhoisData(event.domainName);
      emit(WhoisLoaded(whoisData));
    } catch (e) {
      emit(WhoisError('Failed to fetch WHOIS data'));
    }
  }

  Future<Map<String, dynamic>> _fetchWhoisData(String domainName) async {
    final apiUrl = "https://whoisapi-whois-v2-v1.p.rapidapi.com/whoisserver/WhoisService";
    final apiKey = "b610d5bd0cmshbf52e4f9918d679p154eb0jsn4a7b05bb159b";
    final whoiapiKey = "at_L8cXL0McklArM2JNi6u7eq4MrN2CB";
    final response = await http.get(
      Uri.parse("$apiUrl?domainName=$domainName&apiKey=$whoiapiKey&outputFormat=JSON"),
      headers: {
        'X-RapidAPI-Key': apiKey,
        'X-RapidAPI-Host': 'whoisapi-whois-v2-v1.p.rapidapi.com',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)["WhoisRecord"];
    } else {
      throw Exception('Failed to fetch WHOIS data');
    }
  }
}
