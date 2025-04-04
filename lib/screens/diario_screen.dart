import 'package:flutter/material.dart';

class DiarioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diario personal')),
      body: Center(
        child: Text(
          'Aquí irá el diario personal',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
