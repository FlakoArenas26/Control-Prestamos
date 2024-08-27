// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:control_prestamos/src/database/database_helper.dart';
import 'package:control_prestamos/src/models/pago.dart';

class PaymentForm extends StatefulWidget {
  final int clienteId;

  const PaymentForm({super.key, required this.clienteId});

  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _valorController = TextEditingController();

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor del Pago'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese el valor del pago';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final pago = Pago(
                    clienteId: widget.clienteId,
                    valor: double.parse(_valorController.text),
                    fechaPago: DateTime.now().toIso8601String(),
                  );

                  dbHelper.addPago(pago).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pago registrado')),
                    );
                    Navigator.pop(context);
                  });
                }
              },
              child: const Text('Registrar Pago'),
            ),
          ],
        ),
      ),
    );
  }
}
