import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/message_controller.dart';
import 'package:flutter_tiktok_clone_3/model/user.dart';
import 'package:flutter_tiktok_clone_3/view/screens/chat_screen.dart';
import 'package:get/get.dart';

class MessageScreen extends StatelessWidget {
  String? uid;
  MessageScreen({super.key, this.uid});

  final MessageController messageController = Get.put(MessageController());

  bool canChat = true;
  init(String chatWithId) async {
    canChat = await messageController.checkBlock(chatWithId);
  }

  @override
  Widget build(BuildContext context) {
    messageController.getListUsers('');
    return Obx(() => Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.red,
              title: TextFormField(
                decoration: const InputDecoration(
                    filled: false,
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    )),
                onFieldSubmitted: (value) =>
                    messageController.getListUsers(value),
              )),
          body: ListView.builder(
            itemCount: messageController.listUsers.length,
            itemBuilder: (context, index) {
              myUser user = messageController.listUsers[index];
              return InkWell(
                onTap: (() async {
                  if (await messageController.checkBlock(user.uid)) {
                    Get.snackbar('Notification',
                        'You cant chat with this guy because you blocked this guy');
                  } else {
                    if (await messageController.checkBlock1(user.uid)) {
                      Get.snackbar('Notification',
                          'You cant chat with this guy because you have been blocked by this guy');
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatScreen(
                                chatWithId: user.uid,
                              )));
                    }
                  }
                }),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePhoto),
                  ),
                  title: Text(
                    user.name,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
