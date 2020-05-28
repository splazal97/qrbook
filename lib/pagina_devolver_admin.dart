import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrbook/navigation.dart';
import 'package:qrbook/pagina_crear.dart';
import 'package:qrbook/pagina_libro.dart';
import 'package:qrbook/util.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'navigation_admin.dart';
import 'package:fluttertoast/fluttertoast.dart';


class PaginaDevolverLibro extends StatefulWidget {

  @override
  createState() => _PaginaDevolverLibro();

}

class _PaginaDevolverLibro extends State<PaginaDevolverLibro>{

  var _codeLibro="";
  var _creando = false;




  Future<void> _escanearLibro(context) async {
    final _context = context;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String dialogCode = "";
        return AlertDialog(
          title: Text("ScanQR Libro"),
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
                            this._codeLibro = _code;
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


  @override
  build(context) => Scaffold(
    backgroundColor: Color(0xFFF2A477),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    ),
    drawer: Drawer(child: MenuLateralAdmin(),),
    body: Container(
      margin: EdgeInsets.all(24.0),
      child: Form (
        child: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: FlatButton(
                color: Color(0xFFBF5A36),
                textColor: Colors.white,
                onPressed: () { _escanearLibro(context);},
                shape: StadiumBorder(),
                padding: EdgeInsets.all(15),
                child: const Text('ECANEAR LIBRO'),
                ),
              ), 
          Text("Codigo LIBRO: "+_codeLibro,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Container(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
                child:FlatButton(
                    color: Color(0xFFBF5A36),
                    textColor: Colors.white,
                    onPressed: _creando ? null : () async{
                      await Firestore.instance.collection("books").document(_codeLibro).updateData({'uidUser':""});
                      navegarAtras(context);
                    },
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(15),
                    child: const Text('DEVOLVER'),
                  ),
                ),
            ],
        ),
      ),
    ),
  );
}
