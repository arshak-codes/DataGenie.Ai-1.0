import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DataGenie',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        fontFamily: 'Serif',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  List<String> _columns = [];
  List<List<dynamic>> _data = [];
  String _sqlQuery = '';
  bool _showSql = false;
  bool _showResult = true;
  bool _isLoading = false;
  File? _databaseFile;
  String _databaseName = 'No Active DataBase 🫤               ';
  bool _isDatabaseConnected = false;

  Future<void> _submit() async {
    if (_databaseFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No database file selected')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': _controller.text,
          'db_path': _databaseFile!.path,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          _columns = List<String>.from(jsonResponse['columns']);
          _data = List<List<dynamic>>.from(jsonResponse['data']);
          _sqlQuery = jsonResponse['sql'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load response');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _downloadCsv() async {
    if (_data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data to download')),
      );
      return;
    }

    try {
      final csvData = ListToCsvConverter().convert([_columns, ..._data]);

      final home = await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();

      final file = File(path.join(
          home.path, 'data_${DateTime.now().millisecondsSinceEpoch}.csv'));

      await file.writeAsString(csvData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV file saved to ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: ${e.toString()}')),
      );
    }
  }

  Future<void> _uploadDatabase() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _databaseFile = file;
        _databaseName =
            "Connected to " + path.basename(file.path) + " 😊🔗            ";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database file selected')),
      );

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://127.0.0.1:5000/upload'),
        );
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: path.basename(file.path),
        ));

        var response = await request.send();
        if (response.statusCode == 200) {
          setState(() {
            _isDatabaseConnected = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Database file uploaded successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload database file')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading file: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: _uploadDatabase,
                      child: Text('UPLOAD DATABASE',
                          style: TextStyle(
                              fontFamily: 'ButtonFont',
                              color: const Color.fromARGB(255, 200, 200, 200))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 111, 70, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Text(
                      _databaseName,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'ButtonFont',
                        color: Color.fromARGB(255, 111, 70, 60),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 90),
                Text(
                  'DataGenie',
                  style: TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomFont',
                    color: Color.fromARGB(255, 111, 70, 60),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'ENTER YOUR QUERY HERE!',
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 155, 153, 153)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.grey[400],
                    ),
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text('GENERATE',
                      style: TextStyle(
                          fontFamily: 'ButtonFont',
                          color: Color.fromARGB(255, 200, 200, 200))),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 148, 134, 123),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 148, 134, 123),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showResult = true;
                            _showSql = false;
                          });
                        },
                        child: Text('RESULT',
                            style: TextStyle(
                                fontFamily: 'ButtonFont',
                                color:
                                    const Color.fromARGB(255, 200, 200, 200))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _showResult
                              ? Color.fromARGB(255, 111, 70, 60)
                              : Color.fromARGB(255, 148, 134, 123),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showSql = true;
                            _showResult = false;
                          });
                        },
                        child: Text('SQL',
                            style: TextStyle(
                                fontFamily: 'ButtonFont',
                                color:
                                    const Color.fromARGB(255, 200, 200, 200))),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _showSql
                              ? Color.fromARGB(255, 111, 70, 60)
                              : Color.fromARGB(255, 148, 134, 123),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (_isLoading)
                  CircularProgressIndicator()
                else if (_showSql)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(_sqlQuery),
                  )
                else if (_showResult && _data.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: _columns
                              .map((column) => DataColumn(label: Text(column)))
                              .toList(),
                          rows: _data
                              .map((row) => DataRow(
                                    cells: row
                                        .map((cell) =>
                                            DataCell(Text(cell.toString())))
                                        .toList(),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: ElevatedButton(
            onPressed: _downloadCsv,
            child: Text('DOWNLOAD CSV',
                style: TextStyle(
                    fontFamily: 'ButtonFont',
                    color: Color.fromARGB(255, 200, 200, 200))),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 111, 70, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}