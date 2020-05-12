import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  var _creando = false;
  var _imagen;
  var _imagenURL;

  _seleccionarImagenDeLaGaleria() async {
    var imagen = await ImagePicker.pickImage(source: ImageSource.gallery);
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

    await Firestore.instance.collection("books").add({'imagenURL' : _imagenURL,'titulo':_controladorTitulo.text,'autor':_nombreAutor.text });

    setState(() {
      _creando = false;
    });
  }
  @override
  build(context){
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _keyFormulario,
        child: ListView(
          children: [
            GestureDetector(
              onTap: _seleccionarImagenDeLaGaleria,
              child: _imagen == null ? const Icon(Icons.image, size: 200) : Image.file(_imagen, height: 200),
            ),
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
            RaisedButton(
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