class Validator {
  static String? validateEmail(String? email) {
    const emailPattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final emailRegex = RegExp(emailPattern);

    if (email == null || email.isEmpty) {
      return 'Email can\'t be empty';
    }

    return !emailRegex.hasMatch(email) ? 'Enter a valid email address' : null;
  }

  static String? validatePassword(String? password) {
    RegExp regex = RegExp(r'^(?=.*\d)(?=.*[A-Z])(?=.*\W).{8}$');
    if (password == null || password.isEmpty) {
      return 'Password can\'t be empty';
    }

    if (password.length < 8) {
      return !regex.hasMatch(password)
          ? "Password must be 8 bit long having a special character and an uppercase character also an integer"
          : null;
    }

    return null;
  }

  static String? validateFields(String? value) {
    if (value == null || value.isEmpty) {
      return "fields can't be empty";
    }
    return null;
  }
}
