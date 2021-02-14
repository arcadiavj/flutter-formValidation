import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/productos_bloc.dart';
import 'package:formvalidation/src/blocs/provider.dart';
//import 'package:formvalidation/src/blocs/provider.dart';
import 'package:formvalidation/src/models/prodcto_model.dart';
//import 'package:formvalidation/src/providers/productos_providers.dart';

class HomePage extends StatelessWidget {
  //final productosProvider = new ProductosProvider();
  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, 'producto');
        });
  }

  _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) {
              return _crearItem(context, productosBloc, productos[i]);
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          productosBloc.borrarProductos(producto.id);
        },
        child: Card(
            child: Column(
          children: [
            (producto.fotoUrl == null)
                ? Image(image: AssetImage('lib/assets/no-image.png'))
                : FadeInImage(
                    placeholder: AssetImage('lib/assets/jar-loading.gif'),
                    image: NetworkImage(producto.fotoUrl),
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover),
            ListTile(
              title: Text('${producto.titulo}- ${producto.valor}'),
              subtitle: Text(producto.id),
              onTap: () =>
                  Navigator.pushNamed(context, 'producto', arguments: producto),
            )
          ],
        )));
  }
}
