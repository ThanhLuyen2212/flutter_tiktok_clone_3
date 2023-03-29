import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tiktok_clone_3/controller/auth_controller.dart';
import 'package:flutter_tiktok_clone_3/model/message.dart';
import 'package:flutter_tiktok_clone_3/model/user.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

class ChatController extends GetxController {
// lấy tin nhắn

  String _chatWithId = '';
  var _chatroomid; // chatroomid is a uid of users message with you
  // lấy thông tin người nhắn tin
  Rx<Map<String, dynamic>> _user = Rx<Map<String, dynamic>>({});
  Map<String, dynamic> get user => _user.value;

  final Rx<List<Message>> _messages = Rx<List<Message>>([]);
  List<Message> get messages => _messages.value;

  late myUser _chatWithUserInfo;

  myUser get chatWithUserInfo => _chatWithUserInfo;
  late myUser _myInfo = myUser(name: '', profilePhoto: '', email: '', uid: '');
  myUser get myInfo => _myInfo;

  //message id
  String messageId = '';

  @override
  void onReady() {}

  // updateInfo(String chatWithId) async {
  //   _chatWithId = chatWithId;
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(chatWithId)
  //       .get();
  //   _chatWithUserInfo = myUser.fromSnap(snap);

  //   DocumentSnapshot snap1 = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(AuthController.instance.user.uid)
  //       .get();
  //   _myInfo = myUser.fromSnap(snap1);
  // }

  Future addMessageMethod(String chatRoomId, String messageId,
      Map<String, dynamic> messageinfoMap) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .set(messageinfoMap);
  }

  updateLastMessageSendMethod(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  createChatRoomMethod(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      //chat room already exists
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessageMethod(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('ts', descending: false)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .orderBy('lastMessageSendTs', descending: true)
        .where('users', arrayContains: _myInfo.name)
        .snapshots();
  }

  //get user info
  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
  }
}
