import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/auth_controller.dart';
import 'package:flutter_tiktok_clone_3/controller/profile_controller.dart';
import 'package:flutter_tiktok_clone_3/view/screens/chat_screen.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController profileController = Get.put(ProfileController());

  bool block = false;
  bool show = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileController.updateUserId(widget.uid);
  }

  checkBlock() async {
    if (widget.uid != AuthController.instance.user.uid) {
      await profileController.listBlock();
      block = profileController.listUserBlocked.contains(widget.uid);
      show = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkBlock();
    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (controller) {
          if (controller.user.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black12,
              leading: const Icon(Icons.person_add_alt_1_outlined),
              actions: const [Icon(Icons.more_horiz)],
              title: Text(
                controller.user['name'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  SizedBox(
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: controller.user['profilePic'],
                              height: 100,
                              width: 100,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          )
                        ],
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            controller.user['following'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Flowing',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                      Container(
                        color: Colors.black54,
                        width: 1,
                        height: 15,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                      ),
                      Column(
                        children: [
                          Text(
                            controller.user['followers'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text(
                            'Followers',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                      Container(
                        color: Colors.black54,
                        width: 1,
                        height: 15,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            controller.user['likes'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Likes',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: 140,
                    height: 47,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Center(
                        child: InkWell(
                      onTap: (() {
                        if (widget.uid == AuthController.instance.user.uid) {
                          AuthController.instance.signOut();
                        } else {
                          controller.followUser();
                        }
                      }),
                      child: Text(
                        widget.uid == AuthController.instance.user.uid
                            ? 'Sign Out'
                            : controller.user['isFollowing']
                                ? 'unfollow'
                                : 'Follow',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Visibility(
                    visible: show,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Text(
                            block ? 'Blocked' : 'Block',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            setState(() {
                              block = !block;
                              profileController.BlockUser(widget.uid);
                            });
                          },
                        ),
                        Visibility(
                          visible: !block,
                          child: Container(
                            width: 140,
                            height: 47,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Center(
                                child: InkWell(
                              onTap: (() async {
                                if (await profileController
                                    .checkBlock1(widget.uid)) {
                                  Get.snackbar('Notification',
                                      'You cant chat with this guy because you have been blocked by this guy');
                                } else if (widget.uid !=
                                    AuthController.instance.user.uid) {
                                  Get.to(
                                      () => ChatScreen(chatWithId: widget.uid));
                                }
                              }),
                              child: Icon(
                                (widget.uid != AuthController.instance.user.uid)
                                    ? Icons.message
                                    : null,
                                color: Colors.white,
                                size: 35,
                              ),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.user['thumbnails'].length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            crossAxisSpacing: 5),
                    itemBuilder: (context, index) {
                      String thumbnail = controller.user['thumbnails'][index];
                      return CachedNetworkImage(
                        imageUrl: thumbnail,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                ],
              )),
            ),
          );
        });
  }
}
