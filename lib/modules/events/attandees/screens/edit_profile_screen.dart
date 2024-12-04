import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/extensions/scaffold_message.dart';
import 'package:my_test_app_flavors/core/shared/user_avatar.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../../../core/shared/user_profile_manager.dart';
import '../components/edit_profile_form.dart';
import '../services/profile_provider.dart';

class EditProfileScreen extends StatefulWidget {
  static const id = 'editProfileScreen';

  EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final ProfileProvider _profileProvider;
  late final AuthenticationProvider _authProvider;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _descriptionController;
  late TextEditingController _linkedinController;

  // Industry person controllers
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late TextEditingController _experienceController;

  // Student controllers
  late TextEditingController _degreeProgramController;
  late TextEditingController _yearOfGraduationController;
  late TextEditingController _instituteNameController;

  final UserProfileManager _userProfileManager = UserProfileManager();
  File? _image;
  String? _imageUrl;
  late bool _isStudent;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    _authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    _isStudent = _authProvider.appUser?.isStudent ?? false;

    _nameController = TextEditingController(text: _authProvider.appUser!.name);
    _emailController =
        TextEditingController(text: _authProvider.appUser!.email);
    _descriptionController =
        TextEditingController(text: _authProvider.appUser!.description);
    _linkedinController =
        TextEditingController(text: _authProvider.appUser!.linkedinUrl ?? '');

    if (_isStudent) {
      _degreeProgramController =
          TextEditingController(text: _authProvider.appUser!.degreeProgram);
      _yearOfGraduationController =
          TextEditingController(text: _authProvider.appUser!.yearOfGraduation);
      _instituteNameController =
          TextEditingController(text: _authProvider.appUser!.instituteName);
    } else {
      _companyController =
          TextEditingController(text: _authProvider.appUser!.company);
      _positionController =
          TextEditingController(text: _authProvider.appUser!.position);
      _experienceController =
          TextEditingController(text: _authProvider.appUser!.experience ?? '');
    }

    _imageUrl = _authProvider.appUser!.imageUrl;
    print("Is Student: $_isStudent");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    _linkedinController.dispose();
    if (_isStudent) {
      _degreeProgramController.dispose();
      _yearOfGraduationController.dispose();
      _instituteNameController.dispose();
    } else {
      _companyController.dispose();
      _positionController.dispose();
      _experienceController.dispose();
    }
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl = _imageUrl;
      if (_image != null) {
        imageUrl = await _profileProvider.uploadImage(_image!);
      }
      final userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'description': _descriptionController.text,
        'linkedinUrl': _linkedinController.text,
        'imageUrl': imageUrl,
        'isStudent': _isStudent,
      };

      if (_isStudent) {
        userData.addAll({
          'degreeProgram': _degreeProgramController.text,
          'yearOfGraduation': _yearOfGraduationController.text,
          'instituteName': _instituteNameController.text,
        });
      } else {
        userData.addAll({
          'company': _companyController.text,
          'position': _positionController.text,
          'experience': _experienceController.text,
        });
      }

      final success = await _profileProvider.updateProfile(context, userData);

      if (success) {
        setState(() {
          _imageUrl = imageUrl;
        });
        context.showSnackBar('Profile updated Successfully');
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 4,
              color: ColorConstants.primaryColor,
            ),
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 4 - 80.h),
                UserProfileAvatar(
                  imageUrl: _imageUrl,
                  name: _authProvider.appUser!.name,
                  lastName: _authProvider.appUser!.lastName,
                  isEditable: true,
                  onEditTap: _pickImage,
                  newImage: _image,
                  outerRadius: 75.w,
                  innerRadius: 67.w,
                ),
                20.height,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
                  child: EditProfileForm(
                    formKey: _formKey,
                    nameController: _nameController,
                    emailController: _emailController,
                    linkedinController: _linkedinController,
                    descriptionController: _descriptionController,
                    isStudent: _isStudent,
                    companyController: _isStudent ? null : _companyController,
                    positionController: _isStudent ? null : _positionController,
                    experienceController:
                        _isStudent ? null : _experienceController,
                    degreeProgramController:
                        _isStudent ? _degreeProgramController : null,
                    yearOfGraduationController:
                        _isStudent ? _yearOfGraduationController : null,
                    instituteNameController:
                        _isStudent ? _instituteNameController : null,
                    onUpdateProfile: _updateProfile,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
