import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:qrbook/QrScan_admin.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';

import 'util.dart';
class PaginaCrear extends StatefulWidget{
  _PaginaCrear createState() => _PaginaCrear();
}
class _PaginaCrear extends State<PaginaCrear>{
  final _keyFormulario = GlobalKey<FormState>();
  final _controladorTitulo = TextEditingController();
  final _nombreAutor = TextEditingController();
  var _code ="";



  var _creando = false;
  var _imagen;
  var _imagenURL="http://djdaler.com/3.png";

  Future<void> _createQrDialog(context) async {
    final _context = context;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String dialogCode = "";
        return AlertDialog(
          title: Text("ScanQR"),
          content:
          StatefulBuilder(
              builder: (context, setDialogState) {
                return Column(
                  children: [
                    Text("CODE: " + dialogCode),
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: QrCamera(
                        qrCodeCallback: (_code) {
                          setState(() {
                            this._code = _code;
                          });
                          setDialogState(() {
                            dialogCode = _code;
                          });
                        },
                      ),
                    ),
                  ],
                );
              }
          ),
          actions: [
            RaisedButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
  _seleccionarImagenDeLaGaleria() async {
    var imagen = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagen = imagen;
    });
  }
  _hacerFoto() async {
    var imagen = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imagen = imagen;
    });
  }
  _subirImagenAStorage() async {
    final String uuid = Uuid().v1();

    final url = await (await FirebaseStorage.instance.ref().child("imagenes/image-$uuid.jpg").putFile(_imagen).onComplete).ref.getDownloadURL();

    setState(() {
      _imagenURL = url;
    });
  }
  _guardarLibroEnFirestore() async {

    setState(() {
      _creando = true;
    });

    if(_imagen != null) await _subirImagenAStorage();

    await Firestore.instance.collection("books").document(_code).setData({'imagenURL' : _imagenURL,'titulo':_controladorTitulo.text,'autor':_nombreAutor.text,'uidUser':"" });

    setState(() {
      _creando = false;
    });
  }

  /*_scan(BuildContext context) async {
    // Navigator.push devuelve un Future que se completará después de que llamemos
    // Navigator.pop en la pantalla de selección!
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRRead()),
    );

    // Después de que la pantalla de selección devuelva un resultado,
    // oculta cualquier snackbar previo y muestra el nuevo resultado.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$result")));
  }

   */


  @override
  build(context){
    return Scaffold(
      backgroundColor: Color(0xFFF2A477),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body:Container(
        margin: EdgeInsets.all(24.0),
        child: Form(
          key: _keyFormulario,
          child: ListView(
            children: [
              Container (
                padding: EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  controller: _controladorTitulo,
                  decoration: const InputDecoration(
                      labelText: 'Titulo del libro',
                      labelStyle:  TextStyle(
                        color:  Colors.black,
                        fontSize: 20),
                    fillColor: Colors.white,
                    filled: true,
                    border:  OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black
                      ),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                  validator: (value){
                    if (value.isEmpty) return 'Por favor introduzca un titulo';
                    return null;
                  },
                ),
              ),
              Container (
                padding: EdgeInsets.fromLTRB(0,0,0,20),
                child: TextFormField(
                  controller: _nombreAutor,
                  decoration: const InputDecoration(labelText: 'Nombre del autor',
                    labelStyle:  TextStyle(
                    color:  Colors.black,
                    fontSize: 20),
                    fillColor: Colors.white,
                    filled: true,
                    border:  OutlineInputBorder(
                    borderSide: BorderSide(
                    color: Colors.black
                    ),
                    borderRadius: BorderRadius.all(
                    const Radius.circular(10.0),
                ),
                ),),
                  validator: (value){
                    if (value.isEmpty) return 'Por favor añada el nombre del autor';
                    return null;
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                    'AÑADIR IMAGEN',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                ),
              ),
              Container (
                padding: EdgeInsets.fromLTRB(0,20,0,20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: _seleccionarImagenDeLaGaleria,
                      child: _imagen == null ? const Icon(Icons.image, size: 150) : Image.file(_imagen, height: 200),
                    ),
                    GestureDetector(
                      onTap: _hacerFoto,
                      child: _imagen == null ? const Icon(Icons.camera, size: 150) : Image.file(_imagen,height: 200,),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0,20,0,20),
                child: Text("CÓDIGO ESCANEADO: "+_code,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Container (
                padding: EdgeInsets.fromLTRB(0,0,0,20),
                child: FlatButton(
                  color: Color(0xFFBF5A36),
                  textColor: Colors.white,
                  onPressed: () {
                    _createQrDialog(context);
                  },
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(15),
                  child: const Text('CARGAR QR'),
                ),
              ),
              FlatButton(
                color: Color(0xFFBF5A36),
                textColor: Colors.white,
                onPressed: _creando ? null : () async{
                  if (_keyFormulario.currentState.validate()){
                    await _guardarLibroEnFirestore();
                    navegarAtras(context);
                  }
                },
                padding: EdgeInsets.all(15),
                shape: StadiumBorder(),
                child: const Text('CREAR'),
              )
            ]
          ),
        ),
      ),
    );
  }
}

