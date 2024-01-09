import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ibnosina/dashboard.dart';
import 'package:ibnosina/ui/diagonal_clipper.dart';

class DetailChronique extends StatelessWidget {
  Map<String,dynamic> chroniques;
  Map<String,dynamic> patien;
  int age;
  double _imageHeight;
  DetailChronique({Key key, this.chroniques,this.patien,this.age}) : super(key: key);

  String capitalizeFirstLetter(String s) =>
      (s?.isNotEmpty ?? false) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;
  Widget _buildIamge(BuildContext context){
    if(MediaQuery.of(context).orientation==Orientation.portrait){
      _imageHeight=150.0;
    }else{
      _imageHeight=150.0;
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

  Widget _buildTopHeader(BuildContext context) {
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
                "Detail Médicament",
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

  Widget _buildProfileRow(BuildContext context) {
    if(MediaQuery.of(context).orientation==Orientation.portrait){
      return new Padding(
        padding: new EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
        child: new Row(
          children: <Widget>[
            new CircleAvatar(
              minRadius: 32.0,
              maxRadius: 32.0,
              backgroundImage: new NetworkImage('http://10.0.2.2:8000/avatar/${patien["photo"]}'),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    '${patien["nom"]} ${patien["prenom"]}',
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
                        ' ${age} ans',
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
              backgroundImage: new NetworkImage('http://10.0.2.2:8000/avatar/${patien["photo"]}'),
            ),
            new Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Text(
                    capitalizeFirstLetter('${patien["nom"]} ${patien["prenom"]}'),
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
                        ' ${age} ans',
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

  Widget _buildText(String text,BuildContext context) {
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
  Widget _buildText2(String text2,BuildContext context) {
    var t;
    if(text2.toString()=="null" || text2.toString()=="null Matin" || text2.toString()=="null Midi"|| text2.toString()=="null Soir"|| text2.toString()=="null Avant Coucher"){
      t="";
    }
    else{
      t=text2;
    }
    if(MediaQuery.of(context).orientation==Orientation.portrait){
      return Text(
        capitalizeFirstLetter("${t}"),
        style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.03),
      );
    }
    else{
      return Text(
        capitalizeFirstLetter("${t}"),
        style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.03),
      );
    }
  }
  Widget _buildWi(Widget t1,Widget t2){
    return Padding(
        padding: EdgeInsets.all(15),
        child:Row(
          children: <Widget>[
            Expanded(
                flex: 3,
                child:t1),
            Expanded(
                flex: 7,
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
                  _buildWi(_buildText("Traitement",context), _buildText2("${chroniques["sac_nom"]}",context)),
                  _buildWi(_buildText("Voie",context), _buildText2("${chroniques["voie"]}",context)),
                  _buildWi(_buildText("Unite",context), _buildText2("${chroniques["unite"]}",context)),
                  _buildWi(_buildText("Etat",context), _buildText2("${chroniques["etats"]}",context)),
                  _buildWi(_buildText("Date Debut",context), _buildText2("${chroniques["date_etats"]}",context)),
                  _buildWi(_buildText("Dosage",context), _buildText2("${chroniques["cosac_dosage"]} ${chroniques["cosac_unitedosage"]}",context)),
                  _buildWi(_buildText("Categorie",context), _buildText2("${chroniques["CATC_NOMF"]}",context)),
                  Column(
                    children: <Widget>[
                      _buildText("Prise",context),
                      _buildText2("${chroniques["dose_matin"]} Matin",context),
                      _buildText2("${chroniques["dose_midi"]} Midi",context),
                      _buildText2("${chroniques["dose_soir"]} Soir",context),
                      _buildText2("${chroniques["dose_avant_coucher Avant Coucher"]}",context),
                    ],
                  )
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
          _buildIamge(context),
          _buildTopHeader(context),
          _buildProfileRow(context),
          _buildBottomPart(),
        ],
      ),
    );
  }
}