import 'package:flutter/widgets.dart' show TextStyle, FontWeight;

class CredioFonts {
  ///
  /// FONT-FAMILY POPPINS
  ///
  static const poppins = "Poppins";
}

class CredioTextStyle {
  static const TextStyle light = TextStyle(
    fontFamily: CredioFonts.poppins,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle regular = TextStyle(
    fontFamily: CredioFonts.poppins,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontFamily: CredioFonts.poppins,
  );

  static const TextStyle semiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: CredioFonts.poppins,
  );

  static const TextStyle bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: CredioFonts.poppins,
  );

  static const TextStyle black = TextStyle(
    fontWeight: FontWeight.w900,
    fontFamily: CredioFonts.poppins,
  );
}
