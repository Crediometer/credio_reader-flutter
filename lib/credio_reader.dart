library credio_reader;

import 'dart:io';

import 'package:credio_reader/components/dialog_message.dart';
import 'package:credio_reader/components/dialog_scaffold.dart';
import 'package:credio_reader/components/dimensions.dart';
import 'package:credio_reader/components/scroll_behaviour.dart';
import 'package:credio_reader/configuration/configuration.dart';
import 'package:credio_reader/screens/withdrawal_screen.dart';
import 'package:credio_reader/state/reader_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'consts/app_strings.dart';

class ReaderButton extends StatefulWidget {
  final CredioConfig credioConfig;

  const ReaderButton(this.credioConfig, {super.key});

  Future<void> initiateWithdrawal(
    BuildContext context,
  ) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WithdrawalScreen(),
      ),
    );
  }

  @override
  State<ReaderButton> createState() => _ReaderButtonState();
}

class _ReaderButtonState extends State<ReaderButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ReaderStateProvider.instance(
            credioConfig: widget.credioConfig,
          ),
          lazy: true,
        ),
      ],
      child: ScrollConfiguration(
        behavior: CredioScrollAttitude(),
        child: const ReaderButtonState(),
      ),
    );
  }
}

class ReaderButtonState extends StatelessWidget {
  const ReaderButtonState({super.key});

  @override
  Widget build(BuildContext context) {
    final readerState = context.watch<ReaderStateProvider>();
    return ValueListenableBuilder<PosConnectionState>(
      valueListenable: readerState.posState,
      builder: (context, isConnected, child) {
        return Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                if (isConnected == PosConnectionState.notConnected) {
                  if (await readerState.checkPermission()) {
                    if (context.mounted) {
                      readerState.initState(
                        buildContext: context,
                      );
                    }

                    readerState.scanFinish = -1;
                    readerState.items = null;
                    readerState.getListSection();
                    readerState.selectDevice(
                      () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            readerState.context = context;
                            return CredioDialogScaffold(
                              showClose: true,
                              padded: true,
                              color: readerState.configurations.companyColor,
                              child: DialogMessage(
                                messageType: MessageType.Pending,
                                color: readerState.configurations.companyColor,
                                message: "Getting Available Reader",
                              ),
                            );
                          },
                        );
                      },
                    );
                    // }
                  } else {
                    Future<void> showErrorAlert(
                      BuildContext context, {
                      String? message,
                    }) async {
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return Platform.isIOS
                              ? CupertinoAlertDialog(
                                  actions: [
                                    CupertinoButton(
                                      child: Text(
                                        "Ok",
                                        style: TextStyle(
                                          color: readerState.configurations
                                                  .companyColor ??
                                              const Color(0xffB11226),
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(
                                        context,
                                      ),
                                    )
                                  ],
                                  content: DialogMessage(
                                    message: message ?? comingSoon,
                                    color:
                                        readerState.configurations.companyColor,
                                    route: "route",
                                  ),
                                )
                              : AlertDialog(
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        "Ok",
                                        style: TextStyle(
                                          color: Color(0xffB11226),
                                        ),
                                      ),
                                      onPressed: () => Navigator.pop(
                                        context,
                                      ),
                                    )
                                  ],
                                  content: DialogMessage(
                                    message: message ?? comingSoon,
                                    color:
                                        readerState.configurations.companyColor,
                                    route: "route",
                                  ),
                                );
                        },
                      );
                    }
                  }
                } else {
                  // await readerState.disconnectToDevice();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WithdrawalScreen(),
                    ),
                  );
                }
              },
              style: const ButtonStyle(
                side: MaterialStatePropertyAll(
                  BorderSide(color: Colors.white),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  Color(0xffB11226),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.string(
                    credioLogo,
                    height: 40,
                    width: 40,
                  ),
                  SizedBox(
                    width: CredioScaleUtil(context).sizer.setWidth(
                          1.5,
                        ),
                  ),
                  Container(
                    width: 1,
                    color: Colors.white,
                    height: 50,
                  ),
                  SizedBox(
                    width: CredioScaleUtil(context).sizer.setWidth(2.5),
                  ),
                  Text(
                    isConnected == PosConnectionState.notConnected
                        ? 'Connect Credio Reader'
                        : 'Initiate Withdrawal',
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
