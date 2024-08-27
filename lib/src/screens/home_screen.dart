import 'package:flutter/material.dart';
import 'package:control_prestamos/src/database/database_helper.dart';
import 'package:control_prestamos/src/models/cliente.dart';
import 'package:control_prestamos/src/widgets/cliente_card.dart';

class HomeScreen extends StatelessWidget {
  final DatabaseHelper dbHelper = DatabaseHelper();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: FutureBuilder<List<Cliente>>(
        future: dbHelper.getClientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final clientes = snapshot.data!;
            return ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                return ClienteCard(cliente: clientes[index]);
              },
            );
          } else {
            return const Center(child: Text('No hay clientes registrados.'));
          }
        },
      ),
    );
  }
}
