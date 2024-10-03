import 'package:credio_reader/state/reader_state.dart';
import 'package:credio_reader/utils/intl_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../components/app_selection_sheet.dart';
import '../consts/app_strings.dart';

class WithdrawalScreen extends StatefulWidget {
  final ReaderStateProvider readerState;

  const WithdrawalScreen({Key? key, required this.readerState})
      : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final list = [
  //   "Universal",
  //   "Savings",
  //   "Current",
  //   "Credit",
  // ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.readerState.configurations.amount != null) {
        _proceedToAccountSelection(widget.readerState);
      }
    });
  }

  void _proceedToAccountSelection(ReaderStateProvider readerState) {
    _showAccountTypeSelection(context, readerState);
  }

  void _showAccountTypeSelection(
      BuildContext context, ReaderStateProvider readerState) {
    final config = readerState.configurations;
    final accountTypes = [
      SelectionData(selection: 0, title: "Universal"),
      SelectionData(selection: 1, title: "Savings"),
      SelectionData(selection: 2, title: "Current"),
      SelectionData(selection: 3, title: "Credit"),
    ];

    if (config.customSelectionSheet != null) {
      config.customSelectionSheet!(
        context,
        accountTypes,
        (SelectionData selectedData) {
          readerState.accountType = selectedData.selection as int;
          readerState.startDoTrade();
        },
      );
    } else {
      showSelectionSheet(
        context,
        data: accountTypes,
        onSelect: (SelectionData s) {
          readerState.accountType = s.selection as int;
          readerState.startDoTrade();
        },
        title: "Select Account Type",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReaderStateProvider.instance(),
      builder: (ctx, child) {
        final readerState = ctx.read<ReaderStateProvider>();

        if (readerState.configurations.amount != null) {
          return Container(
            color: Colors.white,
          );
        }

        return Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const Spacer(),
                      const Text(
                        'Withdrawal',
                        style: TextStyle(fontSize: 24),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 35.0),
                  child: Text(
                    'How much do you want to withdraw',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: TextFormField(
                    autofocus: true,
                    controller: readerState.amountCredio,
                    cursorColor: const Color(0xFF656F78),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      AmountFormatter()
                    ],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: readerState
                            .configurations.amountInputDecoration ??
                        InputDecoration(
                          hintText: 'Amount',
                          hintStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF737373),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: SvgPicture.string(nairaSvg),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3.0)),
                            borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.4),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(3.0)),
                            borderSide: BorderSide(
                              color: const Color(0xFF333333).withOpacity(0.2),
                              width: 1.0,
                            ),
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffD11C1C),
                              width: 1,
                            ),
                          ),
                        ),
                  ),
                ),
                const SizedBox(height: 195),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 31.0),
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _showAccountTypeSelection(context, readerState);
                    },
                    style: readerState
                            .configurations.buttonConfiguration?.buttonStyle ??
                        ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffB11226),
                          fixedSize: const Size(double.infinity, 53.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
