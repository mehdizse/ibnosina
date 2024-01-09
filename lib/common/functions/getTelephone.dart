

import 'package:shared_preferences/shared_preferences.dart';

getTelephone() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = await preferences.getString("LastTel");
  return email;
}