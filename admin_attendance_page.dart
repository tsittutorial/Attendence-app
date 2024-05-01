import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_admin/view_page.dart';

void main() {
  runApp(const MaterialApp(
    home: AdminAttendancePage(),
  ));
}

class Employee {
  final String name;
  final String designation;

  Employee({required this.name, required this.designation});
}

class AdminAttendancePage extends StatefulWidget {
  const AdminAttendancePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminAttendancePageState createState() => _AdminAttendancePageState();
}

class _AdminAttendancePageState extends State<AdminAttendancePage> {
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();
    fetchEmployeeData();
  }

  Future<void> fetchEmployeeData() async {
    final response = await http.get(Uri.parse('https://btemporary.com/flutter-1/fetch.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        employees = data.map((e) => Employee(name: e['emp_name'].toString(), designation: e['designation'].toString())).toList();
      });
    } else {
      throw Exception('Failed to load employee data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Page'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 30, // Adjust the spacing between columns as needed
             headingRowColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 101, 178, 236)),
                  dataRowColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 246, 248, 249)),
            columns: const [
              DataColumn(label: SizedBox(width: 150, child: Text('Employee Name'))),
              DataColumn(label: SizedBox(width: 150, child: Text('Designation'))),
              DataColumn(label: SizedBox(width: 100, child: Text('View'))),
            ],
            rows: employees
                .map(
                  (employee) => DataRow(
                    cells: [
                      DataCell(SizedBox(width: 150, child: Text(employee.name))),
                      DataCell(SizedBox(width: 150, child: Text(employee.designation))),
                      DataCell(SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle view action here
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ViewPage(employeeNameAndId: employee.name)),
                              );

                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          child: const Text('View', style: TextStyle(color: Colors.white)),
                        ),
                      )),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
