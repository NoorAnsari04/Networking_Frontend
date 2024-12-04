import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app_user.dart';
import 'auth_networking.dart';

class SocialNetworking {
  final AuthNetworking _authNetworking = AuthNetworking();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
    } on Exception catch (e) {
      print('Exception during Google Sign In: $e');
      return null;
    }
  }

  Future<bool> isUserDocumentExist(String userId) async {
    return await _authNetworking.isUserDocumentExist(userId);
  }

  Future<AppUser?> getUserData(String userId) async {
    final userDoc = await _authNetworking.getUserDocument(userId);
    if (userDoc != null) {
      return AppUser.fromJson({...userDoc, 'id': userId});
    }
    return null;
  }
}
