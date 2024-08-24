class ValidatorError {
  final String key;
  final String message;

  const ValidatorError({
    this.key = '',
    required this.message,
  });
}
