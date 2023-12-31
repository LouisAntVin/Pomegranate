import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/Util/mysnackmsg.dart';
import 'package:pomegranate/model/database_model.dart';

class NewPost extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  final String SelectedSubject;
  final String SelectedModule;
  const NewPost(this.SelectedBranch,this.SelectedSemester,this.SelectedSubject,this.SelectedModule);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  TextEditingController inputTitle = TextEditingController();
  TextEditingController tag = TextEditingController();
  TextEditingController link = TextEditingController();
  bool loading = false;
  String dbRef = 'post';

  reset() {
    tag.clear();
    inputTitle.clear();
    link.clear();
    setState(() {});
  }

  saveUser() async {
    if (inputTitle.text.trim().isEmpty) {
      showMsg(context, 'Enter title');
    } else if (tag.text.trim().isEmpty) {
      showMsg(context, 'Enter tag');
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
            tag: tag.text.trim());
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
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        readOnly: readOnly,
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(hintText: hint, labelText: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF30303B),
      appBar: AppBar(
        title: Text("New Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              userInput('title', 'Enter title.', TextInputType.text, inputTitle),
              userInput('tag', 'Enter tag', TextInputType.text, tag),
              userInput('link', 'Enter link', TextInputType.text, link),
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
                      child: const Text('Save')),
                   const SizedBox()
                ],
              ),
            ],
          ),
        ),
      )

      );

  }
}
