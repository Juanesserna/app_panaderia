import 'package:intl/intl.dart';

/// Formateador de moneda unificado, consistente con el diseño web
/// (siempre muestra 2 decimales). Requiere el paquete `intl` en el
/// pubspec (si tu proyecto ya usa `google_fonts`, es muy probable que
/// `intl` ya esté disponible como dependencia transitiva; si no compila,
/// agrega `intl: ^0.19.0` a pubspec.yaml).
String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(
    locale: 'es_CO',
    symbol: '',
    decimalDigits: 2,
  );
  return formatter.format(amount).trim();
}
