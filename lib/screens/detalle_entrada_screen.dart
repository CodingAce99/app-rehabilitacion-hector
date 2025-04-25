import 'dart:io';

import 'package:app_rehab/models/entrada_diario.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalleEntradaScreen extends StatelessWidget {
  final EntradaDiario entrada;

  const DetalleEntradaScreen({Key? key, required this.entrada})
    : super(key: key);

  String _estadoAEmoji(String estado) {
    switch (estado) {
      case 'Feliz':
        return '😃';
      case 'Neutro':
        return '😐';
      case 'Triste':
        return '😞';
      default:
        return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Entrada Diario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji y estado
            Row(
              children: [
                Text(
                  _estadoAEmoji(entrada.estadoAnimo),
                  style: TextStyle(fontSize: 32),
                ),
                SizedBox(width: 10),
                Text(entrada.estadoAnimo, style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 16),

            // Titulo
            Text(
              entrada.titulo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            // Fecha
            Text(
              DateFormat('dd/MM/yyyy - HH:mm').format(entrada.fecha),
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            // Imagen si existe
            if (entrada.imagenPath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(entrada.imagenPath!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Text(
                        'Error al cargar la imagen',
                        style: TextStyle(color: Colors.red),
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
