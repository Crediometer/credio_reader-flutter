import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../components/app_selection_sheet.dart';

class WithdrawalScreen extends StatelessWidget {
  WithdrawalScreen({Key? key}) : super(key: key);

  final list = [
    "Universal",
    "Savings",
    "Current",
    "Credit",
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            left: size.width * 0.5,
            top: -size.height * 0.12,
            child: SvgPicture.asset(
              'packages/credio_reader/images/circle_bckg.svg',
              // height: 50,
            ),
          ),
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31.0),
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
                  const SizedBox(height: 173),
                  const Text(
                    'Enter amount',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffB11226),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'NGN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 78),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 41.0),
                    child: TextField(),
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const PinScreen(),
                            //   ),
                            // );
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
          ),
        ],
      ),
    );
  }
}
