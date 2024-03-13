import 'dart:collection';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class People {
  late String personId;
  late String personName;
  late String phoneNumber;

  People(this.personId, this.personName, this.phoneNumber);

  factory People.fromJson(String key, Map<dynamic, dynamic> json) {
    return People(
        key, json["person_name"] as String, json["phone_number"] as String);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  bool searching = false;
  String searchTerm = "";

  var refPeople = FirebaseDatabase.instance.ref().child("people");

  Future<void> delete(String personId) async {
    refPeople.child(personId).remove();
  }

  Future<bool> closeTheApp() async {
    try {
      await SystemNavigator.pop();
      return true;
    } catch (e) {
      print('Error closing app: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenInfo = MediaQuery.of(context);
    final double screenWidth = screenInfo.size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              closeTheApp();
            },
            icon: const Icon(Icons.arrow_back)),
        title: searching
            ? TextField(
                decoration: const InputDecoration(
                    hintText: "Search Contacts",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
                style: const TextStyle(color: Colors.white),
                onChanged: (searchResult) {
                  print(searchResult);
                  setState(() {
                    searchTerm = searchResult;
                  });
                },
              )
            : Text(widget.title),
        actions: [
          searching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      searching = false;
                      searchTerm = "";
                    });
                  },
                  icon: const Icon(Icons.cancel))
              : IconButton(
                  onPressed: () {
                    setState(() {
                      searching = true;
                    });
                  },
                  icon: const Icon(Icons.search)),
        ],
      ),
      body: WillPopScope(
        onWillPop: closeTheApp,
        child: StreamBuilder<DatabaseEvent>(
          stream: refPeople.onValue,
          builder: (context, event) {
            if (event.hasData) {
              var contactsList = <People>[];
              var receivedValues = event.data!.snapshot.value as dynamic;
              if (receivedValues != null) {
                receivedValues.forEach((key, object) {
                  var receivedPerson = People.fromJson(key, object);
                  if (searching) {
                    if (receivedPerson.personName.contains(searchTerm)) {
                      contactsList.add(receivedPerson);
                    }
                  } else {
                    contactsList.add(receivedPerson);
                  }
                });
              }

              return ListView.builder(
                itemCount: contactsList.length,
                itemBuilder: (context, index) {
                  var person = contactsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    person: person,
                                  )));
                    },
                    child: Card(
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: screenWidth / 4,
                              child: Text(
                                person.personName,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 3,
                                child: Text(person.phoneNumber)
                            ),
                            SizedBox(
                              width: screenWidth / 6,
                              child: IconButton(
                                  onPressed: () {
                                    delete(person.personId);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.black54,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegistrationPage()));
        },
        tooltip: 'Add People',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  var tfPersonName = TextEditingController();
  var tfPhoneNumber = TextEditingController();

  var refPeople = FirebaseDatabase.instance.ref().child("people");

  Future<void> register(String personName, String phoneNumber) async {
    var info = HashMap<String, dynamic>();
    info["person_id"] = "";
    info["person_name"] = personName;
    info["phone_number"] = phoneNumber;
    refPeople.push().set(info);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Home Page')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfPersonName,
                decoration: const InputDecoration(hintText: "Person Name"),
              ),
              TextField(
                controller: tfPhoneNumber,
                decoration: const InputDecoration(hintText: "Phone Number"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          register(tfPersonName.text, tfPhoneNumber.text);
        },
        tooltip: 'Create a New Contact',
        icon: const Icon(Icons.save),
        label: const Text('Save'),
      ),
    );
  }
}

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.person}) : super(key: key);

  final People person;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var tfPersonName = TextEditingController();
  var tfPhoneNumber = TextEditingController();

  var refPeople = FirebaseDatabase.instance.ref().child("people");

  Future<void> update(String personId, String personName, String phoneNumber) async {
    var info = HashMap<String, dynamic>();
    info["person_name"] = personName;
    info["phone_number"] = phoneNumber;
    refPeople.child(personId).update(info);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Home Page')));
  }

  @override
  void initState() {
    super.initState();

    var person = widget.person;
    tfPersonName.text = person.personName;
    tfPhoneNumber.text = person.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 50,
            right: 50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfPersonName,
                decoration: const InputDecoration(hintText: "Person Name"),
              ),
              TextField(
                controller: tfPhoneNumber,
                decoration: const InputDecoration(hintText: "Phone Number"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          update(widget.person.personId, tfPersonName.text, tfPhoneNumber.text);
        },
        tooltip: 'Update People',
        icon: const Icon(Icons.update),
        label: const Text("Update"),
      ),
    );
  }
}
