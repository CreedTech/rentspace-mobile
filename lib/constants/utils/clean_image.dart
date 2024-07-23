    // Function to clean up the image name
    String cleanImageName(String imageName) {
      final RegExp regExp = RegExp(r'image_picker_[\dA-F-]+-');
      return imageName.replaceAll(regExp, '');
    }