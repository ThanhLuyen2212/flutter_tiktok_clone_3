import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/auth_controller.dart';
import 'package:flutter_tiktok_clone_3/controller/chat_controller.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';

import '../../model/user.dart';

class ChatScreen extends StatefulWidget {
  final String chatWithId;
  ChatScreen({
    super.key,
    required this.chatWithId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageTextEdittingController =
      TextEditingController();
  Stream? messageStream;
  myUser? _myInfo;
  myUser? _chatWithUserInfo;

  final ChatController chatController = Get.put(ChatController());
  String chatRoomId = '';
  String messageId = '';

  launch() async {
    _myInfo = myUser(name: '', profilePhoto: '', email: '', uid: '');
    DocumentSnapshot snap1 = await FirebaseFirestore.instance
        .collection('users')
        .doc(AuthController.instance.user.uid)
        .get();
    _myInfo = myUser.fromSnap(snap1);

    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.chatWithId)
        .get();
    _chatWithUserInfo = myUser.fromSnap(snap);

    chatRoomId = getChatRoomIdByUid(_chatWithUserInfo!.uid, _myInfo!.uid);
    messageStream = await chatController.getChatRoomMessageMethod(chatRoomId);

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState

    launch();
    super.initState();
  }

  // autumation create chatroomid if chatroomid have not create
  getChatRoomIdByUid(String a, String b) {
    if (a.isNotEmpty && b.isNotEmpty) {
      if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
        return "$b\_$a";
      } else {
        return "$a\_$b";
      }
    }
  }

  addMessage() {
    if (_messageTextEdittingController.text != '') {
      String message = _messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        'message': message,
        'sendBy': _myInfo!.name,
        'ts': lastMessageTs,
        'imgUrl': _myInfo!.profilePhoto
      };

      if (messageId == '') {
        messageId = randomAlphaNumeric(12);
      }

      chatController
          .addMessageMethod(chatRoomId, messageId, messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          'lastMessage': message,
          'lastMessageSendTs': lastMessageTs,
          'lastMessageSendBy': _myInfo!.name
        };

        chatController.updateLastMessageSendMethod(
            chatRoomId, lastMessageInfoMap);
      });
    }
  }

  afterSendMessageClick() {
    _messageTextEdittingController.text = "";
    messageId = "";
  }

  Widget chatMessageTitle(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              bottomRight: sendByMe ? Radius.circular(0) : Radius.circular(24),
              topRight: Radius.circular(24),
              bottomLeft: sendByMe ? Radius.circular(24) : Radius.circular(0),
            ),
            color: sendByMe ? Colors.blue : Color(0xfff1f0f0),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ))
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: const EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTitle(
                      ds['message'], _myInfo!.name == ds['sendBy']);
                })
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_chatWithUserInfo!.name),
      ),
      body: Container(
        child: Stack(children: [
          chatMessages(),
          // Container(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     color: Colors.black.withOpacity(0.8),
          //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //     child: Row(children: [
          //       Expanded(
          //           child: TextField(
          //         controller: _messageTextEdittingController,
          //         // onChanged: (value) {
          //         //   chatController.addMessage(
          //         //       false, _messageTextEdittingController.text);
          //         // },
          //         style: TextStyle(color: Colors.white),
          //         decoration: InputDecoration(
          //             border: InputBorder.none,
          //             hintText: 'Type a message',
          //             hintStyle:
          //                 TextStyle(color: Colors.white.withOpacity(0.6))),
          //       )),
          //       GestureDetector(
          //         onTap: () {
          //           addMessage();
          //           afterSendMessageClick();
          //         },
          //         child: Icon(
          //           Icons.send,
          //           color: Colors.white,
          //         ),
          //       )
          //     ]),
          //   ),
          // )
        ]),
      ),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          child: Container(
            height: 50,
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black.withOpacity(0.8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(children: [
                Expanded(
                    child: TextField(
                  controller: _messageTextEdittingController,
                  // onChanged: (value) {
                  //   chatController.addMessage(
                  //       false, _messageTextEdittingController.text);
                  // },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type a message',
                      hintStyle:
                          TextStyle(color: Colors.white.withOpacity(0.6))),
                )),
                GestureDetector(
                  onTap: () {
                    addMessage();
                    afterSendMessageClick();
                  },
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
              ]),
            ),
          )),
    );
  }
}
