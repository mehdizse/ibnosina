import 'package:flutter/material.dart';
import 'details/detailChronique.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'common/functions/getToken.dart';
import 'common/functions/getPatientId.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'ui/diagonal_clipper.dart';



class Chroniques extends StatefulWidget {

  Chroniques({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<Chroniques> {

  List data;
  int ye;
  var nom;
  double _imageHeight ;
  Map<String,dynamic> patient;
  List<dynamic> chroniques;
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
    String url = 'http://10.0.2.2:8000/api/chronique/${patient_id}';
    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    setState(() {

      if(response.statusCode==200) {
        var extractdata = jsonDecode(response.body);

        patient = extractdata["Patient"];
        chroniques= extractdata["Chronique"];
        patient = extractdata["Patient"];
        var now = new DateTime.now();
        var parsedDate = DateTime.parse(patient["date_naissance"]);
        Duration difference=now.difference(parsedDate);
        var days=difference.inDays;
        ye=(days/365).toInt();
        nom="${patient["nom"]} ${patient["prenom"]}";
        photo="${patient["photo"]}";
      }
    });
  }

  @override
  void initState() {
    this.makeRequest();
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
                "Traitement Chronique",
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
  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromARGB(250, 15,148, 180),
      title: Text(widget.title),
      actions: <Widget>[

      ],
    );

    ListTile makeListTile(Map<String, dynamic> chronique,Map<String,dynamic> patien) => ListTile(
        contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.autorenew, color: Color.fromARGB(250, 92, 92, 92)),
        ),
        title: Text(
          capitalizeFirstLetter(chronique["sac_nom"]),
          style: TextStyle(color: Color.fromARGB(250, 92, 92, 92), fontWeight: FontWeight.bold),
        ),


        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text("depuis ${chronique["date_etats"]}",
                      style: TextStyle(color: Color.fromARGB(250, 92, 92, 92)))),
            )
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Color.fromARGB(250, 92, 92, 92), size: 30.0),

        onTap: () {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailChronique(chroniques:chronique,patien:patient,age: ye)));
        }
    );

    Card makeCard(Map<String, dynamic> chronique) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(70, 239, 239, 239)),
        child: makeListTile(chronique,patient),
      ),
    );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: chroniques == null ? 0 : chroniques.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(chroniques[index]);
        },
      ),
    );

    Widget _buildBottomPart() {
      return new Padding(
        padding: new EdgeInsets.only(top: _imageHeight),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
                child:makeBody
            ),
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

