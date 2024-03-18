library credio_reader;

import 'dart:io';
import 'package:credio_reader/components/dialog_message.dart';
import 'package:credio_reader/components/dialog_scaffold.dart';
import 'package:credio_reader/components/dimensions.dart';
import 'package:credio_reader/components/scroll_behaviour.dart';
import 'package:credio_reader/configuration/configuration.dart';
import 'package:credio_reader/screens/withdrawal_screen.dart';
import 'package:credio_reader/state/reader_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

final String comingSoon =
    "The feature is coming soon! Stay tuned to Credio app to enjoy new and exicting features.";

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
                    readerState.initState(
                      buildContext: context,
                    );

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
                              color: readerState.configurations?.companyColor,
                              child: DialogMessage(
                                messageType: MessageType.Pending,
                                color: readerState.configurations?.companyColor,
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
                                                  ?.companyColor ??
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
                                    color: readerState
                                        .configurations?.companyColor,
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
                                    color: readerState
                                        .configurations?.companyColor,
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
                  BorderSide(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: MaterialStatePropertyAll(
                  Color(0xffB11226),
                ),
              ),
              child: Row(
                children: [
                  SvgPicture.string(
                    """<svg xmlns="http://www.w3.org/2000/svg" width="128" height="106.132" viewBox="0 -30 128 106.132">
  <g id="Raggruppa_202" data-name="Raggruppa 202" transform="translate(-152 -297.032)">
    <g id="Raggruppa_118" data-name="Raggruppa 118" transform="translate(178.616 297.032)">
      <path id="Tracciato_368" data-name="Tracciato 368" d="M136.486,971.353c-6.955-.7-28.717-5.574-32.713-23.352L89,952.578S106.316,976.554,136.486,971.353Z" transform="translate(-89 -914.57)" fill="#fff"/>
      <path id="Tracciato_369" data-name="Tracciato 369" d="M173.3,867.424c-7.149-2.584-31.917-17.593-15.48-45.682L134,832.5s.624,7.7,1.665,11.028l7.491-2.289S143.535,863.7,173.3,867.424Z" transform="translate(-124.637 -812.593)" fill="#fff"/>
      <g id="Raggruppa_117" data-name="Raggruppa 117" transform="translate(30.928)">
        <path id="Tracciato_370" data-name="Tracciato 370" d="M259.738,844.59c-9.17,0-16.6-7.687-16.6-17.168s7.434-17.168,16.6-17.168a16.148,16.148,0,0,1,9.286,2.934l5.236-8.025a25.088,25.088,0,0,0-14.521-4.626c-14.246,0-25.795,11.941-25.795,26.67s11.549,26.67,25.795,26.67a25.08,25.08,0,0,0,14.281-4.459L269,841.67A16.146,16.146,0,0,1,259.738,844.59Z" transform="translate(-233.945 -800.537)" fill="#fff"/>
      </g>
    </g>
    <!-- <text id="CredFam" transform="translate(216 396.165)" fill="#fff" font-size="30" font-family="Gilroy-Bold" font-weight="700"><tspan x="-53.96" y="0">Cred</tspan><tspan y="0" font-family="Gilroy-Medium" font-weight="500">Fam</tspan></text> -->
  </g>
</svg>
""",
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
                    width: CredioScaleUtil(context).sizer.setWidth(
                          2.5,
                        ),
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
