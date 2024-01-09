import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ibnosina/common/apifunctions/requestLoginAPI.dart';
import 'package:ibnosina/common/functions/showDialogSingleButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;


class LoginScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen> {


  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _welcomeString = "";
  var logo;
  Widget cm;
  Future launchURL(String url) async {
    if(await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      showDialogSingleButton(context, "Indisponible", "Impossible de se connecter Veuillez Revenir Plus tard", "OK");
    }
  }


  @override
  void initState() {
    super.initState();
    _saveCurrentRoute("/LoginScreen");
  }

  _saveCurrentRoute(String lastRoute) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('LastScreenRoute', lastRoute);
  }

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).orientation==Orientation.portrait) {
      logo = Image.asset('assets/images/logo.jpg', width: 50, height: MediaQuery.of(context).size.height * 0.4,);
      cm=SizedBox(height: 48.0);
    }else{
      logo = Image.asset('assets/images/logo.jpg', width: 50, height: MediaQuery.of(context).size.width * 0.4,);
      cm=SizedBox(height: 20.0);
    }


    final tel = TextFormField(
      keyboardType: TextInputType.number,
      controller: _userNameController,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Telephone',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: 'Mot de passe',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          if(_userNameController.text=="" || _passwordController.text=="") {
            showDialogSingleButton(context, "Obligatoire", "Veuillez saisir telephone et mot de passe", "OK");
          }else{
            requestLoginAPI(context, _userNameController.text,
                _passwordController.text,1);
          }
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold,fontSize: 20)),
      ),
    );


    var drawer = Drawer();
    return WillPopScope(
      onWillPop: () {
        if(Navigator.canPop(context)) {
          Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushReplacementNamed('/dashboard');
        }
      },
      child:Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: <Widget>[
              logo,
              cm,
              tel,
              SizedBox(height: 25.0),
              password,
              SizedBox(height: 35.0),
              loginButon,
            ],
          ),
        ),
      ),
    );
  }
}

