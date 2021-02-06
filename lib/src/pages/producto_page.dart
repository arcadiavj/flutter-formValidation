import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:formvalidation/src/models/prodcto_model.dart';
import 'package:formvalidation/src/providers/productos_providers.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProcutoPage extends StatefulWidget {
  @override
  _ProcutoPageState createState() => _ProcutoPageState();
}

class _ProcutoPageState extends State<ProcutoPage> {
  final formKey = GlobalKey<FormState>();
  ProductoModel producto = new ProductoModel();
  final productoProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Producto'),
          actions: [
            IconButton(
                icon: Icon(Icons.photo_size_select_actual), onPressed: () {}),
            IconButton(icon: Icon(Icons.camera_alt), onPressed: () {})
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
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
      onPressed: () {
        _submit();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
    );
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;
    formKey.currentState.save();
    print('todo OK');
    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);
    productoProvider.creaProducto(producto);
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
}
