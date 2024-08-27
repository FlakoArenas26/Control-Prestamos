import 'package:control_prestamos/src/screens/cliente_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:control_prestamos/src/models/cliente.dart';

class ClienteCard extends StatelessWidget {
  final Cliente cliente;

  const ClienteCard({super.key, required this.cliente});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(cliente.nombre),
        subtitle: Text('Deuda: \$${cliente.deuda}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClienteDetailScreen(cliente: cliente),
            ),
          );
        },
      ),
    );
  }
}
