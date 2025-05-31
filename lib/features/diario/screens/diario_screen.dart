import 'dart:io';
import 'package:app_rehab/features/diario/screens/detalle_entrada_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/diario_provider.dart';
import '../models/entrada_diario.dart';

class DiarioScreen extends StatefulWidget {
  const DiarioScreen({super.key});

  @override
  DiarioScreenState createState() => DiarioScreenState();
}

class DiarioScreenState extends State<DiarioScreen> {
  final _controller = TextEditingController();
  final _tituloController = TextEditingController();
  String _estadoSeleccionado = 'Neutral';
  File? _imagenSeleccionada;

  List<String> _etiquetasSeleccionadas =
      []; // Etiquetas seleccionadas por el usuario
  final List<String> _etiquetasFiltro = [
  ]; // Etiquetas usadas para filtrar las entradas

  // Metodo principal para construir la pantalla
  @override
  Widget build(BuildContext context) {
    final diario = Provider.of<DiarioProvider>(
      context,
    ); // Acceso al provider del diario
    final entradasFiltradas =
        _etiquetasFiltro.isEmpty
            ? diario.entradas
            : diario.entradas.where(
              (entrada) {
                return _etiquetasFiltro.every(
                  (tag) => entrada.etiquetas.contains(tag),
                );
              },
            ).toList(); // Fiiltra las entradas según las etiquetas seleccionadas

    return Scaffold(
      appBar: AppBar(title: Text('Mi diario')), // Título de la pantalla
      body: Padding(
        padding: const EdgeInsets.all(12), // Espaciado interno
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título de la sección de entradas
            Text(
              'Entradas guardadas:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 10),

            // Lista de entradas o mensaje vacio si no hay entradas
            Expanded(
              child:
                  entradasFiltradas.isEmpty
                      ? Center(
                        child: Text('No hay entradas todavía.'),
                      ) // Mensaje si no hay entradas
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: entradasFiltradas.length,
                        itemBuilder: (context, index) {
                          final entrada = entradasFiltradas[index];

                          return Card(
                            margin: EdgeInsets.symmetric(
                              vertical: 6,
                            ), // Margen entre tarjetas
                            elevation: 2, // Sombra de la tarjeta
                            child: ListTile(
                              title: Text(
                                entrada.titulo,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'dd/MM/yyyy – HH:mm',
                                ).format(entrada.fecha),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Boton para editar la entrada
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed:
                                        () => _mostrarDialogoEditar(
                                          context,
                                          entrada,
                                        ),
                                  ),
                                  // Boton para eliminar la entrada
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
                                // Navega a la pantalla de detalles
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
      // Botón flotante para agregar una nueva entrada
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormularioNuevaEntrada,
        label: Text('Nueva entrada'),
        icon: Icon(Icons.add),
      ),
    );
  }

  /// =========================
  /// MÉTODOS PRIVADOS
  /// =========================

  // Abre el formulario para agregar una nueva entrada
  void _abrirFormularioNuevaEntrada() {
    // Variables locales para el modal
    String estadoSeleccionado = 'Neutral';
    List<String> etiquetasSeleccionadas = List.from(_etiquetasSeleccionadas);
    File? imagenTemporal = _imagenSeleccionada;
    List<String> areasDolorSeleccionadas = [];
    final List<String> _areasDolorDisponibles = [
      'Cabeza',
      'Espalda',
      'Piernas',
      'Brazos',
      'Cuello',
      'Abdomen',
    ];

    // Variables para los campos
    double dolor = 5; // Valor inicial del slider
    double calidadSueno = 5; // Valor inicial del slider
    String terapiaSeleccionada = 'Ninguna'; // Valor inicial del dropdown
    String descripcionDolor = ''; // Descripción del dolor
    bool tieneDolor = false; // Inicialmente, se asume que no tiene dolor

    // Abre el modal para agregar una nueva entrada
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
                  () => FocusScope.of(context).unfocus(), // Oculta el teclado
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
                        // Botón de cerrar el modal
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Text(
                          'Nueva entrada',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 12),

                        // Campo de título
                        TextField(
                          controller: _tituloController,
                          decoration: InputDecoration(
                            hintText: 'Escribe un título...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Campo para la descripción de la entrada
                        TextField(
                          controller: _controller,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Escribe tu entrada...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Selección de la terapia
                        Text(
                          'Terapia:',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          value: terapiaSeleccionada,
                          isExpanded: true,
                          hint: Text('Selecciona una terapia'),
                          underline: Container(height: 1, color: Colors.grey),
                          icon: Icon(Icons.arrow_drop_down),
                          style: Theme.of(context).textTheme.bodyLarge,
                          dropdownColor: Colors.white,
                          items:
                              [
                                'Ninguna',
                                'Fisioterapia',
                                'Logopedia',
                                'Ortopedia',
                                'Psicología',
                                'Terapia Ocupacional',
                              ].map((terapia) {
                                return DropdownMenuItem<String>(
                                  value: terapia,
                                  child: Text(terapia),
                                );
                              }).toList(),
                          onChanged: (valor) {
                            setModalState(() {
                              terapiaSeleccionada = valor!;
                            });
                          },
                        ),
                        SizedBox(height: 12),

                        // Slider de calidad de sueño
                        Text(
                          'Calidad de sueño (1-10):',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        _buildCalidadSuenoSlider(calidadSueno, (valor) {
                          setModalState(() {
                            calidadSueno = valor;
                          });
                        }),
                        SizedBox(height: 12),

                        // Selector de estado anímico
                        Text(
                          'Estado anímico:',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        _buildEstadoAnimicoSlider(estadoSeleccionado, (valor) {
                          setModalState(() {
                            estadoSeleccionado = valor;
                          });
                        }),
                        SizedBox(height: 12),

                        // Pregunta si tiene dolor
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '¿Tienes dolor?',
                              style: Theme.of(context).textTheme.bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Switch(
                              value: tieneDolor,
                              onChanged: (valor) {
                                setModalState(() {
                                  tieneDolor = valor;
                                  if (!tieneDolor) {
                                    // Si no tiene dolor, reinicia los valores relacionados
                                    dolor = 0;
                                    areasDolorSeleccionadas.clear();
                                    descripcionDolor = '';
                                  } else {
                                    // Si tiene dolor, ajusta el valor inicial del slider
                                    dolor = 1;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Mostrar campos de dolor solo si tieneDolor es true
                        if (tieneDolor) ...[
                          // Nivel de dolor
                          Text(
                            'Nivel de dolor (1-10):',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Slider(
                            value: dolor,
                            min: 1,
                            max: 10,
                            divisions: 9,
                            label: dolor.round().toString(),
                            onChanged: (valor) {
                              setModalState(() {
                                dolor = valor;
                              });
                            },
                          ),
                          SizedBox(height: 12),

                          // Áreas de dolor
                          Text(
                            '¿Dónde sientes dolor?',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8,
                            children:
                                _areasDolorDisponibles.map((area) {
                                  final seleccionada = areasDolorSeleccionadas
                                      .contains(area);
                                  return FilterChip(
                                    label: Text(area),
                                    selected: seleccionada,
                                    selectedColor: Theme.of(
                                      context,
                                      // ignore: deprecated_member_use
                                    ).colorScheme.primary.withOpacity(0.5),
                                    onSelected: (valor) {
                                      setModalState(() {
                                        if (valor) {
                                          areasDolorSeleccionadas.add(area);
                                        } else {
                                          areasDolorSeleccionadas.remove(area);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                          SizedBox(height: 12),

                          // Descripción del dolor
                          Text(
                            'Descripción del dolor:',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: 'Describe el dolor que sientes...',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (valor) {
                              setModalState(() {
                                descripcionDolor = valor;
                              });
                            },
                          ),
                          SizedBox(height: 12),
                        ],

                        // Selección de Imagen
                        ElevatedButton.icon(
                          icon: Icon(Icons.image),
                          label: Text('Seleccionar imagen'),
                          onPressed: () async {
                            final picker = ImagePicker();
                            final image = await picker.pickImage(
                              source: ImageSource.gallery,
                            );
                            if (image != null) {
                              setModalState(() {
                                imagenTemporal = File(image.path);
                              });
                            }
                          },
                        ),
                        if (imagenTemporal != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Image.file(imagenTemporal!, height: 150),
                          ),
                        SizedBox(height: 16),

                        // Botón para guardar la entrada
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
                                  tieneDolor ? dolor.round().toString() : '0',
                                  calidadSueno.round().toString(),
                                  terapiaSeleccionada,
                                  _etiquetasSeleccionadas,
                                  _imagenSeleccionada?.path,
                                  tieneDolor ? areasDolorSeleccionadas : [],
                                  tieneDolor ? descripcionDolor : '',
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
}

// Método que construye el selector de estado anímico con slider
Widget _buildEstadoAnimicoSlider(
  String estadoSeleccionado,
  void Function(String) onChanged,
) {
  // Lista ordenada de estados anímicos
  final List<String> estados = [
    'Triste',
    'Ansioso',
    'Neutro',
    'Enfadado',
    'Feliz',
  ];
  final List<String> emojis = ['😞', '😰', '😐', '😠', '😃'];

  // Encontrar el índice del estado seleccionado
  int indiceSeleccionado = estados.indexOf(estadoSeleccionado);
  if (indiceSeleccionado < 0) indiceSeleccionado = 2; // Neutro por defecto

  return Column(
    children: [
      Slider(
        value: indiceSeleccionado.toDouble(),
        min: 0,
        max: (estados.length - 1).toDouble(),
        divisions: estados.length - 1,
        label: estados[indiceSeleccionado],
        onChanged: (valor) {
          onChanged(estados[valor.round()]);
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          estados.length,
          (index) => Column(
            children: [
              Text(emojis[index], style: TextStyle(fontSize: 24)),
              Text(estados[index], style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
      SizedBox(height: 8),
    ],
  );
}

// Método que construye el selector de calidad de sueño con slider
Widget _buildCalidadSuenoSlider(
  double calidadSueno,
  void Function(double) onChanged,
) {
  return Column(
    children: [
      Slider(
        value: calidadSueno,
        min: 1,
        max: 10,
        divisions: 9,
        label: calidadSueno.round().toString(),
        onChanged: onChanged,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Emoji para calidad baja (1)
          Column(
            children: [
              Text('😫', style: TextStyle(fontSize: 24)),
              Text('Mala', style: TextStyle(fontSize: 12)),
            ],
          ),
          // Emoji para calidad media (5)
          Column(
            children: [
              Text('😐', style: TextStyle(fontSize: 24)),
              Text('Regular', style: TextStyle(fontSize: 12)),
            ],
          ),
          // Emoji para calidad alta (10)
          Column(
            children: [
              Text('😴', style: TextStyle(fontSize: 24)),
              Text('Excelente', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
      SizedBox(height: 8),
    ],
  );
}

// Método que muestra un diálogo de confirmación para eliminar una entrada
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

// Método que muestra un diálogo para editar una entrada existente
void _mostrarDialogoEditar(BuildContext context, EntradaDiario entrada) {
  final controller = TextEditingController(text: entrada.texto);
  final tituloController = TextEditingController(text: entrada.titulo);
  String estadoSeleccionado = entrada.estadoAnimo;
  double dolor = double.tryParse(entrada.dolor) ?? 5;
  double calidadSueno = double.tryParse(entrada.calidadSueno) ?? 5;
  String descripcionDolor = entrada.descripcionDolor;
  List<String> areasDolorSeleccionadas = List.from(entrada.areasDolor);
  File? imagenSeleccionada =
      entrada.imagenPath != null ? File(entrada.imagenPath!) : null;

  final List<String> areasDolorDisponibles = [
    'Cabeza',
    'Espalda',
    'Piernas',
    'Brazos',
    'Cuello',
    'Abdomen',
  ];

  // Nueva variable para controlar si tiene dolor
  bool tieneDolor =
      entrada.dolor != '0'; // Asume que si el dolor es 0, no tiene dolor

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // Oculta el teclado
            child: AlertDialog(
              title: Text(
                'Editar entrada',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    // Campo de título
                    TextField(
                      controller: tituloController,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Campo de texto descripción
                    TextField(
                      controller: controller,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Descripción entrada',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 12),

                    // Selección estado anímico
                    Text(
                      'Estado anímico:',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildEstadoAnimicoSlider(estadoSeleccionado, (valor) {
                      setModalState(() {
                        estadoSeleccionado = valor;
                      });
                    }),
                    SizedBox(height: 12),

                    // Calidad del sueño
                    Text(
                      'Calidad del sueño (1-10):',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Slider(
                      value: calidadSueno,
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: calidadSueno.round().toString(),
                      onChanged: (valor) {
                        setModalState(() {
                          calidadSueno = valor;
                        });
                      },
                    ),
                    SizedBox(height: 12),

                    // Pregunta si tiene dolor
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '¿Tienes dolor?',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: tieneDolor,
                          onChanged: (valor) {
                            setModalState(() {
                              tieneDolor = valor;
                              if (!tieneDolor) {
                                // Si no tiene dolor, reinicia los valores relacionados
                                dolor = 0;
                                areasDolorSeleccionadas.clear();
                                descripcionDolor = '';
                              } else {
                                // Si tiene dolor, ajusta el valor inicial del slider
                                dolor = 1;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // Mostrar campos de dolor solo si tieneDolor es true
                    if (tieneDolor) ...[
                      // Nivel de dolor
                      Text(
                        'Nivel de dolor (1-10):',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Slider(
                        value: dolor,
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: dolor.round().toString(),
                        onChanged: (valor) {
                          setModalState(() {
                            dolor = valor;
                          });
                        },
                      ),
                      SizedBox(height: 12),

                      // Áreas de dolor
                      Text(
                        '¿Dónde sientes dolor?',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children:
                            areasDolorDisponibles.map((area) {
                              final seleccionada = areasDolorSeleccionadas
                                  .contains(area);
                              return FilterChip(
                                label: Text(area),
                                selected: seleccionada,
                                selectedColor: Theme.of(
                                  context,
                                  // ignore: deprecated_member_use
                                ).colorScheme.primary.withOpacity(0.5),
                                onSelected: (valor) {
                                  setModalState(() {
                                    if (valor) {
                                      areasDolorSeleccionadas.add(area);
                                    } else {
                                      areasDolorSeleccionadas.remove(area);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 12),

                      // Descripción del dolor
                      Text(
                        'Descripción del dolor:',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Describe el dolor que sientes...',
                          border: OutlineInputBorder(),
                        ),
                        controller: TextEditingController(
                          text: descripcionDolor,
                        ),
                        onChanged: (valor) {
                          setModalState(() {
                            descripcionDolor = valor;
                          });
                        },
                      ),
                      SizedBox(height: 12),
                    ],

                    // Selección de Imagen
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
                        tieneDolor ? dolor.round().toString() : '0',
                        calidadSueno.round().toString(),
                        entrada.terapia,
                        entrada.etiquetas,
                        tieneDolor ? areasDolorSeleccionadas : [],
                        imagenSeleccionada?.path,
                        areasDolorSeleccionadas,
                        descripcionDolor,
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
