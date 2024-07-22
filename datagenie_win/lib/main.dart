/*Enter button finishes user input

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Genie',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1E1E1E),
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
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': _controller.text}),
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
      
      // Get the user's home directory
      final home = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      
      // Create a file in the Downloads folder
      final file = File(path.join(home.path, 'data_${DateTime.now().millisecondsSinceEpoch}.csv'));
      
      // Write the CSV data to the file
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Successfully connected to database🔗',
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF252526),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Show me all employees who work in employee dept',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Color(0xFF252526),
                  prefixIcon: Icon(Icons.person, color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Result', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showSql = !_showSql;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _showSql ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('SQL'),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _downloadCsv,
                  child: Text('Download CSV'),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_showSql)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF252526),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(_sqlQuery),
              )
            else if (_data.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: _columns.map((column) => DataColumn(label: Text(column))).toList(),
                      rows: _data.map((row) => DataRow(
                        cells: row.map((cell) => DataCell(Text(cell.toString()))).toList(),
                      )).toList(),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),
            if (_data.isNotEmpty)
              Text('1 to ${_data.length} of ${_data.length}', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: Icon(Icons.send),
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart' as path;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Genie',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF1E1E1E),
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
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': _controller.text}),
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
      
      // Get the user's home directory
      final home = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      
      // Create a file in the Downloads folder
      final file = File(path.join(home.path, 'data_${DateTime.now().millisecondsSinceEpoch}.csv'));
      
      // Write the CSV data to the file
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Successfully connected to database🔗',
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF252526),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Show me all employees who work in employee dept',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Color(0xFF252526),
                  prefixIcon: Icon(Icons.person, color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
                onSubmitted: (value) => _submit(), // Handle Enter key press
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Result', style: TextStyle(fontSize: 18)),
                SizedBox(width: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      _showSql = !_showSql;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _showSql ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('SQL'),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: _downloadCsv,
                  child: Text('Download CSV'),
                ),
              ],
            ),
            SizedBox(height: 10),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else if (_showSql)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFF252526),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(_sqlQuery),
              )
            else if (_data.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: _columns.map((column) => DataColumn(label: Text(column))).toList(),
                      rows: _data.map((row) => DataRow(
                        cells: row.map((cell) => DataCell(Text(cell.toString()))).toList(),
                      )).toList(),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),
            if (_data.isNotEmpty)
              Text('1 to ${_data.length} of ${_data.length}', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: Icon(Icons.send),
      ),
    );
  }
}
