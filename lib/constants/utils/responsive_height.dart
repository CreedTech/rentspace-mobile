double? _sliderHeight;
double? _newscardHeight;
double sliderDynamicScreen(screenHeight) {
  if (screenHeight >= 550 && screenHeight < 600) {
    _sliderHeight = screenHeight / 3.2;
  } else if (screenHeight >= 600 && screenHeight < 650) {
    _sliderHeight = screenHeight / 3.4;
  } else if (screenHeight >= 650 && screenHeight < 700) {
    _sliderHeight = screenHeight / 3.6;
  } else if (screenHeight >= 700 && screenHeight < 750) {
    _sliderHeight = screenHeight / 3.8;
  } else if (screenHeight >= 750 && screenHeight < 800) {
    _sliderHeight = screenHeight / 4;
  } else if (screenHeight >= 800 && screenHeight < 850) {
    _sliderHeight = screenHeight / 4.2;
  } else if (screenHeight >= 850 && screenHeight < 900) {
    _sliderHeight = screenHeight / 4.4;
  } else if (screenHeight >= 900 && screenHeight < 950) {
    _sliderHeight = screenHeight / 4.8;
  } else {
    _sliderHeight = screenHeight / 5;
  }

  return _sliderHeight!;
}
