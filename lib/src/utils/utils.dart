import 'package:flutter/material.dart';

bool esNumero(String valor) {
  if (valor.isEmpty) return false;
  final numero = num.tryParse(valor);
  return (numero == null) ? false : true;
}

mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Informacion Incorrecta'),
          content: Text(mensaje),
          actions: [
            FlatButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('ok'))
          ],
        );
      });
}
