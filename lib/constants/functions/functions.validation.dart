import 'package:intl/intl.dart';

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

String? validateYear(value) {
  if (value == null || value.length == 0) {
    return 'Please enter your car purchase year';
  }
  int year = int.parse(value);
  if (year >= 1950 && year <= 2030) {
    return null;
  } else {
    return 'Please enter a valid car purchase year';
  }
}

String? validatePrice(value) {
  String? checkNullEmpty = checkNullEmptyValidation(value, 'price');
  if (checkNullEmpty != null) {
    return checkNullEmpty;
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

String? checkNullEmptyValidation(value, title) {
  if (value == null || value.isEmpty) {
    return 'Please enter your $title ';
  }
  return null;
}

intToStringFormatter(value) {
  NumberFormat numberFormat = NumberFormat("##,##,##0");
  var parse = int.parse(value);
  var formattedValue = numberFormat.format(parse);
  return formattedValue;
}

formattedTime(value) {
  var date = DateTime.fromMicrosecondsSinceEpoch(value);
  var formattedDate = DateFormat.yMMMd().format(date);
  return formattedDate;
}
