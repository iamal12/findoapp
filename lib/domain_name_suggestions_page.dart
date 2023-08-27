import 'dart:convert';

import 'package:findo/godaddy_register_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DomainNameSuggestionsPage extends StatelessWidget {
  final List<String> suggestions;

  DomainNameSuggestionsPage({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return DomainNameSuggestionsView(suggestions: suggestions);
  }
}

class DomainNameSuggestionsView extends StatefulWidget {
  final List<String> suggestions;

  DomainNameSuggestionsView({required this.suggestions});

  @override
  _DomainNameSuggestionsViewState createState() => _DomainNameSuggestionsViewState();
}

class _DomainNameSuggestionsViewState extends State<DomainNameSuggestionsView> {
  Map<String, bool> availabilityStatus = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Domain Name Suggestions'),
      ),
      body: ListView.builder(
        itemCount: widget.suggestions.length,
        itemBuilder: (context, index) {
          String suggestion = widget.suggestions[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: _buildDomainCard(suggestion, context),
          );
        },
      ),
    );
  }

  Widget _buildDomainCard(String suggestion, BuildContext context) {
    return ExpansionTile(
      title: Text(suggestion),
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDomainBlock(suggestion, '.com', context),
              _buildDomainBlock(suggestion, '.in', context),
              _buildDomainBlock(suggestion, '.org', context),
              _buildDomainBlock(suggestion, '.io', context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDomainBlock(String suggestion,
      String extension,
      BuildContext context,) {
    String domainName = suggestion + extension;

    return GestureDetector(
      onTap: () async {
        bool isAvailable = availabilityStatus[domainName] ?? false;
        if (!isAvailable) {
          bool isAvailableNow = await _checkDomainAvailability(domainName);
          setState(() {
            availabilityStatus[domainName] = isAvailableNow;
          });

          if (!isAvailableNow) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$domainName is already registered.'),
              backgroundColor: Colors.red,
            ));
          }
        } else {
          _showRegistrationBottomSheet(context, domainName);
        }
      },
      child: Container(
        height: 50,
        color: availabilityStatus[domainName] == true
            ? Colors.green
            : Colors.grey,
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            domainName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showRegistrationBottomSheet(BuildContext context, String domainName) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Register $domainName with GoDaddy'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoDaddyRegistrationPage(id:1,domainName: domainName),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Register $domainName with Namecheap'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoDaddyRegistrationPage(id:2,domainName: domainName),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Register $domainName with Google Domains'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GoDaddyRegistrationPage(id:3,domainName: domainName),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }


  Future<bool> _checkDomainAvailability(String domainName) async {
    final url = Uri.https(
        'whoisapi-whois-v2-v1.p.rapidapi.com', '/whoisserver/WhoisService', {
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
      bool isAvailable = jsonData['WhoisRecord']['dataError'] ==
          'MISSING_WHOIS_DATA';
      return isAvailable;
    } else {
      throw Exception('Failed to check domain availability.');
    }
  }

}