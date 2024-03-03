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
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Login Page'),
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
    var screenInfo = MediaQuery.of(context);
    final double screenHeight = screenInfo.size.height;
    final double screenWidth = screenInfo.size.width;

    return Scaffold(
      backgroundColor: Colors.orange,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: Text(
                  "Login Page",
                  style: TextStyle(
                    fontSize: screenWidth / 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Username",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: const TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenHeight / 30),
                child: SizedBox(
                  width: screenWidth / 1.5,
                  height: screenHeight / 14,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Logged In");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      textStyle: TextStyle(
                        fontSize: screenWidth/30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text(
                      "Log In",
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print("Help Is Clicked");
                },
                child: Text(
                  "Need Help?",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth / 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
