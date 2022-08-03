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

String? validateCarModel(value) {
  if (value ==null || value.isEmpty) {
    print('value is $value');
    return "Please choose your car's model";
  }
  return null;
}
String? validateYear(value){
  if(value==null || value.length==0){
    return ' Please enter car purchase year';
  }
  else if((value.length!=4) || (value[0]!='1' || value[0]!='2')){
    return 'Please enter a valid year';
  }
  return null;
}
String? validateCarPrice(value){
  if(value==null || value.isEmpty){
    return 'Please enter your car price value';
  }
  else if(int.parse(value)<1 || int.parse(value)>99){
    return 'Please enter a valid value between 0 and 99 lakhs';
  }
  return null;
}
String? validateFuelType(value){
  if (value ==null || value.isEmpty) {
    return "Please choose your car's fuel type";
  }
  return null;
}
