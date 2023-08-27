import 'package:findo/bloc/domain_rating/domainrating_bloc.dart';
import 'package:findo/domain_name_generator.dart';
import 'package:findo/domain_name_suggestions_page.dart';
import 'package:findo/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/domain_name_suggestions_bloc.dart';
import 'bloc/whois/whois_bloc.dart'; // Import the WhoisBloc
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WhoisBloc>(
          create: (context) => WhoisBloc(),
        ),
        BlocProvider<DomainRatingBloc>(
            create: (context) => DomainRatingBloc()),
      ],
      child: MaterialApp(
        title: 'Findo Suggestions',
        theme: ThemeData(primarySwatch: Colors.green,),
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}



class DomainNameInputPage extends StatefulWidget {
  @override
  _DomainNameInputPageState createState() => _DomainNameInputPageState();
}

class _DomainNameInputPageState extends State<DomainNameInputPage> {
  final TextEditingController _keywordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Findo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _keywordController,
              decoration: InputDecoration(labelText: 'Enter word'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String keyword = _keywordController.text.trim();

                if (keyword.isNotEmpty) {
                  List<String> suggestions = await DomainNameGenerator.generateSuggestions(keyword);
                  print(suggestions.length);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlocProvider(
                      create: (context) => DomainNameSuggestionsBloc(),
                      child: DomainNameSuggestionsPage(suggestions: suggestions),
                    )),
                  );
                }
              },
              child: Text('Go'),
            ),
          ],
        ),
      ),
    );
  }
}
