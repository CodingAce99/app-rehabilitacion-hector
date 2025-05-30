import '../models/ficha_rehabilitación.dart';
import 'package:flutter/material.dart';
import '../models/terapia.dart';
import 'detalle_ficha_screen.dart';
import 'package:provider/provider.dart';
import '../providers/fichas_provider.dart';

class DetalleTerapiaScreen extends StatelessWidget {
  // Creamos una variable final para almacenar la terapia seleccionada.
  final Terapia terapia;

  // Constructor de la clase DetalleTerapiasScreen
  DetalleTerapiaScreen({Key? key, required this.terapia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Accedemos al provider para obtener las fichas de esta terapia.
    final fichasProvider = Provider.of<FichasProvider>(context, listen: false);
    final List<FichaRehabilitacion> fichas = fichasProvider
        .obtenerFichasPorCategoria(terapia.titulo);

    return Scaffold(
      appBar: AppBar(title: Text(terapia.titulo)),
      // Usamos SingleChildScrollView para evitar el desbordamiento vertical.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect da esquinas redondeadas. fit: BoxFit.cover
            // para que la imagen ocupe todo el espacio disponible.
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                terapia.assetImage,
                width: double.infinity,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            // Descripción
            Text(
              terapia.descripcionCorta,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Objetivos
            _buildObjetivosYBeneficios(terapia),
            const SizedBox(height: 24),

            Text(
              'Fichas disponibles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Fichas de rehabilitación
            ...fichas.map(
              (ficha) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.assignment_outlined),

                  title: Text(
                    '${ficha.id.toUpperCase()} - ${ficha.titulo}',
                    style: TextStyle(fontSize: 16),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalleFichaScreen(ficha: ficha),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildObjetivosYBeneficios(Terapia terapia) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Objetivos Terapéuticos',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                ...terapia.objetivos.map(
                  (o) => Builder(
                    builder:
                        (context) => Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(o)),
                          ],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Beneficios',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                ...terapia.beneficios.map(
                  (b) => Builder(
                    builder:
                        (context) => Row(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(b)),
                          ],
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
