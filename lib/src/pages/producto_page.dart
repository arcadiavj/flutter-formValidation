import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:formvalidation/src/models/prodcto_model.dart';
import 'package:formvalidation/src/providers/productos_providers.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProcutoPage extends StatefulWidget {
  @override
  _ProcutoPageState createState() => _ProcutoPageState();
}

class _ProcutoPageState extends State<ProcutoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ProductoModel producto = new ProductoModel();
  final productoProvider = new ProductosProvider();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if (prodData != null) {
      producto = prodData;
    }
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Producto'),
          actions: [
            IconButton(
                icon: Icon(Icons.photo_size_select_actual),
                onPressed: _seleccionarFoto),
            IconButton(icon: Icon(Icons.camera_alt), onPressed: _tomarFoto)
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    _mostrarFoto(),
                    _crearNombre(),
                    _crearPrecio(),
                    _crearBoton(),
                    _crearDisponible()
                  ],
                )),
          ),
        ));
  }

  _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (valor) {
        producto.titulo = valor;
      },
      validator: (valor) {
        if (valor.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (valor) {
        producto.valor = double.parse(valor);
      },
      validator: (valor) {
        if (utils.esNumero(valor)) {
          return null;
        } else {
          return 'solo numeros';
        }
      },
    );
  }

  _crearBoton() {
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: (_guardando) ? null : _submit,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    setState(() {
      _guardando = true;
    });
    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(foto);
    }

    if (producto.id == null) {
      productoProvider.creaProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }
    setState(() {
      _guardando = false;
    });
    mostrarSnackbar('OBJETO GUARDADO');
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _crearDisponible() {
    return SwitchListTile(
        value: producto.disponible,
        title: Text('Disponible'),
        activeColor: Colors.deepPurple,
        onChanged: (valor) {
          producto.disponible = valor;
          setState(() {});
        });
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('lib/assets/no-image.jpg'),
        image: NetworkImage(producto.fotoUrl),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      if (foto != null) {
        return Image.file(
          foto,
          height: 300.0,
          fit: BoxFit.cover,
        );
      }
      return Image.asset('lib/assets/no-image.png');
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _procesarImagen(ImageSource origen) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: origen,
    );
    if (foto != null) {
      //limpiea
    }

    foto = File(pickedFile.path);

    /*if (foto != null) {
      producto.urlImg = null;
    }*/

    setState(() {});
  }
}
