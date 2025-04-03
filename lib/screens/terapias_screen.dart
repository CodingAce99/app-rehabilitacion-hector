import 'package:flutter/material.dart';
import '../models/terapia.dart';
import 'detalle_terapia_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TerapiasScreen extends StatelessWidget {
  final List<Terapia> terapias = [
    Terapia(
      nombre: 'Fisioterapia',
      descripcionBreve: 'Ejercicios y masajes para la recuperación física',
      descripcionDetallada:
          'La fisioterapia es una disciplina de la salud que ofrece una alternativa terapéutica no farmacológica...',
      imagePath: 'assets/images/fisioterapia.svg',
    ),
    Terapia(
      nombre: 'Logopedia',
      descripcionBreve:
          'Ejercicios para la recuperación del habla y la comunicación',
      descripcionDetallada:
          'La logopedia es una disciplina que se encarga de la prevención, evaluación, diagnóstico y tratamiento de los trastornos de la comunicación...',
      imagePath: 'assets/images/logopedia.jpg',
    ),
    Terapia(
      nombre: 'Productos Ortopedia',
      descripcionBreve: 'Productos para la movilidad y la vida diaria',
      descripcionDetallada:
          'La ortopedia es una especialidad médica que se dedica a corregir o evitar las deformidades o traumas del sistema musculoesquelético...',
      imagePath: 'assets/images/ortopedia.jpg',
    ),
    Terapia(
      nombre: 'Psicología',
      descripcionBreve: 'Apoyo emocional y terapia psicológica',
      descripcionDetallada:
          'La psicología es la ciencia que estudia los procesos mentales, las sensaciones, las percepciones y el comportamiento del ser humano...',
      imagePath: 'assets/images/psicologia.jpg',
    ),
    Terapia(
      nombre: 'Terapia Ocupacional',
      descripcionBreve: 'Actividades para la vida diaria y la autonomía',
      descripcionDetallada:
          'La terapia ocupacional es una disciplina socio-sanitaria que se encarga de la rehabilitación y reinserción de personas con discapacidades físicas, mentales, sensoriales o sociales...',
      imagePath: 'assets/images/terapia_ocupacional.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terapias')),
      body: ListView.builder(
        itemCount: terapias.length,
        itemBuilder: (context, index) {
          final terapia = terapias[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleTerapiaScreen(terapia: terapia),
                ),
              );
            },
            borderRadius: BorderRadius.circular(15),
            child: Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    // SVG a la izquierda
                    SvgPicture.asset(terapia.imagePath, width: 60, height: 60),
                    SizedBox(width: 16),
                    // Info textual a la derecha
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            terapia.nombre,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            terapia.descripcionBreve,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
