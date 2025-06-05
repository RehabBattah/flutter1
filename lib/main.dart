import 'addpost.dart';
import 'home.dart';
import 'login.dart';
import 'myposts.dart';
import 'noconnection.dart';
import 'register.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "register": (context) => RegisterScreen(),
        "login": (context) => LoginScreen(),
        "home": (context) => HomeScreen(),
        "addpost": (context) => AddPostScreen(),
        "myposts": (context) => MyPostsScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authState) {
          if (authState.connectionState == ConnectionState.active) {
            if (authState.hasData) {
              return LoginScreen();
            } else {
              return LoginScreen();
            }
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}