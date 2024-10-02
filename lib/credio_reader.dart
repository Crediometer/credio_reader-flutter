library credio_reader;

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'components/dialog_message.dart';
import 'components/dialog_scaffold.dart';
import 'components/scroll_behaviour.dart';
import 'configuration/configuration.dart';
import 'screens/withdrawal_screen.dart';
import 'state/reader_state.dart';
import 'consts/app_strings.dart';

class ReaderButton extends StatefulWidget {
  final CredioConfig credioConfig;

  const ReaderButton(this.credioConfig, {Key? key}) : super(key: key);

  Future<void> initiateWithdrawal(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WithdrawalScreen(
          predefinedAmount: credioConfig.amount,
        ),
      ),
    );
  }

  @override
  _ReaderButtonState createState() => _ReaderButtonState();
}

class _ReaderButtonState extends State<ReaderButton> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ReaderStateProvider.instance(
            credioConfig: widget.credioConfig,
          ),
        ),
      ],
      child: ScrollConfiguration(
        behavior: CredioScrollAttitude(),
        child: const ReaderButtonContent(),
      ),
    );
  }
}

class ReaderButtonContent extends StatelessWidget {
  const ReaderButtonContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final readerState = context.watch<ReaderStateProvider>();
    return ValueListenableBuilder<PosConnectionState>(
      valueListenable: readerState.posState,
      builder: (context, posState, child) {
        final button = readerState.configurations.initializerButton;

        return GestureDetector(
          child: button ?? _buildDefaultButton(context, readerState, posState),
          onTap: () => _handleButtonTap(context, readerState, posState),
        );
      },
    );
  }

  Widget _buildDefaultButton(BuildContext context,
      ReaderStateProvider readerState, PosConnectionState posState) {
    return ElevatedButton(
      onPressed: () => _handleButtonTap(context, readerState, posState),
      style: readerState.configurations.buttonConfiguration?.buttonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffB11226),
            fixedSize: const Size(double.infinity, 53.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
      child: Text(
        posState == PosConnectionState.notConnected
            ? connectCredioReader
            : initialWithdrawal,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _handleButtonTap(BuildContext context,
      ReaderStateProvider readerState, PosConnectionState posState) async {
    if (posState == PosConnectionState.notConnected) {
      if (await readerState.checkPermission()) {
        if (context.mounted) {
          readerState.initState(buildContext: context);
        }

        readerState.scanFinish = -1;
        readerState.items = null;
        readerState.getListSection();
        readerState.selectDevice(() {
          _showPendingDialog(context, readerState);
        });
      } else {
        if (context.mounted) _showErrorAlert(context, readerState);
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WithdrawalScreen(
            predefinedAmount: readerState.configurations.amount,
          ),
        ),
      );
    }
  }

  void _showPendingDialog(
      BuildContext context, ReaderStateProvider readerState) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        readerState.context = context;
        return CredioDialogScaffold(
          showClose: true,
          padded: true,
          color: const Color(0xffB11226),
          child: DialogMessage(
            messageType: MessageType.Pending,
            message: "Getting Available Reader",
          ),
        );
      },
    );
  }

  Future<void> _showErrorAlert(
      BuildContext context, ReaderStateProvider readerState,
      {String? message}) async {
    await showDialog(
      context: context,
      builder: (context) {
        final color = const Color(0xffB11226);

        return Platform.isIOS
            ? CupertinoAlertDialog(
                actions: [
                  CupertinoButton(
                    child: Text("Ok", style: TextStyle(color: color)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
                content: DialogMessage(
                  message: message ?? comingSoon,
                  color: color,
                  route: "route",
                ),
              )
            : AlertDialog(
                actions: [
                  TextButton(
                    child: const Text("Ok",
                        style: TextStyle(color: Color(0xffB11226))),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
                content: DialogMessage(
                  message: message ?? comingSoon,
                  color: color,
                  route: "route",
                ),
              );
      },
    );
  }
}
