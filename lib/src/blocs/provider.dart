import 'package:flutter/material.dart';
import 'package:formvalidation/src/blocs/login_bloc.dart';
export 'package:formvalidation/src/blocs/login_bloc.dart';

class Provider extends InheritedWidget {
  static Provider _instanciaActual;
  factory Provider({Key key, Widget child}) {
    if (_instanciaActual == null) {
      _instanciaActual = new Provider._internal(key: key, child: child);
    }
    return _instanciaActual;
  }
  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  final loginBloc = LoginBloc();
  //Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    try {
      return true;
    } catch (e) {
      print('Error $e');
    }
    throw UnimplementedError();
  }

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
