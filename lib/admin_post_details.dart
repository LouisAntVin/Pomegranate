import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/Util/mysnackmsg.dart';
import 'package:pomegranate/model/database_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetail extends StatefulWidget {
  final Post_Model SelectedPost;

  const PostDetail(this.SelectedPost);

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

  deleteComment(Comment_Model st) async {
      db
          .collection('post')
          .doc(widget.SelectedPost.docID)
          .collection('Comments')
          .doc(st.comID)
          .delete()
          .then((value) {
        showMsg(context, 'Comment Deleted', isError: false);
        setState(() {
          getAllComments();
        });
      });

  }

  deletePost() async {
    db.collection('post').doc(widget.SelectedPost.docID).delete().then((value) {
      showMsg(context, 'Post Deleted', isError: false);
      Navigator.of(context).pop();
    });
  }

  spamReport() async {
    if (comment.text.trim().isEmpty) {
      showMsg(context, 'Enter Specific Reason');
    } else {
      setState(() {
        loading = true;
      });

      try {
        Spam_Model data = Spam_Model(
          docID: widget.SelectedPost.docID!,
          text: comment.text.trim(),
          user: currentUser.displayName!.trim(),
          time: Timestamp.now().toDate().toString().substring(0, 11),
        );
        await db.collection('spam').add(data.toFirestore()).then((value) {
          setState(() {
            loading = false;
          });
          showMsg(context, 'Post Reported!', isError: false);
          comment.clear();
        });
      } catch (e) {
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
        showMsg(context, e.toString());
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllComments();
    currentUser.displayName ?? widget.SelectedPost.user;
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
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                    Text(widget.SelectedPost.docID!,
                        style: TextStyle(fontSize: 14, color: Colors.black54)),
                    Text("Branch: ${widget.SelectedPost.branch!} \nSemester: ${widget.SelectedPost.semester!}\nSubject: ${widget.SelectedPost.subject!}\nModule: ${widget.SelectedPost.module!}\n ",
                        style: TextStyle(fontSize: 15, color: Colors.black54)),
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
                        IconButton(
                            onPressed: () {
                              _launchUrl(Uri.parse(
                                  widget.SelectedPost.link.toString()));
                            },
                            icon: const Icon(Icons.link)),
                        IconButton(
                            onPressed: () {
                              deletePost();
                            },
                            icon: const Icon(Icons.delete)),

                        IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    title: Row(
                                      children: [
                                        Icon(Icons.report, color: Colors.red),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Report Post!",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red)),
                                      ],
                                    ),
                                    content: TextField(
                                      controller: comment,
                                      decoration: InputDecoration(
                                          hintText: "Specify Reason"),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          spamReport();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Report"),
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
                            icon: const Icon(Icons.report_gmailerrorred)),
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
                      trailing: IconButton(
                          onPressed: () {
                            deleteComment(st);
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.white60),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
