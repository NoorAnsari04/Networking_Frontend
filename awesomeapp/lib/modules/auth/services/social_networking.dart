import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/serviceLocator.dart';
import '../../../core/services/hive_services.dart';
import 'app_user.dart';
import 'auth_networking.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import 'auth_provider.dart';

class SocialNetworking {
  final AuthNetworking _authNetworking = AuthNetworking();

  Future<Map<String, dynamic>?> signInWithGoogle() async {
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

      final idToken = await userCredential.user?.getIdToken();

      print('Google ID Token: $idToken');

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
          final isNewUser = response.data['data']['isNewUser'] ?? false;
          final token = response.data['data']['accessToken'];
          if (token == null) {
            print('Token is missing!');
            return null;
          }
          final appUser = AppUser.fromJson({...userData, 'id':userData['_id']});
          print('User signed up successfully: $userData');
          final authProvider = serviceLocator<AuthenticationProvider>();
          authProvider.updateUser(appUser);
          authProvider.updateToken(token);
          await HiveService().saveUser(appUser);

          return {
            'firebaseUser': FirebaseAuth.instance.currentUser,
            'appuser': appUser,
            'token': token,
            'isNewUser': isNewUser
          };
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
