import 'package:flutter/material.dart';
import '../models/terapia.dart';

class DetalleTerapiaScreen extends StatelessWidget {
  final Terapia terapia;

  const DetalleTerapiaScreen({Key? key, required this.terapia})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(terapia.titulo)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(terapia.assetImage, width: 200, height: 200),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(terapia.descripcion, style: TextStyle(fontSize: 18)),
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
            //Se puede añadir mas contenido aquí, como enlaces o videos
          ],
        ),
      ),
    );
  }
}
