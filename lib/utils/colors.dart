import 'dart:ui';

/// Returns Rainbow colors
List<Color> getRainbowColors(int bright, int dark, {int alpha = 255}) {
  return [
    Color.fromARGB(alpha, bright, dark, dark),
    Color.fromARGB(alpha, bright, (dark + (bright - dark) * 0.7).round(), dark),
    Color.fromARGB(alpha, dark, bright, dark),
    Color.fromARGB(alpha, dark, bright, bright),
    Color.fromARGB(alpha, dark, dark, bright),
    Color.fromARGB(alpha, bright, dark, bright),
  ];
}
