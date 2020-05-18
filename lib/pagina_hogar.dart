
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrbook/admin_home.dart';
import 'package:qrbook/navigation.dart';

import 'util.dart';

import 'pagina_inicio.dart';
import 'pagina_crear.dart';

class PaginaHogar extends StatefulWidget {
  @override
  createState() => _PaginaHogarState();
}
class _PaginaHogarState extends State<PaginaHogar>{
  var _email = "anonymus";



  initState() {
    super.initState();
    _obtenerEmailLogeado();
  }
  _obtenerEmailLogeado() async {
    var usuario = await FirebaseAuth.instance.currentUser();

    if (usuario != null){
      setState(() {
        this._email = usuario.email;
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          navegarHacia(context, PaginaCrear());
        },
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("books").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Text('Error: ${snapshot.error}');
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            default:
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder:  (context, index){
                  var books = snapshot.data.documents.elementAt(index);
                  return ListTile(
                    leading: books['imagenURL'] !=null ? Image.network(books['imagenURL'],width: 140,height: 220) : const Icon(Icons.image,size: 220),
                    title: Text(books['titulo']),
                    subtitle: Text(books['autor']),
                  );
                },
              );
          }
        },
      ),
    );

  }
