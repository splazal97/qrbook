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
var _email  = "";
var _user = "";
var _foto= "";
initState(){
  super.initState();
  _obtenerLogeado();
}
  _obtenerLogeado() async {
    var usuario = await FirebaseAuth.instance.currentUser();

    if (usuario != null){
      setState(() {
        this._email = usuario.email;
        this._user = usuario.displayName;
        this._foto = usuario.photoUrl;
      });
    }
  }

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

                title: Text("$_user",style: TextStyle(
                  fontSize: 40
                  ),
                ),
                subtitle: Text("$_email"),
                leading: CircleAvatar(backgroundImage: NetworkImage("$_foto"),),
              ),
              ),
             ListTile(
               title: Text('Inicio'),
               leading: Icon(Icons.home,color: Color(0xffD96E30)),
               onTap: (){
               },
            ),
            ListTile(
              title: Text('Reservar'),
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
