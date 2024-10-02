import 'dart:async';
import 'dart:developer';

import 'package:credio_reader/components/app_selection_sheet.dart';
import 'package:credio_reader/components/dialog_message_copy.dart';
import 'package:credio_reader/components/dialog_scaffold.dart';
import 'package:credio_reader/components/merchant_transaction_receipt.dart';
import 'package:credio_reader/configuration/configuration.dart';
import 'package:credio_reader/consts/app_strings.dart';
import 'package:credio_reader/models/reader_transaction_request.dart';
import 'package:credio_reader/screens/pin_input_screen.dart';
import 'package:credio_reader/services/http.dart';
import 'package:credio_reader/utils/helper.dart';
import 'package:credio_reader/utils/modals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:credio_reader/screens/withdrawal_screen.dart';
import '../utils/utils.dart';
import '../models/set_amount.dart';

enum PosConnectionState {
  connected,
  notConnected,
}

class ReaderStateProvider extends ChangeNotifier {
  set configurations(CredioConfig config) {
    _configurations = config;
  }

  CredioConfig get configurations => _configurations;

  late CredioConfig _configurations;

  ReaderStateProvider._(); // Private constructor

  static ReaderStateProvider? _instance;

  static ReaderStateProvider instance({CredioConfig? credioConfig}) {
    _instance ??= ReaderStateProvider._();
    if (credioConfig != null) _instance!.configurations = credioConfig;
    return _instance!;
  }

  BuildContext? pinContext;

  final communicationMode = "BLUETOOTH";
  int accountType = 0;

  String? lastMessage;

  ValueNotifier<String> logs = ValueNotifier("");
  static final RegExp regexPattern = RegExp(r'\D');
  TextEditingController amountCredio = TextEditingController();

  final TextEditingController _pinController = TextEditingController();
  TextEditingController get pinController => _pinController;
  ValueNotifier<PosConnectionState> posState =
      ValueNotifier(PosConnectionState.notConnected);

  BuildContext? context;

  final FlutterPluginQpos _flutterPluginQPos = FlutterPluginQpos();

  String display = "";
  StreamSubscription? _subscription;
  List<String>? items;

  var scanFinish = 0;
  bool initStateCalled = false;

  FlutterPluginQpos get qPos => _flutterPluginQPos;
  DateTime today = DateTime.now();

