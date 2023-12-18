String obscureEmail(String email) {
  if (email.isEmpty) {
    return email;
  }

  // Split the email address into local and domain parts
  List<String> parts = email.split('@');
  if (parts.length == 2) {
    String localPart = parts[0];
    String domainPart = parts[1];

    // Obfuscate the local part with asterisks
    int obscuredLength =
        localPart.length - 2; // Number of characters to obscure
    String obscuredLocalPart = localPart.substring(0, 2) +
        '*' * obscuredLength +
        localPart.substring(2 + obscuredLength);

    // Recreate the obscured email address
    return obscuredLocalPart + '@' + domainPart;
  }

  return email; // If the email format is unexpected, return the original email.
}
