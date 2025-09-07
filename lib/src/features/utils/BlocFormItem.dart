class BlocFormItem<T> {
  final T value;
  final String? error;

  const BlocFormItem({required this.value, this.error});

  /// Copia el estado con cambios
  BlocFormItem<T> copyWith({T? value, String? error}) {
    return BlocFormItem<T>(value: value ?? this.value, error: error);
  }

  /// Verifica si el campo es válido
  bool get isValid => error == null || error!.isEmpty;

  @override
  String toString() => 'BlocFormItem(value: $value, error: $error)';
}
