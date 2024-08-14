import 'dart:typed_data';

class Utils {
  static String hexes = "0123456789ABCDEF";

  static String? uInt8ListToHexStr(Uint8List list) {
    var hex = StringBuffer();

    for (int i = 0; i < list.length; i++) {
      hex.write(hexes[((list[i] & 0xF0) >> 4)]);
      hex.write(hexes[((list[i] & 0x0F))]);
    }
    return hex.toString();
  }

  static String? uIint16ListToHexStr(Uint16List list) {
    var hex = StringBuffer();
    for (int i = 0; i < list.length; i++) {
      hex.write(hexes[((list[i] & 0xF000) >> 12)]);
      hex.write(hexes[((list[i] & 0x0F00) >> 8)]);
      hex.write(hexes[((list[i] & 0x00F0) >> 4)]);
      hex.write(hexes[((list[i] & 0x000F))]);
    }
    return hex.toString();
  }

  static bool equals(String value, String other) {
    int n = other.length;
    if (n == value.length) {
      int i = 0;
      while (n-- != 0) {
        if (value.codeUnitAt(i) != other.codeUnitAt(i)) return false;
        i++;
      }
      return true;
    }
    return false;
  }
}
