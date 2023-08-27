import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/domain_rating/domainrating_bloc.dart';
class DomainRatingPage extends StatelessWidget {
  final TextEditingController _domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Domain Rating Checker'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _domainController,
              decoration: InputDecoration(labelText: 'Enter domain'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final domain = _domainController.text.trim();
                if (domain.isNotEmpty) {
                  BlocProvider.of<DomainRatingBloc>(context).add(FetchDomainRating(domain));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a domain.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Check Rating'),
            ),
            SizedBox(height: 20),
            BlocBuilder<DomainRatingBloc, DomainRatingState>(
              builder: (context, state) {
                if (state is DomainRatingInitial) {
                  return SizedBox.shrink();
                } else if (state is DomainRatingLoading) {
                  return CircularProgressIndicator();
                } else if (state is DomainRatingLoaded) {
                  return Text('Domain Rating: ${state.rating}');
                } else if (state is DomainRatingError) {
                  return Text('Error: ${state.errorMessage}');
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
