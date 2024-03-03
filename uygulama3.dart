import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _randomNumber;

  @override
  void initState() {
    super.initState();
    _randomNumber = Random().nextInt(11); // from 0 to 10
    print(_randomNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Guessing Game",
              style: TextStyle(color: Colors.black54, fontSize: 36),
            ),
            Image.asset("images/dice.png"),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GamePage(
                                randomNumber: _randomNumber,
                              )));
                },
                child: const Text("Start The Game"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  final int randomNumber;

  const GamePage({
    Key? key,
    required this.randomNumber,
  }) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  var tfController = TextEditingController();
  int remaining = 3;
  String help = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Remaining: $remaining",
              style: const TextStyle(color: Colors.orangeAccent, fontSize: 36),
            ),
            Text(
              "$help Your Guess",
              style: const TextStyle(color: Colors.black54, fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: tfController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: "Guess a Number (1 - 10)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
              ),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    remaining = remaining - 1;
                  });

                  int guess = int.parse(tfController.text);
                  if (guess == widget.randomNumber) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResultPage(
                                  result: true,
                                )));
                    return;
                  } else if (guess > widget.randomNumber) {
                    help = "Decrease";
                  } else if (guess < widget.randomNumber) {
                    help = "Increase";
                  }

                  if (remaining == 0) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResultPage(
                                  result: false,
                                )));
                  }

                  tfController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black54,
                ),
                child: const Text("Guess"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ResultPage extends StatefulWidget {
  final bool result;

  const ResultPage({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.result
                ? Image.asset("images/happy_face.png")
                : Image.asset("images/sad_face.png"),
            Text(
              widget.result ? "You Won" : "You lost",
              style: const TextStyle(color: Colors.black54, fontSize: 36),
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Play Again"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
