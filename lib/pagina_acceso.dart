import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrbook/admin_home.dart';
import 'util.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  var _admin = "LVUACGE5V8Owf559rilA4Z60NiA2";
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var _admisitrador = "";

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
      if (usuario.uid.toString() == _admin) {
        navegarHacia(context, PaginaAdminHome());
      } else {
        if (usuario != null) navegarHacia(context, PaginaHogar());
      }
      } catch (e) {
      setState(() {
        _mensajeError = e.message;
        _accedido = false;
      });
    }

  }

  loguearConGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;
    assert(!user.isAnonymous);
    assert(await user.getIdToken() !=null);
    try {
      if (user.uid == _admin) {
         return navegarHacia(context, PaginaAdminHome());
      }else {
        if (user != null) return navegarHacia(context, PaginaHogar());
      }
    } catch (e) {
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
          margin: EdgeInsets.all(24.0),

          child: Form(
            key: _keyFormulario,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Image.asset('assets/qrbooklogo.png', width: 200.0,height: 200.0),
              /*
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
                    padding: EdgeInsets.all(10),
                    color: Color(0xFFBF5A36),
                    shape: StadiumBorder(),
                ),
                ),
                FlatButton (
                  onPressed: () => navegarHacia(context, RegisterPage()),
                  child: const Text('REGISTRARSE',style: TextStyle(color: Colors.white,fontSize: 30),),
                  padding: EdgeInsets.all(10),
                  color: Color(0xFFBF5A36),
                  shape: StadiumBorder(),
                ),

           */
                _signInButton(),
                _buildMensajeDeError()
              ],
        ),
        ),
        )
    );
  }

  Widget _signInButton() {
    return
      Container(
        padding: EdgeInsets.fromLTRB(0,40,0,0),

        child: FlatButton(
          splashColor: Colors.grey,
          color: Colors.white,
          //color: Color(0xFFBF5A36),
          onPressed: () {
            loguearConGoogle();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              Image(image: AssetImage("assets/google_logo.png"), height: 50.0),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                'Iniciar sesion con Google',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBF5A36),
                ),
              ),
            )
          ],
        ),
      ),
    ),
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




