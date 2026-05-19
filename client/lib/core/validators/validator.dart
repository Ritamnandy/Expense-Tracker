class Validator {
  // ================= EMAIL VALIDATOR =================

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    // Anchored at both ends ($) to prevent partial matches like "a@b.com!!!"
    const emailPattern =
        r"^[a-zA-Z0-9.!#$%&'*+\-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$";

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

    // Length check first — most fundamental requirement
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Add at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Add at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Add at least one number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Add at least one special character';
    }

    return null;
  }
}
