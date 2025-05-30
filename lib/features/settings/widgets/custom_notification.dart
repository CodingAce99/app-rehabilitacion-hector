import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNotification {
  static void mostrar(
    BuildContext context, {
    String titulo = 'Recordatorio de Rehabilitación',
    String mensaje = '¡Es hora de realizar tus ejercicios!',
    bool reproducirSonido = false,
    bool vibrar = false,
  }) {
    try {
      // Usar showGeneralDialog que es más robusto que Overlay directo
      showGeneralDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: true,
        barrierLabel: 'Notificación',
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation1, animation2) {
          return SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.healing,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titulo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mensaje,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            Navigator.pop(context);
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

      // Auto-cerrar después de 4 segundos
      Future.delayed(const Duration(seconds: 4), () {
        Navigator.of(context, rootNavigator: true).pop();
      }).catchError((error) {
        // Si ya se cerró la notificación, ignorar el error
        print('Notificación ya cerrada: $error');
      });

      // Vibración si está activada
      if (vibrar) {
        HapticFeedback.mediumImpact();
      }
    } catch (e) {
      print('Error al mostrar notificación: $e');
      // Intenta con SnackBar como alternativa
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$titulo: $mensaje'),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
