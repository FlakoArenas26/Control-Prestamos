class Pago {
  final int id;
  final int clienteId;
  final double valor;
  final String fechaPago;

  Pago({
    this.id = 0, // Valor predeterminado para el ID
    required this.clienteId,
    required this.valor,
    required this.fechaPago,
  });

  factory Pago.fromMap(Map<String, dynamic> map) {
    return Pago(
      id: map['id'],
      clienteId: map['cliente_id'],
      valor: map['valor'],
      fechaPago: map['fecha_pago'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente_id': clienteId,
      'valor': valor,
      'fecha_pago': fechaPago,
    };
  }
}
