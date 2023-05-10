import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/auth_controller.dart';
import 'package:flutter_tiktok_clone_3/model/user.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  Rx<String> _uid = ''.obs;

  updateUserId(String uid) {
    _uid.value = uid;
    getUserData();
  }

  getUserData() async {
    // get all of video user had post to internet
    List<String> thumbnails = [];
    var myVideos = await FirebaseFirestore.instance
        .collection('videos')
        .where('uid', isEqualTo: _uid.value)
        .get();

    for (int i = 0; i < myVideos.docs.length; i++) {
      thumbnails.add((myVideos.docs[i].data() as dynamic)['thumbnail']);
    }

    //get imformation of yourself or people you searched
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .get();

    // set yourself data to userdata
    final userData = userDoc.data()! as dynamic;
    String name = userData['name'];
    String profilePhoto = userData['profilePic'];
    int likes = 0;
    int followers = 0;
    int following = 0;
    bool isFollowing = false;

    // get sum like and set to likes
    for (var item in myVideos.docs) {
      likes += (item.data()['likes'] as List).length;
    }

    // get information of followers
    var followerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .get();

    // get information of following
    var followingDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('following')
        .get();

    followers = followerDoc.docs.length;
    following = followingDoc.docs.length;

    FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(AuthController.instance.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        isFollowing = true;
      } else {
        isFollowing = false;
      }
    });

    _user.value = {
      'followers': followers.toString(),
      'following': following.toString(),
      'isFollowing': isFollowing,
      'likes': likes.toString(),
      'profilePic': profilePhoto,
      'name': name,
      'thumbnails': thumbnails,
    };
    update();
  }

  followUser() async {
    var doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid.value)
        .collection('followers')
        .doc(AuthController.instance.user.uid)
        .get();

    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid.value)
          .collection('followes')
          .doc(AuthController.instance.user.uid)
          .set({});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.instance.user.uid)
          .collection('following')
          .doc(_uid.value)
          .set({});
      _user.value
          .update('followers', (value) => (int.parse(value) + 1).toString());
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_uid.value)
          .collection('followes')
          .doc(AuthController.instance.user.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AuthController.instance.user.uid)
          .collection('following')
          .doc(_uid.value)
          .delete();
      _user.value
          .update('followers', (value) => (int.parse(value) - 1).toString());
    }

    _user.value.update('isfollowing', (value) => !value);
    update();
  }

  // Future<bool> listBlock(String id) async {
  //   List<String> listUserBlocked = [];
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(AuthController.instance.user.uid)
  //       .get()
  //       .then((DocumentSnapshot snapshot) async {
  //     for (var item in ((snapshot.data() as dynamic)['block'])) {
  //       listUserBlocked.add(await item);
  //     }
  //   });
  //   return listUserBlocked.contains(id);
  // }

  List<String> listUserBlocked = [];
  listBlock() async {
    listUserBlocked = [];
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthController.instance.user.uid)
        .get();

    myUser user = myUser.fromSnap(userDoc);
    for (var item in user.block!) {
      listUserBlocked.add(item.toString());
    }
  }

  BlockUser(String id) async {
    var uid = AuthController.instance.user.uid;

    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (((doc.data()! as dynamic)['block'] as List).contains(id)) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'block': FieldValue.arrayRemove([id])
      });
    } else {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'block': FieldValue.arrayUnion([id])
      });
    }
  }

  Future<bool> checkBlock1(String chatWithId) async {
    List<String> listUserBlocked1 = [];
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(chatWithId)
        .get();

    myUser user = myUser.fromSnap(userDoc);
    for (var item in user.block!) {
      listUserBlocked1.add(item.toString());
    }
    return Future.value(
        listUserBlocked1.contains(AuthController.instance.user.uid));
  }
}
