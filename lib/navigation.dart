import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'util.dart';
import 'pagina_hogar.dart';
import 'pagina_inicio.dart';

class MenuLateral extends StatefulWidget{


  @override
  _MenuLateralState createState() =>_MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral>{

  _cerrarSession() async {
    await FirebaseAuth.instance.signOut();
    navegarHacia(context, PaginaInicio());
  }
  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: ListTile(
                title: Text("Sergio",style: TextStyle(
                  fontSize: 40
                  ),
                ),
                subtitle: Text("_email"),
                leading: CircleAvatar(backgroundImage: AssetImage("assets/qrbooklogo.png"),),
              ),
             //BoxDecoration(image: DecorationImage(image: AssetImage("assets/qrbooklogo.png"),
              ),
             ListTile(
               title: Text('Inicio'),
               leading: Icon(Icons.home,color: Color(0xffD96E30)),
               onTap: (){

               },
            ),
            ListTile(
              title: Text('Alquilar'),
              leading: Icon(Icons.book,color: Color(0xffD96E30)),
                onTap: (){

                }
            ),
            ListTile(
              title: Text('Mi Qr'),
              leading: Icon(Icons.code,color: Color(0xffD96E30)),
                onTap: (){

                }
            ),
            ListTile(
              title: Text('Salir'),
              leading: Icon(Icons.exit_to_app, color: Color(0xffD96E30)),
                onTap: (){_cerrarSession();}
            ),
            ],
        ),
      );
  }
}
