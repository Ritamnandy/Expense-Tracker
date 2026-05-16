class Validator {
  // ================= EMAIL VALIDATOR =================

  static String? emailValidator(String? value) {
    // Empty Check
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    const emailPattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+\-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

    if (!RegExp(emailPattern).hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // ================= PASSWORD VALIDATOR =================

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    // Uppercase Letter Check
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Add at least one uppercase letter';
    }

    // Lowercase Letter Check
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Add at least one lowercase letter';
    }

    // Number Check
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Add at least one number';
    }

    // Special Character Check
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Add at least one special character';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
