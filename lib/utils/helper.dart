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
