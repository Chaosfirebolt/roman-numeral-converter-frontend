import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Roman Numeral Converter';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputController = TextEditingController();
  final resultController = TextEditingController(text: 'Result');
  String? result;

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(
                  width: 10,
                ),
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
                const SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    var input = inputController.text;
                    //TODO call backend
                    setState(() {
                      resultController.text = input;
                    });
                  },
                  child: const Icon(Icons.change_circle),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: TextField(
                    textAlign: TextAlign.center,
                    readOnly: true,
                    controller: resultController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    inputController.dispose();
    resultController.dispose();
  }
}
