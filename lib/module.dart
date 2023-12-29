import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pomegranate/newpost.dart';
import 'package:pomegranate/post.dart';

class Module extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  final String SelectedSubject;
  const Module( this.SelectedBranch, this.SelectedSemester,this.SelectedSubject);

  @override
  State<Module> createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  @override
  late String _module;
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF30303B),//
        appBar: AppBar(
          title: Text('Choose Your Module'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomScrollView(
                  primary: false,
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid.count(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2, // Updated to have 2 columns
                        children: <Widget>[
                          buildGridItem('1'),
                          buildGridItem('2'),
                          buildGridItem('3'),
                          buildGridItem('4'),
                          buildGridItem('5'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridItem(String text) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: OKToast(
        child: InkWell(
            splashColor: Colors.red,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30, // Set the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                    color: Colors.black, // Set the text color
                  ),
                ),
              ),
            ),
            onTap: ()  {
              setState(() {
                _module=text;
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Post(widget.SelectedBranch,widget.SelectedSemester,widget.SelectedSubject,_module),
                ),
              );
            }),
      ),
    );
  }
}
