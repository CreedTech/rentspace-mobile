 String formatAsPercentage(double value) {
    int percentage = (value * 100).round();
    return '$percentage%';
  }