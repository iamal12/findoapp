import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoDaddyRegistrationPage extends StatelessWidget {
  final String domainName;
  int id = 0;

  GoDaddyRegistrationPage({required this.id,required this.domainName});

  @override
  Widget build(BuildContext context) {
    print(domainName);
    String url = _getUrlForDomain(domainName);

    return Scaffold(
      appBar: AppBar(
        title: Text('Register with GoDaddy'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  String _getUrlForDomain(String domain) {
    if (id == 1) {
      return 'https://www.godaddy.com/en-in/domainsearch/find?domainToCheck=$domain';
    } else if (id==2) {
      return 'https://www.namecheap.com/domains/registration/results/?domain=$domain';
    } else if (id==3) {
      return 'https://domains.google.com/registrar/search?searchTerm=$domain';
    } else {
      return 'https://www.godaddy.com/domainsearch/find?domainToCheck=$domain';
    }
  }
}
