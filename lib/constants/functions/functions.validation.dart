String? validateEmail(value, isValid) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  }
  if (value.isNotEmpty && isValid == false) {
    return 'Please, enter a valide email';
  }
  return null;
}

String? validatePassword(value, email) {
  if (email.isNotEmpty) {
    if (value.isEmpty || value == null) {
      return 'Please enter password';
    }
    if (value.length < 3) {
      return 'Please enter a valid password';
    }
  }
  return null;
}

String? validateName(value, nameType) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $nameType name';
  }

  return null;
}

String? validateSamePassword(value, password) {
  if (value != password) {
    return 'Confirm password must be same as password';
  } else if (value.isEmpty && password.isEmpty) {
    return null;
  } else if (value == null || value.isEmpty) {
    return 'Please enter confirm password';
  }

  return null;
}
