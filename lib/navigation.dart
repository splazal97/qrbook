import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'util.dart';

class MenuLateral extends StatefulWidget{

  @override
  _MenuLateralState createState() =>_MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("Nombre usuario y correo"),
            ),
             ListTile(
               title: Text('Inicio'),
               leading: Icon(Icons.home),
            ),
            ListTile(
              title: Text('Alquilar'),
              leading: Icon(Icons.book),
            ),
            ListTile(
              title: Text('Historial'),
              leading: Icon(Icons.collections_bookmark),
            ),
            ListTile(
              title: Text('Mi Qr'),
              leading: Icon(Icons.code),
            ),
            ListTile(
              title: Text('Salir'),
              leading: Icon(Icons.exit_to_app),
            ),
            ],
        ),
      ),
    );
  }
}
