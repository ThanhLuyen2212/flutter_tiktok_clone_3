import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tiktok_clone_3/model/video.dart';
import 'package:get/get.dart';

import '../model/user.dart';

class SearchController extends GetxController {
  // serach by user name
  final Rx<List<myUser>> _searchedUsers = Rx<List<myUser>>([]);
  List<myUser> get serachUsers => _searchedUsers.value;
  // search by title video
  final Rx<List<Video>> _searchedVideos = Rx<List<Video>>([]);
  List<Video> get searchVideos => _searchedVideos.value;

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

  searchVideo(String typeVideo) async {
    _searchedVideos.bindStream(FirebaseFirestore.instance
        .collection('videos')
        .where('caption', isGreaterThanOrEqualTo: typeVideo)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Video> retVal = [];
      for (var element in query.docs) {
        retVal.add(Video.fromSnap(element));
      }
      return retVal;
    }));
  }
}
