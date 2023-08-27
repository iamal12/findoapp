import 'package:findo/domainratingpage.dart';
import 'package:findo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'domain_name_suggestions_page.dart';
import 'whois_page.dart';
import 'bloc/whois/whois_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text('Findo - The Domaining App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WhoisPage(),
                  ),
                );
              },
              label: 'Whois Page',
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            CardButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DomainNameInputPage(),
                  ),
                );
              },
              label: 'Domain Name Suggestions Page',
              color: Colors.green,
            ),
            SizedBox(height: 20),
            CardButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DomainRatingPage(),
                  ),
                );
              },
              label: 'Check Ahrefs Domain Rating',
              color: Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color color;

  const CardButton({
    required this.onPressed,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        color: color,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
