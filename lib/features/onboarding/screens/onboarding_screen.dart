import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app_rehab/screens/dashboard_screen.dart';

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

  // Declaración de variables para la animación
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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

  void dispose() {
    // Método para liberar recursos.
    _animationController.dispose();
    super.dispose();
  }

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
              "assets/images/onboarding_page1.png",
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),

            // Capa de color para legibilidad
            Container(color: Colors.white.withOpacity(0.30)),

            // Contenido desplazable
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                // Páginas del onboarding
                _buildTextPage(
                  titulo: "Bienvenido a la aplicación de Rehabilitación",
                  subtitulo: "Tu espacio seguro para el bienestar emocional",

                  descripcion:
                      "Descubre herramientas y recursos para cuidar tu salud mental.",
                ),
                _buildTextPage(
                  titulo: "Descubre Herramientas Poderosas",
                  subtitulo:
                      "Diario emocional, ejercicios de respiración y más.",

                  descripcion:
                      "Explora nuestras funciones diseñadas para ayudarte a gestionar tus emociones.",
                ),
                _buildTextPage(
                  titulo: "Tu Bienestar, Tu Control",
                  subtitulo:
                      "Personaliza tu experiencia y protege tu privacidad.",
                  descripcion:
                      "Ajusta la app a tus necesidades y ten la tranquilidad de que tus datos están seguros.",
                ),
                _buildTextPage(
                  titulo: "Comparte tu evolución con tu equipo terapéutico",
                  subtitulo:
                      "Conecta tu progreso con tus profesionales de confianza",
                  descripcion:
                      "Accede a un seguimiento más personalizado compartiendo tus avances con fisioterapeutas, psicólogos o cuidadores. La colaboración impulsa tu recuperación.",
                ),
              ],
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
                  // Botón "Empezar"
                  if (_currentPage ==
                      3) // Mostrar el botón solo en la última página
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF7D9C4),
                          foregroundColor: Color.fromARGB(255, 135, 93, 82),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 40.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: () async {
                          // Evita que el onboarding se muestre en cada inicio,
                          // guardando el estado en SharedPreferences
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('onboarding_completed', true);

                          // Navegar a la pantalla (ej. DashboardScreen)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      DashboardScreen(), // Cambia a tu pantalla principal
                            ),
                          );
                        },
                        child: const Text(
                          "Comenzar",
                          style: TextStyle(fontSize: 18.0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... (método _buildPage) ...
  // Este método construye una página individual del onboarding.
  Widget _buildTextPage({
    required String titulo,
    required String subtitulo,
    required String descripcion,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 206, 139, 139),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Text(
            subtitulo,
            style: const TextStyle(
              fontSize: 16.0,
              color: Color.fromARGB(255, 198, 133, 133),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Text(
            descripcion,
            style: const TextStyle(
              fontSize: 16.0,
              color: Color.fromARGB(221, 84, 153, 156),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
