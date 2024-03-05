import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> check() async {
    var sp = await SharedPreferences.getInstance();

    String spUsername = (sp.getString("userName")) ?? "undefined username";
    String spPassword = (sp.getString("password")) ?? "undefined password";

    if (spUsername == "admin" && spPassword == "12345") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: check(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            bool checkResult = snapshot.data!;
            return checkResult ? const HomePage() : const LoginPage(title: 'Login Page');
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var tfUsername = TextEditingController();
  var tfPassword = TextEditingController();

  Future<void> loginCheck() async {
    var user = tfUsername.text;
    var pass = tfPassword.text;

    if (user == "admin" && pass == "12345") {
      var sp = await SharedPreferences.getInstance();

      sp.setString("userName", user);
      sp.setString("password", pass);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username or Password Incorrect")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: tfUsername,
                decoration: const InputDecoration(
                  hintText: "Username",
                ),
              ),
              TextField(
                obscureText: true,
                controller: tfPassword,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  loginCheck();
                },
                child: const Text("Log In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late String spUsername;
  late String spPassword;

  Future<void> readData() async {
    var sp = await SharedPreferences.getInstance();

    setState(() {
      spUsername = (sp.getString("userName")) ?? "undefined username";
      spPassword = (sp.getString("password")) ?? "undefined password";
    });
  }

  Future<void> logOut() async {
    var sp = await SharedPreferences.getInstance();

    sp.remove("userName");
    sp.remove("password");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login Page')));

  }

  @override
  void initState() {
    super.initState();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        actions: [
          IconButton(
            onPressed: () {
              logOut();
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Username: $spUsername",
                style: const TextStyle(fontSize: 30),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Password: $spPassword",
                style: const TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
