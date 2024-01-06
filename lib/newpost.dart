import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/Util/mysnackmsg.dart';
import 'package:pomegranate/model/database_model.dart';

class NewPost extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  final String SelectedSubject;
  final String SelectedModule;
  const NewPost(this.SelectedBranch, this.SelectedSemester,
      this.SelectedSubject, this.SelectedModule);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController inputTitle = TextEditingController();
  TextEditingController disc = TextEditingController();
  TextEditingController link = TextEditingController();
  bool loading = false;
  String dbRef = 'post';
  List items = ["youtube", "web", "notes", "Textbook"];
  String? selectedItem;

  reset() {
    disc.clear();
    inputTitle.clear();
    link.clear();
    setState(() {});
  }

  saveUser() async {
    if (inputTitle.text.trim().isEmpty) {
      showMsg(context, 'Enter title');
    } else if (disc.text.trim().isEmpty) {
      showMsg(context, 'Enter description');
    } else if (link.text.trim().isEmpty) {
      showMsg(context, 'Enter link');
    } else {
      setState(() {
        loading = true;
      });

      try {
        Post_Model data = Post_Model(
          branch: widget.SelectedBranch,
          semester: widget.SelectedSemester,
          subject: widget.SelectedSubject,
          module: widget.SelectedModule,
          title: inputTitle.text.trim(),
          link: link.text.trim(),
          tag: selectedItem,
          user: FirebaseAuth.instance.currentUser!.displayName!,
          email: FirebaseAuth.instance.currentUser!.email!,
          disc: disc.text.trim(),
          likes: [],
        );
        await db.collection(dbRef).add(data.toFirestore()).then((value) {
          setState(() {
            loading = false;
          });
          showMsg(context, 'Data Saved!', isError: false);
          reset();
        });
      } catch (e) {
        setState(() {
          loading = false;
        });

        showMsg(context, e.toString());
      }
    }
  }

  userInput(String title, String hint, TextInputType type,
      TextEditingController controller,
      {int line = 1}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        keyboardType: type,
        maxLines: line,
        decoration: InputDecoration(
          hintText: hint,
          labelText: title,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.redAccent, width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.redAccent, width: 0.1),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF30303B),
        appBar: AppBar(
          title: Text("New Post"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                userInput(
                    'title', 'Enter title.', TextInputType.text, inputTitle),
                userInput('description', 'Enter description', TextInputType.text, disc,
                    line: 4),
                userInput('link', 'Enter link', TextInputType.text, link),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Select Source Tag',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 3,
                          color: Colors.redAccent,
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
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading
                        ? const SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              saveUser();
                            },
                            child: const Text('Upload')),
                    const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
