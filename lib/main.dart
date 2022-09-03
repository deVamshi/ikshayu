import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ikshayu/emergency.screen.dart';
import 'package:ikshayu/helpers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ikshayu/home.dart';
import 'package:ikshayu/home.screen.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'firebase_options.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:avatar_glow/avatar_glow.dart';

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
      debugShowCheckedModeBanner: false,
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
  bool inEmergencyScreen = false;

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
      sendEmergencySms();

      await Future.delayed(const Duration(seconds: 2));

      await callEmergencyContact();
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        inEmergencyScreen = true;
      });
    }

    remainingTime = timeDecided;
  }

  Future<void> callEmergencyContact() async {
    try {
      bool? res = await FlutterPhoneDirectCaller.callNumber("6303663432");
      debugPrint("Value of calling function");
      debugPrint("$res");
    } catch (e) {
      debugPrint("$e");
    }
  }

  void sendEmergencySms() {
    String message = "Your loved one might be in danger, Please check on them!";
    List<String> recipents = ["6303663432"];
    _sendSMS(message, recipents);
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(
      message: message,
      recipients: recipents,
      sendDirect: true,
    ).catchError((onError) {
      debugPrint("$onError");
    });
    debugPrint(_result);
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
      if (a < 1 || a == double.nan) {
        if (!isInDanger) showPromptToAbort();
      }
    });

    super.initState();
  }

  void _signIn() => signInWithGoogle();

  @override
  Widget build(BuildContext context) {
    if (inEmergencyScreen) return const EmergencyScreen();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isInDanger
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Are you in Emergency?",
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        remainingTime == 0
                            ? "Calling Emergency..."
                            : "Press abort within the next 5 seconds if it is a false fall",
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.w200),
                      ),
                      AvatarGlow(
                          glowColor: Colors.blue,
                          endRadius: 200,
                          duration: const Duration(milliseconds: 2000),
                          repeat: true,
                          showTwoGlows: true,
                          repeatPauseDuration:
                              const Duration(milliseconds: 100),
                          child: ElevatedButton(
                            onPressed: () {
                              isInDanger = false;
                              remainingTime = timeDecided;
                              setState(() {});
                            },
                            child: Text(
                              "Abort",
                              style: TextStyle(fontSize: 27),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              padding: EdgeInsets.all(100),
                              shape: CircleBorder(),
                            ),
                          )),
                    ],
                  )
                : Home(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     sendEmergencySms();
      //   },
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
