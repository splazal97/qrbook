import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrbook/navigation.dart';
import 'package:qrbook/pagina_crear.dart';
import 'package:qrbook/pagina_libro.dart';
import 'package:qrbook/util.dart';

import 'navigation_admin.dart';

class PaginaAdminHome extends StatefulWidget {

  @override
  createState() => _PaginaAdminHome();

}
class _PaginaAdminHome extends State<PaginaAdminHome>{

  @override
  build(context) => Scaffold(
    backgroundColor: Color(0xFFF2A477),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ),
    drawer: Drawer(child: MenuLateralAdmin(),),
    floatingActionButton: FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Color(0xFFBF5A36),
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
                return Card(
                  child: ListTile(
                    leading: books['imagenURL'] !=null ? Image.network(books['imagenURL']) : const Icon(Icons.image),
                    title: Text(books['titulo'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    subtitle: Text(books['autor']),
                    trailing: Icon(Icons.more_vert),
                    onTap: () => navegarHacia(context, PaginaLibro(book:books)),
                    isThreeLine: true,
                ),
                );
              },
            );
        }
      },
    ),
  );
}
