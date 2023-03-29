import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone_3/controller/auth_controller.dart';
import 'package:flutter_tiktok_clone_3/view/screens/add_video_screen.dart';
import 'package:flutter_tiktok_clone_3/view/screens/message_screen.dart';
import 'package:flutter_tiktok_clone_3/view/screens/profile_screen.dart';
import 'package:flutter_tiktok_clone_3/view/screens/search_screen.dart';
import 'package:flutter_tiktok_clone_3/view/screens/video_screen.dart';

const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

// firebase
// var firebaseAuth = FirebaseAuth.instance;
// var firebaseStorage = FirebaseStorage.instance;
// var firestore = FirebaseFirestore.instance;

// controller
//var authController = AuthController.instance;

// page
List pages = [
  //VideoScreen(),
  //Text('Video_screen'),

  //Text('Search Screen'),
  VideoScreen(),
  SearchScreen(),
  const AddVideoScreen(),
  //Text('addvideo screen'),
  //Text('Message Screen'),
  MessageScreen(),
  //Text('Profile Screen'),
  ProfileScreen(
    uid: AuthController.instance.user.uid,
  ),
];
