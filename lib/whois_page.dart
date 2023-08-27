import 'bloc/whois/whois_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WhoisPage extends StatelessWidget {
  final TextEditingController _domainNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<WhoisBloc>(context).add(ResetWhois());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('WHOIS Lookup'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              BlocProvider.of<WhoisBloc>(context).add(ResetWhois());
            },
          ),
        ),
        body: BlocConsumer<WhoisBloc, WhoisState>(
          listener: (context, state) {
            if (state is WhoisError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ));
            }
          },
          builder: (context, state) {
            if (state is WhoisInitial) {
              return buildInitialUI();
            }
            else if( state is WhoisLoading){
              return Center(child: CircularProgressIndicator());
            }
            else if (state is WhoisLoaded) {
              return buildWhoisDataUI(context,state.whoisData);
            }
            return buildInitialUI();
          },
        ),
      ),
    );
  }

  Widget buildInitialUI() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _domainNameController,
              decoration: InputDecoration(labelText: 'Enter domain name'),
            ),
            SizedBox(height: 20),
            Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    final domainName = _domainNameController.text.trim();
                    if (domainName.isNotEmpty) {
                      BlocProvider.of<WhoisBloc>(context)
                          .add(FetchWhois(domainName));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Invalid Domain Name.'),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  child: Text('Find Whois Data'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildWhoisDataUI(BuildContext context, Map<String, dynamic> whoisData) {
    if (whoisData == null) {
      return Center(
        child: Text('No data available about the Domain.'),
      );
    }
    final registryData = whoisData["registryData"];
    final parseCode = registryData["parseCode"];
    if (parseCode == 64) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'The domain "${whoisData["domainName"]}" is available to register!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('Field',style: TextStyle(fontSize: 20),)),
                  DataColumn(label: Text('Value',style: TextStyle(fontSize: 20))),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text('Domain Name')),
                      DataCell(Text(whoisData["domainName"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Created Date')),
                      DataCell(Text(whoisData["createdDate"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Updated Date')),
                      DataCell(Text(whoisData["updatedDate"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Expires Date')),
                      DataCell(Text(whoisData["expiresDate"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Registrant Information')),
                      DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Name')),
                      DataCell(Text(whoisData["registrant"]["name"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Organization')),
                      DataCell(Text(whoisData["registrant"]["organization"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Street')),
                      DataCell(Text(whoisData["registrant"]["street1"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('City')),
                      DataCell(Text(whoisData["registrant"]["city"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('State/Province')),
                      DataCell(Text(whoisData["registrant"]["state"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Postal Code')),
                      DataCell(Text(whoisData["registrant"]["postalCode"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Country')),
                      DataCell(Text(whoisData["registrant"]["country"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Country Code')),
                      DataCell(Text(whoisData["registrant"]["countryCode"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Email')),
                      DataCell(Text(whoisData["registrant"]["email"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Telephone')),
                      DataCell(Text(whoisData["registrant"]["telephone"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Administrative Contact Information')),
                      DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Name')),
                      DataCell(
                          Text(whoisData["administrativeContact"]["name"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Technical Contact Information') ),
                      DataCell(Text('')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Name')),
                      DataCell(Text(whoisData["technicalContact"]["name"]  ?? 'N/A')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text('Name Servers')),
                      DataCell(Text(whoisData["nameServers"]["rawText"]  ?? 'N/A')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}