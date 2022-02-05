import 'dart:ui';
import 'dart:math' as math;

String capitalizeFirstLetterString(String word){
  return word.replaceFirst(word[0], word[0].toUpperCase());
}

Color parseColorFromDb(String color){
  return Color(int.parse(color.substring(6, 16)));
}

Color getRandomColor(){
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}