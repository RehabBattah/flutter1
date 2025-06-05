import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPostsScreen extends StatefulWidget {
  const MyPostsScreen({super.key});

  @override
  State<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends State<MyPostsScreen> {
  final posts = FirebaseFirestore.instance.collection("events");

  void deletePost(String id) {
    posts.doc(id).delete().catchError((err) {
      print("Error deleting post: $err");
    });
  }

  void editPost(Map<String, dynamic> postData, String id) {
    Navigator.of(context).pushNamed("addpost", arguments: {
      "id": id,
      "title": postData["title"],
      "location": postData["location"],
      "description": postData["description"],
      "date": postData["date"],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Events")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("addpost"),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: posts
            // .where("creatorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            // .orderBy("timestamp", descending: true)
            // .snapshots(),

            .where("creatorId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  var data = doc.data();
                  var title = data["title"] ?? "";
                  var location = data["location"] ?? "";
                  var description = data["description"] ?? "";
                  var date = data["date"] != null
                      ? DateTime.parse(data["date"])
                      : null;

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$title", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("Location $location", style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 5),
                          if (date != null)
                            Text("Date: ${date.day}/${date.month}/${date.year}", style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text(description),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => deletePost(doc.id),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.amber),
                                onPressed: (){} ,
                                // editPost(data, doc.id),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Center(child: Text("No Events Found"));
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

