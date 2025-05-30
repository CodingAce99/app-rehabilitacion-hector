// Importaciones de librerías y paquetes
import 'package:app_rehab/features/terapias/widgets/terapia_seguimiento_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importaciones de otras pantallas y widgets
import '../providers/terapias_seguimiento_provider.dart';
import '../providers/fichas_provider.dart';
import '../models/ficha_rehabilitación.dart';
import '../models/terapia_seguimiento.dart';

class SeguimientoTerapiasScreen extends StatelessWidget {
  const SeguimientoTerapiasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seguimiento de Terapias")),
      body: Consumer<TerapiasSeguimientoProvider>(
        builder: (context, seguimientoProvider, _) {
          final terapias = seguimientoProvider.terapias;

          if (terapias.isEmpty) {
            return const Center(child: Text('No hay terapias en seguimiento.'));
          }
          final enCurso = terapias.where((t) => !t.completada).length;
          final completadas = terapias.where((t) => t.completada).length;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'En curso: $enCurso | Completadas: $completadas',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: terapias.length,
                  itemBuilder: (context, index) {
                    final terapia = terapias[index];
                    return TerapiaSeguimientoCard(
                      terapia: terapia,
                      onMarcarCompletada: () {
                        seguimientoProvider.marcarComoCompletada(terapia.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      // Botón para añadir nuevas terapias
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarModalAgregarTerapia(context),
        label: const Text("Añadir Terapia"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  ///==================
  /// METODOS PRIVADOS
  ///==================

  /// Muestra un modal para agregar una nueva terapia al seguimiento.
  void _mostrarModalAgregarTerapia(BuildContext context) async {
    String? categoriaSeleccionada;
    FichaRehabilitacion? fichaSeleccionada;
    List<FichaRehabilitacion> fichasFiltradas = [];

    // Acceder al provider de fichas para obtener las terapias disponibles
    final fichasProvider = Provider.of<FichasProvider>(context, listen: false);

    // Intentar cargar las fichas si el mapa está vacío
    if (fichasProvider.fichasPorCategoria.isEmpty) {
      try {
        // Esperar a que se carguen los datos
        await fichasProvider.cargarFichasDesdeJson();

        // Verificar nuevamente después de cargar
        if (fichasProvider.fichasPorCategoria.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No hay terapias disponibles en el archivo JSON'),
            ),
          );
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar las terapias: ${e.toString()}'),
          ),
        );
        return;
      }
    }

    // Obtener la lista de categorías
    final categorias = fichasProvider.fichasPorCategoria.keys.toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // Usamos debugPrint para verificar que categorias tenga elementos
            debugPrint('Categorías disponibles: ${categorias.length}');

            return Container(
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                // Envolvemos en SingleChildScrollView para evitar overflow
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Añadir nueva terapia al seguimiento',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Paso 1: Seleccionar categoría de terapia
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tipo de terapia',
                        border: OutlineInputBorder(),
                      ),
                      value: categoriaSeleccionada,
                      hint: const Text('Selecciona el tipo de terapia'),
                      isExpanded:
                          true, // Asegurar que el dropdown ocupe todo el ancho disponible
                      items:
                          categorias.map((categoria) {
                            final categoriaMostrar =
                                categoria[0].toUpperCase() +
                                categoria.substring(1);
                            return DropdownMenuItem(
                              value: categoria,
                              child: Text(categoriaMostrar),
                            );
                          }).toList(),
                      onChanged: (valor) {
                        setModalState(() {
                          // Usamos setModalState en lugar de setState
                          categoriaSeleccionada = valor;
                          fichaSeleccionada = null;
                          if (valor != null) {
                            fichasFiltradas = fichasProvider
                                .obtenerFichasPorCategoria(valor);
                            debugPrint(
                              'Fichas filtradas: ${fichasFiltradas.length} para categoría $valor',
                            );
                          } else {
                            fichasFiltradas = [];
                          }
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Paso 2: Seleccionar la terapia específica
                    if (categoriaSeleccionada != null)
                      DropdownButtonFormField<FichaRehabilitacion>(
                        decoration: const InputDecoration(
                          labelText: 'Terapia específica',
                          border: OutlineInputBorder(),
                        ),
                        value: fichaSeleccionada,
                        hint: const Text('Selecciona la terapia'),
                        isExpanded: true,
                        items:
                            fichasFiltradas.map((ficha) {
                              return DropdownMenuItem(
                                value: ficha,
                                child: Text(ficha.titulo),
                              );
                            }).toList(),
                        onChanged: (valor) {
                          setModalState(() {
                            fichaSeleccionada = valor;
                          });
                        },
                      ),

                    const SizedBox(height: 24),

                    // Botones de acción
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed:
                              fichaSeleccionada == null
                                  ? null
                                  : () {
                                    final seguimientoProvider = Provider.of<
                                      TerapiasSeguimientoProvider
                                    >(context, listen: false);

                                    final nuevaTerapia = TerapiaSeguimiento(
                                      id:
                                          DateTime.now().millisecondsSinceEpoch
                                              .toString(),
                                      nombre: fichaSeleccionada!.titulo,
                                      ficha: fichaSeleccionada!,
                                      fechaInicio: DateTime.now(),
                                      completada: false,
                                    );

                                    seguimientoProvider.agregarTerapia(
                                      nuevaTerapia,
                                    );
                                    Navigator.pop(context);
                                  },
                          child: const Text('Añadir'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
