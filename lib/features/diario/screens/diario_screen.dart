import 'dart:io';
import 'package:app_rehab/features/diario/screens/detalle_entrada_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/diario_provider.dart';
import '../models/entrada_diario.dart';

class DiarioScreen extends StatefulWidget {
  @override
  _DiarioScreenState createState() => _DiarioScreenState();
}

class _DiarioScreenState extends State<DiarioScreen> {
  final _controller = TextEditingController();
  final _tituloController = TextEditingController();
  String _estadoSeleccionado = 'Neutral';
  File? _imagenSeleccionada;

  final List<String> _etiquetasDisponibles = [
    'Dolor',
    'Ejercicio',
    'Mejora',
    'Cansancio',
    'Terapia',
  ];

  List<String> _etiquetasSeleccionadas = [];
  List<String> _etiquetasFiltro = [];

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() => _imagenSeleccionada = File(imagen.path));
    }
  }

  void _guardarEntrada() {
    final texto = _controller.text.trim();
    final titulo = _tituloController.text.trim();
    if (texto.isNotEmpty) {
      Provider.of<DiarioProvider>(context, listen: false).agregarEntrada(
        titulo,
        texto,
        _estadoSeleccionado,
        _etiquetasSeleccionadas,
        imagenPath: _imagenSeleccionada?.path,
      );
      _controller.clear();
      _tituloController.clear();
      setState(() {
        _estadoSeleccionado = 'Neutral';
        _etiquetasSeleccionadas = [];
        _imagenSeleccionada = null;
      });
      Navigator.of(context).pop(); // Cierra el modal
    }
  }

  void _abrirFormularioNuevaEntrada() {
    // variables locales para el modal
    String estadoSeleccionado = _estadoSeleccionado;
    List<String> etiquetasSeleccionadas = List.from(_etiquetasSeleccionadas);
    File? imagenTemporal = _imagenSeleccionada;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GestureDetector(
              onTap:
                  () => FocusScope.of(context).unfocus(), // oculta el teclado
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    MediaQuery.of(context).viewInsets.bottom + 32,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _tituloController,
                          decoration: InputDecoration(
                            hintText: 'Título de la entrada',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        TextField(
                          controller: _controller,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Escribe tu entrada...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Estado anímico:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          spacing: 10,
                          children:
                              ['Feliz', 'Neutral', 'Triste'].map((estado) {
                                final seleccionado =
                                    estadoSeleccionado == estado;
                                return ChoiceChip(
                                  label: Text(estado),
                                  selected: seleccionado,
                                  onSelected: (_) {
                                    setModalState(
                                      () => estadoSeleccionado = estado,
                                    );
                                  },
                                );
                              }).toList(),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Etiquetas:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Wrap(
                          spacing: 8,
                          children:
                              _etiquetasDisponibles.map((etiqueta) {
                                final seleccionada = etiquetasSeleccionadas
                                    .contains(etiqueta);
                                return FilterChip(
                                  label: Text(etiqueta),
                                  selected: seleccionada,
                                  onSelected: (valor) {
                                    setModalState(() {
                                      if (valor) {
                                        etiquetasSeleccionadas.add(etiqueta);
                                      } else {
                                        etiquetasSeleccionadas.remove(etiqueta);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        ),
                        SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: Icon(Icons.image),
                          label: Text('Seleccionar imagen'),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setModalState(
                                () => imagenTemporal = File(image.path),
                              );
                            }
                          },
                        ),
                        if (imagenTemporal != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Image.file(imagenTemporal!, height: 150),
                          ),
                        SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            child: Text('Guardar entrada'),
                            onPressed: () {
                              final titulo = _tituloController.text.trim();
                              final texto = _controller.text.trim();

                              if (titulo.isNotEmpty && texto.isNotEmpty) {
                                _estadoSeleccionado = estadoSeleccionado;
                                _etiquetasSeleccionadas =
                                    etiquetasSeleccionadas;
                                _imagenSeleccionada = imagenTemporal;

                                Provider.of<DiarioProvider>(
                                  context,
                                  listen: false,
                                ).agregarEntrada(
                                  titulo,
                                  texto,
                                  _estadoSeleccionado,
                                  _etiquetasSeleccionadas,
                                  imagenPath: _imagenSeleccionada?.path,
                                );

                                _controller.clear();
                                _tituloController.clear();
                                _imagenSeleccionada = null;

                                Navigator.of(context).pop(); // Cierra el modal
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _estadoAEmoji(String estado) {
    switch (estado) {
      case 'Feliz':
        return '😃';
      case 'Triste':
        return '😞';
      case 'Neutral':
      default:
        return '😐';
    }
  }

  Widget _selectorEstadoAnimo() {
    final estados = ['Feliz', 'Neutral', 'Triste'];

    return Wrap(
      spacing: 10,
      children:
          estados.map((estado) {
            final seleccionado = _estadoSeleccionado == estado;

            return ChoiceChip(
              label: Text(estado),
              selected: seleccionado,
              selectedColor: Colors.blue[100],
              onSelected: (_) {
                setState(() => _estadoSeleccionado = estado);
              },
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
      appBar: AppBar(title: Text('Mi diario')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Entradas guardadas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child:
                  entradasFiltradas.isEmpty
                      ? Center(child: Text('No hay entradas todavía.'))
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: diario.entradas.length,
                        itemBuilder: (context, index) {
                          final entrada = diario.entradas[index];

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            elevation: 2,
                            child: ListTile(
                              leading: Text(
                                _estadoAEmoji(entrada.estadoAnimo),
                                style: TextStyle(fontSize: 28),
                              ),
                              title: Text(
                                entrada.titulo,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'dd/MM/yyyy – HH:mm',
                                ).format(entrada.fecha),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed:
                                        () => _mostrarDialogoEditar(
                                          context,
                                          entrada,
                                        ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed:
                                        () => _confirmarEliminar(
                                          context,
                                          entrada.id,
                                        ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetalleEntradaScreen(
                                          entrada: entrada,
                                        ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirFormularioNuevaEntrada,
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('¿Eliminar entrada?'),
            content: Text('Esta acción no se puede deshacer.'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text('Eliminar'),
                onPressed: () {
                  Provider.of<DiarioProvider>(
                    context,
                    listen: false,
                  ).eliminarEntrada(id);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  void _mostrarDialogoEditar(BuildContext context, EntradaDiario entrada) {
    final controller = TextEditingController(text: entrada.texto);
    final tituloController = TextEditingController(text: entrada.titulo);
    String estadoSeleccionado = entrada.estadoAnimo;
    File? imagenSeleccionada =
        entrada.imagenPath != null ? File(entrada.imagenPath!) : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return GestureDetector(
              onTap:
                  () => FocusScope.of(context).unfocus(), // oculta el teclado
              child: AlertDialog(
                title: Text('Editar entrada'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: tituloController,
                        decoration: InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      TextField(
                        controller: controller,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Texto del diario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Estado anímico:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 10,
                        children:
                            ['Feliz', 'Neutral', 'Triste'].map((estado) {
                              final seleccionado = estadoSeleccionado == estado;
                              return ChoiceChip(
                                label: Text(estado),
                                selected: seleccionado,
                                selectedColor: Colors.blue[100],
                                onSelected: (_) {
                                  setModalState(
                                    () => estadoSeleccionado = estado,
                                  );
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (image != null) {
                            setModalState(() {
                              imagenSeleccionada = File(image.path);
                            });
                          }
                        },
                        icon: Icon(Icons.image),
                        label: Text('Seleccionar imagen'),
                      ),
                      if (imagenSeleccionada != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              imagenSeleccionada!,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    child: Text('Guardar'),
                    onPressed: () {
                      final texto = controller.text.trim();
                      final titulo = tituloController.text.trim();

                      if (titulo.isNotEmpty && texto.isNotEmpty) {
                        Provider.of<DiarioProvider>(
                          context,
                          listen: false,
                        ).editarEntrada(
                          entrada.id,
                          titulo,
                          texto,
                          estadoSeleccionado,
                          entrada.etiquetas,
                          imagenSeleccionada?.path,
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
