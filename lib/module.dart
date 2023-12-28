import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pomegranate/post.dart';
import 'package:pomegranate/model/database_model.dart';

class Module extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  const Module(this.SelectedBranch, this.SelectedSemester);

  @override
  State<Module> createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<dynamic> moduleList = [];
  var _module;
  getdata() async {
    await db.collection('csbs').doc('5').get().then(
      (value) {
        moduleList = value.data()?["subject"];
        print(moduleList);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getdata();
    print(moduleList);
  }


  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.grey[600], //
          appBar: AppBar(
            title: Text('Choose Your Subject'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: moduleList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _module=moduleList[index];

                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Post(widget.SelectedBranch,widget.SelectedSemester,_module),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(moduleList[index].toString()),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
