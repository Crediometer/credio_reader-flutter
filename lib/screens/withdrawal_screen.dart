import 'package:credio_reader/state/reader_state.dart';
import 'package:credio_reader/utils/intl_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../components/app_selection_sheet.dart';

class WithdrawalScreen extends StatefulWidget {
  WithdrawalScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final list = [
    "Universal",
    "Savings",
    "Current",
    "Credit",
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReaderStateProvider.instance(),
      builder: (ctx, child) {
        final readerState = ctx.read<ReaderStateProvider>();
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
                    decoration: InputDecoration(
                      hintText: 'Amount',
                      hintStyle: const TextStyle(
                        fontSize: 12.0,
                        color: Color(0xFF737373),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: SvgPicture.asset(
                            'packages/credio_reader/images/naira.svg'),
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
                      showSelectionSheet(
                        context,
                        data: list
                            .map(
                              (e) => SelectionData<int>(
                                selection: list.indexOf(e),
                                title: e,
                              ),
                            )
                            .toList(),
                        onSelect: (SelectionData s) {
                          readerState.accountType = s.selection;
                          readerState.startDoTrade();
                        },
                        title: "Select Account Type",
                      );
                    },
                    style: ElevatedButton.styleFrom(
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
