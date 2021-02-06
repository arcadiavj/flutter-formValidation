import 'dart:convert';

import 'package:formvalidation/src/models/prodcto_model.dart';
import 'package:http/http.dart' as http;

class ProductosProvider {
  final String _url =
      "https://flutter-varios-e7b8f-default-rtdb.firebaseio.com";

  Future<bool> creaProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';

    final resp = await http.post(url, body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json';
    final resp = await http.get(url);
    final decodeData = json.decode(resp.body);
    print(decodeData);
    return [];
  }
}
