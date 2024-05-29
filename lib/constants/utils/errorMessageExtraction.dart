String extractErrorMessage(Map<String, dynamic> response) {
  if (response.containsKey('message')) {
    return response['message'];
  } else if (response.containsKey('error')) {
    return response['error'];
  } else if (response.containsKey('errors')) {
    if (response['errors'] is List && response['errors'].isNotEmpty) {
      return response['errors'][0]['error'] ?? 'Something went wrong';
    }
  }
  return 'Something went wrong. Try Again Later.';
}