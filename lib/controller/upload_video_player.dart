import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tiktok_clone_3/model/video.dart';
import 'package:get/get.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  // compress video into a file
  //
  _compressVideo(String videoPath) async {
    final compressedVideo = await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  // Reference: reference can be thought of as a pointer to a file in the cloud

  // upload video to storage in firebase storage

  Future<String> _uploadVideoToStorage(String id, String videoPath) async {
    Reference ref = FirebaseStorage.instance.ref().child('videos').child(id);

    UploadTask uploadTask = ref.putFile(await _compressVideo(videoPath));
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  _getThumbnail(String videoPath) async {
    final thumbnail = await VideoCompress.getFileThumbnail(videoPath);
    return thumbnail;
  }

  Future<String> _uploadImageToStorage(String id, String videoPath) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('thumbnails').child(id);

    UploadTask uploadTask = ref.putFile(await _getThumbnail(videoPath));
    TaskSnapshot snap = await uploadTask;
    String donwnloadUrl = await snap.ref.getDownloadURL();
    return donwnloadUrl;
  }

  uploadVideo(String songName, String caption, String videoPath) async {
    try {
      Get.snackbar('Notification', 'Please wait to put video to firebase');
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // get id

      var allDocs = await FirebaseFirestore.instance.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl = await _uploadVideoToStorage('video $len', videoPath);
      String thumbnail =
          await _uploadImageToStorage('thumbnai $len', videoPath);

      Video video = Video(
          username: (userDoc.data()! as Map<String, dynamic>)['name'],
          uid: uid,
          thumbnail: thumbnail,
          caption: caption,
          commentsCount: 0,
          id: 'video $len',
          likes: [],
          profilePic: (userDoc.data()! as Map<String, dynamic>)['profilePic'],
          shareCount: 0,
          songName: songName,
          videoUrl: videoUrl);

      await FirebaseFirestore.instance
          .collection('videos')
          .doc('video $len')
          .set(video.toJson());
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Error put video to firebase');
    }
  }
}
