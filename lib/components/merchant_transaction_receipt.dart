import 'package:credio_reader/components/dimensions.dart';
import 'package:credio_reader/components/receipts_clipper.dart';
import 'package:credio_reader/components/typography/text_styles.dart';
import 'package:credio_reader/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screenshot/screenshot.dart';

import '../consts/app_strings.dart';

class MerchantTransactionReceipt extends StatefulWidget {
  // final Transaction receipt;
  // final Profile profile;
  final String? maskedPan;
  final String? cardType;
  final String? creditAccountName;
  final String? creditAccountNumber;
  final String? paymentReference;
  final String? responseCode;
  final String? narration;
  final String? terminalId;
  final String? rrn;
  final String? authCode;
  final String? stan;
  final num? amount;
  final String? transactionTime;

  const MerchantTransactionReceipt({
    Key? key,
    // required thiseceipt,
    // required this.profile,
    this.maskedPan,
    this.cardType,
    this.creditAccountName,
    this.creditAccountNumber,
    this.rrn,
    this.paymentReference,
    this.responseCode,
    this.narration,
    this.terminalId,
    this.authCode,
    this.stan,
    this.amount,
    this.transactionTime,
  }) : super(key: key);

  @override
  State<MerchantTransactionReceipt> createState() =>
      _MerchantTransactionReceiptState();
}

