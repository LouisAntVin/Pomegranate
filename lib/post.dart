import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/Util/like.dart';
import 'package:pomegranate/home.dart';
import 'package:pomegranate/model/database_model.dart';
import 'package:pomegranate/newpost.dart';
import 'package:pomegranate/post_details.dart';
import 'package:url_launcher/url_launcher.dart';

class Post extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  final String SelectedSubject;
  final String SelectedModule;
  const Post(this.SelectedBranch, this.SelectedSemester, this.SelectedSubject,
      this.SelectedModule);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String dbRef = 'post';

  bool loading = false;
  String docID = '';
  List<Post_Model> postList = [];
  List<Post_Model> filter_postList = [];
  List items = ["youtube", "web", "notes", "Textbook"];
  String? selectedItem;

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  getAllUsers() async {
    if (postList.isNotEmpty) {
      postList = [];
    }
    await db
        .collection(dbRef)
        .where("branch", isEqualTo: widget.SelectedBranch)
        .where("semester", isEqualTo: widget.SelectedSemester)
        .where("subject", isEqualTo: widget.SelectedSubject)
        .where("module", isEqualTo: widget.SelectedModule)
        .get()
        .then(
      (value) {
        for (var e in value.docs) {
          print(e);
          postList.add(Post_Model.fromFirestore(e));
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getAllUsers();
    filter_postList = postList;
  }

  void _runfilter() {
    List<Post_Model> results = [];
    selectedItem == null
        ? results = postList
        : results =
            postList.where((element) => element.tag == selectedItem).toList();
    setState(() {
      filter_postList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30303B),
      appBar: AppBar(
        title: const Text('Results'),
        actions: [
          IconButton(
            onPressed: () {
              getAllUsers();
              filter_postList = postList;
            },
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(builder: (BuildContext context) => HomePage(widget.SelectedBranch,widget.SelectedSemester)),
                ModalRoute.withName('/'),
              );
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: DropdownButtonFormField<String>(
                elevation: 6,
                decoration: InputDecoration(
                  hintText: 'show',
                  suffixIcon: selectedItem == null
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                                selectedItem = null;
                                _runfilter();
                              })),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.purple,
                    ),
                  ),
                ),
                value: selectedItem,
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      ),
                    )
                    .toList(),
                onChanged: (item) => setState(
                  () {
                    selectedItem = item;
                    _runfilter();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                getAllUsers();
                filter_postList = postList;
              },
              child: ListView.builder(
                itemCount: filter_postList.length,
                itemBuilder: (context, index) {
                  Post_Model st = filter_postList[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  PostDetail(st,st.likes!.contains(currentUser.email)),
                        ),
                      ).then((value) => () {
                        getAllUsers();
                        filter_postList = postList;
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LikeButton(
                                isLiked: st.likes!.contains(currentUser.email),
                                onTap: () { print(st.likes);}
                            ),
                            Text(st.likes!.length.toString()),
                          ],
                        ),
                        title: Text(st.title.toString()),
                        subtitle: Text(st.tag.toString()),
                        trailing: IconButton(
                            onPressed: () {
                              _launchUrl(Uri.parse(st.link.toString()));
                            },
                            icon: const Icon(Icons.link)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tooltip: "New Post",
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewPost(
                  widget.SelectedBranch,
                  widget.SelectedSemester,
                  widget.SelectedSubject,
                  widget.SelectedModule),
            ),
          ).then((value) => () {
            getAllUsers();
            filter_postList = postList;
          });
        },
      ),
    );
  }
}
