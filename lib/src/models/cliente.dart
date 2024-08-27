class Cliente {
  final int id;
  final String nombre;
  final double deuda;
  final String fechaRegistro;

  Cliente({
    required this.id,
    required this.nombre,
    required this.deuda,
    required this.fechaRegistro,
  });

  factory Cliente.fromMap(Map<String, dynamic> map) {
    return Cliente(
      id: map['id'],
      nombre: map['nombre'],
      deuda: map['deuda'],
      fechaRegistro: map['fecha_registro'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'deuda': deuda,
      'fecha_registro': fechaRegistro,
    };
  }
}
