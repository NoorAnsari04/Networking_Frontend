import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'app_user.dart';
import 'auth_networking.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';

class SocialNetworking {
  final AuthNetworking _authNetworking = AuthNetworking();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        print('Google Authentication failed.');
        return null;
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final idToken = googleAuth.idToken;

      if (idToken != null) {
        final dio = Dio();
        final url = ApiConstants.baseUrl + ApiConstants.socialSignup;

        final response = await dio.post(
          url,
          data: {'idToken': idToken},
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        if (response.statusCode == 200) {
          final userData = response.data['data']['user'];
          print('User signed up successfully: $userData');

          return FirebaseAuth.instance.currentUser;
        } else {
          print(
              'Backend response error (status: ${response.statusCode}): ${response.data}');
          return null;
        }
      } else {
        print('Google Auth ID Token is null.');
        return null;
      }
    } on DioException catch (e) {
      print('Dio Error: ${e.response?.data ?? e.message}');
      return null;
    } catch (e) {
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
