/// Representa errores controlados dentro de la aplicación.
class AppFailure {
  const AppFailure({required this.code, this.message});

  final String code;
  final String? message;

  @override
  String toString() => 'AppFailure(code: $code, message: $message)';
}
