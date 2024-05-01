// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class Employee {
  final String emp_id;
  final String emp_name;
  final String designation;
  final String mobile_num;
  final String date_of_joining;

  Employee({
    required this.emp_id,
    required this.emp_name,
    required this.designation,
    required this.mobile_num,
    required this.date_of_joining,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      emp_id: json['emp_id'] ?? 'Unknown',
      emp_name: json['emp_name'] ?? 'Unknown',
      designation: json['designation'] ?? 'Unknown',
      mobile_num: json['mobile_num'] ?? 'Unknown',
      date_of_joining: json['date_of_joining'] ?? 'Unknown',
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Detail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EmployeeDetailPage(),
    );
  }
}

class EmployeeDetailPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const EmployeeDetailPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Detail'),
  
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEmployeeScreen()),
              );
            },
          ),
        ],
      ),
      body: const EmployeeDetailTable(),
    );
  }
}

class EmployeeDetailTable extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const EmployeeDetailTable({Key? key});

  @override
  _EmployeeDetailTableState createState() => _EmployeeDetailTableState();
}

class _EmployeeDetailTableState extends State<EmployeeDetailTable> {
  late Future<List<Employee>> _employees;

  @override
  void initState() {
    super.initState();
    _employees = fetchEmployees();
  }

  Future<List<Employee>> fetchEmployees() async {
    
    final response = await http.get(
      Uri.parse('https://btemporary.com/flutter-1/fetch.php'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      // print(response.body);
      print(responseData.last);
      return responseData.map((e) => Employee.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

Future<void> deleteEmployee(String empId) async { // Update parameter name to empId
  const apiUrl = 'https://btemporary.com/flutter-1/delete.php';
  final response = await http.post(
    Uri.parse(apiUrl),
    body: {'emp_id': empId}, // Correct the key to 'emp_id'
  );

  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    print(responseData);
    if (responseData['Result'] == 'successful') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee deleted successfully')),
      );
      setState(() {
        _employees = fetchEmployees();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to delete employee. Please try again.')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content:
              Text('Failed to delete employee. Please try again later.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async 
      {  
        setState(() {
          _employees = fetchEmployees();
        });
        
      },
      child: FutureBuilder<List<Employee>>(
        future: _employees,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => Color.fromARGB(255, 101, 178, 236),
                  ),
                  dataRowColor: MaterialStateColor.resolveWith(
                    (states) => Color.fromARGB(255, 246, 248, 249),
                  ),
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  dataTextStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  columns: const [
                    DataColumn(label: Text('Emp ID')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Designation')),
                    DataColumn(label: Text('Mobile Number')),
                    DataColumn(label: Text('Date Of Joining')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: snapshot.data!.map((employee) {
                    return DataRow(cells: [
                      DataCell(Text(employee.emp_id)),
                      DataCell(Text(employee.emp_name)),
                      DataCell(Text(employee.designation)),
                      DataCell(Text(employee.mobile_num)),
                      DataCell(Text(employee.date_of_joining)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditEmployeeScreen(employee: employee),
                                ),
                              ).then((result) {
                                if (result != null && result) {
                                  setState(() {
                                    _employees = fetchEmployees();
                                  });
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteEmployee(employee.emp_id);
                            },
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController mobileNumberController = TextEditingController(); // Create a new instance for mobile number
 

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name cannot be empty';
    }
    if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? validateEmpId(String? value) {
  if (value == null || value.isEmpty) {
    return 'ID cannot be empty';
  }
  if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
    return 'ID can only contain letters, numbers, and one optional space anywhere';
  }
  return null;
}


  String? validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile Number cannot be empty';
    }
    if (value.length != 10) {
      return 'Mobile Number must be exactly 10 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile Number must contain only digits';
    }
    return null;
  }

  Future<void> _submitEmployee(BuildContext context) async {
  final String empName = nameController.text;
  final String empId = idController.text;
  final String designation = designationController.text;
  final String dateOfJoining = _selectedDate != null
      ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
      : "";
  final String mobileNum = mobileNumberController.text;

  // Parse the mobile number as an integer
  final int mobileNumber = int.tryParse(mobileNum) ?? 0;

  const apiUrl = 'https://btemporary.com/flutter-1/emp_insert.php';

  final response = await http.post(
    Uri.parse(apiUrl),
    body: {
      'emp_name': empName,
      'emp_id': empId,
      'designation': designation,
      'date_of_joining': dateOfJoining,
      'mobile_num': mobileNumber.toString(), // Convert the mobile number to string
    },
  );
  
  if (response.statusCode == 200) {
    print(response.body);
    // final responseData = json.decode(response.body);
    
    if (response.statusCode==200){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee added successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add employee. Please try again.'),
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to add employee. Please try again later.'),
      ),
    );
  }
}


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: idController,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateEmpId,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: designationController,
                  decoration: const InputDecoration(
                    labelText: 'Designation',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}"
                        : "",
                  ),
                  decoration: InputDecoration(
                    labelText: 'Date of Joining',
                    border: const OutlineInputBorder(),
                     suffixIcon: IconButton(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: mobileNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: validateMobileNumber,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shadowColor: Colors.white,
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitEmployee(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shadowColor: Colors.white,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class EditEmployeeScreen extends StatefulWidget {
  final Employee employee;

  const EditEmployeeScreen({Key? key, required this.employee}) : super(key: key);

  @override
  _EditEmployeeScreenState createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> 
{
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController designationController;
  late TextEditingController dateofjoinController;
  late TextEditingController mobileNumberController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.emp_name);
    idController = TextEditingController(text: widget.employee.emp_id);
    designationController = TextEditingController(text: widget.employee.designation);
    
    dateofjoinController = TextEditingController(text: widget.employee.date_of_joining);
    mobileNumberController = TextEditingController(text: widget.employee.mobile_num);

  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    designationController.dispose();
    dateofjoinController.dispose();
    mobileNumberController.dispose();    
    super.dispose();
  }

  Future<void> _updateEmployee(BuildContext context) async {
    final String empName = nameController.text;
    final String empId = idController.text;
    final String designation = designationController.text;
    final String dateofjoining = dateofjoinController.text;
    final String mobileNum = mobileNumberController.text;


    const apiUrl = 'https://btemporary.com/flutter-1/updateemp_details.php';

   
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'id': empId,
        'emp_name': empName,
        'emp_id': empId,
        'designation': designation,
        'date_of_joining': dateofjoining,
        'mobile_num': mobileNum,
        

      },
    );

    if (response.statusCode == 200) {
      print('Response Body: ${response.body}');
      final responseData = json.decode(response.body);
      if (responseData['Result'] == 'Employee updated successfully') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee updated successfully')),
        );
        Navigator.pop(context, true); // Send back true to indicate successful update
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update employee. Please try again.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update employee. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Employee'),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(), // Use OutlineInputBorder for rectangular border
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: idController,
              decoration: const InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder(),
              ),
              // enabled: false, // ID should not be editable
            ),
            const SizedBox(height: 12),
            TextField(
              controller: designationController,
              decoration: const InputDecoration(
                labelText: 'Designation',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: mobileNumberController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: dateofjoinController,
              decoration: const InputDecoration(
                labelText: 'Date Of Joining',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // Navigate back
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shadowColor: Colors.white,
      ),
      child: const Text(
        'Back',
        style: TextStyle(color: Colors.white),
      ),
    ),
    const SizedBox(width: 10), // Add spacing between buttons
    ElevatedButton(
      onPressed: () => _updateEmployee(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shadowColor: Colors.white,
      ),
      child: const Text(
        'Update',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ],
),
            
          ],
        ),
      ),
      )
    );
  }
}