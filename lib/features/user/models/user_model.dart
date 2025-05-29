class UserModel {
  final String nombre;
  final String? genero;
  final DateTime? fechaNacimiento;

  UserModel({required this.nombre, this.genero, this.fechaNacimiento});

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'genero': genero,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      nombre: json['nombre'] ?? 'Usuario',
      genero: json['genero'],
      fechaNacimiento:
          json['fechaNacimiento'] != null
              ? DateTime.parse(json['fechaNacimiento'])
              : null,
    );
  }
}
