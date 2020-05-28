import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrbook/navigation.dart';
import 'package:qrbook/pagina_crear.dart';
import 'package:qrbook/pagina_libro.dart';
import 'package:qrbook/util.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'navigation_admin.dart';
import 'package:fluttertoast/fluttertoast.dart';


class PaginaAlquilarAdmin extends StatefulWidget {

  @override
  createState() => _PaginaAlquilarAdmin();

}

class _PaginaAlquilarAdmin extends State<PaginaAlquilarAdmin>{

  var _codeLibro="";
  var _codePersona="";
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

  Future<void> _escanearPersona(context) async {
    final _context = context;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        String dialogCode = "";
        return AlertDialog(
          title: Text("ScanQR Persona"),
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
                            this._codePersona = _code;
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
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0,0,0,40),
              child: FlatButton(
                color: Color(0xFFBF5A36),
                textColor: Colors.white,
                onPressed: () { _escanearLibro(context);},
                child: const Text('ECANEAR LIBRO'),
                shape: StadiumBorder(),
                padding: EdgeInsets.all(15),
              ),
            ),
            Text("Codigo LIBRO: "+_codeLibro,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Container (
              margin: const EdgeInsets.fromLTRB(0, 40, 0, 40),
              child: FlatButton(
                color: Color(0xFFBF5A36),
                textColor: Colors.white,
                onPressed: () { _escanearPersona(context);},
                  child: const Text('ESCANEAR PERSONA'),
                shape: StadiumBorder(),
                padding: EdgeInsets.all(15),
                ),
              ),
            Text("Codigo persona: "+ _codePersona,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Container(
              margin: const EdgeInsets.only(top: 40),
              child:FlatButton(
                color: Color(0xFFBF5A36),
                textColor: Colors.white,
                onPressed: _creando ? null : () async{
                      await Firestore.instance.collection("books").document(_codeLibro).updateData({'uidUser':_codePersona});
                      navegarAtras(context);
                  },
                  child: const Text('CREAR PRESTAMO',),
                shape: StadiumBorder(),
                padding: EdgeInsets.all(15),
                ),
            ),
          ],
        ),
      ),
    ),
  );
}
