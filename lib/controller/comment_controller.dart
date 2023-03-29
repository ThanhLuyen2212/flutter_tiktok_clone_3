import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tiktok_clone_3/controller/auth_controller.dart';
import 'package:flutter_tiktok_clone_3/model/comments.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  final Rx<List<Comment>> _comments = Rx<List<Comment>>([]);
  List<Comment> get comments => _comments.value;

  String _postId = "";

  updatePostID(String id) {
    _postId = id;
    getComment();
  }

  getComment() {
    try {
      _comments.bindStream(FirebaseFirestore.instance
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Comment> retValue = [];
        for (var element in query.docs) {
          retValue.add(Comment.fromSnap(element));
        }
        return retValue;
      }));
    } catch (e) {
      Get.snackbar("Error while get message", e.toString());
    }
  }

  postComment(String commentText) async {
    try {
      if (commentText.isNotEmpty) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(AuthController.instance.user.uid)
            .get();
        var allDocs = await FirebaseFirestore.instance
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .get();
        int len = allDocs.docs.length;
        Comment comment = Comment(
            username: (userDoc.data()! as dynamic)['name'],
            comment: commentText.trim(),
            datePub: DateTime.now(),
            likes: [],
            profilePic: (userDoc.data()! as dynamic)['profilePic'],
            uid: AuthController.instance.user.uid,
            id: 'Comment $len');

        await FirebaseFirestore.instance
            .collection('videos')
            .doc(_postId)
            .collection('comments')
            .doc('Comment $len')
            .set(comment.toJson());

        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('videos')
            .doc(_postId)
            .get();
        await FirebaseFirestore.instance
            .collection('videos')
            .doc(_postId)
            .update({
          'commentsCount': (doc.data()! as dynamic)['commentsCount'] + 1
        });
      }
    } catch (e) {
      Get.snackbar('Error while commenting', e.toString());
    }
  }

  likeComment(String id) async {
    var uid = AuthController.instance.user.uid;
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('videos')
        .doc(_postId)
        .collection('comments')
        .doc(id)
        .get();

    if (doc.data() != null && (doc.data()! as dynamic)['likes'].contains(uid)) {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('videos')
          .doc(_postId)
          .collection('comments')
          .doc(id)
          .update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }
}
