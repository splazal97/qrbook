import 'package:flutter/material.dart';
import 'package:qrbook/navigation.dart';


class PaginaHome extends StatefulWidget {

  @override
  createState() => _PaginaHomeSatate();

}

class _PaginaHomeSatate extends State<PaginaHome>{


  @override
  build(context) => Scaffold(
    backgroundColor: Color(0xFFF2A477),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ),
    drawer: Drawer(child: MenuLateral(),
    ),
  );
}