
import 'package:shared_preferences/shared_preferences.dart';

saveLogout() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await preferences.setString('LastUser', "");
  await preferences.setString('LastToken', "");
  await preferences.setString('LastTel', "");
  await preferences.setString('LastPassword', "");
  await preferences.setInt('PatientId', 0);

}