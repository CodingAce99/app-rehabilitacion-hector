import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entrada_diario.dart';

class DetalleEntradaScreen extends StatelessWidget {
  final EntradaDiario entrada;

  const DetalleEntradaScreen({Key? key, required this.entrada})
    : super(key: key);

  String _estadoDescripcion(String estado) {
    switch (estado) {
      case 'Feliz':
        return 'El paciente presenta un estado de ánimo positivo.';
      case 'Neutral':
        return 'El paciente presenta un estado de ánimo estable.';
      case 'Triste':
        return 'El paciente presenta un estado de ánimo bajo.';
      default:
        return 'Estado anímico no registrado.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalle de la entrada')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            Text(
              entrada.titulo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),

            // Fecha
            Text(
              DateFormat('dd/MM/yyyy – HH:mm').format(entrada.fecha),
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),

            // Estado de ánimo
            EntradaDetalleTile(
              titulo: 'Estado de ánimo',
              contenido: Text(
                _estadoDescripcion(entrada.estadoAnimo),
                style: TextStyle(fontSize: 16),
              ),
              delay: 100,
            ),

            // Texto del diario
            EntradaDetalleTile(
              titulo: 'Descripción del día',
              contenido: Text(entrada.texto, style: TextStyle(fontSize: 16)),
              delay: 300,
            ),

            // Etiquetas (si existen)
            if (entrada.etiquetas.isNotEmpty)
              EntradaDetalleTile(
                titulo: 'Etiquetas asociadas',
                contenido: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      entrada.etiquetas.map((etiqueta) {
                        return Chip(
                          label: Text(etiqueta),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                ),
                delay: 500,
              ),

            // Imagen (solo si existe)
            if (entrada.imagenPath != null)
              EntradaDetalleTile(
                titulo: 'Imagen adjunta',
                contenido: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(entrada.imagenPath!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Center(child: Text('No se pudo cargar la imagen.')),
                  ),
                ),
                delay: 700,
              ),
          ],
        ),
      ),
    );
  }
}

class EntradaDetalleTile extends StatefulWidget {
  final String titulo;
  final Widget contenido;
  final int delay;

  const EntradaDetalleTile({
    Key? key,
    required this.titulo,
    required this.contenido,
    required this.delay,
  }) : super(key: key);

  @override
  State<EntradaDetalleTile> createState() => _EntradaDetalleTileState();
}

class _EntradaDetalleTileState extends State<EntradaDetalleTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.titulo,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6),
              widget.contenido,
            ],
          ),
        ),
      ),
    );
  }
}
