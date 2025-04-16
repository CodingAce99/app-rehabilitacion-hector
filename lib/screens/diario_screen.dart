import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/diario_provider.dart';
import '../models/entrada_diario.dart';
import 'dart:io';

class DiarioScreen extends StatefulWidget {
  @override
  _DiarioScreenState createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  final _controller = TextEditingController();

  String _estadoSeleccionado = '😐';

  final List<String> _etiquetasDisponibles = [
    'Dolor',
    'Ejercicio',
    'Mejora',
    'Cansancio',
    'Terapia',
  ];

  List<String> _etiquetasSeleccionadas = [];
  List<String> _etiquetasFiltro = [];
  File? _imagenSeleccionada; // Ruta de la imagen seleccionada

  void _guardarEntrada() {
    final texto = _controller.text.trim();
    if (texto.isNotEmpty) {
      Provider.of<DiarioProvider>(context, listen: false).agregarEntrada(
        texto,
        _estadoSeleccionado,
        _etiquetasSeleccionadas,
        imagenPath: _imagenSeleccionada?.path,
      );

      _controller.clear();
      setState(() {
        _estadoSeleccionado = '😐';
        _etiquetasSeleccionadas = [];
        _imagenSeleccionada = null; // Reinicia la imagen seleccionada
      });
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: ImageSource.gallery);

    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path); // Guarda la ruta
      });
    }
  }

  Widget _selectorEstadoAnimo() {
    final estados = ['😃', '😐', '😞'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          estados.map((emoji) {
            final seleccionado = _estadoSeleccionado == emoji;
            return GestureDetector(
              onTap: () => setState(() => _estadoSeleccionado = emoji),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: seleccionado ? Colors.blue[100] : null,
                  border: Border.all(
                    color: seleccionado ? Colors.blue : Colors.grey,
                  ),
                ),
                child: Text(emoji, style: TextStyle(fontSize: 28)),
              ),
            );
          }).toList(),
    );
  }

  Widget _selectorEtiquetas() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children:
          _etiquetasDisponibles.map((etiqueta) {
            final seleccionada = _etiquetasSeleccionadas.contains(etiqueta);
            return FilterChip(
              label: Text(etiqueta),
              selected: seleccionada,
              selectedColor: Colors.blue[100],
              onSelected: (valor) {
                setState(() {
                  if (valor) {
                    _etiquetasSeleccionadas.add(etiqueta);
                  } else {
                    _etiquetasSeleccionadas.remove(etiqueta);
                  }
                });
              },
            );
          }).toList(),
    );
  }

  Widget _filtroEtiquetas() {
    return Wrap(
      spacing: 8,
      children:
          _etiquetasDisponibles.map((etiqueta) {
            final seleccionada = _etiquetasFiltro.contains(etiqueta);
            return FilterChip(
              label: Text(etiqueta),
              selected: seleccionada,
              selectedColor: Colors.lightBlue[100],
              onSelected: (valor) {
                setState(() {
                  if (valor) {
                    _etiquetasFiltro.add(etiqueta);
                  } else {
                    _etiquetasFiltro.remove(etiqueta);
                  }
                });
              },
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final diario = Provider.of<DiarioProvider>(context);

    final entradasFiltradas =
        _etiquetasFiltro.isEmpty
            ? diario.entradas
            : diario.entradas.where((entrada) {
              return _etiquetasFiltro.every(
                (tag) => entrada.etiquetas.contains(tag),
              );
            }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Diario Personal')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Escribe tu entrada aquí...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ),
          _selectorEstadoAnimo(),
          SizedBox(height: 10),
          Text('Etiquetas:', style: TextStyle(fontWeight: FontWeight.bold)),
          _selectorEtiquetas(),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _guardarEntrada,
            child: Text('Guardar entrada'),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtrar por etiqueta:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _filtroEtiquetas(),
              ],
            ),
          ),
          Expanded(
            child:
                entradasFiltradas.isEmpty
                    ? Center(child: Text('No hay entradas que coincidan.'))
                    : ListView.builder(
                      itemCount: entradasFiltradas.length,
                      itemBuilder: (context, index) {
                        final entrada = entradasFiltradas[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      entrada.estadoAnimo,
                                      style: TextStyle(fontSize: 28),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        entrada.texto,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'dd/MM/yyyy – HH:mm',
                                  ).format(entrada.fecha),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Wrap(
                                  spacing: 6,
                                  children:
                                      entrada.etiquetas.map((tag) {
                                        return Chip(
                                          label: Text(tag),
                                          backgroundColor: Colors.grey[200],
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
