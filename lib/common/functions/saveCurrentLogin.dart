

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ibnosina/model/loginModel.dart';

saveCurrentLogin(Map responseJson) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();


  var user;
  if ((responseJson != null && !responseJson.isEmpty)) {
    user = LoginModel.fromJson(responseJson).name;
  } else {
    user = "";
  }
  var token = (responseJson != null && !responseJson.isEmpty) ? LoginModel.fromJson(responseJson).token : "";
  var tel = (responseJson != null && !responseJson.isEmpty) ? LoginModel.fromJson(responseJson).tel : "";
  var password = (responseJson != null && !responseJson.isEmpty) ? LoginModel.fromJson(responseJson).password : "";
  var pk = (responseJson != null && !responseJson.isEmpty) ? LoginModel.fromJson(responseJson).patientId : 0;

  await preferences.setString('LastUser', (user != null && user.length > 0) ? user : "");
  await preferences.setString('LastToken', (token != null && token.length > 0) ? token : "");
  await preferences.setString('LastTel', (tel != null && tel.length > 0) ? tel : "");
  await preferences.setString('LastPassword', (password != null && password.length > 0) ? password : "");
  await preferences.setInt('PatientId', (pk != null && pk > 0) ? pk : 0);
}