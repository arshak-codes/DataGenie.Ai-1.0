import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gemini App To Retrieve SQL Data'),
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';

  void _submit() async {
    String question = _controller.text;
    String response = await getGeminiResponse(question);
    setState(() {
      _response = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Input',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: Text('Ask the question'),
          ),
          SizedBox(height: 20),
          Text('The Response is:'),
          SizedBox(height: 10),
          Text(_response),
        ],
      ),
    );
  }
}

Future<String> getGeminiResponse(String question) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:5000/query'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'question': question,
    }),
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load response');
  }
}
