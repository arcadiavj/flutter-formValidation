import 'dart:async';

class Validators {
  final validarEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regEx = new RegExp(pattern);
    if (regEx.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('email no es correcto');
    }
  });
  final validarPassword =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (pass.length > 6) {
      sink.add(pass);
    } else {
      sink.addError('Más de 6 caracteres por favor');
    }
  });
}
