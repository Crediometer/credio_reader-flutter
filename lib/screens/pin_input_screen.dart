import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinInputScreen extends StatefulWidget {
  final bool isUserSubscribedToDirectDebit;

  const PinInputScreen({
    Key? key,
    required this.isUserSubscribedToDirectDebit,
  }) : super(key: key);

  @override
  State<PinInputScreen> createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  bool _isChecked = false;

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
                          'Card Pin',
                          style: TextStyle(fontSize: 24),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Please Enter Card PIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 112),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: PinCodeTextField(
                      appContext: context,
                      length: 4,
                      obscureText: true,
                      obscuringCharacter: '*',
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        borderRadius: BorderRadius.circular(8.0),
                        inactiveColor: const Color(0xff707070),
                        activeColor: const Color(0xff058B42),
                        selectedColor: const Color(0xff058B42),
                        shape: PinCodeFieldShape.box,
                        borderWidth: 1,
                        inactiveBorderWidth: 1,
                        selectedBorderWidth: 1,
                        activeBorderWidth: 1,
                        fieldHeight: 60,
                        fieldWidth: 60,
                      ),
                    ),
                  ),
                  const SizedBox(height: 280),
                  if (widget.isUserSubscribedToDirectDebit) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Row(
                        children: [
                          const Text(
                            'Get a direct debit each ',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          const Text(
                            'month',
                            style: TextStyle(
                                fontSize: 12.0, color: Color(0xff058B42)),
                          ),
                          const Spacer(),
                          CupertinoSwitch(
                            value: _isChecked,
                            activeColor: const Color(0xffB11226),
                            trackColor:
                                const Color(0xffB11226).withOpacity(0.17),
                            thumbColor: _isChecked
                                ? Colors.white
                                : const Color(0xffBBBBBB).withOpacity(0.17),
                            onChanged: (bool value) {
                              setState(() {
                                _isChecked = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31.0),
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
