class Validators {
  static String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingrese un correo electrónico';
    }
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }
}
