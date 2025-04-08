import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/diario_provider.dart';
import '../models/entrada_diario.dart';

class DiarioScreen extends StatefulWidget {
  @override
  _DiarioScreenState createState() => _DiarioScreenState();
}

// State asociado al widget principal
class _DiarioScreenState extends State<DiarioScreen> {
  // Controlador para el campo de texto (permite leer lo que escribe el usuario)
  final _controller = TextEditingController();

  // Emoji seleccionado como estado de ánimo (inicializado como "neutral")
  String _estadoSeleccionado = '😐';

  //Función que se llama al pulsar el botón de "Guardar entrada"
  void _guardarEntrada() {
    final texto = _controller.text.trim(); // Elimina espacios al inicio y final
    if (texto.isNotEmpty) {
      // Usamos Provider para acceder al DiarioProvider y llamar a agregarEntrada
      // listen: false porque no necesitamos redibujar la pantalla tras esto
      Provider.of<DiarioProvider>(
        context,
        listen: false,
      ).agregarEntrada(texto, _estadoSeleccionado);
      _controller.clear(); // Limpiamos el campo de texto{
      setState(() {
        _estadoSeleccionado = '😐'; // Reiniciamos el emoji a neutral
      });
    }
  }

  void _mostrarDialogoEditar(entrada) {
    final controller = TextEditingController(text: entrada.texto);
    String estadoSeleccionado = entrada.estadoAnimo;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar entrada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Texto del diario'),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    ['😃', '😐', '😞'].map((emoji) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            estadoSeleccionado = emoji;
                          });
                          Navigator.of(context).pop();
                          _mostrarDialogoEditar(
                            EntradaDiario(
                              id: entrada.id,
                              fecha: entrada.fecha,
                              texto: controller.text,
                              estadoAnimo: emoji,
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  estadoSeleccionado == emoji
                                      ? Colors.blue
                                      : Colors.grey,
                            ),
                          ),
                          child: Text(emoji, style: TextStyle(fontSize: 24)),
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: Text('Guardar'),
              onPressed: () {
                Provider.of<DiarioProvider>(
                  context,
                  listen: false,
                ).editarEntrada(
                  entrada.id,
                  controller.text,
                  estadoSeleccionado,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Widget que construye la fila de selección de emojis de estado de ánimo
  Widget _selectorEstadoAnimo() {
    final estados = ['😃', '😐', '😞']; // Opciones posibles de estado

    // Usamos Row + map para crear un widget por cada emoji
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Centra horizontalmente
      children:
          estados.map((emoji) {
            final bool seleccionado = _estadoSeleccionado == emoji;

            return GestureDetector(
              //usamos GestureDetector porque queremos controlar que pasa al tocar el emoji
              onTap: () {
                setState(() {
                  _estadoSeleccionado = emoji; // Cambia el emoji seleccionado
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      seleccionado
                          ? Colors.blue[100]
                          : null, // Color solo si está seleccionado
                  border: Border.all(
                    color:
                        seleccionado
                            ? Colors.blue
                            : Colors.grey, // Color del borde
                  ),
                ),
                child: Text(
                  emoji,
                  style: TextStyle(
                    fontSize: 28, // Tamaño del emoji
                  ),
                ),
              ),
            );
          }).toList(), // Convertimos el map en lista de widgets
    );
  }

  // Widget que construye la lista de entradas del diario
  @override
  Widget build(BuildContext context) {
    // Obtenemos el provider para acceder a las entradas del diario
    final diario = Provider.of<DiarioProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Diario Personal')),

      // Cuerpo principal con columna (elementos apilados verticalmente)
      body: Column(
        children: [
          // Campo de texto para que el usuario escriba su entrada
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller, // Permite recuperar el texto escrito
              decoration: InputDecoration(
                hintText: 'Escribe tu entrada aquí...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3, // Permite varias líneas (estilo "nota")
            ),
          ),

          // Muestra los emojis para elegir estado de ánimo
          _selectorEstadoAnimo(),

          // Botón para guardar la entrada
          ElevatedButton(
            onPressed: _guardarEntrada,
            child: Text('Guardar entrada'),
          ),

          Divider(), // Línea separadora entre formulario y lista
          // Lista de entradas ya creadas
          Expanded(
            child:
                diario.entradas.isEmpty
                    ? Center(child: Text('No hay entradas aún.'))
                    : ListView.builder(
                      itemCount: diario.entradas.length,
                      itemBuilder: (context, index) {
                        final entrada = diario.entradas[index];
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: Text(
                              entrada.estadoAnimo,
                              style: TextStyle(fontSize: 28),
                            ),
                            title: Text(entrada.texto),
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
                                      () => _mostrarDialogoEditar(entrada),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text(
                                              'Confirmar eliminación',
                                            ),
                                            content: Text(
                                              '¿Estás seguro de que deseas eliminar esta entrada?',
                                            ),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancelar'),
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(), // Cierra el diálogo
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
                                                  ).eliminarEntrada(entrada.id);
                                                  Navigator.of(
                                                    context,
                                                  ).pop(); // Cierra el diálogo
                                                },
                                              ),
                                            ],
                                          ),
                                    );
                                  },
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
