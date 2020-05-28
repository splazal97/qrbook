import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qrbook/admin_home.dart';
import 'package:qrbook/pagina_acceso.dart';
import 'package:qrbook/pagina_alquilar_admin.dart';
import 'package:qrbook/pagina_devolver_admin.dart';
import 'package:qrbook/pagina_libros_prestados_admin.dart';

import 'util.dart';
import 'pagina_hogar.dart';
import 'pagina_inicio.dart';

class MenuLateralAdmin extends StatefulWidget{


  @override
  _MenuLateralAdminState createState() =>_MenuLateralAdminState();
}

class _MenuLateralAdminState extends State<MenuLateralAdmin>{
  final GoogleSignIn googleSignIn = GoogleSignIn();
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

  void _cerrarSession() async {
    await googleSignIn.signOut();
    navegarHacia(context, PaginaAcceso());
  }

  void _irInicio() async {
    navegarHacia(context, PaginaAdminHome());
  }

  void _irAlquiler() async {
    navegarHacia(context, PaginaAlquilarAdmin());
  }

  void _irLibrosPrestados() async {
    navegarHacia(context, PaginaLibrosPrestados());
  }

  void _irDevolver() async {
    navegarHacia(context, PaginaDevolverLibro());
  }


  @override
  Widget build(BuildContext context){
    return Drawer(
      child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: ListTile(
                title: Text("Bibliotecario",style: TextStyle(
                  fontSize: 32
                  ),
                ),
                subtitle: Text("$_email"),
                leading: CircleAvatar(backgroundImage: AssetImage("assets/qrbooklogo.png"),),
              ),
             //BoxDecoration(image: DecorationImage(image: AssetImage("assets/qrbooklogo.png"),
              ),
             ListTile(
               title: Text('Inicio'),
               leading: Icon(Icons.home,color: Color(0xffD96E30)),
               onTap: (){_irInicio();
               },
            ),
            ListTile(
              title: Text('Prestamo'),
              leading: Icon(Icons.book,color: Color(0xffD96E30)),
                onTap: (){_irAlquiler();
                }
            ),
            ListTile(
                title: Text('Devolver'),
                leading: Icon(Icons.keyboard_return,color: Color(0xffD96E30)),
                onTap: (){_irDevolver();
                }
            ),

            ListTile(
                title: Text('Libros prestados'),
                leading: Icon(Icons.collections_bookmark,color: Color(0xffD96E30)),
                onTap: (){_irLibrosPrestados();
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
