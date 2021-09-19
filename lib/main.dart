import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:study/app.dart';
import 'package:study/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  runApp(App());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "test",
      home: Home(),
    );
  }
}
