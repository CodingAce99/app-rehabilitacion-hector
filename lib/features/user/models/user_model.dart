// ========== User Model =========

class UserModel {
  final String nombre;
  final String? genero;
  final DateTime? fechaNacimiento;

  // Constructor de la clase
  UserModel({required this.nombre, this.genero, this.fechaNacimiento});

  // Método que convierte esta instancia a un Map (estructura clave-valor)
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'genero': genero,
      'fechaNacimiento': fechaNacimiento?.toIso8601String(),
    };
  }

  // Método que crea una instancia de UserModel desde un Map (estructura clave-valor)
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
