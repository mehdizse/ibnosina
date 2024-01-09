import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ibnosina/common/widgets/basicDrawer.dart';


class Dashboard extends StatefulWidget {
  var title="";
  Dashboard({String title}){
    this.title=title;
  }
  @override
  _DashboardState createState() => _DashboardState();
}

Container makeDashboardItem(String title, IconData icon,BuildContext context,String link) {
  var iconsize;
  var textsize;
  var box1;
  var box2;
  var radi;
  if(MediaQuery.of(context).orientation==Orientation.portrait){
    iconsize=MediaQuery.of(context).size.height*0.07;
    textsize=MediaQuery.of(context).size.height*0.03;
    box1=MediaQuery.of(context).size.height*0.04;
    box2=MediaQuery.of(context).size.height*0.02;
    radi=45.0;
  }else{
    iconsize=MediaQuery.of(context).size.width*0.08;
    textsize=MediaQuery.of(context).size.width*0.03;
    box1=MediaQuery.of(context).size.width*0.04;
    box2=MediaQuery.of(context).size.width*0.02;
    radi=50.0;
  }
  return Container(
      child: Container(
        child: new InkWell(
          onTap: () {
            Navigator.pushNamed(context, link);
          },
          child: Column(
            children: <Widget>[
              SizedBox(height:box1 ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius:radi,
                  child: Icon(
                    icon,
                    size: iconsize,
                    color: Colors.blue,
                  )),
              SizedBox(height: box2),
              new Center(
                child: new Text(title,
                    style:
                    new TextStyle(fontSize: textsize, color: Colors.black)),
              )
            ],
          ),
        ),
      ));
}

class _DashboardState extends State<Dashboard> {
  var orientation  ;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: BasicDrawer(),
      appBar: AppBar(
        title: Text("Ibnosina"),
        elevation: .1,
        backgroundColor: Color.fromARGB(250, 15,148, 180),
      ),      body: Container(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
      color: Colors.grey[200],
      child:new OrientationBuilder(
      builder: (context, orientation) {
       return new GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
        padding: EdgeInsets.all(3.0),
        children: <Widget>[
          makeDashboardItem("Fiche Administrative", Icons.insert_drive_file,context,'/fiche'),
          makeDashboardItem("Consultations", FontAwesomeIcons.stethoscope,context,'/consultation'),
          makeDashboardItem("Traitement En Cours", FontAwesomeIcons.cuttlefish,context,'/chronique'),
          makeDashboardItem("Historique Pres", FontAwesomeIcons.capsules,context,'/historique'),
          makeDashboardItem("Antecedants", FontAwesomeIcons.folderOpen,context,'/biometrie'),
          makeDashboardItem("Examens", FontAwesomeIcons.syringe,context,'/bilans'),
          makeDashboardItem("Phytoterapie", FontAwesomeIcons.pagelines,context,'/phytoterapie'),
          makeDashboardItem("Hospitalisations", FontAwesomeIcons.ambulance,context,'/hospitalisation'),
          makeDashboardItem("Acts", FontAwesomeIcons.fileMedicalAlt,context,'/act'),
          makeDashboardItem("Imagerie",Icons.view_array,context,'/imagerie'),
        ],
      );}),
    ),
    );
  }
}