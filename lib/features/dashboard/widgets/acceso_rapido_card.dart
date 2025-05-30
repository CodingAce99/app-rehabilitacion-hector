import 'package:flutter/material.dart';

// Tarjeta de acceso rápido que incluye un ícono, un título y una acción al presionar
class AccesoRapidoCard extends StatelessWidget {
  final IconData icon; // Ícono que se muestra en la tarjeta
  final String titulo; // Título de la tarjeta
  final VoidCallback onTap; // Acción que se ejecuta al presionar la tarjeta

  const AccesoRapidoCard({
    super.key,
    required this.icon,
    required this.titulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2, // Sombra de la tarjeta
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ), // Bordes redondeados
      child: ListTile(
        leading: Icon(icon, size: 30, color: Theme.of(context).iconTheme.color),
        title: Text(titulo), // Título de la tarjeta
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ),
        onTap: onTap, // Acción al presionar la tarjeta
      ),
    );
  }
}
