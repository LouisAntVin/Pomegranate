import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/model/database_model.dart';
import 'package:pomegranate/Util/mysnackmsg.dart';
import 'package:url_launcher/url_launcher.dart';

class Post extends StatefulWidget {
  final String SelectedSemester;
  final String SelectedModule;
  const Post(this.SelectedSemester,this.SelectedModule);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String dbRef = 'post';
  Uri _url = Uri.parse('https://flutter.dev');

  TextEditingController inputTitle = TextEditingController();
  TextEditingController tag = TextEditingController();
  TextEditingController link = TextEditingController();
  bool loading = false;
  bool isUpdate = false;
  String docID = '';
  List<Post_Model> postList = [];
  List<Post_Model> filter_postList = [];
  List items = ["youtube", "web", "notes", "Textbook"];
  String? selectedItem;

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  reset() {
    tag.clear();
    inputTitle.clear();
    link.clear();
    setState(() {});
  }

  setUpdatePost(Post_Model st) {
    setState(() {
      isUpdate = true;
      docID = st.docID ?? '';
      tag.text = st.tag ?? '';
      link.text = st.link ?? '';
      inputTitle.text = st.title ?? '';
    });
  }

  getAllUsers() async {
    if (postList.isNotEmpty) {
      postList = [];
    }
    await db.collection(dbRef).where("sem", isEqualTo: widget.SelectedSemester).get().then(
      (value) {
        for (var e in value.docs) {
          print(e);
          postList.add(Post_Model.fromFirestore(e));
        }
        setState(() {});
      },
    );
  }

  updatePost() async {
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
            title: inputTitle.text.trim(),
            link: link.text.trim(),
            tag: tag.text.trim());
        await db
            .collection(dbRef)
            .doc(docID)
            .update(data.toFirestore())
            .then((value) {
          setState(() {
            loading = false;
          });
          showMsg(context, 'Data Updated!', isError: false);
          getAllUsers();
          isUpdate = false;
          _runfilter();
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
            title: inputTitle.text.trim(),
            link: link.text.trim(),
            tag: tag.text.trim());
        await db.collection(dbRef).add(data.toFirestore()).then((value) {
          setState(() {
            loading = false;
          });
          showMsg(context, 'Data Saved!', isError: false);
          getAllUsers();
          _runfilter();
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

  onDelete(Post_Model st) async {
    db.collection(dbRef).doc(st.docID).delete().then((value) {
      showMsg(context, 'Post Deleted', isError: false);
      setState(() {
        getAllUsers();
      });
    });
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
      appBar: AppBar(
        title: const Text('Firestore App'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              child: DropdownButtonFormField<String>(
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
            child: ListView.builder(
              itemCount: filter_postList.length,
              itemBuilder: (context, index) {
                Post_Model st = filter_postList[index];
                return InkWell(
                  onTap: () {
                    setUpdatePost(st);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Text(st.tag.toString()),
                      title: Text(st.title.toString()),
                      subtitle: Text(st.link.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              // const link="https://www.youtube.com/watch?v=s4tXuqbNymA",

                              onPressed: () {
                                _url = Uri.parse(st.link.toString());
                                _launchUrl();
                              },
                              icon: const Icon(Icons.link)),
                          IconButton(
                              onPressed: () {
                                onDelete(st);
                                _runfilter();
                              },
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          userInput('title', 'Enter title.', TextInputType.text, inputTitle,
              readOnly: isUpdate),
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
                        isUpdate ? updatePost() : saveUser();
                      },
                      child: isUpdate
                          ? const Text('Update data')
                          : const Text('Save')),
              isUpdate
                  ? IconButton(
                      onPressed: () {
                        isUpdate = false;
                        reset();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.red,
                      ))
                  : const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
}
