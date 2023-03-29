import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/user.dart';

class SearchController extends GetxController {
  final Rx<List<myUser>> _searchedUsers = Rx<List<myUser>>([]);

  List<myUser> get serachUsers => _searchedUsers.value;

  searchUser(String typedUser) async {
    _searchedUsers.bindStream(FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: typedUser)
        .snapshots()
        .map((QuerySnapshot query) {
      List<myUser> retVal = [];
      for (var element in query.docs) {
        retVal.add(myUser.fromSnap(element));
      }
      return retVal;
    }));
  }
}
