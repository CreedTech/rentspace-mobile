  String formatPhoneNumber(String phoneNumber) {
      if (phoneNumber.startsWith('+234')) {
        if (phoneNumber.length > 4 && phoneNumber[4] == '0') {
          return '+234${phoneNumber.substring(5)}';
        }
      }
      return phoneNumber;
    }
