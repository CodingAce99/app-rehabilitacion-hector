import 'package:flutter/material.dart';
import '../models/terapia.dart';

class DetalleTerapiaScreen extends StatelessWidget {
  // Creamos una variable final para almacenar la terapia seleccionada.
  final Terapia terapia;

  // Constructor de la clase DetalleTerapiasScreen
  const DetalleTerapiaScreen({Key? key, required this.terapia})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(terapia.titulo)),
      // Usamos SingleChildScrollView para evitar el desbordamiento vertical.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Aquí iran los bloques siguientes:

            // Imagen de la terapia

            /*
            ClipRRect da esquinas redondeadas. fit: BoxFit.cover
            para que la imagen ocupe todo el espacio disponible.
            */
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                terapia.assetImage,
                width: double.infinity,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            // Título y descripción de la terapia
            Text(
              terapia.titulo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Text(
              terapia.descripcion,
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
            ),
            const SizedBox(height: 24),

            // Objetivos terapeuticos con Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Objetivos Terapéuticos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    /*
                    Usamos .map() para recorrer la lista de objetivos
                    y crear un widget Row para cada uno.
                    */
                    ...terapia.objetivos.map(
                      (objetivo) => Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green),
                          const SizedBox(width: 8),
                          Expanded(child: Text(objetivo)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Beneficios con Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beneficios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...terapia.beneficios.map(
                      (beneficio) => Row(
                        children: [
                          Icon(Icons.arrow_right, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(child: Text(beneficio)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Botón para volver
            Center(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text('Volver'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
