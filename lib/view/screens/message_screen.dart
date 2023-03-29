import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/auth_controller.dart';
import 'package:flutter_tiktok_clone_3/controller/message_controller.dart';
import 'package:flutter_tiktok_clone_3/controller/search_controller.dart';
import 'package:flutter_tiktok_clone_3/model/user.dart';
import 'package:flutter_tiktok_clone_3/view/screens/chat_screen.dart';
import 'package:flutter_tiktok_clone_3/view/screens/profile_screen.dart';
import 'package:get/get.dart';

class MessageScreen extends StatelessWidget {
  String? uid;
  MessageScreen({super.key, this.uid});

  final MessageController messageController = Get.put(MessageController());

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
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          chatWithId: user.uid,
                        ))),
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
