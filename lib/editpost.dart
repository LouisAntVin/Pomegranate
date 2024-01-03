import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/Util/mysnackmsg.dart';
import 'package:pomegranate/model/database_model.dart';

class EditPost extends StatefulWidget {
  final Post_Model SelectedPost;

  const EditPost(this.SelectedPost);

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
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

  updatePost() async {
    if (inputTitle.text.trim().isEmpty) {
      showMsg(context, 'Enter title');
    } else if (disc.text.trim().isEmpty) {
      showMsg(context, 'Enter Description');
    } else if (link.text.trim().isEmpty) {
      showMsg(context, 'Enter link');
    } else {
      setState(() {
        loading = true;
      });
      try {
        Post_Model data = Post_Model(
            branch: widget.SelectedPost.branch,
            semester: widget.SelectedPost.semester,
            subject: widget.SelectedPost.subject,
            module: widget.SelectedPost.module,
            title: inputTitle.text.trim(),
            link: link.text.trim(),
            tag: selectedItem,
            user: FirebaseAuth.instance.currentUser!.displayName!,
            disc: disc.text.trim(),
            likes: widget.SelectedPost.likes,
        );
        await db
            .collection('post')
            .doc(widget.SelectedPost.docID)
            .update(data.toFirestore())
            .then((value) {
          setState(() {
            loading = false;
          });
          showMsg(context, 'Data Updated!', isError: false);
          reset();
          Navigator.pop(context);
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
  void initState() {
    // TODO: implement initState
    inputTitle.text=widget.SelectedPost.title ?? '';
    disc.text=widget.SelectedPost.disc ?? '';
    link.text=widget.SelectedPost.link ?? '';
    selectedItem=widget.SelectedPost.tag;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFF30303B),
        appBar: AppBar(
          title: Text("Edit Post"),
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
                userInput('description', 'Enter description',
                    TextInputType.text, disc,
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
                              updatePost();
                            },
                            child: const Text('Update')),
                    const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
