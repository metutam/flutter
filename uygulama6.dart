import 'dart:io';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Flags {
  late int flagId;
  late String flagName;
  late String flagImage;

  Flags(this.flagId, this.flagName, this.flagImage);
}

class DatabaseAssistant {
  static const String databaseName = "flagquiz.sqlite";

  static Future<Database> databaseAccess() async {
    String databasePath = join(await getDatabasesPath(), databaseName);

    if (await databaseExists(databasePath)) {
      print("There's already database. No need to copy.");
    } else {
      ByteData data = await rootBundle.load("database/$databaseName");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(databasePath).writeAsBytes(bytes, flush: true);
      print("Database is copied");
    }
    return openDatabase(databasePath);
  }
}

class FlagsDAO {
  // Flags Data Access Object
  Future<List<Flags>> randomFlags() async {
    var db = await DatabaseAssistant.databaseAccess();

    List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM flags ORDER BY RANDOM() LIMIT 5");

    return List.generate(maps.length, (index) {
      var row = maps[index];
      return Flags(row["flag_id"], row["flag_name"], row["flag_image"]);
    });
  }

  Future<List<Flags>> randomWrongChoices(int flagId) async {
    var db = await DatabaseAssistant.databaseAccess();

    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM flags WHERE flag_id != $flagId ORDER BY RANDOM() LIMIT 5");

    return List.generate(maps.length, (index) {
      var row = maps[index];
      return Flags(row["flag_id"], row["flag_name"], row["flag_image"]);
    });
  }
}

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
      home: const MyHomePage(title: 'Home Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "Welcome",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QuizScreen()));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: const Text("Start"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  var questions = <Flags>[];
  var correctQuestion = Flags(0, "", "");
  var wrongChoices = <Flags>[];
  var allChoices = HashSet<Flags>(); // HashSet is an unordered collection

  int questionCounter = 0;
  int correctCounter = 0;
  int wrongCounter = 0;

  String flagImageName = "placeholder.png";
  String buttonA = "";
  String buttonB = "";
  String buttonC = "";
  String buttonD = "";

  @override
  void initState() {
    super.initState();
    takeQuestions();
  }

  Future<void> takeQuestions() async {
    questions = await FlagsDAO().randomFlags();
    uploadQuestions();
  }

  Future<void> uploadQuestions() async {
    correctQuestion = questions[questionCounter];

    flagImageName = correctQuestion.flagImage;

    wrongChoices = await FlagsDAO().randomWrongChoices(correctQuestion.flagId);

    allChoices.clear();
    allChoices.add(correctQuestion);
    allChoices.add(wrongChoices[0]);
    allChoices.add(wrongChoices[1]);
    allChoices.add(wrongChoices[2]);

    buttonA = allChoices.elementAt(0).flagName;
    buttonB = allChoices.elementAt(1).flagName;
    buttonC = allChoices.elementAt(2).flagName;
    buttonD = allChoices.elementAt(3).flagName;

    setState(() {}); //  re-render of the user interface
  }

  void checkCounter(BuildContext context) {
    questionCounter++;

    if (questionCounter != 5) {
      uploadQuestions();
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResultScreen(
                    correctAnswers: correctCounter,
                  )));
    }
  }

  void checkCorrectness(String buttonText) {
    if (correctQuestion.flagName == buttonText) {
      correctCounter++;
    } else {
      wrongCounter++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text('Quiz Screen'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "True: $correctCounter",
                  style: const TextStyle(fontSize: 18),
                ),
                Text(
                  "False: $wrongCounter",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            questionCounter != 5
                ? Text(
                    "${questionCounter + 1}. Question",
                    style: const TextStyle(fontSize: 30),
                  )
                : const Text(
                    "5. Question",
                    style: TextStyle(fontSize: 30),
                  ),
            Image.asset("images/flags/$flagImageName"),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  checkCorrectness(buttonA);
                  checkCounter(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: Text(buttonA),
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  checkCorrectness(buttonB);
                  checkCounter(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: Text(buttonB),
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  checkCorrectness(buttonC);
                  checkCounter(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: Text(buttonC),
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  checkCorrectness(buttonD);
                  checkCounter(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: Text(buttonD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key, required this.correctAnswers})
      : super(key: key);

  final int correctAnswers;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int questionNumber = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: const Text('Result Screen'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${widget.correctAnswers} Correct & ${questionNumber - widget.correctAnswers} Wrong",
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              // The operator x ~/ y is more efficient than (x / y).toInt()
              "${(widget.correctAnswers * 100) ~/ questionNumber}% Success",
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
                child: const Text("Try Again"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
