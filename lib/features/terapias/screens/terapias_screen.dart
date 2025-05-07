import 'package:flutter/material.dart';
import 'detalle_terapia_screen.dart';
import '../models/terapia.dart';
import 'package:provider/provider.dart';
import '../providers/fichas_provider.dart'; // Ensure this path is correct

class TerapiasScreen extends StatefulWidget {
  // Constructor de la clase TerapiasScreen
  TerapiasScreen({Key? key}) : super(key: key);

  @override
  // Método para crear el estado de la pantalla
  State<TerapiasScreen> createState() => _TerapiasScreenState();
}

// Esta clase representa la pantalla de Terapias
class _TerapiasScreenState extends State<TerapiasScreen>
        // Implementamos TickerProviderStateMixin para las animaciones.
        with
        TickerProviderStateMixin {
  final List<Terapia> _terapias = [
    Terapia(
      titulo: 'Fisioterapia',
      descripcion: 'Ejercicios para la recuperación física',
      assetImage: 'assets/images/fisioterapia_icon.png',
      objetivos: [
        'Mejorar la movilidad',
        'Aliviar el dolor',
        'Rehabilitar lesiones',
      ],
      beneficios: [
        'Aumenta la fuerza muscular',
        'Mejora la flexibilidad',
        'Previene lesiones futuras',
      ],
    ),
    Terapia(
      titulo: 'Logopedia',
      descripcion: 'Mejora la comunicación y el lenguaje',
      assetImage: 'assets/images/logopedia_icon.png',
      objetivos: [
        'Desarrollar habilidades de habla',
        'Mejorar la comprensión del lenguaje',
        'Aumentar la confianza al comunicarse',
      ],
      beneficios: [
        'Facilita la interacción social',
        'Aumenta la autoestima',
        'Mejora la calidad de vida',
      ],
    ),
    Terapia(
      titulo: 'Ortopedia',
      descripcion: 'Ayuda a corregir lesiones',
      assetImage: 'assets/images/ortopedia_icon.png',
      objetivos: [
        'Corregir deformidades',
        'Aliviar el dolor',
        'Mejorar la función física',
      ],
      beneficios: [
        'Aumenta la movilidad',
        'Previene complicaciones',
        'Mejora la calidad de vida',
      ],
    ),
    Terapia(
      titulo: 'Psicología',
      descripcion: 'Apoyo emocional y mental',
      assetImage: 'assets/images/psicologia_icon.png',
      objetivos: [
        'Mejorar la salud mental',
        'Desarrollar habilidades de afrontamiento',
        'Aumentar la autoestima',
      ],
      beneficios: [
        'Reduce la ansiedad y el estrés',
        'Mejora las relaciones interpersonales',
        'Aumenta la calidad de vida',
      ],
    ),
    Terapia(
      titulo: 'Terapia Ocupacional',
      descripcion: 'Mejora la calidad de vida',
      assetImage: 'assets/images/terapia_ocupacional_icon.png',
      objetivos: [
        'Desarrollar habilidades para la vida diaria',
        'Mejorar la independencia',
        'Aumentar la participación en actividades significativas',
      ],
      beneficios: [
        'Aumenta la autoestima',
        'Mejora la calidad de vida',
        'Facilita la reintegración social',
      ],
    ),
    // Agregar más terapias según sea necesario.
  ];

  // ANIMACIONES...

  // Declaración de variables para las animaciones.
  final List<AnimationController> _controllers = [];
  final List<Animation<Offset>> _animations = [];

  // Método para inicializar las animaciones.
  @override
  void initState() {
    super.initState();
    // Carga las fichas de rehabilitación desde el provider.
    Provider.of<FichasProvider>(context, listen: false).cargarFichasDesdeJson();

    // Recorre la lista de terapias y crea animaciones para cada una.
    for (int i = 0; i < _terapias.length; i++) {
      // Inicializamos el controlador de animación.
      final controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      );

      // Definimos la animación de desplazamiento desde la izquierda.
      final animation = Tween<Offset>(
        begin: Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      // Guardamos el controlador y la animación en listas.
      _controllers.add(controller);
      _animations.add(animation);
    }

    // Retrasamos el comienzo de las animaciones para que no choquen.
    Future.delayed(Duration(milliseconds: 400), () {
      for (int i = 0; i < _controllers.length; i++) {
        // Cada animación espera 100ms más que la anterior.
        Future.delayed(Duration(milliseconds: 100 * i), () {
          // mounted es una comprobación para asegurarnos de que el widget aún esté en el árbol de widgets.
          // (Evita errores si el usuario sale rápido de la pantalla).
          if (mounted) _controllers[i].forward();
        });
      }
    });
  }

  // Método para liberar los recursos de las animaciones. (Obligatorio para evitar fugas de memoria).
  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terapias', style: TextStyle(fontSize: 22))),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _terapias.length,
        itemBuilder: (context, index) {
          return SlideTransition(
            position: _animations[index],
            child: _buildTerapiaCard(context, _terapias[index]),
          );
        },
      ),
    );
  }

  Widget _buildTerapiaCard(BuildContext context, Terapia terapia) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetalleTerapiaScreen(terapia: terapia),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                terapia.assetImage,
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      terapia.titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      terapia.descripcion,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
