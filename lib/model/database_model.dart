import 'package:cloud_firestore/cloud_firestore.dart';

class Comment_Model {
  final String? comID;
  final String text;
  final String user;
  final String time;

  Comment_Model({
    this.comID,
    required this.text,
    required this.user,
    required this.time,
  });
  factory Comment_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data();
    return Comment_Model(
      comID: snapshot.id,
      text: data?['text'],
      user: data?['user'],
      time: data?['time'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (text != null) "text": text,
      if(user != null) "user": user,
      if(time != null) "time": time,
    };
  }
}

class Subject_Model {
  final String? docID;
  final List? SUBJECTS;

  Subject_Model({
    this.docID,
    this.SUBJECTS,
  });
  factory Subject_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data();
    return Subject_Model(
      docID: snapshot.id,
      SUBJECTS: data?['SUBJECTS'],
    );
  }
}

class Post_Model {
  final String? docID;
  final String? title;
  final String? branch;
  final String? semester;
  final String? subject;
  final String? module;
  final String? tag;
  final String? link;
  final String? user;
  final String? email;
  final String? disc;
  final List? likes;


  Post_Model({
    this.docID,
    this.title,
    this.branch,
    this.semester,
    this.subject,
    this.module,
    this.tag,
    this.link,
    this.user,
    this.email,
    this.disc,
    this.likes,
  });

  factory Post_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data();
    return Post_Model(
      docID: snapshot.id,
      title: data?['title'],
      branch: data?['branch'],
      semester: data?['semester'],
      subject: data?['subject'],
      module: data?['module'],
      tag: data?['tag'],
      link: data?['link'],
      user: data?['user'],
      email: data?['email'],
      disc: data?['disc'],
      likes: data?['likes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (branch != null) "branch": branch,
      if (semester != null) "semester": semester,
      if (subject != null) "subject": subject,
      if (module != null) "module": module,
      if (tag != null) "tag": tag,
      if (link != null) "link": link,
      if(user != null) "user": user,
      if(email != null) "email": email,
      if(disc != null) "disc": disc,
      if(likes != null) "likes": likes,

    };
  }
}

class Save_Post_Model {
  final String? comID;
  final String text;
  final String user;
  final String time;

  Save_Post_Model({
    this.comID,
    required this.text,
    required this.user,
    required this.time,
  });
  factory Save_Post_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data();
    return Save_Post_Model(
      comID: snapshot.id,
      text: data?['text'],
      user: data?['user'],
      time: data?['time'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (text != null) "text": text,
      if(user != null) "user": user,
      if(time != null) "time": time,
    };
  }
}

class Spam_Model {
  final String? spamID;
  final String text;
  final String user;
  final String time;
  final String docID;

  Spam_Model({
    this.spamID,
    required this.text,
    required this.user,
    required this.time,
    required this.docID,
  });
  factory Spam_Model.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data();
    return Spam_Model(
      spamID: snapshot.id,
      text: data?['text'],
      user: data?['user'],
      time: data?['time'],
      docID: data?['docID'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (text != null) "text": text,
      if(user != null) "user": user,
      if(time != null) "time": time,
      if(docID != null) "docID": docID,
    };
  }
}