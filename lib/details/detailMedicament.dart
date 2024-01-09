import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ibnosina/common/functions/getToken.dart';
import 'package:ibnosina/common/functions/getPatientId.dart';
import 'package:ibnosina/dashboard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ibnosina/ui/diagonal_clipper.dart';

class DetailMedicament extends StatefulWidget {
  int medicament_id;
  DetailMedicament({Key key, this.title,this.medicament_id}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState(medicament_id);
}

class _ListPageState extends State<DetailMedicament> {
  int medicament_id;
  _ListPageState(int medicament_id){
      this.medicament_id=medicament_id;
  }

  List data;
  Map<String,dynamic> patient;
  List<dynamic> prescriptions;
  List<dynamic> medicaments;
  var ye;
  var nom;
  double _imageHeight ;
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
    String url = 'http://10.0.2.2:8000/api/medicament/${patient_id}';
    final response = await http.post(
      Uri.parse(url),
      body:body,
    );

    setState(() {

      if(response.statusCode==200) {
        var extractdata = jsonDecode(response.body);
        patient = extractdata["Patient"];
        prescriptions= extractdata["Prescription"];
        photo==patient["photo"];
        var now = new DateTime.now();
        var parsedDate = DateTime.parse(patient["date_naissance"]);
        Duration difference=now.difference(parsedDate);
        var days=difference.inDays;
        ye=(days/365).toInt();
        nom="${patient["nom"]} ${patient["prenom"]}";
        for(var i in prescriptions){
          if(i["id"]==medicament_id){
            medicaments=i["prescription"];
          }
        }
      }
    });
  }
  String capitalizeFirstLetter(String s) =>
      (s?.isNotEmpty ?? false) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
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
                "Medicaments",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          new  InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Dashboard()));
            },
            child: Icon(Icons.home, color: Colors.white,size: 30,),
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
  @override
  Widget build(BuildContext context){
    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color.fromARGB(250, 15,148, 180),
      title: Text("Medicaments"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard()));
          },
        )
      ],
    );

    ListTile makeListTile(Map<String, dynamic> medicament,Map<String,dynamic> patien,int i) => ListTile(
        contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.autorenew, color:Color.fromARGB(250, 92, 92, 92)),
        ),
        title: Text(
          capitalizeFirstLetter("${medicament["sac_nom"]}"),
          style: TextStyle(color: Color.fromARGB(250, 92, 92, 92), fontWeight: FontWeight.bold),
        ),


        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text("${medicament["cosac_dosage"]} ${medicament["cosac_unitedosage"]} PENDANT ${medicament["nbr_jours"]} JOURS",
                      style: TextStyle(color: Color.fromARGB(250, 92, 92, 92)))),
            )
          ],
        ),


        onTap: () {

         /* Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailMedicament(medicament_id:prescription["id"]))); */
        }
    );

    Card makeCard(Map<String, dynamic> medicament,int i) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(70, 239, 239, 239)),
        child: makeListTile(medicament,patient,i),
      ),
    );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: medicaments == null ? 0 : medicaments.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(medicaments[index],index+1);
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
