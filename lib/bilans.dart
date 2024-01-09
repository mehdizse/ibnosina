import 'package:flutter/material.dart';
import 'details/detailBilan.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'common/functions/getToken.dart';
import 'common/functions/getPatientId.dart';




class Bilans extends StatefulWidget {
  Bilans({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<Bilans> {

  List data;
  Map<String,dynamic> patient;
  List<dynamic> bilans;
  var ye;
  var nom;
  TextEditingController _textController = TextEditingController();
  Widget appBarTitle = new Text(
    "Examens",
    style: new TextStyle(color: Colors.white,),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  bool _isSearching;
  String _searchText = "";
  List searchresult = new List();

  _ListPageState() {
    _textController.addListener(() {
      if (_textController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _textController.text;
        });
      }
    });
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(centerTitle: true, title: appBarTitle,backgroundColor: Color.fromARGB(250, 15,148, 180) ,actions: <Widget>[
      new IconButton(
        icon: icon,
        onPressed: () {
          setState(() {
            if (this.icon.icon == Icons.search) {
              this.icon = new Icon(
                Icons.close,
                color: Colors.white,
              );
              this.appBarTitle = new TextField(
                controller: _textController,
                style: new TextStyle(
                  color: Colors.white,
                ),
                decoration: new InputDecoration(
                    hintText: "Rechercher Bilan...",
                    hintStyle: new TextStyle(color: Colors.white)),
                onChanged: searchOperation,
              );
              _handleSearchStart();
            } else {
              _handleSearchEnd();
            }
          });
        },
      ),
    ]);
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        "Examens",
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _textController.clear();
    });
  }

  void searchOperation(String searchText) {
    searchresult.clear();
    if (_isSearching != null) {
      for (int i = 0; i < bilans.length; i++) {
        String data = bilans[i]["element"];
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchresult.add(bilans[i]);
        }
      }
    }
  }

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

    String url = 'http://10.0.2.2:8000/api/bilan/${patient_id}';
    Map<String, String> body = {
      'token': token,
    };
    final response = await http.post(
      Uri.parse(url),
      body: body,
    );

    setState(() {

      if(response.statusCode==200) {
        _isSearching = false;
        var extractdata = jsonDecode(response.body);
        patient = extractdata["Patient"];
        bilans= extractdata["Bilan"];
        var now = new DateTime.now();
        var parsedDate = DateTime.parse(patient["date_naissance"]);
        Duration difference=now.difference(parsedDate);
        var days=difference.inDays;
        ye=(days/365).toInt();
        print(ye);
      }
    });
  }

  @override
  void initState() {
    this.makeRequest();
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

    ListTile makeListTile(Map<String, dynamic> bilan,Map<String,dynamic> patien) => ListTile(
        contentPadding:
        EdgeInsets.symmetric(horizontal: 20.0, vertical: 3.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.autorenew, color: Color.fromARGB(250, 92, 92, 92)),
        ),
        title: Text(
          capitalizeFirstLetter("${bilan["element"]} "),
          style: TextStyle(color: Color.fromARGB(250, 92, 92, 92), fontWeight: FontWeight.bold),
        ),


        subtitle: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Padding(
                  padding: EdgeInsets.only(left: 5.0),
                  child: Text("${bilan["valeur"]} ${bilan["unite"]} ${bilan["date_analyse"]}",
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
                  builder: (context) => DetailBilan(bilanes:bilan,patien:patient,age:ye)));
        }
    );

    Card makeCard(Map<String, dynamic> bilan) => Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(70, 239, 239, 239)),
        child: makeListTile(bilan,patient),
      ),
    );

    final makeBody = Container(
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: searchresult.length != 0 || _textController.text.isNotEmpty
          ?

      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: searchresult.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(searchresult[index]);
        },
      ): ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: bilans == null ? 0 : bilans.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(bilans[index]);
        },
      ),
    );

    return Scaffold(
      key: globalKey,
      appBar: buildAppBar(context),
      body: new Container(
      child: new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
          child: makeBody,
          )
        ]
      )),
    );
  }
}
