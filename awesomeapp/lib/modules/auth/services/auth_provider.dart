import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/hive_services.dart';
import 'auth_networking.dart';
import 'app_user.dart';
import 'social_networking.dart';

class AuthenticationProvider with ChangeNotifier {
  final _authNetworking = AuthNetworking();
  final _socialNetworking = SocialNetworking();
  final _hiveService = HiveService();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  AppUser? _appUser;

  AppUser? get appUser => _appUser;

  bool get isLoggedIn => _appUser != null;

  UserCredential? _userCredential;

  UserCredential? get userCredential => _userCredential;

  AuthenticationProvider() {
    _appUser = _hiveService.getUser();
  }

  Future<bool> login(
      BuildContext context, String email, String password) async {
    try {
      _setLoading(true);
      final AppUser? user = await _authNetworking.login(email, password);
      _setLoading(false);
      print('User returned from login: $user');
      // print('Logged in user: ${_appUser?.name}');

      if (user != null) {
        _appUser = user;
        print('Logged in user: ${_appUser?.fullName}');
        _hiveService.saveUser(user);
        notifyListeners();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Login Failed. Please check your credentials.')));
        return false;
      }
    } catch (e) {
      _setLoading(false);
      print('Login Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error ocurred during login')));
      return false;
    }
  }

  Future<bool> signOut() async {
    _setLoading(true);
    final bool result = await _authNetworking.signOut();
    _setLoading(false);

    if (result) {
      _appUser = null;
      _hiveService.deleteUser();
      notifyListeners();
    }
    return result;
  }

  Future<bool> signUp(BuildContext context,
      {required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String confirmPassword}) async {
    try {
      _setLoading(true);
      final AppUser? user = await _authNetworking.signUp(
          email: email,
          password: password,
          firstName: firstName,
          lastname: lastName,
          confirmPassword: confirmPassword);
      _setLoading(false);
      if (user != null) {
        _appUser = user;
        _hiveService.saveUser(user);
        notifyListeners();
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signup Failed. Please try again')));
        return false;
      }
    } catch (e) {
      _setLoading(false);
      print('Error during signup: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error ocurred during Signup")));
      return false;
    }
  }

  Future<void> createUserDocument(Map<String, dynamic> userData,
      {bool isGoogleSignIn = false}) async {
    String userId;
    if (isGoogleSignIn) {
      userId = firebaseAuth.currentUser!.uid;
    } else {
      if (_userCredential != null && _userCredential!.user != null) {
        userId = _userCredential!.user!.uid;
      } else {
        return null;
      }
    }
    await _authNetworking.createUserDocument(userId, userData);
    if (_appUser != null) {
      _hiveService.saveUser(_appUser!);
      notifyListeners();
    }
  }

  Future<bool> googleSignIn() async {
    _setLoading(true);
    final user = await _socialNetworking.signInWithGoogle();
    _setLoading(false);

    if (user != null) {
      // Check if user document exists
      bool documentExists =
          await _socialNetworking.isUserDocumentExist(user.uid);

      if (documentExists) {
        // If document exists, fetch user data
        _appUser = await _socialNetworking.getUserData(user.uid);
        if (_appUser != null) {
          _hiveService.saveUser(_appUser!);
          notifyListeners();
        }
      }

      return true;
    }
    return false;
  }

  Future<bool> isUserDocumentExist() async {
    if (firebaseAuth.currentUser != null) {
      return await _authNetworking
          .isUserDocumentExist(firebaseAuth.currentUser!.uid);
    }
    return false;
  }

  void updateUser(AppUser appUser) {
    _appUser = appUser;
    _hiveService.saveUser(appUser);
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  static Future<void> saveUserCredentials(
      String email, String password, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('rememberMe', true);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
    }
  }

  static Future<Map<String, dynamic>> loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'email': prefs.getString('email') ?? '',
      'password': prefs.getString('password') ?? '',
      'rememberMe': prefs.getBool('rememberMe') ?? false,
    };
  }

  String? authToken() {
    // if (_appUser != null) {
    //   return _appUser!.accessToken;
     return HiveService().getUser()?.accessToken;
    }

    // return null;
  

  Future<String?> getAuthToken(String refreshToken) async {
    try {
      final newAccessToken =
          await _authNetworking.refreshAuthToken(refreshToken);
      if (newAccessToken != null) {
        _appUser?.accessToken = newAccessToken;
        _hiveService.saveUser(_appUser!);
        notifyListeners();
        return newAccessToken;
      }
    } catch (e) {
      print("Error fetching new auth token: $e");
    }
    return null;
  }

  void updateToken(String newToken){
    if(_appUser != null ){
      _appUser!.accessToken = newToken;
      _hiveService.saveUser(_appUser!);
      notifyListeners();
    }
  }
}
