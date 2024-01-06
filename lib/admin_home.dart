import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/Util/authentication.dart';
import 'package:pomegranate/Util/mysnackmsg.dart';
import 'package:pomegranate/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pomegranate/model/database_model.dart';
import 'package:pomegranate/admin_post_details.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String dbRef = 'spam';

  bool loading = false;
  List<Spam_Model> spamList = [];
  List spamIndex = [];
  List<Post_Model> postList = [];

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  getSpamPost() async {
    if (spamList.isNotEmpty) {
      spamList = [];
    }
    await db.collection(dbRef).get().then(
      (value) {
        for (var e in value.docs) {
          print(e);
          spamList.add(Spam_Model.fromFirestore(e));
        }
        setState(() {});
      },
    );
  }

  getpost(String docID) async {

    setState(() {
      loading = true;
    });
    var docSnapshot =
        await db.collection('post').doc(docID).get();
    if (docSnapshot.exists) {
      setState(() {
        postList.add(Post_Model.fromFirestore(docSnapshot));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetail(postList.last),
          ),
        );
      }); // <-- The value you want to retrieve.
      // Call setState if needed.
    }
    setState(() {
      loading = false;
    });
  }

  deleteSpam(Spam_Model st) async {
    db
        .collection('spam')
        .doc(st.spamID)
        .delete()
        .then((value) {
      showMsg(context, 'Comment Deleted', isError: false);
      setState(() {
        getSpamPost();
      });
    });

  }

  @override
  void initState() {
    super.initState();
    getSpamPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30303B),
      appBar: AppBar(
        title: const Text('Home'),
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
              getSpamPost();
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
                      "Admin",
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
          /*
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
          */
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Reported Posts",
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
                getSpamPost();
              },
              child: ListView.builder(
                itemCount: spamList.length,
                itemBuilder: (context, index) {
                  Spam_Model st = spamList[index];

                  return InkWell(
                    onTap: () {
                      getpost(st.docID);
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(st.text.toString()),
                        subtitle: Text(st.time.toString()),
                        trailing:
                            IconButton(
                                onPressed: () {
                                  deleteSpam(st);
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.black54),

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
