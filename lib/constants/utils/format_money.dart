String formatMoney(double amount) {
  if (amount >= 1000000) {
    return '${(amount / 1000000).toStringAsFixed(0)}M';
  } else if (amount >= 1000) {
    // Check if the amount is an exact multiple of 1000
    if (amount % 1000 == 0) {
      return '${amount ~/ 1000}K'; // Remove decimal places
    } else {
      return '${(amount / 1000).toStringAsFixed(2)}K'; // Keep decimal places
    }
  } else {
    return amount.toStringAsFixed(2);
  }
}
