import 'package:flutter/material.dart';
import 'package:control_prestamos/src/screens/login_screen.dart'; // Asegúrate de que esta ruta sea correcta

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Préstamos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 66, 104, 226)),
        useMaterial3: true,
      ),
      home:
          const LoginScreen(), // Establece LoginScreen como la pantalla principal
    );
  }
}
