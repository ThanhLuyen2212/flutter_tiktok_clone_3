import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tiktok_clone_3/controller/auth_controller.dart';
import 'package:flutter_tiktok_clone_3/model/user.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart';

class MessageController extends GetxController {
  final Rx<List<myUser>> _listUsers = Rx<List<myUser>>([]);
  List<myUser> get listUsers => _listUsers.value;

  getListUsers(String typedUser) async {
    if (typedUser == '') {
      _listUsers.bindStream(FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map((QuerySnapshot query) {
        List<myUser> retVal = [];
        for (var element in query.docs) {
          if ((element.data() as dynamic)['uid'] !=
              AuthController.instance.user.uid) {
            retVal.add(myUser.fromSnap(element));
          }
        }
        return retVal;
      }));
    } else {
      _listUsers.bindStream(FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: typedUser)
          .snapshots()
          .map((QuerySnapshot query) {
        List<myUser> retVal = [];
        for (var element in query.docs) {
          if ((element.data() as dynamic)['uid'] !=
              AuthController.instance.user.uid) {
            retVal.add(myUser.fromSnap(element));
          }
        }
        return retVal;
      }));
    }
  }

  Future<bool> checkBlock(String chatWithId) async {
    List<String> listUserBlocked = [];
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthController.instance.user.uid)
        .get();

    myUser user = myUser.fromSnap(userDoc);
    for (var item in user.block!) {
      listUserBlocked.add(item.toString());
    }
    return Future.value(listUserBlocked.contains(chatWithId));
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
