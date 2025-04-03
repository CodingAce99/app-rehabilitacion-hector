import 'package:flutter/material.dart';
import 'menu_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold es la estructura básica de cada pantalla (app bar, body, etc)
    return Scaffold(
      // Center y Column para centrar y alinear verticalmente los elementos
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Bienvenido a tu app de rehabilitación!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navega a la pantalla del menú usando Navigator.push
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
              child: Text('Empezar'),
            ),
          ],
        ),
      ),
    );
  }
}
