import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'util.dart';

import 'pagina_hogar.dart';


class RegisterPage extends StatefulWidget {
  @override
  createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _keyFormulario = GlobalKey<FormState>();
  final _controladorEmail = TextEditingController();
  final _controladorPasswd = TextEditingController();

  _registrarConEmailYPasswd() async {
    final usuario = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _controladorEmail.text,
      password: _controladorPasswd.text,
    )).user;

    if (usuario != null) navegarHacia(context, PaginaHogar());
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
              const Text("REGISTRO",textAlign: TextAlign.center,style: TextStyle(fontSize: 50,color: Colors.white)),
              new Image.asset('assets/qrbooklogo.png', width: 200.0,height: 200.0),
            Container (
              padding: EdgeInsets.fromLTRB(0,20,0,20),
              child: TextFormField(
                controller: _controladorEmail,
                decoration: const InputDecoration(labelText: 'EMAIL',
                labelStyle: TextStyle(
                    color: Color(0xFFBF5A36),
                    fontSize: 20),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black
                      ),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(10.0)
                      )
                  )
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Por favor introduzca su email';
                  return null;
                },
              ),
            ),
              Container (
                padding: EdgeInsets.fromLTRB(0,20,0,20),
                child: TextFormField(
                  controller: _controladorPasswd,
                  decoration: const InputDecoration(labelText: 'PASSWORD',
                  labelStyle: TextStyle(
                    color: Color(0xFFBF5A36),
                    fontSize: 20),
                    fillColor: Colors.white,
                    filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black
                    ),
                    borderRadius: BorderRadius.all(
                      const Radius.circular(10.0)
                    )
                  )
                ),
                validator: (value) {
                  if (value.isEmpty) return 'Por favor introduzca su password';
                  return null;
                },
              ),
              ),
              FlatButton(
                onPressed: () async {
                  if (_keyFormulario.currentState.validate()) _registrarConEmailYPasswd();
                },
                padding: EdgeInsets.all(15),
                child: const Text('REGISTRAR',style: TextStyle(color: Colors.white,fontSize: 30),),
                color: Color(0xFFBF5A36),
                shape: StadiumBorder(),
              ),
            ],
        ),
      ),
      ),
    );
  }
}