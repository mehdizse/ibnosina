import 'package:flutter/material.dart';
import 'package:ibnosina/common/apifunctions/requestLogoutAPI.dart';
import 'package:ibnosina/ui/loginScreen.dart';
import 'package:ibnosina/common/functions/showDialogSingleButton.dart';


class BasicDrawer extends StatefulWidget {
  @override
  _BasicDrawerState createState() => _BasicDrawerState();
}

class _BasicDrawerState extends State<BasicDrawer>  {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: new EdgeInsets.all(32.0),
        child: ListView(children: <Widget>[
          ListTile(title: Text("A propos", style: TextStyle(
              color: Colors.black, fontSize: 20.0),),
            onTap: () {
              showDialogSingleButton(context, "Anapharm",
                  "Surveillez votre patient est plus facile que jamais.", "OK");
            },
          ),
          ListTile(title: Text("Se déconnecter", style: TextStyle(
              color: Colors.black, fontSize: 20.0),),
            onTap: () {
                requestLogoutAPI(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>new LoginScreen()));
            },
          ),
        ],),
      ),
    );
  }
}

