import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/terapia.dart';

class DetalleTerapiaScreen extends StatelessWidget {
  final Terapia terapia;

  const DetalleTerapiaScreen({super.key, required this.terapia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(terapia.nombre)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            SvgPicture.asset(terapia.imagePath, width: 200, height: 200),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                terapia.descripcionDetallada,
                style: TextStyle(fontSize: 18),
              ),
            ),

            // Botón volver
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
              label: Text('Volver'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(height: 0),
            //Se puede añadir mas contenido aquí, como enlaces o videos
          ],
        ),
      ),
    );
  }
}
