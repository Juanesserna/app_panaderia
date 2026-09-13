/// Fecha actual en formato dd/MM/yyyy, igual al usado en los diseños web.
String fechaHoyFormateada() {
  final ahora = DateTime.now();
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${pad(ahora.day)}/${pad(ahora.month)}/${ahora.year}';
}

/// Hora actual en formato HH:mm.
String horaHoyFormateada() {
  final ahora = DateTime.now();
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${pad(ahora.hour)}:${pad(ahora.minute)}';
}

/// Fecha y hora actuales en un solo string `dd/MM/yyyy HH:mm`, formato
/// usado por el módulo de Producción para `fechaSolicitud` /
/// `fechaFabricacion`.
String fechaHoraActualFormateada() =>
    '${fechaHoyFormateada()} ${horaHoyFormateada()}';
