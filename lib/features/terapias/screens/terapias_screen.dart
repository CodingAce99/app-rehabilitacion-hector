import 'package:flutter/material.dart';
import 'detalle_terapia_screen.dart';
import '../models/terapia.dart';
import 'package:provider/provider.dart';
import '../providers/fichas_provider.dart'; // Ensure this path is correct

// Pantalla que muestra una lista de terapias disponibles

class TerapiasScreen extends StatefulWidget {
  // Constructor de la clase TerapiasScreen
  const TerapiasScreen({super.key});

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
      descripcionCorta: 'Ejercicios para la recuperación física',
      descripcionLarga:
          "La fisioterapia es una disciplina de la salud que se enfoca en prevenir, tratar y rehabilitar lesiones o disfunciones del movimiento y del sistema musculoesquelético mediante técnicas físicas como el ejercicio terapéutico, masajes, estiramientos, electroterapia y otras intervenciones no farmacológicas. Su objetivo principal es mejorar la calidad de vida del paciente, aliviar el dolor, recuperar la movilidad y funcionalidad del cuerpo, y promover la autonomía e independencia en las actividades diarias.",
      assetImage: 'assets/images/icons/fisioterapia_icon_2.0.png',
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
      descripcionCorta: 'Mejora la comunicación y el lenguaje',
      descripcionLarga:
          "La logopedia es la disciplina encargada de la prevención, evaluación, diagnóstico y tratamiento de los trastornos de la comunicación, el lenguaje, el habla, la voz, la audición y la deglución. Los logopedas trabajan con personas de todas las edades, desde bebés hasta adultos mayores, ayudando a desarrollar o recuperar habilidades comunicativas y funciones orales esenciales para la vida diaria, la interacción social y el aprendizaje. Su intervención es clave en casos como retraso del lenguaje, dislexia, tartamudez, afasia, trastornos de la voz o dificultades para tragar.",
      assetImage: 'assets/images/icons/logopedia_icon_2.0.png',
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
      descripcionCorta: 'Ayuda a corregir lesiones',
      descripcionLarga:
          "La ortopedia es una especialidad médica dedicada al estudio, diagnóstico, prevención y tratamiento de las alteraciones del sistema musculoesquelético, que incluye huesos, articulaciones, músculos, ligamentos y tendones. Su objetivo es corregir o aliviar problemas que afectan la movilidad y funcionalidad del cuerpo, ya sea por malformaciones congénitas, lesiones traumáticas, enfermedades degenerativas o alteraciones del crecimiento. Los tratamientos pueden ser conservadores, como el uso de ortesis, rehabilitación y medicamentos, o quirúrgicos, como la corrección de deformidades o la sustitución de articulaciones.",
      assetImage: 'assets/images/icons/ortopedia_icon_2.0.png',
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
      descripcionCorta: 'Apoyo emocional y mental',
      descripcionLarga:
          "La psicología es la ciencia que estudia el comportamiento humano y los procesos mentales, como las emociones, la percepción, el pensamiento, el aprendizaje y la memoria. Su objetivo es comprender cómo las personas piensan, sienten y actúan, tanto a nivel individual como en sus relaciones con los demás. A través de la evaluación, el diagnóstico y la intervención terapéutica, los psicólogos ayudan a las personas a enfrentar dificultades emocionales, trastornos mentales, conflictos personales y situaciones de estrés, promoviendo el bienestar psicológico, la salud mental y el desarrollo personal.",
      assetImage: 'assets/images/icons/psicologia_icon_2.1.png',
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
      descripcionCorta: 'Mejora la calidad de vida',
      descripcionLarga:
          "La terapia ocupacional es una disciplina sociosanitaria que se centra en promover la autonomía y la participación de las personas en sus actividades cotidianas, especialmente cuando estas se ven limitadas por una discapacidad física, mental, sensorial o social. Mediante el uso terapéutico de ocupaciones significativas —como el autocuidado, el trabajo, el ocio y la interacción social—, los terapeutas ocupacionales ayudan a recuperar, mantener o desarrollar habilidades funcionales que mejoren la calidad de vida y la inclusión de la persona en su entorno.",
      assetImage: 'assets/images/icons/terapia_ocupacional_icon_2.0.png',
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
      appBar: AppBar(
        title: Text(
          'Terapias',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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

  // Método para construir la tarjeta de cada terapia.
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
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      terapia.descripcionCorta,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 20),
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