class _MerchantTransactionReceiptState
    extends State<MerchantTransactionReceipt> {
  late ScreenshotController controller;
  final ValueNotifier<bool> hideBtn = ValueNotifier(false);

  @override
  void initState() {
    controller = ScreenshotController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaler = CredioScaleUtil(context);
    return Scaffold(
        backgroundColor: const Color(0xFFF6F6F6),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Screenshot(
                controller: controller,
                child: ClipPath(
                  clipper: ReceiptClipper(),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 23,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        transactionStatusImage(),
                        SizedBox(
                          height: scaler.sizer.setHeight(1.5),
                        ),
                        Text(
                          'Credio.',
                          textAlign: TextAlign.center,
                          style: CredioTextStyle.bold.copyWith(
                            color: const Color(0xFFB11226),
                            fontSize: 26,
                          ),
                        ),
                        Text(
                          formatCurrency("${(widget.amount ?? 0) / 100}"),
                          textAlign: TextAlign.center,
                          style: CredioTextStyle.semiBold.copyWith(
                            color: const Color(0xFF333333),
                            fontSize: 29,
                          ),
                        ),
                        Text(
                          '${getSuccessful(widget.responseCode) ? 'Successful' : 'Unsuccessful'} transaction',
                          textAlign: TextAlign.center,
                          style: CredioTextStyle.medium.copyWith(
                            color: getSuccessful(widget.responseCode)
                                ? const Color(0xFF058B42)
                                : const Color(0xFFB11226),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          formatDate(
                            widget.transactionTime ?? '',
                            format: "HH:mm, MMM dd, y",
                          ),
                          textAlign: TextAlign.center,
                          style: CredioTextStyle.medium.copyWith(
                            color: const Color(0xFF333333).withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          height: scaler.sizer.setHeight(2),
                        ),
                        const TransactionSeparator(),
                        SizedBox(
                          height: scaler.sizer.setHeight(2),
                        ),
                        const TransactionSectionHeader("Card Holder"),
                        TransactionRow(
                            title: 'Masked Pan',
                            description: widget.maskedPan ?? ""),
                        TransactionRow(
                            title: 'Card Type',
                            description: widget.cardType ?? ""),
                        SizedBox(
                          height: scaler.sizer.setHeight(2),
                        ),
                        const TransactionSeparator(),
                        SizedBox(
                          height: scaler.sizer.setHeight(2),
                        ),
                        const TransactionSectionHeader("Recipient"),
                        const TransactionRow(
                            title: 'Account Number',
                            description: "0231973328" ?? ""),
                        const TransactionRow(
                            title: 'Merchant Name',
                            description: "Rasheed Abefe Raji" ?? ""),
                        TransactionRow(
                            title: 'Terminal Id',
                            description: widget.terminalId ?? ""),
                        SizedBox(
                          height: scaler.sizer.setHeight(2),
                        ),
                        const TransactionSeparator(),
                        SizedBox(
                          height: scaler.sizer.setHeight(2),
                        ),
                        const TransactionSectionHeader("Transaction Info"),
                        TransactionRow(
                            title: 'RRN', description: widget.rrn ?? ""),
                        TransactionRow(
                            title: 'Response Code',
                            description: widget.responseCode ?? ""),
                        TransactionRow(
                            title: 'Auth Code',
                            description: widget.authCode ?? ""),
                        TransactionRow(
                            title: 'Stan', description: widget.stan ?? ""),
                        TransactionRow(
                            title: 'Message',
                            description: widget.narration ?? ""),
                        SizedBox(
                          height: scaler.sizer.setHeight(2),
                        ),
                        const Divider(
                          color: Color(0xFFE8EAED),
                          thickness: 1.5,
                        ),
                        InkWell(
                          onTap: () async {
                            hideBtn.value = true;
                            // await formSubmitDialog(
                            //   context: context,
                            //   future: shareReceipt(
                            //     controller,
                            //     scaler.sizer.setHeight(0.8),
                            //     transaction: transaction.transaction!
                            //         .firstWhere((element) =>
                            //             element.to ==
                            //             data.message!.profile!.vaults!
                            //                 .phoneNumber),
                            //   ),
                            //   prompt:
                            //       "Please wait as we generate your receipt",
                            // );
                            hideBtn.value = false;
                          },
                          child: ValueListenableBuilder(
                            valueListenable: hideBtn,
                            builder: (context, bool hidden, child) {
                              if (hidden) return const Offstage();
                              return child!;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/share_receipt.svg'),
                                  SizedBox(width: scaler.sizer.setWidth(4)),
                                  Text(
                                    'Share',
                                    style: CredioTextStyle.medium.copyWith(
                                      color: const Color(0xFF3D3D3D),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: CredioScaleUtil(context).sizer.setHeight(2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: hideBtn,
                  builder: (context, bool hidden, child) {
                    if (hidden) return const Offstage();
                    return child!;
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffB11226),
                        fixedSize: const Size(double.infinity, 53.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              SizedBox(
                height: scaler.sizer.setHeight(5),
              )
            ],
          ),
        ));
  }

  Widget transactionStatusImage() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getSuccessful(widget.responseCode)
            ? const Color(0xFF23A26D).withOpacity(0.12)
            : const Color(0xFFB11226).withOpacity(0.12),
      ),
      child: SvgPicture.string(
        getSuccessful(widget.responseCode) ? tickCircle : failed,
      ),
    );
  }
}

class TransactionRow extends StatelessWidget {
  final String title;
  final String description;

  const TransactionRow({
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 24, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: CredioTextStyle.regular.copyWith(
                color: const Color(0xFF121212).withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            child: Text(
              description,
              overflow: TextOverflow.visible,
              style: CredioTextStyle.regular.copyWith(
                color: const Color(0xFF333333).withOpacity(0.6),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionSectionHeader extends StatelessWidget {
  final String title;

  const TransactionSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: CredioTextStyle.medium.copyWith(
              fontSize: 17,
              color: const Color(0xFF333333),
            ),
          ),
          SizedBox(
            height: CredioScaleUtil(context).sizer.setHeight(2),
          ),
        ],
      ),
    );
  }
}

class TransactionSeparator extends StatelessWidget {
  const TransactionSeparator({
    Key? key,
    this.height = 1.5,
  }) : super(key: key);
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 10.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(
            dashCount,
            (_) {
              return SizedBox(
                width: dashWidth,
                height: dashHeight,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFDCDEE0),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
