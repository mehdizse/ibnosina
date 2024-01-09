

import 'package:shared_preferences/shared_preferences.dart';

getPassword() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var password = await preferences.getString("LastPassword");
  return password;
}