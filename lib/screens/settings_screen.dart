// Importaciones necesarias
import 'package:app_rehab/widgets/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Otras importaciones
import '../features/user/screens/profile_screen.dart';
import '../core/theme/theme_provider.dart';
import '../features/user/providers/user_provider.dart';
import '../features/settings/screens/appearance_settings_screen.dart';
import '../features/settings/screens/notification_settings_screen.dart';
import '../features/settings/screens/data_privacy_screen.dart';
import '../features/settings/screens/therapy_settings_screen.dart';
import '../features/settings/screens/accessibility_settings_screen.dart';
import '../features/settings/screens/help_support_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        children: [
          // Sección de perfil destacada
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.2),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<UserProvider>(context).user?.nombre ??
                            'Usuario',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Editar perfil',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // Encabezado de opciones de configuración
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              'CONFIGURACIÓN',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Apariencia
          _buildSettingItem(
            context,
            icon: Icons.palette_outlined,
            title: 'Apariencia',
            subtitle: 'Tema, tamaño de texto',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AppearanceSettingsScreen()),
                ),
          ),

          // Notificaciones
          _buildSettingItem(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notificaciones',
            subtitle: 'Recordatorios y alertas',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NotificationSettingsScreen(),
                  ),
                ),
          ),

          // Datos y privacidad
          _buildSettingItem(
            context,
            icon: Icons.lock_outline,
            title: 'Datos y privacidad',
            subtitle: 'Respaldo, restauración y eliminación',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DataPrivacyScreen()),
                ),
          ),

          // Terapias
          _buildSettingItem(
            context,
            icon: Icons.healing_outlined,
            title: 'Ejercicios y Terapias',
            subtitle: 'Configuración de rutinas',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TherapySettingsScreen()),
                ),
          ),

          // Accesibilidad
          _buildSettingItem(
            context,
            icon: Icons.accessibility_new_outlined,
            title: 'Accesibilidad',
            subtitle: 'Opciones de visualización y uso',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccessibilitySettingsScreen(),
                  ),
                ),
          ),

          const Divider(),

          // Encabezado de soporte
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Text(
              'AYUDA Y SOPORTE',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Ayuda y soporte
          _buildSettingItem(
            context,
            icon: Icons.help_outline,
            title: 'Ayuda',
            subtitle: 'FAQ, soporte, acerca de',
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HelpSupportScreen()),
                ),
          ),

          // Acerca de (acceso directo)
          _buildSettingItem(
            context,
            icon: Icons.info_outline,
            title: 'Acerca de',
            subtitle: 'Versión, licencias',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'App Rehabilitación',
                applicationVersion: '1.0.0',
                applicationIcon: Icon(Icons.healing, size: 48),
                children: [
                  Text(
                    'Una aplicación para apoyar en el proceso de rehabilitación.',
                  ),
                  SizedBox(height: 16),
                  Text('© 2025 - Todos los derechos reservados'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
