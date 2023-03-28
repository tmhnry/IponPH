import 'package:flutter/painting.dart';

enum Location { Beginning, Only, End }
enum Gender { Male, Female }
enum Discount { Coupon, Item }
enum Frequency { Daily, Weekly, Monthly, AllTime }

class CustomColors {
  static const Color darkBlueGradient = Color.fromRGBO(6, 57, 84, 1);
  static const Color lightBlueGradient = Color.fromRGBO(5, 111, 146, 1);
  static const Color orangeForText = Color.fromRGBO(255, 165, 0, 1);
  static const Color whiteForText = Color.fromRGBO(255, 255, 255, 1);
  static const Color whiteForLabelText = Color.fromRGBO(255, 255, 255, 1);
  static const Color charcoal = Color.fromRGBO(38, 70, 83, 1);
  static const Color orangeYellowCrayola = Color.fromRGBO(233, 196, 106, 1);
}

class CustomTextStyle {
  static const TextStyle labelStyle = TextStyle(
    color: CustomColors.whiteForLabelText,
  );
  static const TextStyle inputPrefixStyle = TextStyle(
    color: CustomColors.orangeForText,
  );
  static const TextStyle inputStyle = TextStyle(
    color: CustomColors.whiteForText,
  );
}
