import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileNetworking {
  final _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File image) async {
    try {
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final firebaseStorageRef = _storage.ref().child('images/$imageName');
      final uploadTask = firebaseStorageRef.putFile(image);
      final taskSnapshot = await uploadTask;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Upload Error: $e');
      throw e;
    }
  }

  Future<bool> updateProfile(
      String id, Map<String, dynamic> UserDetails) async {
    try {
      await _firestore.collection('users').doc(id).update(UserDetails);
      return true;
    } catch (e) {
      return false;
    }
  }
}
