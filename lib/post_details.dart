import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pomegranate/Util/like.dart';
import 'package:pomegranate/Util/mysnackmsg.dart';
import 'package:pomegranate/model/database_model.dart';
import 'package:pomegranate/editpost.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetail extends StatefulWidget {
  final Post_Model SelectedPost;
  final bool likepass;

  const PostDetail(this.SelectedPost, this.likepass);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  bool isSaved = false;
  TextEditingController comment = TextEditingController();
  List<Comment_Model> commentList = [];
  bool loading = false;
  final box = Hive.box('save');
  var saveArray = [];

  void savePost(String PostID) {
    saveArray.add(PostID);
    box.put(currentUser.email, saveArray);
  }

  void unsavePost(String PostID) {
    saveArray.remove(PostID);
    box.put(currentUser.email, saveArray);
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  getAllComments() async {
    if (commentList.isNotEmpty) {
      commentList = [];
    }
    await db
        .collection('post')
        .doc(widget.SelectedPost.docID)
        .collection('Comments')
        .get()
        .then(
      (value) {
        for (var e in value.docs) {
          print(e);
          commentList.add(Comment_Model.fromFirestore(e));
        }
        setState(() {});
      },
    );
  }

  addComment() async {
    if (comment.text.trim().isEmpty) {
      showMsg(context, 'Enter comment');
    } else {
      setState(() {
        loading = true;
      });

      try {
        Comment_Model data = Comment_Model(
          text: comment.text.trim(),
          user: currentUser.displayName!.trim(),
          time: Timestamp.now().toDate().toString().substring(0, 11),
        );
        await db
            .collection('post')
            .doc(widget.SelectedPost.docID)
            .collection('Comments')
            .add(data.toFirestore())
            .then((value) {
          setState(() {
            loading = false;
          });
          showMsg(context, 'Data Saved!', isError: false);
          getAllComments();
          comment.clear();
        });
      } catch (e) {
        setState(() {
          loading = false;
        });

        showMsg(context, e.toString());
      }
    }
  }

  deleteComment(Comment_Model st) async {
    if (st.user == currentUser.displayName) {
      db
          .collection('post')
          .doc(widget.SelectedPost.docID)
          .collection('Comments')
          .doc(st.comID)
          .delete()
          .then((value) {
        showMsg(context, 'Post Deleted', isError: false);
        setState(() {
          getAllComments();
        });
      });
    }
  }

  deletePost() async {
    db.collection('post').doc(widget.SelectedPost.docID).delete()
        .then((value) {
      showMsg(context, 'Post Deleted', isError: false);
      Navigator.of(context).pop();
    });
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    DocumentReference postRef = FirebaseFirestore.instance
        .collection('post')
        .doc(widget.SelectedPost.docID);

    if (isLiked) {
// if the post is now liked, add the user's email to the 'Likes' field
      postRef.update({
        'likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else
// if the post is now unliked, remove the user's email from the 'Likes' field
      postRef.update({
        'likes': FieldValue.arrayRemove([currentUser.email])
      });
  }

  void toggleSave(String PostID) {
    setState(() {
      isSaved = !isSaved;
    });
    if (isSaved) {
      savePost(PostID);
    } else {
      unsavePost(PostID);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likepass;
    getAllComments();
    saveArray = box.get(currentUser.email) ?? [];
    isSaved = saveArray.contains(widget.SelectedPost.docID);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30303B),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Post Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white70),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.SelectedPost.user!,
                        style: TextStyle(fontSize: 12, color: Colors.black54)),
                    Text(widget.SelectedPost.title!,
                        style: TextStyle(fontSize: 18)),
                    Divider(
                      color: Colors.black87,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Text(widget.SelectedPost.disc!,
                        style: TextStyle(fontSize: 16, color: Colors.black87)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LikeButton(isLiked: isLiked, onTap: toggleLike),
                        IconButton(
                            onPressed: () {
                              _launchUrl(Uri.parse(
                                  widget.SelectedPost.link.toString()));
                            },
                            icon: const Icon(Icons.link)),
                        Visibility(
                          visible: widget.SelectedPost.user!.trim() ==
                              currentUser.displayName!.trim(),
                          child: IconButton(
                              onPressed: () {
                                deletePost();
                              },
                              icon: const Icon(Icons.delete)),
                        ),
                        Visibility(
                          visible: widget.SelectedPost.user!.trim() ==
                              currentUser.displayName!.trim(),
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditPost(widget.SelectedPost),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit)),
                        ),
                        SaveButton(
                            isSaved: isSaved,
                            onTap: () {
                              toggleSave(widget.SelectedPost.docID!);
                              print(saveArray);
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text("Comments",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25)),
          Divider(
            color: Colors.white38,
            indent: 15,
            endIndent: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: commentList.length,
              itemBuilder: (context, index) {
                Comment_Model st = commentList[index];
                return InkWell(
                  onTap: () {},
                  child: Card(
                    color: Colors.white10,
                    child: ListTile(
                      title: Text(st.text.toString(),
                          style: TextStyle(color: Colors.white)),
                      subtitle: Row(
                        children: [
                          Text(st.user.toString(),
                              style: TextStyle(color: Colors.white54),
                              textScaleFactor: 1),
                          Text("  :  ",
                              style: TextStyle(color: Colors.white54),
                              textScaleFactor: 0.8),
                          Text(st.time.toString(),
                              style: TextStyle(color: Colors.white54),
                              textScaleFactor: 0.8),
                        ],
                      ),
                      trailing: Visibility(
                        visible: st.user == currentUser.displayName!.trim(),
                        child: IconButton(
                            onPressed: () {
                              deleteComment(st);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.white60),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tooltip: "New Post",
        child: Icon(Icons.comment),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text("Add Comment"),
                content: TextField(
                  controller: comment,
                  decoration: InputDecoration(hintText: "Write a comment.."),
                ),
                actions: [
                  TextButton(
                    onPressed: () => addComment(),
                    child: Text("Post"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      comment.clear();
                    },
                    child: Text("Cancel"),
                  ),
                ]),
          );
        },
      ),
    );
  }
}
