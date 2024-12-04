import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'app_user.dart';

class AuthNetworking {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> createUserDocument(
      String userId, Map<String, dynamic> userData) async {
    try {
      await firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isUserDocumentExist(String userId) async {
    try {
      var docSnapshot = await firestore.collection('users').doc(userId).get();
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking user document: $e');
      return false;
    }
  }

  Future<AppUser?> login(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      final userDoc = await getUserDocument(userCredential.user!.uid);
      if (userDoc != null) {
        userDoc.update('id', (value) => userCredential.user!.uid,
            ifAbsent: () => userCredential.user!.uid);
        return AppUser.fromJson(userDoc);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    try {
      final snapshot = await firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<void> storeUserDataInFirestore(User? user) async {
    if (user != null) {
      final userDoc = firestore.collection('users').doc(user.uid);
      final userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        await userDoc.set({
          'name': user.displayName,
          'email': user.email,
          'imageUrl': user.photoURL,
        });
      }
    }
  }

  Future<bool> signOut() async {
    try {
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
