
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrbook/admin_home.dart';
import 'package:qrbook/navigation.dart';
import 'package:qrbook/navigation_admin.dart';
import 'package:qrbook/pagina_libro.dart';
import 'util.dart';

import 'pagina_inicio.dart';
import 'pagina_crear.dart';

class PaginaLibrosPrestados extends StatefulWidget {
  @override
  createState() => _PaginaLibrosPrestados();
}
class _PaginaLibrosPrestados extends State<PaginaLibrosPrestados>{
  var _email = "anonymus";
  var _UIDLogueado="";


  initState() {
    super.initState();
    _obtenerEmailLogeado();
    _obtenerUIDLogueado();
  }
  _obtenerEmailLogeado() async {
    var usuario = await FirebaseAuth.instance.currentUser();

    if (usuario != null){
      setState(() {
        this._email = usuario.email;
      });
    }
  }

  _obtenerUIDLogueado() async {
    var usuario = await FirebaseAuth.instance.currentUser();

    if (usuario != null){
      setState(() {
        this._UIDLogueado = usuario.uid;
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
    drawer: Drawer(child: MenuLateralAdmin()),
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
                if(books['uidUser']!=""){
                  return Card(
                    child: ListTile(
                      leading: books['imagenURL'] !=null ? Image.network(books['imagenURL']) : const Icon(Icons.image),
                      title: Text(books['titulo'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                      subtitle: Text(books['autor']),
                      onTap: () => navegarHacia(context, PaginaLibro(book:books)),
                      isThreeLine: true,
                    ),
                  );
                }else{
                  return Container();
                }

              },
            );
        }
      },
    ),
  );

}
