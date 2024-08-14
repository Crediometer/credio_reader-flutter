import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

num? extractAmount(String? amount) {
  if (amount == null || amount.isEmpty) {
    return null;
  } else {
    final val = amount.startsWith("NGN")
        ? amount.substring(3)
        : amount.startsWith("N")
            ? amount.substring(0)
            : amount;
    final number = num.tryParse(val.replaceAll(RegExp(r'[^0-9\.]'), ""));

    if (number != null) {
      return number;
    } else {
      return number;
    }
  }
}

bool getSuccessful(result) {
  return (result == "00" || result == "10" || result == "11" || result == "16");
}

String getAmountTransaction(String amount) {
  int actual = (extractAmount(amount) ?? 0).toInt() * 100;
  int multiple = 12 - "$actual".length;
  String result = "${'0' * multiple}$actual";
  return result;
}

String formatDate(String date, {String? format}) {
  DateFormat formatter =
      format == null ? DateFormat("d-MM-yyyy") : DateFormat(format);
  if (date == null || date.isEmpty) {
    return formatter.format(DateTime.now());
  }
  var datetime = DateTime.tryParse(date);
  if (datetime == null) {
    return formatter.format(DateTime.now());
  }
  return formatter.format(
    datetime.add(
      Duration(
        hours: 1,
      ),
    ),
  );
}

String formatCurrency(
  String amount, {
  bool spaceIcon = true,
  bool ignoreSymbol = false,
  String symbol = '₦',
}) {
  final formatter = NumberFormat.currency(
    locale: "en_NG",
    name: ignoreSymbol ? '' : symbol, //?? '\$',
    symbol: ignoreSymbol ? "" : "$symbol${spaceIcon ? " " : ""}",
    decimalDigits: 2,
  );
  if (amount == null || amount.isEmpty || amount == "null") {
    return "$symbol-.--";
  }
  amount = amount.replaceAll(RegExp(r'[^0-9\.]'), "");
  final amountDouble = double.tryParse(amount);
  if (amount == null || amountDouble == null) {
    return amount;
  }
  if (amountDouble == 0) {
    return "${symbol}0.00";
  }
  return formatter.format(amountDouble);
}

String formatCurrencyInput(String amount) {
  final formatter = NumberFormat.currency(
    locale: "en_NG",
    name: '',
    symbol: "",
    decimalDigits: 0,
  );
  amount = amount.replaceAll(RegExp(r'[^0-9\.]'), "");
  final amountDouble = double.tryParse(amount);
  if (amount == null || amountDouble == null) {
    return "";
  }
  return formatter.format(amountDouble);
}

String parseError(
  dynamic errorResponse,
  String? defaultMessage, [
  bool ignore401 = false,
]) {
  print("xxxx: $errorResponse");
  try {
    final fallbackMessage = defaultMessage != null && defaultMessage.isNotEmpty
        ? defaultMessage
        : "My request failed due to an unexpected error, please try again";
    try {
      final int statusCode = errorResponse["statusCode"] ?? 400;
      final dynamic error = errorResponse["data"];

      print("error: $error");

      // if (statusCode == 503) {
      //   if (error is String) {
      //     final document = parse(error);
      //     final titleElement = document.querySelector("title");
      //     if (titleElement != null) {
      //       return titleElement.text;
      //     }
      //     return 'Sorry, My request could not be resolved at this time, please retry';
      //   }
      // }

      if (error is Map) {
        if (error["message"] != null &&
            error["message"] is String &&
            error["message"].isNotEmpty) {
          return error["message"];
        } else if (error.containsKey("errors") && error["errors"] != null) {
          return _parseErrorArray(error["errors"]) ??
              _fallBackMessage(statusCode, defaultMessage!);
        } else {
          return _fallBackMessage(statusCode, fallbackMessage);
        }
      }
      if (error is String) {
        return error != null && error.isNotEmpty
            ? _fallBackMessage(statusCode, error)
            : _fallBackMessage(statusCode, fallbackMessage);
      }
      return _fallBackMessage(statusCode, fallbackMessage);
    } catch (_) {
      return fallbackMessage;
    }
  } catch (_) {
    return defaultMessage ??
        "My request failed due to an unexpected error, please try again";
  }
}

String? _parseErrorArray(Map error) {
  try {
    final data = Map<String, List>.from(error);
    List errorMessages = [];
    data.keys.forEach((it) {
      errorMessages.addAll(data[it]!);
    });
    return errorMessages.join(", ");
  } catch (_) {
    return null;
  }
}

String _fallBackMessage(int statusCode, String defaultMessage) {
  if (statusCode == 405) {
    return "Sorry, you are not permitted to carry out this action at this time";
  } else if (statusCode == 404) {
    return "Sorry, the requested data could not be found at this time";
  } else if (statusCode == 503) {
    return "Sorry, My request could not be resolved at this time, please retry";
  } else if (statusCode == 401) {
    return "Unauthorized";
  } else if (statusCode >= 400 && statusCode < 500) {
    return "Sorry, My request could not be resolved at this time, please retry";
  } else if (statusCode >= 500 && statusCode < 600) {
    return "Sorry, My request could not be resolved at this time because of an unexpected error";
  } else {
    return defaultMessage;
  }
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

_parseAndDecode(String response) {
  return jsonDecode(response);
}
