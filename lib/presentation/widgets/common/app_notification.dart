import 'package:flutter/material.dart';

enum NotifTipo { exito, advertencia, error }

class _NotifEstilo {
  final Color bg;
  final Color dot;
  final Color titulo;
  final Color texto;
  const _NotifEstilo(this.bg, this.dot, this.titulo, this.texto);
}

const _estilos = {
  NotifTipo.exito: _NotifEstilo(Color(0xFFDCE6D0), Color(0xFF5B7F44), Color(0xFF2F3B22), Color(0xFF586B45)),
  NotifTipo.advertencia: _NotifEstilo(Color(0xFFF5DFB3), Color(0xFFC97A45), Color(0xFF4A2E17), Color(0xFF7A5230)),
  NotifTipo.error: _NotifEstilo(Color(0xFFF2D4D4), Color(0xFFC0392B), Color(0xFF6B1E1E), Color(0xFF8A3D3D)),
};

void showAppNotification(
  BuildContext context, {
  required NotifTipo tipo,
  required String titulo,
  required String mensaje,
}) {
  final s = _estilos[tipo]!;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: s.bg,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(width: 6, height: 6, decoration: BoxDecoration(color: s.dot, shape: BoxShape.circle)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5, color: s.titulo)),
                const SizedBox(height: 2),
                Text(mensaje, style: TextStyle(fontSize: 12.5, color: s.texto)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}