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
String? validateYear(value){
  if(value==null || value.length==0) {
    return 'Please enter your car purchase year';
  }
  int year = int.parse(value);
  if(year>=1950 && year<=2030) {
    return null;
  } else {
    return 'Please enter a valid car purchase year';
  }

}
String? validateCarPrice(value) {
  String? checkNullEmpty = checkNullEmptyValidation(value, 'car price value');
  if (checkNullEmpty != null) {
    return checkNullEmpty;
  } else if (int.parse(value) < 1 || int.parse(value) > 99) {
    return 'Please enter a valid value between 0 and 99 lakhs';
  }
  return null;
}

String? validateMobile(value) {
  String? checkNullEmpty = checkNullEmptyValidation(value, "phone number");
  if (checkNullEmpty != null) {
    return checkNullEmpty;
  }
  if (value.length != 10) {
    return 'Please enter a valid mobile number';
  }
  return null;
}

String? checkNullEmptyValidation(value,title){
  if(value==null || value.isEmpty){
    return 'Please enter your $title ';
  }
  return null;
}
