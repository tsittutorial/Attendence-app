import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  List<dynamic> data = []; // List to store fetched data

  Future<void> _fetchData() async {
    final Uri apiUrl = Uri.parse('https://btemporary.com/email/fetch.php');

    try {
      final http.Response response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch data')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch data when the page initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Color.fromARGB(255, 101, 178, 236),
                  ),
                  dataRowColor: MaterialStateColor.resolveWith(
                    (states) => Color.fromARGB(255, 246, 248, 249),
                  ),
                  columns: const [
                    DataColumn(
                      label: Text(
                        'ID',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Request',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    data.length,
                    (int index) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            data[index]['id'].toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        DataCell(
                          Text(
                            data[index]['name'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        DataCell(
                          Text(
                            data[index]['email'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        DataCell(
                          // Wrap the text widget with Flexible and set maxLines to null
                          Flexible(
                            child: Text(
                              data[index]['request'],
                              style: TextStyle(fontSize: 15),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}