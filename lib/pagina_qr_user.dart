import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrbook/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';


class PaginaQrUser extends StatefulWidget {
  @override
  createState() => _PaginaQrUser();
}
class _PaginaQrUser extends State<PaginaQrUser> {
  var _codeQR="";
  initState(){
    super.initState();
    _obtenerQrLogueado();
  }
  _obtenerQrLogueado() async {
    var usuario = await FirebaseAuth.instance.currentUser();

    if (usuario != null){
      setState(() {
        this._codeQR = usuario.uid;
      });
    }
  }
  @override
  build(context) => Scaffold(
    backgroundColor: Color(0xFFF2A477),
    appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
  ),
    drawer: Drawer(child: MenuLateral()),
    body: Container(
      margin: EdgeInsets.all(24.0),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child:Text(
              "MI QR CODE",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 20,),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            child:Center(
              child:QrImage(
                backgroundColor: Colors.white,
                data: _codeQR,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}