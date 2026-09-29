import 'package:flutter/material.dart';

class TarjetaKPI extends StatelessWidget {
  final String titulo;
  final String valor;
  final String subtitulo;
  final IconData icono;
  final Color colorAcento;

  const TarjetaKPI({
    Key? key,
    required this.titulo,
    required this.valor,
    required this.subtitulo,
    required this.icono,
    this.colorAcento = const Color(0xFFFF6B00),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorAcento.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icono, size: 18, color: colorAcento),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            valor,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            style: TextStyle(color: Colors.grey[500], fontSize: 11),
          ),
        ],
      ),
    );
  }
}
