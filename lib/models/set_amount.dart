import '../consts/app_strings.dart';

class SetAmountParams {
  final String amount;
  final String cashbackAmount;
  final String currencyCode;
  final String transactionType;

  SetAmountParams({
    required this.amount,
    this.cashbackAmount = "",
    this.currencyCode = currency, // Fixed value
    this.transactionType = transType, // Fixed value
  });

  Map<String, String> toJson() {
    return {
      'amount': amount,
      'cashbackAmount': cashbackAmount,
      'currencyCode': currencyCode,
      'transactionType': transactionType,
    };
  }
}
