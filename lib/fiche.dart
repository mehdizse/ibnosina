import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'common/functions/getToken.dart';
import 'common/functions/getPatientId.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ui/diagonal_clipper.dart';


class Fiche extends StatefulWidget {
  Fiche({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<Fiche> {

  Map<String,dynamic> patient;
  List<dynamic> bilans;
  List<dynamic> userss;
  var ps;

  double _imageHeight ;
  bool showOnlyCompleted = false;
  var enfants;
  var ye;
  var p;
  var nom;
  var name;
  var prenom;
  var photo;
  Future<String> makeRequest() async {
    var token;
    var patient_id;



    await getToken().then((result) {
      token = result;
      return token;
    });
    await getPatientId().then((resultat) {
      patient_id = resultat;
    });

    Map<String, String> body = {
      'token': token,
    };
    var response = await http.post(Uri.parse('http://10.0.2.2:8000/api/patient/${patient_id}',
    ),body:body);



    setState(() {
      print(response.statusCode);
      if(response.statusCode==200) {
        var extractdata = jsonDecode(response.body);
        patient = extractdata["Patient"];
        userss= extractdata["user"];
        bilans=extractdata["Bilan"];

        var now = new DateTime.now();
        var date_naissance=patient["date_naissance"];
        var parsedDate = DateTime.parse(date_naissance);
        Duration difference=now.difference(parsedDate);
        var days=difference.inDays;
        ye=(days/365).toInt();
        nom="${patient["nom"]} ${patient["prenom"]}";
        photo="${patient["photo"]}";
        var nbr=patient["nbre_enfants"];
        if(nbr==null){
          enfants=0;
        }else{
          enfants=nbr;
        }
        var po=patient["poids"];

        if(po!=null){
          p=po;
        }
        if(ps !=null){
          p=ps;

        }
        for(var i in bilans){
          if(i["element"]=="poids" && i["valide"]==1){
            ps=i["valeur"];
            break;
          }
        }
        for(var z in userss){
            name=z["name"];
            prenom=z["prenom"];
        }
      }

    });
  }

  @override
  void initState() {
    this.makeRequest();
    patient = new Map<String,dynamic>();
    userss =new List<dynamic>();
    bilans=new List<dynamic> ();
  }
  Widget _buildIamge(){
    if(MediaQuery.of(context).orientation==Orientation.portrait){
      _imageHeight=150;
    }else{
      _imageHeight=150;
    }
    return new Positioned.fill(
      bottom: null,
      child: new ClipPath(
        clipper: new DialogonalClipper(),
        child: new Container(
          height: _imageHeight,
          color: Color.fromARGB(250, 15,148, 180),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new  InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white,size: 30,),
          ),
          new Expanded(
            child: new Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: new Text(
                "Fiche Administrative",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow() {
    if(MediaQuery.of(context).orientation==Orientation.portrait){
      return new Padding(
        padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              minRadius: 32.0,
              maxRadius: 32.0,
              backgroundImage: new NetworkImage('http://10.0.2.2:8000/avatar/${photo}'),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    '${nom}',
                    style: new TextStyle(
                        fontSize: MediaQuery.of(context).size.height*0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  new Row(
                    children: <Widget>[
                      new Icon(FontAwesomeIcons.heartbeat, size: MediaQuery.of(context).size.height*0.029, color: Colors.white),
                      new Text(
                        ' ${ye} ans',
                        style: new TextStyle(
                            fontSize:  MediaQuery.of(context).size.height*0.03,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );}else{
      return new Padding(
        padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              minRadius: 28.0,
              maxRadius: 28.0,
              backgroundImage: new NetworkImage('http://10.0.2.2:8000/avatar/${photo}'),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    '${nom}',
                    style: new TextStyle(
                        fontSize: MediaQuery.of(context).size.width*0.04,
                        color: Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                  ),
                  new Row(
                    children: <Widget>[
                      new Icon(FontAwesomeIcons.heartbeat, size: MediaQuery.of(context).size.width*0.029, color: Colors.white),
                      new Text(
                        ' ${ye} ans',
                        style: new TextStyle(
                            fontSize: MediaQuery.of(context).size.width*0.03,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      );
    }
  }
  String capitalizeFirstLetter(String s) =>
      (s?.isNotEmpty ?? false) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
  Widget _buildText(String text) {
    if(MediaQuery.of(context).orientation==Orientation.portrait){
      return Text(
        capitalizeFirstLetter("${text}"),
        style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.03,fontWeight: FontWeight.bold,color: Color.fromARGB(250, 15,148, 180)),
      );
    }
    else{
      return Text(
        "${text}",
        style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03,fontWeight: FontWeight.bold,color: Color.fromARGB(250, 15,148, 180)),
      );
    }
  }
  Widget _buildText2(String text2) {
    var t;
    if(text2.toString()=="null"){
      t="";
    }
    else{
      t=capitalizeFirstLetter(text2);
    }
    if(MediaQuery.of(context).orientation==Orientation.portrait){
      return Text(
        " ${t}",
        style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.03),
      );
    }
    else{
      return Text(
        " ${t}",
        style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03),
      );
    }
  }
  Widget _buildWi(Widget t1,Widget t2){
    return Padding(
        padding: EdgeInsets.only(left:25,right: 15,top: 15,bottom: 15),
        child:Row(
          children: <Widget>[
            Expanded(
                flex: 5,
                child:t1),
            Expanded(
                flex: 5,
                child: t2)
          ],));
  }


  @override
  Widget build(BuildContext context) {

    final bottomContent =new Expanded(
      flex: 1,
      child: new SingleChildScrollView(
          child:Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildWi(_buildText("Adresse"), _buildText2("${patient["adresse"]}")),
                  _buildWi(_buildText("Telephone"), _buildText2("${patient["num_tel_1"]}")),
                  _buildWi(_buildText("Situation Familliale"), _buildText2("${patient["situation_familliale"]} ${enfants} enfants")),
                  _buildWi(_buildText("Proffesion"), _buildText2("${patient["travaille"]}")),
                  _buildWi(_buildText("Num Sécurite Sociale"), _buildText2("${patient["num_securite_sociale"]}")),
                  _buildWi(_buildText("Num National d'identite"), _buildText2("${patient["code_national"]}")),
                  _buildWi(_buildText("Poids"), _buildText2("${p}")),
                  _buildWi(_buildText("Taille"), _buildText2("${patient["taille"]}")),
                  _buildWi(_buildText("Groupe Sanguin"), _buildText2("${patient["groupe_sanguin"]}")),
                  _buildWi(_buildText("Medecin Traitent"), _buildText2("${name } ${prenom }")),

                ],
              ))),
    );
    Widget _buildBottomPart() {
      return new Padding(
        padding: new EdgeInsets.only(top: _imageHeight),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            bottomContent
          ],
        ),
      );
    }
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildIamge(),
          _buildTopHeader(),
          _buildProfileRow(),
          _buildBottomPart(),
          ],
        ),
    );
  }
}