import 'package:bloc/bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
part 'domainrating_event.dart';
part 'domainrating_state.dart';

class DomainRatingBloc extends Bloc<DomainRatingEvent, DomainRatingState> {
  DomainRatingBloc() : super(DomainRatingInitial()) {
    on<FetchDomainRating>(_onFetchDomainRating);
  }

  Future<void> _onFetchDomainRating(FetchDomainRating event, Emitter<DomainRatingState> emit) async {
    emit(DomainRatingLoading());

    try {
      final rating = await fetchDomainRating(event.domain);
      emit(DomainRatingLoaded(rating));
    } catch (e) {
      emit(DomainRatingError("Failed to fetch domain rating."));
    }
  }

  Future<int> fetchDomainRating(String domain) async {
    final url = Uri.https(
      'ahrefs-dr-rank-checker.p.rapidapi.com',
      '/check',
    );

    final headers = {
      'content-type': "application/json",
      'X-RapidAPI-Key': "6b66e62a6cmsh4a9fe4e2c90091ep1fd30ajsnd54ab0110b2c",
      'X-RapidAPI-Host': "ahrefs-dr-rank-checker.p.rapidapi.com",
    };

    final payload = jsonEncode({"url": domain});

    final response = await http.post(url, headers: headers, body: payload);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData["data"]["domainRating"];
    } else {
      throw Exception("Failed to fetch domain rating.");
    }
  }
}
