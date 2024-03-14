library credio_reader;

import 'package:credio_reader/configuration/configuration.dart';
import 'package:credio_reader/screens/withdrawal_screen.dart';
import 'package:credio_reader/state/reader_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class CredioReader {

//   CredioReader({
//   });

// Future<void> initiateWithdrawal(
//   BuildContext context,
// ) async {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => WithdrawalScreen(
//
//       ),
//     ),
//   );
//   }
// }

class CredioReaderInitiator extends StatefulWidget {
  final CredioConfig credioConfig;

  const CredioReaderInitiator(this.credioConfig, {super.key});

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
  State<CredioReaderInitiator> createState() => _CredioReaderInitiatorState();
}

class _CredioReaderInitiatorState extends State<CredioReaderInitiator> {
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
    return ChangeNotifierProvider(
      create: (_) => ReaderStateProvider.instance(widget.credioConfig),
      lazy: true,
      child: const Placeholder(),
    );
  }
}