  void initState({
    required BuildContext buildContext,
  }) {
    if (!initStateCalled) {
      initStateCalled = true;

      _subscription =
          _flutterPluginQPos.onPosListenerCalled!.listen((QPOSModel data) {
        parasListener(
          datas: data,
          thisContext: buildContext,
        );
        notifyListeners();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }

  Future<void> connectToDevice(String item, BuildContext context) async {
    List<String> addrs = item.split("//");
    scanFinish = 0;
    items = null;
    notifyListeners();
    await _flutterPluginQPos.connectBluetoothDevice(addrs[1]);
  }

  Future<void> disconnectToDevice() async {
    await _flutterPluginQPos.disconnectBT();
  }

  sendPin(BuildContext context, String pin) async {
    pinContext = context;
    _flutterPluginQPos.sendPin(pin);
  }

  void startDoTrade() {
    _flutterPluginQPos.setFormatId(FormatID.DUKPT);
    _flutterPluginQPos
        .setCardTradeMode(CardTradeMode.SWIPE_TAP_INSERT_CARD_NOTUP);

    _flutterPluginQPos.setDoTradeMode(DoTradeMode.CHECK_CARD_NO_IPNUT_PIN);
    _flutterPluginQPos.doTrade(0);
  }

  void parasListener({
    required QPOSModel datas,
    required BuildContext thisContext,
  }) async {
    String? method = datas.method;
    log("dataas --- ${datas.toJson()}");
    List<String> paras = List.empty();

    String? parameters = datas.parameters;
    if (parameters != null && parameters.isNotEmpty) {
      paras = parameters.split("||");
    }

    switch (method) {
      case onRequestTransactionResult:
        if ((parameters ?? '').contains('Approved')) {
          log("yeah Approved");
        } else if (parameters?.toLowerCase() == 'cancel' ||
            parameters?.toLowerCase() == 'terminated') {
        } else {}
        display = parameters!;
        notifyListeners();
        break;
      case onRequestWaitingUser:
        if (lastMessage?.toLowerCase() !=
            "Please insert/swipe/tap card!".toLowerCase()) {
          lastMessage = "Please insert/swipe/tap card!";
        }
        break;
      case onRequestDisplay:
        display = parameters!;
        log("onRequestDisplay -- $display");
        if (display.toLowerCase().toLowerCase() == 'please') {}
        if (display.toLowerCase().toLowerCase() == 'terminated') {
        } else if (display.isEmpty || display == '') {
        } else {
          if (!display.toLowerCase().contains("approved")) {
            if (lastMessage?.toLowerCase() != display.toLowerCase()) {
              lastMessage = display;
            }
          }
        }
        notifyListeners();
        break;

      case onRequestTime:
        String dateSlug =
            "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}${today.hour.toString().padLeft(2, '0')}${today.minute.toString().padLeft(2, '0')}${today.second.toString().padLeft(2, '0')}";

        _flutterPluginQPos.sendTime(
          dateSlug,
        );
        break;
      case onRequestSetPin:
        display = "Please input pin on your app";
        log(display);
        notifyListeners();
        pinController.clear();
        Navigator.push(
          _configurations.locator!.currentContext!,
          MaterialPageRoute(
            builder: (ctx) => const PinInputScreen(),
          ),
        );
        break;

      case onDeviceFound:
        items ??= List.empty(growable: true);
        if ((parameters!.startsWith("MPOS") ||
                parameters.startsWith("Credio")) &&
            !(items!.contains(parameters))) {
          items!.add(parameters);
          StringBuffer buffer = StringBuffer();
          for (int i = 0; i < items!.length; i++) {
            buffer.write(items![i]);
          }

          notifyListeners();
        }
        break;

      case onDoTradeResult:
        log("onDoTradeResult... $paras");
        log("something is wrong here????");
        if (Utils.equals(paras[0], "ICC")) {
          log("something is wrong here???? 4444");
          _flutterPluginQPos.doEmvApp("START");
        }

        if (Utils.equals(paras[0], "NFC_ONLINE") ||
            Utils.equals(paras[0], "NFC_OFFLINE")) {
          if (Utils.equals(paras[1], "TapCard")) {}
          notifyListeners();
        } else if (Utils.equals(paras[0], "MCR")) {
          display = paras[1];
          notifyListeners();
        } else {}
        break;

      case onError:
        display = parameters!;
        notifyListeners();
        break;
      case onRequestQposDisconnected:
        display = "device disconnected!";
        _subscription!.cancel();
        initStateCalled = false;
        notifyListeners();
        break;
      case onBluetoothBondTimeout:
        Navigator.pop(context!);
        break;

      case onRequestSelectEmvApp:
        _flutterPluginQPos.selectEmvApp(1);
        break;
      case onRequestQposConnected:
        display = "device connected!";
        posState.value = PosConnectionState.connected;
        notifyListeners();
        await Navigator.push(
          // ignore: use_build_context_synchronously
          configurations.locator!.currentContext!,
          MaterialPageRoute(
            builder: (context) => WithdrawalScreen(
              predefinedAmount: configurations.amount,
            ),
          ),
        );
        break;

      case onBluetoothBonding:
        logs.value = "${logs.value}\nBonding with pos machine \n";

        Navigator.pop(context!);
        break;

      case onRequestSetAmount:
        num amount =
            configurations.amount ?? extractAmount(amountCredio.text) ?? 0;
        SetAmountParams amountParams =
            SetAmountParams(amount: "${(amount * 100).toInt()}");

        // SetAmountParams amountParams = SetAmountParams(
        //     amount: "${(extractAmount(amountCredio.text) ?? 0) * 100}");

        _flutterPluginQPos.setAmount(amountParams.toJson());
        break;

      case onRequestDeviceScanFinished:
        processItems(
          items,
        );
        break;

      case onRequestNoQposDetected:
        break;
      case onRequestOnlineProcess:
        _flutterPluginQPos.sendOnlineProcessResult("8A023030");

        if (paras[0].trim().toUpperCase().contains("FALLBACK")) {
          break;
        }
        var tlv = paras[0].split(':').last;
        final CardHttpService cardService = CardHttpService();

        try {
          ReaderTransactionRequest readerTransactionRequest =
              ReaderTransactionRequest(
            tlv: tlv,
            author: configurations.apiKey,
            metaData: configurations.metaData,
            accountType: accountType,
            terminalId: configurations.terminalId,
            webhookURL: configurations.webhookURL,
          );

          final doRoute = await (configurations.customLoader != null
              ? configurations.customLoader!<dynamic>(
                  context: pinContext!,
                  prompt: 'Please wait while we process your transaction...',
                  errorMessage:
                      "An unexpected error occurred. Please try again.",
                  future:
                      cardService.merchantCardTopUp(readerTransactionRequest),
                  onError: (String errorMessage) {
                    showDialog(
                      context: pinContext!,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text(errorMessage),
                          actions: <Widget>[
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
              : formSubmitDialog(
                  context: pinContext!,
                  prompt: 'Please wait while we process your transaction...',
                  future:
                      cardService.merchantCardTopUp(readerTransactionRequest),
                ));

          if (doRoute != null) {
            showCupertinoModalBottomSheet(
              context: pinContext!,
              isDismissible: false,
              backgroundColor: Colors.white,
              enableDrag: false,
              builder: (ctx) {
                return MerchantTransactionReceipt(
                  maskedPan: doRoute["maskedPan"],
                  cardType: 'Debit Card', // check this
                  creditAccountName: doRoute["merchantName"],
                  creditAccountNumber: doRoute["customerRef"],
                  terminalId: doRoute["terminalId"],
                  authCode: doRoute["authCode"],
                  responseCode: doRoute["responseCode"],
                  stan: doRoute["STAN"],
                  rrn: doRoute['rrn'],
                  narration: doRoute['messageReason'],
                  amount: doRoute["amount"],
                  transactionTime: doRoute["responseTime"],
                  credioConfig: configurations,
                );
              },
            );
          }
        } catch (error) {
          log("Error occurred during server connection $error");
        } finally {}
        break;
      case onBluetoothBondFailed:
        Navigator.pop(context!);
        showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (context) {
            return Container();
          },
        );
        break;
      case bluetoothIsPowerOff2Mode:
        Navigator.pop(context!);
        showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (context) {
            return Container();
          },
        );
        break;

      default:
        throw ArgumentError('error');
    }
  }

  Future<bool> checkPermission() async {
    return (await Permission.bluetooth.request().isGranted &&
        await Permission.location.request().isGranted);
  }

  void selectDevice(
    VoidCallback next,
  ) {
    _flutterPluginQPos.init(communicationMode);
    _flutterPluginQPos.scanQPos2Mode(2);
    next();
  }

  Widget _getListDate(
    BuildContext context,
    int position,
  ) {
    if (items != null) {
      return ListTile(
        onTap: () {},
      );
    } else {
      return TextButton(
        onPressed: () {},
        child: const Text(
          "No device available",
        ),
      );
    }
  }

  Future<void> processItems(
    List<String>? items,
  ) async {
    Navigator.pop(context!);

    try {
      if ((items ?? []).isEmpty) {
        showDialog(
            context: context!,
            builder: ((context) {
              return CredioDialogScaffold(
                showClose: true,
                padded: true,
                child: DialogMessage(
                  message: 'You have no reader available',
                  messageType: MessageType.Info,
                ),
              );
            }));
      } else if (items?.length == 1) {
        await connectToDevice(items!.first, context!);
      } else {
        showSelectionSheet(
          context!,
          onSelect: (data) async {
            await connectToDevice((data.selection)!, context!);
          },
          title: "Select device",
          data: (items ?? []).map((item) {
            var name = item.split("//")[0].replaceAll(regexPattern, '');

            return SelectionData(
              selection: item,
              title: name,
            );
          }).toList(),
        );
      }
    } catch (e) {
      log("an error occurred -- $e");
    }

    scanFinish = 1;
    notifyListeners();
  }

  Widget? getListSection() {
    if (items == null) {
      if (scanFinish == 0) {
        return const Text("");
      } else {
        if (scanFinish == -1) {
          return const Center(child: CircularProgressIndicator());
        }
      }
    } else {
      if (scanFinish == 1) {
        Widget listSection = ListView.separated(
          separatorBuilder: (context, index) =>
              Container(height: 1, color: Colors.black),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(5.0),
          itemCount: items == null ? 0 : items!.length,
          itemBuilder: (BuildContext context, int index) {
            return _getListDate(context, index);
          },
        );
        return listSection;
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    }
    return null;
  }
}
