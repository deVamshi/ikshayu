import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ikshayu/helpers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ikshayu/home.screen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'firebase_options.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

int timeDecided = 5;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isInDanger = false;

  bool isLoggedIn = false;

  int remainingTime = timeDecided;

  void showPromptToAbort() async {
    setState(() {
      isInDanger = true;
    });

    for (int i = remainingTime; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        remainingTime--;
      });
    }

    if (isInDanger) {
      await Future.delayed(const Duration(seconds: 1));
      callEmergencyContact();
    }

    remainingTime = timeDecided;
  }

  void callEmergencyContact() async {
    try {
      bool? res = await FlutterPhoneDirectCaller.callNumber("6305926936");
      debugPrint("Value of calling function");
      debugPrint("$res");
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void initState() {
    // FirebaseAuth.instance.authStateChanges().listen((User? user) {
    //   if (user == null) {
    //     print('User is currently signed out!');
    //     isLoggedIn = false;
    //     setState(() {});
    //   } else {
    //     print('User is signed in!');
    //     isLoggedIn = true;
    //     setState(() {});
    //   }
    // });

    accelerometerEvents.listen((AccelerometerEvent event) {
      double a =
          sqrt(event.x * event.x + event.y * event.y + event.z + event.z);
      if (a < 1 || a == double.nan) showPromptToAbort();
    });

    super.initState();
  }

  void _signIn() => signInWithGoogle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isInDanger
                ? Column(
                    children: [
                      Text(remainingTime == 0
                          ? "Calling Emergency..."
                          : "Press abort within ${remainingTime < 0 ? 0 : remainingTime} seconds to abort"),
                      ElevatedButton(
                        onPressed: () {
                          isInDanger = false;
                          remainingTime = timeDecided;
                        },
                        child: const Text("Abort"),
                      )
                    ],
                  )
                : const Text('Everything Looks Fine!'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
