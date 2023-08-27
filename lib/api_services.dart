import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.datamuse.com/words';

  static Future<List<String>> getWordsStartWith(String startWith) async {
    final response = await http.get(Uri.parse('$baseUrl?sp=$startWith*'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<String> words =
      responseData.map((item) => item['word'].toString()).toList();
      return words;
    } else {
      throw Exception('Failed to fetch words');
    }
  }

  static Future<List<String>> getWordsEndWith(String endWith) async {
    final response = await http.get(Uri.parse('$baseUrl?sp=*$endWith'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      List<String> words =
      responseData.map((item) => item['word'].toString()).toList();
      return words;
    } else {
      throw Exception('Failed to fetch words');
    }
  }

  static Future<bool> checkDomainAvailability(String domain, String extension) async {
    final url = Uri.https('domainstatus.p.rapidapi.com', '/');
    print(url);
    final headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': 'b610d5bd0cmshbf52e4f9918d679p154eb0jsn4a7b05bb159b', // Replace with your RapidAPI key
      'X-RapidAPI-Host': 'domainstatus.p.rapidapi.com',
    };
    final body = json.encode({
      'name': domain,
      'tld': extension,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      print(response.body);
      final jsonData = json.decode(response.body);
      return jsonData['available'] ?? false;
    } else {
      throw Exception('Failed to check domain availability.');
    }
  }
}
