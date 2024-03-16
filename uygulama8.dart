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
      home: const MyHomePage(title: 'Animated FAB Button'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController animationControl;

  late Animation<double> scaleAnimation;
  late Animation<double> rotateAnimation;

  bool status = false;

  @override
  void initState() {
    super.initState();
    animationControl = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(animationControl)
      ..addListener(() {
        setState(() {});
      });

    rotateAnimation = Tween(begin: 0.0, end: pi / 4).animate(animationControl)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    animationControl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: const Center(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform.scale(
              scale: scaleAnimation.value,
              child: FloatingActionButton(
                onPressed: () {},
                tooltip: 'Floating Action Button',
                backgroundColor: Colors.yellow,
                child: const Icon(Icons.photo_camera),
              ),
            ),
            Transform.scale(
              scale: scaleAnimation.value,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: FloatingActionButton(
                  onPressed: () {},
                  tooltip: 'Floating Action Button',
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.alarm),
                ),
              ),
            ),
            Transform.rotate(
              angle: rotateAnimation.value,
              child: FloatingActionButton(
                onPressed: () {
                  if (status) {
                    animationControl.reverse();
                    status = false;
                  } else {
                    animationControl.forward();
                    status = true;
                  }
                },
                tooltip: 'Floating Action Button',
                backgroundColor: Colors.red,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ));
  }
}
