// image.dart
import 'package:flutter/material.dart';
import 'package:ibnosina/common/functions/showDialogImageButton.dart';
import 'package:cached_network_image/cached_network_image.dart';



class Images extends StatelessWidget{
  var bilans;
  var patient;
  var age;

  Images(this.bilans,this.patient,this.age){
    _getItems();
  }

  Widget _buildProductItem(BuildContext context, int index){
    print(bilans[index]["fichier"]);
    return GestureDetector(
      onTap: () {
        //showDialogImageButton(context, bilans[index]['element'], "http://anapharms.com/images/${bilans[index]["fichier"]}",'OK');
      },
        child:  new Card(
        child: Column(
          children: <Widget>[
            Image.network(
                'http://10.0.2.2:8000/avatar/${bilans[index]["fichier"]}',
              height: 200,
              width: 300,
              ),


            Text(bilans[index]["element"],
                style: TextStyle(color: Colors.teal,fontSize: 20)),
          ],
        ),
      ),
    ); }

    Widget _getItems(){
      return ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: bilans.length,
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getItems(),
    );
  }
}