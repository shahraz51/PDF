import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wechat/screen/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wechat/screen/myhomepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xfff5f5f5),
        primarySwatch: Colors.deepPurple,
        primaryColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.deepPurpleAccent),
        textTheme: const TextTheme(
            headline1: TextStyle(
                color: Color(0xff360568),
                fontSize: 30,
                fontWeight: FontWeight.bold)),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, usersnapshots) {
          if (usersnapshots.hasData) {
            return  Myhomepage();
          } else {
            return const auth();
          }
        },
      ),
    );
  }
}
