import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/search_controller.dart';
import 'package:flutter_tiktok_clone_3/model/user.dart';
import 'package:flutter_tiktok_clone_3/view/screens/profile_screen.dart';
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
              onFieldSubmitted: (value) => searchController.searchUser(value),
            )),
        body: searchController.serachUsers.isEmpty
            ? const Center(
                child: Text(
                  'Search for users!',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.serachUsers.length,
                itemBuilder: (context, index) {
                  myUser user = searchController.serachUsers[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                              uid: user.uid,
                            ))),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePhoto),
                      ),
                      title: Text(
                        user.name,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
