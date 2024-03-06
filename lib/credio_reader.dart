library credio_reader;

import 'package:credio_reader/screens/withdrawal_screen.dart';
import 'package:flutter/material.dart';

class CredioReader {
  final bool isUserSubscribedToDirectDebit;

  CredioReader({
    required this.isUserSubscribedToDirectDebit,
  });

  // Future<String?> getPlatformVersion() {
  //   return CredioReaderPlatform.instance.getPlatformVersion();
  // }

  ///Ensure that the context passed to initiateWithdrawal is a descendant of a MaterialApp or CupertinoApp widget.
  ///This usually means passing the context from a widget that is part of the app's widget tree
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
}
