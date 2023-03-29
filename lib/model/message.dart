import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String uid;
  String message;

  Message({required this.uid, required this.message});

  Map<String, dynamic> toJon() => {'uid': uid, 'message': message};

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Message(uid: snapshot['uid'], message: snapshot['message']);
  }
}
