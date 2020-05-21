import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrbook/admin_home.dart';
import 'package:qrbook/pagina_acceso.dart';
import 'package:qrbook/pagina_hogar.dart';
import 'util.dart';
class PaginaInicio extends StatefulWidget {
  @override
createState() => _PaginaInicioState();
}

class _PaginaInicioState extends State<PaginaInicio>{
  var _admin = "LVUACGE5V8Owf559rilA4Z60NiA2";
  void initState(){
    super.initState();
    _comprobarLogin();
  }

  _comprobarLogin() async {

    var usuario = await FirebaseAuth.instance.currentUser();

    if (usuario.uid.toString() == _admin){
      navegarHacia(context, PaginaAdminHome());
    } else if (usuario != null && usuario.uid.toString() !=_admin) {
      navegarHacia(context, PaginaHogar());
    } else {
      navegarHacia(context, PaginaAcceso());
    }
  }

  @override
  build( context) {

    return Scaffold(
      body: const CircularProgressIndicator(),
    );
  }
}