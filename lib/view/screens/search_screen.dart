import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/search_controller.dart';
import 'package:flutter_tiktok_clone_3/model/user.dart';
import 'package:flutter_tiktok_clone_3/model/video.dart';
import 'package:flutter_tiktok_clone_3/view/screens/profile_screen.dart';
import 'package:flutter_tiktok_clone_3/view/screens/video_screen.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final SearchController searchController = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
              onFieldSubmitted: (value) {
                searchController.searchUser(value);
                searchController.searchVideo(value);
              }),
        ),
        body: (searchController.serachUsers.isEmpty &&
                searchController.searchVideos.isEmpty)
            ? const Center(
                child: Text(
                  '\t      Search for users! \n and search for videos!!!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: const Text(
                      'user',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: searchController.serachUsers.length,
                      itemBuilder: (context, index) {
                        myUser user = searchController.serachUsers[index];
                        return InkWell(
                          onTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        uid: user.uid,
                                      ))),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user.profilePhoto),
                            ),
                            title: Text(
                              user.name,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: const Text(
                      'Video',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: ListView.builder(
                        itemCount: searchController.searchVideos.length,
                        itemBuilder: (context, index) {
                          Video vidoes = searchController.searchVideos[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => VideoScreen(
                                    videosearch: vidoes,
                                  ));
                            },
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(vidoes.thumbnail),
                              ),
                              title: Text(
                                vidoes.caption,
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ))
                ],
              ),
      ),
    );
  }
}
