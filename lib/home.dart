import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var events= FirebaseFirestore.instance.collection("Events");
  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed("register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user!.email!.split('@')[0]}"),

        actions: [IconButton(onPressed: logout, icon: Icon(Icons.login))],
      ),
      body: StreamBuilder(
          stream: events.snapshots(),
          builder: (context, responce) {
            if (responce.connectionState == ConnectionState.done ||
                responce.connectionState == ConnectionState.active) {
              if (responce.data!.docs.isNotEmpty) {
                return ListView(
                  children: responce.data!.docs
                      .map((item) => ListTile(
                        title: Text(item.get("event1")!),
                        subtitle: Text(item.get("body")!),
                      ))
                      .toList());
              } else {
                return Center(child: Text("NO Events Added"),);
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}