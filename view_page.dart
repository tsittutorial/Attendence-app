
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWid;

class ViewPage extends StatefulWidget {
  final String employeeNameAndId;

  const ViewPage({Key? key, required this.employeeNameAndId})
      : super(key: key);

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  List<DateTime> databaseDates = [];
  Map<DateTime, String> statusMap = {};
  List<DateTime> filteredDates = [];
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();
    fetchAttendance(widget.employeeNameAndId);
  }

  Future<void> fetchAttendance(String name) async {
    final response = await http.get(Uri.parse(
        'https://btemporary.com/flutter-1/view_attendance.php?name=$name'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        statusMap = {
          for (var item in data) DateTime.parse(item['date_new']): item['status']
        };
        databaseDates = statusMap.keys.toList();
        filteredDates = List.from(databaseDates);
      });
    } else {
      throw Exception('Failed to load attendance data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employeeNameAndId),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: _printPDF,
          ),
          IconButton(
            icon: const Icon(Icons.description), onPressed: () {  },
            
          )
        ],
      ),
      body: Column(
        children: [
          _buildDatePickers(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
                child: DataTable(
                  columnSpacing: 30,
                  headingRowColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 101, 178, 236)),
                  dataRowColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 246, 248, 249)),
                  columns: [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: filteredDates.map((date) {
                    return DataRow(cells: [
                      DataCell(Text(
                          '${date.year}-${_formatDate(date.month)}-${_formatDate(date.day)}')),
                      DataCell(Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: statusMap[date] == 'Present'
                              ? Colors.green
                              : Colors.red,
                        ),
                        child: Text(
                          statusMap[date] ?? 'Absent',
                          style: const TextStyle(color: Colors.white),
                        ),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickers() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'From Date',
                  hintText: 'Select From Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: fromDate != null
                      ? '${_formatDate(fromDate!.day)}/${_formatDate(fromDate!.month)}/${fromDate!.year}'
                      : '',
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: fromDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2025),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      fromDate = selectedDate;
                      _filterDates();
                    });
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'To Date',
                  hintText: 'Select To Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: toDate != null
                      ? '${_formatDate(toDate!.day)}/${_formatDate(toDate!.month)}/${toDate!.year}'
                      : '',
                ),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: toDate ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2025),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      toDate = selectedDate;
                      _filterDates();
                    });
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.backspace),
            onPressed: () {
              setState(() {
                fromDate = null;
                toDate = null;
                filteredDates = List.from(databaseDates);
              });
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(int date) {
    return date.toString().padLeft(2, '0');
  }

  void _filterDates() {
    if (fromDate != null && toDate != null) {
      setState(() {
        filteredDates = databaseDates
            .where((date) =>
                date.isAfter(fromDate!) && date.isBefore(toDate!))
            .toList();
      });
    }
  }

  Future<void> _printPDF() async {
    final pdf = pdfWid.Document(
      version: PdfVersion.pdf_1_4,
      compress: true,
    );
    pdf.addPage(
      pdfWid.Page(
        pageFormat: const PdfPageFormat(600, 500),
        build: (context) {
          return pdfWid.Table(
            border: pdfWid.TableBorder.all(),
            children: [
              pdfWid.TableRow(children: [
                pdfWid.Text('Date',
                    style: pdfWid.TextStyle(fontWeight: pdfWid.FontWeight.bold)),
                pdfWid.Text('Status',
                    style: pdfWid.TextStyle(fontWeight: pdfWid.FontWeight.bold)),
              ]),
              for (DateTime date in filteredDates)
                pdfWid.TableRow(children: [
                  pdfWid.Text(
                    '${date.year}-${_formatDate(date.month)}-${_formatDate(date.day)}',
                  ),
                  pdfWid.Container(
                    padding: const pdfWid.EdgeInsets.all(8.0),
                    decoration: pdfWid.BoxDecoration(
                      borderRadius: pdfWid.BorderRadius.circular(5.0),
                      color: statusMap[date] == 'Present'
                          ? PdfColors.green
                          : PdfColors.red,
                    ),
                    child: pdfWid.Text(
                      statusMap[date] ?? 'Absent',
                      style: const pdfWid.TextStyle(color: PdfColors.white),
                    ),
                  ),
                ]),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
  }

 
}

void main() {
  runApp(MaterialApp(
    home: ViewPage(employeeNameAndId: 'John Doe'),
  ));
}
