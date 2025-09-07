import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper para inyectar BLoCs de manera centralizada
class BlocProviderHelper {
  BlocProviderHelper._();

  /// Método genérico para crear una pantalla con un BLoC
  static Widget create<T extends StateStreamableSource<Object?>>({
    required T bloc,
    required Widget child,
  }) {
    return BlocProvider<T>.value(value: bloc, child: child);
  }

  /// Método para múltiples BLoCs a la vez
  static Widget createMulti({
    required List<BlocProvider> providers,
    required Widget child,
  }) {
    return MultiBlocProvider(providers: providers, child: child);
  }
}
