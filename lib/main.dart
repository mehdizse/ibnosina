import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'consultation.dart';
import 'act.dart';
import 'automedication.dart';
import 'bilans.dart';
import 'antecedants.dart';
import 'chronique.dart';
import 'fiche.dart';
import 'hospitalisation.dart';
import 'medicament.dart';
import 'phytoterapie.dart';
import 'package:ibnosina/Historique.dart';
import 'ui/loginScreen.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:ibnosina/common/apifunctions/requestLoginAPI.dart';
import 'package:ibnosina/common/functions/getTelephone.dart';
import 'package:ibnosina/common/functions/getPassword.dart';
import 'imagerie.dart';

void main(){
  runApp(new MaterialApp(
    debugShowCheckedModeBanner:false,
    home: new MyApp(),
    routes: <String, WidgetBuilder>{
      '/dashboard': (BuildContext context) => Dashboard(title: 'anapharm'),
      '/consultation': (BuildContext context) =>
          Consultation(title: 'Consultation'),
      '/fiche': (BuildContext context) => Fiche(),
      '/automedication': (BuildContext context) =>
          Automedication(title: 'Automedications'),
      '/medicament': (BuildContext context) =>
          Medicament(title: 'Prescriptions'),
      '/act': (BuildContext context) => Act(title: 'Act Medicales'),
      '/bilans': (BuildContext context) => Bilans(title: 'Examens'),
      '/chronique': (BuildContext context) =>
          Chronique(title: 'Traitement En Cours'),
      '/chroniques': (BuildContext context) =>
          Chronique(title: 'Traitement Chronique'),
      '/phytoterapie': (BuildContext context) =>
          Phytoterapie(title: 'Phytoterapies'),
      '/historique': (BuildContext context) =>
          Historique(title: 'Historique Medicament'),
      '/hospitalisation': (BuildContext context) =>
          Hospitalisation(title: 'Hospitalisations'),
      '/biometrie': (BuildContext context) =>
          Biometrie(title: 'Antecedants'),
      '/imagerie': (BuildContext context) =>
          Imagerie(title: 'Imagerie'),
      "/LoginScreen": (BuildContext context) => LoginScreen(),
    },
  ));
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 8,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text(' La santé est le trésor de la vie',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0
        ),
      ),
      image: Image.asset('assets/images/logo.jpg',),
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      onClick: ()=>print("Ibnosina"),
      loaderColor: Colors.red,
    );
  }
}
class AfterSplash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var login;
    var password;

    requestEmailApi() async {
      await getTelephone().then((result) {
        login = result;
      });
      await getPassword().then((resultat) {
        password = resultat;
      });

      if (login != null && password != null && login != "" && password != "") {
        requestLoginAPI(context, login, password,2);
      } else {
        requestLoginAPI(context,"","",2);
      }
    }
    requestEmailApi();
    return new Container(
      width: 0,
      height: 0,
      color: Colors.white,
    );
  }
}