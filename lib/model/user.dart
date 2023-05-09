import 'package:cloud_firestore/cloud_firestore.dart';

class myUser {
  String name;
  String profilePhoto;
  String email;
  String uid;
  List? block;

  myUser(
      {required this.name,
      required this.profilePhoto,
      required this.email,
      required this.uid,
      this.block});

  // app - firebase (Map)
  Map<String, dynamic> toJson() => {
        'name': name,
        'profilePic': profilePhoto,
        'email': email,
        'uid': uid,
        'block': block
      };

  //fire base - app(User)
  static myUser fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return myUser(
        name: snapshot['name'],
        profilePhoto: snapshot['profilePic'],
        email: snapshot['email'],
        uid: snapshot['uid'],
        block: snapshot['block']);
  }
}
