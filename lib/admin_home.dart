import 'package:flutter/material.dart';

class PaginaAdminHome extends StatefulWidget {

  @override
  createState() => _PaginaAdminHome();

}
class _PaginaAdminHome extends State<PaginaAdminHome>{
  @override
  build(context) => Scaffold(
    backgroundColor: Color(0xFFF2A477),
    body: Container(
      child: ListTile(
        title: Text("inicio de sesion como admin"),
      ),
    ),
  );
}