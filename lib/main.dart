import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrbook/pagina_inicio.dart';

 main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  build(context) => MaterialApp(home: PaginaInicio()
  );
}
