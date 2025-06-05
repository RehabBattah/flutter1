import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final events = FirebaseFirestore.instance.collection("events");

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> likeEvent(String eventId) async {
    var currentEvent = await events.doc(eventId).get();
    List likes = currentEvent["likes"] ?? [];

    if (likes.contains(user!.uid)) {
      likes.remove(user!.uid);
    } else {
      likes.add(user!.uid);
    }

    await events.doc(eventId).update({"likes": likes});
  }

  Future<void> commentOnEvent(String eventId) async {
    var controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Enter your comment"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              var comment = controller.text;
              await events.doc(eventId).update({
                "comments": FieldValue.arrayUnion([
                  {
                    "userId": user!.uid,
                    "text": comment,
                    "timestamp": Timestamp.now(),
                  },
                ])
              });
              Navigator.of(context).pop();
            },
            child: Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${user!.email}"),
        actions: [
          IconButton(
            icon: Icon(Icons.list_alt_outlined),
            onPressed: () => Navigator.of(context).pushNamed("myposts"),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("addpost"),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: events.orderBy("timestamp", descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  var data = doc.data();
                  var title = data["title"] ?? "";
                  var location = data["location"] ?? "";
                  var description = data["description"] ?? "";
                  var date = data["date"] != null
                      ? DateTime.parse(data["date"])
                      : null;
                  var likes = data["likes"] ?? [];
                  var comments = data["comments"] ?? [];
                  var creatorEmail = data["creatoremail"] ?? "Unknown";

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("$title", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text("Posted by: $creatorEmail", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          SizedBox(height: 5),
                          Text("Location: $location", style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 5),
                          if (date != null)
                            Text("Date: ${date.day}/${date.month}/${date.year}", style: TextStyle(color: Colors.grey[700])),
                          SizedBox(height: 10),
                          Text(description),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => likeEvent(doc.id),
                                icon: Icon(
                                  likes.contains(user!.uid)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                              ),
                              Text("${likes.length}"),
                              SizedBox(width: 20),
                              IconButton(
                                onPressed: () => commentOnEvent(doc.id),
                                icon: Icon(Icons.comment_outlined),
                              ),
                              Text("${comments.length}"),
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
