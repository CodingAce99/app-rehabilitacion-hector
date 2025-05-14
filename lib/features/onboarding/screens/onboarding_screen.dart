import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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
  ];

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
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _buildTextPage(
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
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: _currentPage == _paginas.length - 1 ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF7D9C4),
                          foregroundColor: const Color.fromARGB(
                            255,
                            135,
                            93,
                            82,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 40.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed:
                            _currentPage == _paginas.length - 1
                                ? () async {
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool(
                                    'onboarding_completed',
                                    true,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DashboardScreen(),
                                    ),
                                  );
                                }
                                : null,
                        child: const Text(
                          "Comenzar",
                          style: TextStyle(fontSize: 18.0),
                        ),
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
    required String imagenPath,
    required String subtitulo,
    required String descripcion,
    Key? key,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagenPath,
            height: MediaQuery.of(context).size.height * 0.30,
          ),
          const SizedBox(height: 10.0),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 206, 139, 139),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: 16.0,
              color: Color.fromARGB(255, 198, 133, 133),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            descripcion,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
              color: Color.fromARGB(221, 84, 153, 156),
            ),
          ),
        ],
      ),
    );
  }
}
