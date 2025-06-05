import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==========================================================================
// Clase para mostrar notificaciones personalizadas en la aplicación
// ==========================================================================

class CustomNotification {
  // Método estático para mostrar una notificación personalizada
  static void mostrar(
    BuildContext context, {
    String titulo =
        'Recordatorio de Rehabilitación', // Título de la notificación
    String mensaje =
        '¡Es hora de realizar tus ejercicios!', // Mensaje de la notificación
    bool reproducirSonido = false, // Indica si se debe reproducir un sonido
    bool vibrar = false, // Indica si se debe activar la vibración
  }) {
    try {
      // Usar showGeneralDialog para mostrar una notificación personalizada
      showGeneralDialog(
        context: context,
        barrierColor: Colors.transparent, // Sin fondo oscuro
        barrierDismissible: true, // Permite cerrar tocando fuera
        barrierLabel: 'Notificación', // Etiqueta de accesibilidad
        transitionDuration: const Duration(
          milliseconds: 300,
        ), // Duración de la animación
        pageBuilder: (context, animation1, animation2) {
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter, // Aparece en la parte superior
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Material(
                  color: Colors.transparent, // Fondo transparente
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width *
                        0.8, // Ancho del 80% de la pantalla
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.surface, // Fondo según el tema
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.2), // Sombra sutil
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icono de notificación
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                              // ignore: deprecated_member_use
                            ).colorScheme.primary.withOpacity(
                              0.2,
                            ), // Fondo del ícono
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.healing, // Icono de terapia
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),

                        //Contenido de la notificación
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // Título de la notificación
                                titulo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Mensaje de la notificación
                              Text(
                                mensaje,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                    // ignore: deprecated_member_use
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Botón para cerrar la notificación
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            Navigator.pop(context); // Cierra la notificación
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      // Auto-cerrar la notificación después de 4 segundos
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pop(); // Cierra la notificación
      }).catchError((error) {
        // Ignora el error si la notificación ya fue cerrada
        debugPrint('Notificación ya cerrada: $error');
      });

      // Vibración si está activada
      if (vibrar) {
        HapticFeedback.mediumImpact(); // Vibración de intensidad media
      }
    } catch (e) {
      debugPrint('Error al mostrar notificación: $e');
      // Si ocurre un error, muestra un SnackBar como alternativa
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$titulo: $mensaje'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
