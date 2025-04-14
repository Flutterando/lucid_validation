String extractClassName(String input) {
  final regex = RegExp(r"Instance of '(\w+)'");
  final match = regex.firstMatch(input);
  return match?.group(1) ?? '';
}
