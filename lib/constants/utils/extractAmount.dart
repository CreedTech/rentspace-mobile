String extractAmount(String input) {
  final nairaIndex = input.indexOf('₦');
  if (nairaIndex != -1 && nairaIndex < input.length - 1) {
    return input.substring(nairaIndex + 1).trim();
  }
  return '';
}
