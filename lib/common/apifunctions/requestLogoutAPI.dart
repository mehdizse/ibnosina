import 'dart:async';
import 'dart:io';
import 'package:ibnosina/ui/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibnosina/common/functions/getToken.dart';
import 'package:ibnosina/common/functions/saveLogout.dart';
import 'package:ibnosina/model/loginModel.dart';


Future<LoginModel> requestLogoutAPI(BuildContext context) async {
  final url = "http://10.0.2.2:8000/api/logout";

  var token;

  await getToken().then((result) {
    token = result;
  });
  Map<String, String> body = {
    'token': token,
  };
  final response = await http.post(
    Uri.parse(url),
    body: body,
  );

  if (response.statusCode == 200) {
    saveLogout();
  }else{
    saveLogout();
  }
}