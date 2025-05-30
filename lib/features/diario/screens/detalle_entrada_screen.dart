import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/entrada_diario.dart';

// Pantalla para mostrar los detalles de una entrada del diario
class DetalleEntradaScreen extends StatelessWidget {
  final EntradaDiario entrada;

  const DetalleEntradaScreen({super.key, required this.entrada});

  // Devuelve una descripción basada en el estado de ánimo
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
      appBar: AppBar(
        title: Text(
          entrada.titulo, // Título de la entrada
          style: Theme.of(context).textTheme.titleLarge, // Usar el tema
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16), // Espaciado interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo de terapia
            Text(
              'Terapia: ${entrada.terapia}',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Fecha de la entrada
            Text(
              DateFormat('dd/MM/yyyy – HH:mm').format(entrada.fecha),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 20),

            // Estado de ánimo
            EntradaDetalleTile(
              titulo:
                  '${_obtenerEmoticono('estadoAnimo', entrada.estadoAnimo)} Estado de ánimo',
              contenido: Text(
                entrada.estadoAnimo.isNotEmpty
                    ? '${entrada.estadoAnimo} - ${_estadoDescripcion(entrada.estadoAnimo)}'
                    : 'No se registró el estado de ánimo.',
                style: Theme.of(context).textTheme.bodyMedium, // Usar el tema
              ),
              delay: 100,
            ),

            // Calidad del sueño
            EntradaDetalleTile(
              titulo:
                  '${_obtenerEmoticono('calidadSueno', entrada.calidadSueno)} Calidad del sueño',
              contenido: Text(
                entrada.calidadSueno.isNotEmpty
                    ? 'Calidad del sueño: ${entrada.calidadSueno}/10'
                    : 'No se registró la calidad del sueño.',
                style: Theme.of(context).textTheme.bodyMedium, // Usar el tema
              ),
              delay: 200,
            ),

            // Nivel de dolor
            EntradaDetalleTile(
              titulo:
                  '${_obtenerEmoticono('dolor', entrada.dolor)} Nivel de dolor',
              contenido: Text(
                entrada.dolor.isNotEmpty
                    ? 'Nivel de dolor: ${entrada.dolor}/10'
                    : 'No se registró el nivel de dolor.',
                style: Theme.of(context).textTheme.bodyMedium, // Usar el tema
              ),
              delay: 300,
            ),

            // Áreas de dolor
            if (entrada.areasDolor.isNotEmpty)
              EntradaDetalleTile(
                titulo: 'Áreas de dolor',
                contenido: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      entrada.areasDolor.map((area) {
                        return Chip(
                          label: Text(
                            area,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.bodySmall, // Usar el tema
                          ),
                          backgroundColor: Colors.red[100],
                        );
                      }).toList(),
                ),
                delay: 400,
              ),

            // Descripción del dolor
            EntradaDetalleTile(
              titulo: 'Descripción del dolor',
              contenido: Text(
                entrada.descripcionDolor.isNotEmpty
                    ? entrada.descripcionDolor
                    : 'No se registró una descripción del dolor.',
                style: Theme.of(context).textTheme.bodyMedium, // Usar el tema
              ),
              delay: 500,
            ),

            // Texto del diario
            EntradaDetalleTile(
              titulo: 'Descripción del día',
              contenido: Text(
                entrada.texto,
                style: Theme.of(context).textTheme.bodyMedium, // Usar el tema
              ),
              delay: 600,
            ),

            // Etiquetas asociadas
            if (entrada.etiquetas.isNotEmpty)
              EntradaDetalleTile(
                titulo: 'Etiquetas asociadas',
                contenido: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      entrada.etiquetas.map((etiqueta) {
                        return Chip(
                          label: Text(
                            etiqueta,
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.bodySmall, // Usar el tema
                          ),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                ),
                delay: 700,
              ),

            // Imagen adjunta (solo si existe)
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
                delay: 800,
              ),
          ],
        ),
      ),
    );
  }

  // Devuleve un emoticono basado en el campo y valor
  String _obtenerEmoticono(String campo, String valor) {
    switch (campo) {
      case 'estadoAnimo':
        switch (valor) {
          case 'Feliz':
            return '😊';
          case 'Neutral':
            return '😐';
          case 'Triste':
            return '😢';
          case 'Enfadado':
            return '😠';
          case 'Ansioso':
            return '😟';
          default:
            return '❓';
        }
      case 'calidadSueno':
        final calidad = int.tryParse(valor) ?? 0;
        if (calidad >= 8) return '😴'; // Excelente calidad de sueño
        if (calidad >= 5) return '😌'; // Calidad de sueño aceptable
        return '😟'; // Mala calidad de sueño
      case 'dolor':
        final nivelDolor = int.tryParse(valor) ?? 0;
        if (nivelDolor == 0) return '😄'; // Sin dolor
        if (nivelDolor <= 3) return '🙂'; // Dolor leve
        if (nivelDolor <= 6) return '😕'; // Dolor moderado
        return '😖'; // Dolor severo
      default:
        return ''; // Sin emoticono
    }
  }
}

// Widget para mostrar un detalle de la entrada con animación
class EntradaDetalleTile extends StatefulWidget {
  final String titulo; // Título del detalle
  final Widget contenido; // Contenido del detalle
  final int delay; // Retraso de la animación

  const EntradaDetalleTile({
    super.key,
    required this.titulo,
    required this.contenido,
    required this.delay,
  });

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
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ), // Usar el tema
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
