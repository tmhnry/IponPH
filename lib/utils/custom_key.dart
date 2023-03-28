import 'dart:math';
import './custom_functions.dart';

class _CustomKeyConstants {
  static const String chars = '0123456789ABCDEF';
  static const int standardLength = 12;
}

class CustomKey {
  final int length;
  final String key;
  DateTime date;

  CustomKey()
      : this.length = _CustomKeyConstants.standardLength,
        this.key = cFuncGenerateString(
          n: _CustomKeyConstants.standardLength,
          g: cFuncSubstring,
        ),
        this.date = DateTime.now();
  CustomKey.create({required String key, required DateTime date})
      : this.length = key.replaceAll(RegExp(r'-'), '').length,
        this.key = key,
        this.date = date;
  CustomKey.custom(
    int length,
    String function({
      required String s,
      int? n,
    }),
  )   : this.length = length,
        this.date = DateTime.now(),
        this.key = cFuncGenerateString(
          n: length,
          g: function,
        );

  DateTime setDate(DateTime date) => this.date = date;
}

class CustomKeyMethods {
  static get standardLength => _CustomKeyConstants.standardLength;

  static String generateChar() {
    Random _generator = Random.secure();
    return _CustomKeyConstants.chars[_generator.nextInt(
      _CustomKeyConstants.chars.length,
    )];
  }

  static CustomKey filter(List<String> keyStrings) {
    CustomKey customKey = CustomKey();
    while (keyStrings.contains(customKey.key)) {
      customKey = CustomKey();
    }
    return customKey;
  }

  static CustomKey filterSixteen(List<String> keyStrings) {
    const int l16 = 16;
    CustomKey customKey = CustomKey.custom(
      l16,
      cFuncSubstringSixteen,
    );
    while (keyStrings.contains(customKey.key)) {
      customKey = CustomKey.custom(
        l16,
        cFuncSubstringSixteen,
      );
    }
    return customKey;
  }

  static CustomKey filterEight(List<String> keyStrings) {
    const int l8 = 8;
    CustomKey customKey = CustomKey.custom(
      l8,
      cFuncSubstringEight,
    );
    while (keyStrings.contains(customKey.key)) {
      customKey = CustomKey.custom(
        l8,
        cFuncSubstringEight,
      );
    }
    return customKey;
  }

  static CustomKey filterFour(List<String> keyStrings) {
    const int l4 = 4;
    CustomKey customKey = CustomKey.custom(
      l4,
      ({
        required String s,
        int? n,
      }) =>
          s,
    );
    while (keyStrings.contains(customKey.key)) {
      customKey = CustomKey.custom(
        l4,
        ({
          required String s,
          int? n,
        }) =>
            s,
      );
    }
    return customKey;
  }
}
