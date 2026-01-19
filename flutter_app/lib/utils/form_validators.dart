class FormValidators {
  static String? requiredPositiveDouble(String? value, {required String fieldName}) {
    final raw = (value ?? '').trim().replaceAll(',', '.');
    if (raw.isEmpty) return '$fieldName is required.';

    final parsed = double.tryParse(raw);
    if (parsed == null) return '$fieldName must be a valid number.';
    if (parsed <= 0) return '$fieldName must be greater than zero.';

    return null;
  }

  static double parseDouble(String value) {
    return double.parse(value.trim().replaceAll(',', '.'));
  }
}
