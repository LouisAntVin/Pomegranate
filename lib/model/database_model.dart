import 'package:cloud_firestore/cloud_firestore.dart';

class Post_Model {
  final String? docID;
  final String? title;
  final String? tag;
  final String? link;

  Post_Model({
    this.docID,
    this.title,
    this.tag,
    this.link,
  });

  factory Post_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data();
    return Post_Model(
      docID: snapshot.id,
      title: data?['title'],
      tag: data?['tag'],
      link: data?['link'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (tag != null) "tag": tag,
      if (link != null) "link": link,
    };
  }
}