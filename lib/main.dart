import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ikshayu/helpers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ikshayu/home.screen.dart';
import 'firebase_options.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
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
  String result = "Not yet";

  bool isLoggedIn = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        isLoggedIn = false;
        setState(() {});
      } else {
        print('User is signed in!');
        isLoggedIn = true;
        setState(() {});
      }
    });

    // accelerometerEvents.listen((AccelerometerEvent event) {
    //   double a =
    //       sqrt(event.x * event.x + event.y * event.y + event.z + event.z);
    //   if (a < 1 || a == double.nan) {
    //     setState(() {
    //       result = "FELLLL";
    //     });
    //   }
    // });

    super.initState();
  }

  void _signIn() => signInWithGoogle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isLoggedIn
          ? HomeScreen()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$result',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            bool? res = await FlutterPhoneDirectCaller.callNumber("8106483285");
            debugPrint("Value of calling function");
            debugPrint("$res");
          } catch (e) {
            debugPrint("$e");
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
