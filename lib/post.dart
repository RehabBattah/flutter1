import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  PostCard(
      {required this.post,
      required this.fristButtonOnPress,
      required this.fristIcon,
      required this.secondButtonOnPress,
      required this.secondIcon});
  Map<String, dynamic> post;
  VoidCallback fristButtonOnPress;
  VoidCallback secondButtonOnPress;
  Icon fristIcon;
  Icon secondIcon;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(child: Text(widget.post['creatoremail']![0])),
                SizedBox(width: 10),
                Text(widget.post['creatoremail']!,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 12),
            Text(widget.post['title']!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                  widget.post['image'] ??
                      "https://firebasestorage.googleapis.com/v0/b/weallbeam.firebasestorage.app/o/default.png?alt=media&token=63da4649-5910-4bad-bd81-f4b96248ad45",
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover),
            ),
            SizedBox(height: 8),
            Text(widget.post['body']!),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed:widget.fristButtonOnPress, icon: widget.fristIcon),
                Text("${(widget.post['likes'] as List).length}"),
                IconButton(
                    onPressed: widget.secondButtonOnPress, icon: widget.secondIcon),
                    Text("${(widget.post['comments'] as List).length}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
