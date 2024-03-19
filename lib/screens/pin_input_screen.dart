import 'package:credio_reader/components/dimensions.dart';
import 'package:credio_reader/state/reader_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PinInputScreen extends StatefulWidget {
  const PinInputScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PinInputScreen> createState() => _PinInputScreenState();
}

class _PinInputScreenState extends State<PinInputScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ReaderStateProvider.instance(),
      builder: (ctx, child) {
        final readerState = ctx.read<ReaderStateProvider>();
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
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
                          'Card PIN',
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
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48.0),
                    child: PinCodeTextField(
                      autoFocus: true,
                      appContext: context,
                      onCompleted: (pin) => {readerState.sendPin(context, pin)},
                      length: 4,
                      controller: readerState.pinController,
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
                  SizedBox(
                    height: CredioScaleUtil(context).sizer.setHeight(50),
                  ),
                  // if (widget.isUserSubscribedToDirectDebit) ...[
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
                          trackColor: const Color(0xffB11226).withOpacity(0.17),
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
                  // ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 31.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (readerState.pinController.text.isNotEmpty &&
                            readerState.pinController.text.length == 4) {
                          readerState.sendPin(
                              context, readerState.pinController.text);
                        }
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
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
