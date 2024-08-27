// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:control_prestamos/src/models/cliente.dart';
import 'package:control_prestamos/src/models/pago.dart';
import 'package:control_prestamos/src/database/database_helper.dart';
import 'package:control_prestamos/src/widgets/payment_form.dart';

class ClienteDetailScreen extends StatefulWidget {
  final Cliente cliente;

  const ClienteDetailScreen({super.key, required this.cliente});

  @override
  _ClienteDetailScreenState createState() => _ClienteDetailScreenState();
}

class _ClienteDetailScreenState extends State<ClienteDetailScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  late Future<List<Pago>> pagos;

  @override
  void initState() {
    super.initState();
    pagos = dbHelper.getPagosByCliente(widget.cliente.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de ${widget.cliente.nombre}'),
      ),
      body: Column(
        children: [
          Text('Deuda: \$${widget.cliente.deuda}'),
          Expanded(
            child: FutureBuilder<List<Pago>>(
              future: pagos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final pagos = snapshot.data!;
                  return ListView.builder(
                    itemCount: pagos.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('Pago: \$${pagos[index].valor}'),
                        subtitle: Text('Fecha: ${pagos[index].fechaPago}'),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No hay pagos registrados.'));
                }
              },
            ),
          ),
          PaymentForm(clienteId: widget.cliente.id),
        ],
      ),
    );
  }
}
