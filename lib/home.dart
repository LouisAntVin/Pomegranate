import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pomegranate/Util/authentication.dart';
import 'package:pomegranate/login.dart';
import 'package:pomegranate/profile.dart';
import 'package:pomegranate/subject.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pomegranate/Util/like.dart';
import 'package:pomegranate/model/database_model.dart';
import 'package:pomegranate/post_details.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  const HomePage(this.SelectedBranch, this.SelectedSemester);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final box = Hive.box('save');
  var saveArray = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  String dbRef = 'post';

  bool loading = false;
  List<Post_Model> postList = [];

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }


  getSavedPost() async {
    if (postList.isNotEmpty) {
      postList = [];
    }
    await db
        .collection(dbRef)
        .where(FieldPath.documentId, whereIn: saveArray)
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
    saveArray = box.get(currentUser.email) ?? [];
    getSavedPost();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30303B),
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                      context,
                      MaterialPageRoute(builder: (contex) => Profile(widget.SelectedBranch, widget.SelectedSemester)),
            );
          },
          icon: Icon(Icons.person),
          tooltip: 'Logout',
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthenticationHelper()
                  .signOut()
                  .then((_) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (contex) => Login()),
                      ));
            },
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          ),
          IconButton(
            onPressed: () {
              getSavedPost();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/pome logo.png',
                  height: 70,
                ),
                Column(
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName!,
                      style: TextStyle(color: Colors.redAccent, fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white38,
            indent: 15,
            endIndent: 15,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                elevation: 9,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 100,
                  child: InkWell(
                    splashColor: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Center(
                        child: Text(
                          "SELECT SUBJECT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30, // Set the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                            color: Colors.black, // Set the text color
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Subject(
                              widget.SelectedBranch, widget.SelectedSemester),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Text(
              "Saved Posts",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(
            color: Colors.white12,
            indent: 15,
            endIndent: 15,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                getSavedPost();
              },
              child: ListView.builder(
                itemCount: postList.length,
                itemBuilder: (context, index) {
                  Post_Model st = postList[index];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  PostDetail(st,st.likes!.contains(currentUser.email)),
                        ),
                      );
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
    );
  }
}
