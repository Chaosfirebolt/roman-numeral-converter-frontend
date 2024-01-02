import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:roman_numeral_converter_frontend/roman_integer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputController = TextEditingController();
  final romanResultController = TextEditingController(text: 'Roman numeral');
  final arabicResultController = TextEditingController(text: 'Arabic numeral');
  late BuildContext homePageContext;

  @override
  Widget build(BuildContext context) {
    homePageContext = context;
    var resultDecoration = const InputDecoration(border: OutlineInputBorder());

    var space = const SizedBox(width: 10);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Center(
          child: Text(widget.title),
        ),
        titleTextStyle:
            const TextStyle(color: Colors.yellowAccent, fontSize: 25),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                space,
                Flexible(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: inputController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter arabic or roman numeral',
                    ),
                  ),
                ),
                space,
                FloatingActionButton(
                  onPressed: convert,
                  child: const Icon(Icons.change_circle),
                ),
                space,
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                space,
                Flexible(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    controller: romanResultController,
                    decoration: resultDecoration,
                  ),
                ),
                space,
                const Text(
                  '=',
                  style: TextStyle(fontSize: 23),
                ),
                space,
                Flexible(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    controller: arabicResultController,
                    decoration: resultDecoration,
                  ),
                ),
                space,
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<RequestResult> getResult(String input) async {
    var authority = const String.fromEnvironment('authority');
    Uri uri = Uri.https(
      authority,
      '/convert',
      {
        'val': input,
      },
    );

    String user = const String.fromEnvironment('u');
    String pass = const String.fromEnvironment('p');
    String encoded = base64Encode(utf8.encode('$user:$pass'));
    final response = await http.get(
      uri,
      headers: {
        HttpHeaders.authorizationHeader: 'Basic $encoded',
      },
    );
    return RequestResult.fromData(
      response: response.statusCode,
      json: response.body,
    );
  }

  void convert() {
    getResult(inputController.text).then((value) => {
          if (value.success)
            {
              romanResultController.text = value.successResult.roman,
              arabicResultController.text =
                  value.successResult.arabic.toString()
            }
          else
            {
              ScaffoldMessenger.of(homePageContext).showSnackBar(SnackBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Container(
                  padding: const EdgeInsets.all(20),
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    value.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 19,
                    ),
                  ),
                ),
                duration: const Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
              ))
            }
        });
  }

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
    romanResultController.dispose();
  }
}
