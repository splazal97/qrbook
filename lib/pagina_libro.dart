import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'util.dart';


class PaginaLibro extends StatefulWidget{
  final DocumentSnapshot book;
  PaginaLibro({this.book});
  @override
  createState() => _PaginaLibro();
}

class _PaginaLibro extends State<PaginaLibro>{
  @override
  build(context) => Scaffold(
    backgroundColor: Color(0xFFF2A477),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ),
    body: Container(


      child:ListView(

          children:[
            Container(
              width: MediaQuery.of(context).size.width,
              height:300,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                    topLeft:  const  Radius.circular(40.0),
                    topRight: const  Radius.circular(40.0)),
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: NetworkImage(widget.book['imagenURL']),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child:Center(
                child:Text(
                    widget.book['titulo'].toString().toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36)
                ),
              ),
            ),

            Container(
              color: Colors.white,
              child:Center(
                child:Text(
                    widget.book['autor'].toString().toUpperCase(),
                    style: TextStyle(fontSize: 28)
                ),
              ),
            ),
          ]


      ),
    ),
  );

}