import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ibnosina/common/functions/saveCurrentLogin.dart';
import 'package:ibnosina/common/functions/showDialogSingleButton.dart';
import 'dart:convert';

import 'package:ibnosina/model/loginModel.dart';

Future<LoginModel> requestLoginAPI(BuildContext context, String tel, String password,int deco) async {
  final url = "http://10.0.2.2:8000/api/user/login";
    Map<String, String> body = {
      'tel': tel,
      'password': password,
    };
    final response = await http.post(
      Uri.parse(url),
      body: body,
    );
    if(tel == "" || password == ""){
      print("cas1");
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    }else{
    if (response.statusCode == 200) {
      print("cas2");
      final responseJson = json.decode(response.body);
      print(responseJson);
      saveCurrentLogin(responseJson);
      Navigator.of(context).pushReplacementNamed('/dashboard');
      return LoginModel.fromJson(responseJson);
    } else {
      showDialogSingleButton(context, "Impossible de Se connecter",
          "Telephone ou mot de passe Incorrect Contacter l'administration.", "OK");
      return null;
    }}
}
