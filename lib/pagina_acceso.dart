import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrbook/admin_home.dart';
import 'util.dart';

import 'pagina_registro.dart';
import 'pagina_hogar.dart';

class PaginaAcceso extends StatefulWidget{
  @override
  createState() => _PaginaAccesoState();
}

class _PaginaAccesoState extends State<PaginaAcceso> {
  final _keyFormulario = GlobalKey<FormState>();
  final _controladorEmail = TextEditingController();
  final _controlPasswd = TextEditingController();
  var _mensajeError ="";
  var _accedido = false;
  var _admin = "f6St2p3zn7gVUxBDA8DSh8qaqs53";


  _loguearConEmailYPassword() async {
    setState(() {
      _accedido = true;
    });
    try {
      final usuario = (await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _controladorEmail.text,
          password: _controlPasswd.text,

      )).user;
      var _admisitrador = usuario.uid;
      if (_admisitrador == _admin) navegarHacia(context, PaginaAdminHome());
      if (usuario != null) navegarHacia(context, PaginaHogar());
    } catch(e){
      setState(() {
        _mensajeError = e.message;
        _accedido = false;
      });
    }
  }
  @override
  build(context) {
    return Scaffold(
      backgroundColor:  Color(0xFFF2A477),
        body: Container (
          margin: EdgeInsets.all(16),
          child: Form(
            key: _keyFormulario,
            child: ListView(
              children: [
                Text("INICIAR SESION",textAlign: TextAlign.center,style: TextStyle(fontSize: 50,color: Colors.white),),
                new Image.asset('assets/qrbooklogo.png', width: 200.0,height: 200.0),
                Container (
                  padding: EdgeInsets.fromLTRB(0,20,0,20),
                  child: TextFormField(
                    controller: _controladorEmail,
                    decoration: const InputDecoration(labelText: 'EMAIL',
                        labelStyle:TextStyle(color: Color(0xFFBF5A36),fontSize: 20),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black
                        ),
                        borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      )
                    )
                  ),
                  validator: (value){
                    if (value.isEmpty) return 'Introduzca un correo';
                        return null;
                  },
                ),
                ),
                Container (
                  padding: EdgeInsets.fromLTRB(0,0,0,15),
                  child: TextFormField(
                    controller: _controlPasswd,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'PASSWORD',
                        labelStyle: TextStyle(color: Color(0xFFBF5A36), fontSize: 20),
                        fillColor: Colors.white,
                        filled: true,
                        border:  OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black
                          ),
                          borderRadius:  const BorderRadius.all(
                            const Radius.circular(10.0),
                          )
                        )
                    ),
                    validator: (value) {
                      if (value.isEmpty) return 'Introduzca una contraseña';
                      return null;
                    },
                  ),
                ),
                Container (
                  padding: EdgeInsets.fromLTRB(0,0,0,15),
                  child: FlatButton (
                    onPressed: _accedido ? null : () async {
                    if (_keyFormulario.currentState.validate()) _loguearConEmailYPassword();
                    },
                    child: const Text('ACCEDER',style: TextStyle(color: Colors.white,fontSize: 30),),
                    padding: EdgeInsets.all(15),
                    color: Color(0xFFBF5A36),
                    shape: StadiumBorder(),
                ),
                ),
                FlatButton (
                  onPressed: () => navegarHacia(context, RegisterPage()),
                  child: const Text('REGISTRARSE',style: TextStyle(color: Colors.white,fontSize: 30),),
                  padding: EdgeInsets.all(15),
                  color: Color(0xFFBF5A36),
                  shape: StadiumBorder(),
                ),
                _buildMensajeDeError()
              ],
        ),
        ),
        )
    );
  }


  _buildMensajeDeError() {
    if (_mensajeError.length > 0 && _mensajeError != null)
      return Text(
        _mensajeError,
        style: TextStyle(
          color: Colors.red,
        ),
      );
  return Container(
    height: 0.0,
  );
  }
}




