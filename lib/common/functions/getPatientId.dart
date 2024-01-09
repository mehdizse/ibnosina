

import 'package:shared_preferences/shared_preferences.dart';

getPatientId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  int getPatientId = await preferences.getInt("PatientId");
  return getPatientId;
}