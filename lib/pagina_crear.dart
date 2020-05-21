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
  var _QR = TextEditingController();



  var _creando = false;
  var _imagen;
  var _imagenURL;

   Future<String> _createQrDialog(BuildContext context){

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("ScanQR"),
        actions: <Widget>[
          SizedBox(
            width: 300,
            height: 300,
            child: QrCamera(
              qrCodeCallback: (_code){
                setState(() {
                  this._code = _code;
                });
              },
            ),
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text('Cargar'),
            onPressed: () {
              Navigator.of(context).pop(_code);
            },
          )
        ],
      );
    });
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

    await Firestore.instance.collection("books").add({'imagenURL' : _imagenURL,'titulo':_controladorTitulo.text,'autor':_nombreAutor.text,'codigoQR':_QR });

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
      body: Form(
        key: _keyFormulario,
        child: ListView(
          children: [
            TextFormField(
              controller: _controladorTitulo,
              decoration: const InputDecoration(labelText: 'Titulo del libro'),
              validator: (value){
                if (value.isEmpty) return 'Por favor introduzca un titulo';
                return null;
              },
            ),
            TextFormField(
              controller: _nombreAutor,
              decoration: const InputDecoration(labelText: 'Nombre del autor'),
              validator: (value){
                if (value.isEmpty) return 'Por favor añada el nombre del autor';
                return null;
              },
            ),
            Text(
                'AÑADIR IMAGEN'
            ),
            Row(
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
            TextFormField(
              controller: _QR,
              decoration: const InputDecoration(labelText: 'CodigoQR'),
              validator: (value){
                if (value.isEmpty) return 'Por escane QR';
                return null;
              },
            ),
            RaisedButton(
              color: Colors.white,
              onPressed: () {
                _createQrDialog(context).then((onValue) {
                  _QR = onValue as TextEditingController;
                });
              },
              child: const Text('CARGAR QR'),
            ),
            RaisedButton(
              color: Colors.white,
              onPressed: _creando ? null : () async{
                if (_keyFormulario.currentState.validate()){
                  await _guardarLibroEnFirestore();
                  navegarAtras(context);
                }
              },
              child: const Text('CREAR'),
            )

          ]
        ),
      ),
    );
  }


}

