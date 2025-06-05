import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String title = "";
  String location = "";
  String description = "";
  DateTime? selectedDate;
  var key = GlobalKey<FormState>();

  saveEvent() {
    key.currentState!.save();
    FirebaseFirestore.instance.collection("events").add({
      "title": title,
      "location": location,
      "description": description,
      "date": selectedDate?.toIso8601String(),
      "timestamp": Timestamp.now(),
      "creatorId": FirebaseAuth.instance.currentUser!.uid,
      "creatoremail": FirebaseAuth.instance.currentUser!.email,
      "likes": [],
      "comments": []
    }).then((res) {
      Navigator.of(context).pop();
    }).catchError((err) {
      print(err);
    });
  }

  pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Event"),
      ),
      body: Form(
        key: key,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                onSaved: (newValue) {
                  title = newValue ?? "";
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Location"),
                onSaved: (newValue) {
                  location = newValue ?? "";
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                onSaved: (newValue) {
                  description = newValue ?? "";
                },
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: pickDate,
                icon: Icon(Icons.date_range),
                label: Text(
                  selectedDate == null
                      ? "Pick a date"
                      : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                ),
              ),
              SizedBox(height: 14),
              ElevatedButton(
                onPressed: saveEvent,
                child: Text("Add Event"),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
