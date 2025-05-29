import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:app_rehab/features/dashboard/screens/dashboard_screen.dart';
import 'package:app_rehab/features/user/providers/user_provider.dart';
import 'package:app_rehab/features/user/models/user_model.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
        // Implementamos SingleTickerProviderStateMixin (reloj interno) para controlar las animacion.
        with
        SingleTickerProviderStateMixin {
  // PageController se utiliza para controlar la página actual del PageView.
  // Inicialmente, se establece en 0
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  // Este controlador se utiliza para manejar el texto ingresado por el usuario.
  final TextEditingController _nombreController = TextEditingController();

  // Declaración de variables para la animación
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Método para inicializar cualquier configuración necesaria. (animaciones, etc.)

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _animationController.forward(); // Inicia la animación
  }

  // Método para liberar recursos.
  @override
  void dispose() {
    _nombreController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Define las páginas como una lista
  final List<Map<String, String>> _paginas = [
    {
      'imagenPath': "assets/images/onboarding/onboarding_ilustration1.png",
      'titulo': 'Bienvenido a la aplicación de Rehabilitación',
      'subtitulo': 'Tu espacio seguro para el bienestar emocional',
      'descripcion':
          'Descubre herramientas y recursos para cuidar tu salud mental.',
    },
    {
      'imagenPath': "assets/images/onboarding/onboarding_ilustration2.2.png",
      'titulo': 'Descubre Herramientas Poderosas',
      'subtitulo': 'Diario emocional, ejercicios de respiración y más.',
      'descripcion':
          'Explora nuestras funciones diseñadas para ayudarte a gestionar tus emociones.',
    },
    {
      'imagenPath': "assets/images/onboarding/onboarding_ilustration3.1.png",
      'titulo': 'Tu Bienestar, Tu Control',
      'subtitulo': 'Personaliza tu experiencia y protege tu privacidad.',
      'descripcion':
          'Ajusta la app a tus necesidades y ten la tranquilidad de que tus datos están seguros.',
    },
    {
      'imagenPath': "assets/images/onboarding/onboarding_ilustration3.3.png",
      'titulo': 'Comparte tu evolución con tu equipo terapéutico',
      'subtitulo': 'Conecta tu progreso con tus profesionales de confianza',
      'descripcion':
          'Accede a un seguimiento más personalizado compartiendo tus avances con fisioterapeutas, psicólogos o cuidadores.',
    },
    {
      'tipo': 'formulario',
      'titulo': 'Personaliza tu experiencia',
      'subtitulo': 'Cuéntanos un poco sobre ti',
      'imagenPath': "assets/images/onboarding/onboarding_ilustration3.3.png",
    },
  ];

  // Define la paleta de colores coherente
  final ColorScheme _colorScheme = const ColorScheme(
    primary: Color(0xFFC39397), // Rosa suave para elementos primarios
    onPrimary: Colors.white, // Texto sobre el color primario
    secondary: Color(0xFF54999C), // Azul-verde para acentos
    onSecondary: Colors.white, // Texto sobre el color secundario
    surface: Color(0xFFFAF7F4), // Fondo de tarjetas
    background: Color(0xFFFFFFFF), // Fondo general
    error: Color(0xFFB00020), // Color para errores
    onError: Colors.white, // Texto sobre errores
    onSurface: Color(0xFF875D52), // Texto sobre superficies
    onBackground: Color(0xFF54999C), // Texto sobre el fondo
    brightness: Brightness.light, // Tema claro
  );

  // Este método construye la interfaz de usuario del onboarding.
  @override
  Widget build(BuildContext context) {
    // ... (codigo del build) ...
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Imagen fija de fondo
            Image.asset(
              "assets/images/onboarding/onboarding_theme.png",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),

            // Capa de color para legibilidad
            Container(color: Colors.white.withOpacity(0.30)),

            // Contenido con transición animada entre páginas
            PageView.builder(
              controller: _pageController,
              itemCount: _paginas.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) {
                    // Animación compuesta: fade + slide
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(_currentPage < index ? 0.2 : -0.2, 0.0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                        child: child,
                      ),
                    );
                  },
                  child:
                      _paginas[index]['tipo'] == 'formulario'
                          ? _buildFormPage(
                            key: ValueKey<int>(index),
                            imagenPath: _paginas[index]['imagenPath']!,
                            titulo: _paginas[index]['titulo']!,
                            subtitulo: _paginas[index]['subtitulo']!,
                          )
                          : _buildTextPage(
                            key: ValueKey<int>(index),
                            imagenPath: _paginas[index]['imagenPath']!,
                            titulo: _paginas[index]['titulo']!,
                            subtitulo: _paginas[index]['subtitulo']!,
                            descripcion: _paginas[index]['descripcion']!,
                          ),
                );
              },
            ),

            // Indicador y boton de "Empezar" en la ultima página
            Positioned(
              bottom: 80.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  // Indicador de página
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 4,
                    effect: const WormEffect(
                      dotColor: Color(0xFFEADDD2),
                      activeDotColor: Color.fromARGB(255, 195, 147, 151),
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                    onDotClicked: (index) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Botón "Empezar".
                  // Reservamos un espacio para el botón en la última página.
                  const SizedBox(height: 20),
                  // Botón dinámico (Continuar/Comenzar)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _colorScheme.primary,
                        foregroundColor: _colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 40.0,
                        ),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage < _paginas.length - 1) {
                          // Si no estamos en la última página, avanzar
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          // Si estamos en la última página, finalizamos el onboarding
                          _animationController.reverse().then((value) {
                            _animacionSalida(context);
                          });
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _currentPage < _paginas.length - 1
                                ? "Continuar"
                                : "Comenzar",
                            style: GoogleFonts.montserrat(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Botón atrás (visible excepto en la primera página)
            Positioned(
              bottom: 80.0,
              left: 24.0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _currentPage > 0 ? 1.0 : 0.0,
                child: TextButton(
                  onPressed:
                      _currentPage > 0
                          ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                          : null,
                  child: Text(
                    'Atrás',
                    style: TextStyle(
                      color: _colorScheme.secondary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =========================
  /// MÉTODOS PRIVADOS
  /// =========================

  // Construye una página individual del onboarding.
  Widget _buildTextPage({
    required String titulo,
    required String imagenPath,
    required String subtitulo,
    required String descripcion,
    Key? key,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen con efecto de sombra suave
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagenPath,
                height: MediaQuery.of(context).size.height * 0.32,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 24.0),

          Text(
            titulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: _colorScheme.primary,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 16.0),

          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: _colorScheme.primary.withOpacity(0.85),
              height: 1.3,
            ),
          ),

          const SizedBox(height: 16.0),

          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              color: _colorScheme.secondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // Añadir este método a _OnboardingScreenState

  Widget _buildFormPage({
    required String titulo,
    required String subtitulo,
    required String imagenPath,
    Key? key,
  }) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen con efecto de sombra suave (igual que en _buildTextPage)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagenPath,
                height: MediaQuery.of(context).size.height * 0.25,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(height: 20.0),

          Text(
            titulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: _colorScheme.primary,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 12.0),

          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: _colorScheme.primary.withOpacity(0.85),
              height: 1.3,
            ),
          ),

          const SizedBox(height: 24.0),

          // Campo para el nombre
          TextField(
            controller: _nombreController,
            decoration: InputDecoration(
              labelText: '¿Cómo te llamas?',
              hintText: 'Escribe tu nombre',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _colorScheme.primary),
              ),
              prefixIcon: Icon(
                Icons.person_outline,
                color: _colorScheme.primary,
              ),
              floatingLabelStyle: TextStyle(color: _colorScheme.primary),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: _colorScheme.primary, width: 2),
              ),
            ),
            textCapitalization: TextCapitalization.words,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              color: _colorScheme.secondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 16.0),

          // Texto explicativo opcional
          Text(
            'Usaremos tu nombre para personalizar tu experiencia en la aplicación.',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 14.0,
              fontStyle: FontStyle.italic,
              color: _colorScheme.secondary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  // Animación de salida al completar el onboarding.
  Future<void> _animacionSalida(BuildContext context) async {
    final nombre = _nombreController.text.trim();

    // Guardar datos del usuario
    if (nombre.isNotEmpty) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.saveUser(UserModel(nombre: nombre));
    }

    // Guardar que el onboarding se completó
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    // Transición suave a la siguiente pantalla
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) {
          return FadeTransition(opacity: animation, child: DashboardScreen());
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
