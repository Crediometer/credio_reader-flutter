import 'dart:async';
import 'dart:developer';

import 'package:credio_reader/components/app_selection_sheet.dart';
import 'package:credio_reader/components/merchant_transaction_receipt.dart';
import 'package:credio_reader/configuration/configuration.dart';
import 'package:credio_reader/screens/pin_input_screen.dart';
import 'package:credio_reader/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plugin_qpos/QPOSModel.dart';
import 'package:flutter_plugin_qpos/flutter_plugin_qpos.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/utils.dart';

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

  String bankNibbs = "";

  BuildContext? context;

  final FlutterPluginQpos _flutterPluginQPos = FlutterPluginQpos();

  String? _mAddress;

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

      initPlatformState();
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

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = (await _flutterPluginQPos.posSdkVersion)!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    notifyListeners();
  }

  Future<void> connectToDevice(String item) async {
    List<String> addrs = item.split("//");
    _mAddress = addrs[1];
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
    // Profile profile,
  }) async {
    String? method = datas.method;
    log("dataas --- ${datas.toJson()}");
    List<String> paras = List.empty();

    String? parameters = datas.parameters;
    if (parameters != null && parameters.isNotEmpty) {
      paras = parameters.split("||");
    }

    switch (method) {
      case 'onRequestTransactionResult':
        log("yeah haaaaa");
        final Map<String, dynamic> doRoute = {
          "rrn": "242153479142",
          "onlinePin": false,
          "merchantName": "ITEX INTEGRATED SERVIC",
          "merchantAddress": "LA           LANG",
          "merchantId": "FBP204010449858",
          "terminalId": "207003DW",
          "STAN": "531056",
          "transactionActivityTime": "1128093015",
          "transactionTime": "093015",
          "transactionDate": "1128",
          "responseTime": "2022-11-28T08:30:16.295Z",
          "responseCode": "00",
          "merchantCategoryCode": "5050",
          "handlerName": "NIBSS POSVAS",
          "MTI": "0210",
          "maskedPan": "506110XXXXXXXXX9519",
          "processingCode": "001000",
          "amount": 1000,
          "currencyCode": "566",
          "messageReason": "Approved",
          "originalDataElements": null,
          "customerRef":
              "~0014A0000003710001011000802480000204E8000309Verve CPA09083D94304310067.9.160508000032860602CT040424120803S90",
          "script":
              "9F26087A41030E8D1A02769F2701809F10200FA501A202F8000000000000000000000F0F08010000000000000000000000009F37041B0413949F360200BD950500802480009A032211169C01009F02060000000000015F2A0200566820258009F1A02005669F3303E0E8F09F3501229F34034203009F1E043D9430438407A0000003710001",
          "aiic": "00000506110",
          "ficc": "00000639138",
          "authCode": "342151"
        };
        showCupertinoModalBottomSheet(
          context: pinContext!,
          isDismissible: false,
          backgroundColor: Colors.white,
          enableDrag: false,
          builder: (ctx) {
            return MerchantTransactionReceipt(
              maskedPan: doRoute["maskedPan"],
              cardType: 'Debit Card',
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
            );
          },
        );
        // result from Transactions
        if ((parameters ?? '').contains('Approved')) {
          log("yeah Approved");
        } else if (parameters?.toLowerCase() == 'cancel' ||
            parameters?.toLowerCase() == 'terminated') {
        } else {}
        display = parameters!;
        notifyListeners();
        break;
      case 'onRequestWaitingUser':
        if (lastMessage?.toLowerCase() !=
            "Please insert/swipe/tap card!".toLowerCase()) {
          lastMessage = "Please insert/swipe/tap card!";
        }
        break;
      case 'onRequestDisplay':
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
      case 'onQposInfoResult':
        display = parameters!;
        log("display--- $display");
        notifyListeners();
        break;
      case 'onRequestTime':
        log("hiuhhh");
        String dateSlug =
            "${today.year.toString()}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}${today.hour.toString().padLeft(2, '0')}${today.minute.toString().padLeft(2, '0')}${today.second.toString().padLeft(2, '0')}";
        log('Date Slug -- $dateSlug');

        _flutterPluginQPos.sendTime(
          dateSlug,
        );
        break;
      case 'onRequestSetPin':
        display = "Please input pin on your app";
        log(display);
        notifyListeners();
        // Navigator.pop(context!);
        pinController.clear();
        Navigator.push(
          _configurations.locator!.currentContext!,
          MaterialPageRoute(
            builder: (ctx) => const PinInputScreen(),
          ),
        );
        //TODO: navigate to pin page
        break;
      case 'onQposRequestPinResult':
        log("pin result --- $parameters");
        break;
      case 'onDeviceFound':
        print("onDeviceFound : $parameters");
        items ??= List.empty(growable: true);
        if ((parameters!.startsWith("MPOS") ||
                parameters.startsWith("Credio")) &&
            !(items!.contains(parameters))) {
          items!.add(parameters);
          StringBuffer buffer = StringBuffer();
          for (int i = 0; i < items!.length; i++) {
            buffer.write(items![i]);
          }
          print("onDeviceFound : ${buffer.toString()}");

          notifyListeners();
        }
        break;
      case 'onError':
        print("oNError =-- $paras");
        break;
      case 'onDoTradeResult':
        log("onDoTradeResult... $paras");
        log("something is wrong here????");
        if (Utils.equals(paras[0], "ICC")) {
          log("something is wrong here???? 4444");
          _flutterPluginQPos.doEmvApp("START");
        }

        if (Utils.equals(paras[0], "NFC_ONLINE") ||
            Utils.equals(paras[0], "NFC_OFFLINE")) {
          if (Utils.equals(paras[1], "TapCard")) {
            //TODO: navigate to card pin page
          }
          notifyListeners();
        } else if (Utils.equals(paras[0], "MCR")) {
          display = paras[1];
          notifyListeners();
        } else {}
        break;
      case 'onQposIdResult':
        display = parameters!;
        notifyListeners();
        break;
      case 'onError':
        display = parameters!;
        notifyListeners();
        break;
      case 'onRequestQposDisconnected':
        display = "device disconnected!";
        _subscription!.cancel();
        // posState = PosConnectionState.NotConnected;
        // readerConnectionState.value = false;
        initStateCalled = false;
        notifyListeners();
        break;
      case 'onBluetoothBondTimeout':
        Navigator.pop(context!);
        // showDialog(
        //   context: context!,
        //   barrierDismissible: false,
        //   builder: (context) {
        //     return CredioDialogScaffold(
        //       showClose: true,
        //       padded: true,
        //       child: DialogMessage(
        //         messageType: MessageType.Error,
        //         message: "Bluetooth Bond Timeout detected",
        //       ),
        //     );
        //   },
        // );
        break;
      case 'onQposIsCardExist':
        log("card exits ${datas.toJson()}");
        break;
      case 'onRequestSelectEmvApp':
        _flutterPluginQPos.selectEmvApp(1);
        break;
      case 'onRequestQposConnected':
        display = "device connected!";
        posState.value = PosConnectionState.connected;
        // readerConnectionState.value = true;
        // log("${_flutterPluginQpos.getQposId()}");
        // final CardHttpService _cardService = CardHttpService();
        print("... called single time ");
        // PosState? state = PosState.instance;
        // state!.profile.value!.then((value) async {
        //   print("... called multiple times ");

        // try {
        //   log("terminaId -- ${value!.message!.profile!.reader!.first.terminalId!}");
        //   _cardKeyExchange = await _cardService.cardExchange(
        //     value!.message!.profile!.reader!.first.uuid!,
        //     value.message!.profile!.reader!.first.terminalId!,
        //   );
        //   log("card exchange $_cardKeyExchange");
        //
        //   if (_cardKeyExchange != null) {
        //     log("checking status for key exchange");
        //     if (_cardKeyExchange!.data!.status == null ||
        //         _cardKeyExchange!.data!.error == true) {
        //       log("Prepping failed");
        //       disconnectToDevice();
        //       showErrorAlert(thisContext,
        //           message: "Kindly Reconnect to Reader");
        //     } else {
        //       log("Prepping was successful");
        //     }
        //   }
        // } catch (e) {
        //   log("cardExchange response error -- $e");
        //   log("Prepping failed");
        //   disconnectToDevice();
        //   showErrorAlert(thisContext, message: "Kindly Reconnect to Reader");
        // }

        notifyListeners();
        // });
        break;
      case 'onUpdatePosFirmwareResult':
        break;
      case 'onUpdatePosFirmwareProcessChanged':
        print('onUpdatePosFirmwareProcessChanged$parameters');

        print('onUpdatePosFirmwareProcessChanged${double.parse(parameters!)}');

        break;
      case 'onBluetoothBonding':
        logs.value = "${logs.value}\nBonding with pos machine \n";

        Navigator.pop(context!);
        // showDialog(
        //   context: context!,
        //   barrierDismissible: false,
        //   builder: (context) {
        //     return CredioDialogScaffold(
        //       showClose: false,
        //       padded: true,
        //       child: DialogMessage(
        //           messageType: MessageType.Pending,
        //           message: "Bonding with pos machine"),
        //     );
        //   },
        // );
        break;
      case 'onReturnUpdateEMVResult':
        log("emv result ---- ${datas.toJson()}");
        break;
      case 'onBluetoothBoardStateResult':
        log("Something with board state ${datas.toJson()}");
        break;
      case 'onRequestSetAmount':
        Map<String, String> params = <String, String>{};
        params['amount'] = "${(extractAmount(amountCredio.text) ?? 0) * 100}";
        params['cashbackAmount'] = "";
        params['currencyCode'] = "0566"; //"NGN"; //
        params['transactionType'] = "GOODS";
        _flutterPluginQPos.setAmount(params);
        break;
      case 'onReturnGetEMVListResult':
        break;
      case 'onRequestDeviceScanFinished':
        log("items   - --- ${items!.length}");
        processItems(
          items,
        );
        break;

      //todo remove  pop
      case 'onRequestNoQposDetected':
        // showDialog(
        //   context: context!,
        //   barrierDismissible: false,
        //   builder: (context) {
        //     return CredioDialogScaffold(
        //       showClose: true,
        //       padded: true,
        //       child: DialogMessage(
        //           messageType: MessageType.Error,
        //           message: "No POS machine detected"),
        //     );
        //   },
        // );

        break;
      case 'onRequestOnlineProcess':
        _flutterPluginQPos.sendOnlineProcessResult("8A023030");

        if (paras[0].trim().toUpperCase().contains("FALLBACK")) {
          break;
        }
        // var tlv = paras[0].split(':').last;
        // final CardHttpService _cardService = CardHttpService();
        // final OperatorHttpService _operatorService = OperatorHttpService();
        // final AuthState? authState = AuthState.instance;

        try {
          // CardTransactionRequest buildCardTransactionRequest() {
          //   if (authState!.userType == UserType.Operator) {
          //     return CardTransactionRequest(
          //       tlv: tlv,
          //       accountType: accountType,
          //       author: authorNumber,
          //       key: _cardKeyExchange?.data!.pinKey!,
          //       merchantId: _cardKeyExchange?.data!.merchantId!,
          //       merchantCategoryCode:
          //           _cardKeyExchange?.data!.merchantCategoryCode!,
          //       terminalId: _cardKeyExchange?.data!.terminalid!,
          //       merchantName: _cardKeyExchange?.data!.merchantName!,
          //       operatorNumber: operatorNumber ?? '',
          //     );
          //   } else {
          //     return CardTransactionRequest(
          //       tlv: tlv,
          //       accountType: accountType,
          //       author: authorNumber,
          //       key: _cardKeyExchange?.data!.pinKey!,
          //       merchantId: _cardKeyExchange?.data!.merchantId!,
          //       merchantCategoryCode:
          //           _cardKeyExchange?.data!.merchantCategoryCode!,
          //       terminalId: _cardKeyExchange?.data!.terminalid!,
          //       merchantName: _cardKeyExchange?.data!.merchantName!,
          //     );
          //   }
          // }
          //
          // final data = buildCardTransactionRequest();
          // final doRoute = await formSubmitDialog(
          //   context: pinContext!,
          //   prompt: 'Please wait while we process your transaction...',
          //   future: authState!.userType == UserType.SuperAdmin
          //       ? _cardService.merchantCardTopUp(data)
          //       : _operatorService.operatorCardTopUp(data),
          // );
          // if (doRoute != null) {
          // showCupertinoModalBottomSheet(
          //   context: pinContext!,
          //   isDismissible: false,
          //   backgroundColor: Colors.white,
          //   enableDrag: false,
          //   builder: (ctx) {
          //     return authState.userType == UserType.SuperAdmin
          //         ? MerchantTransactionReceipt(
          //             maskedPan: doRoute["maskedPan"],
          //             cardType: 'Debit Card',
          //             creditAccountName: doRoute["merchantName"],
          //             creditAccountNumber: doRoute["customerRef"],
          //             terminalId: doRoute["terminalId"],
          //             authCode: doRoute["authCode"],
          //             responseCode: doRoute["responseCode"],
          //             stan: doRoute["STAN"],
          //             rrn: doRoute['rrn'],
          //             narration: doRoute['messageReason'],
          //             amount: doRoute["amount"],
          //             transactionTime: doRoute["responseTime"],
          //           )
          //         : OperatorTransactionReceipt(
          //             maskedPan: doRoute["maskedPan"],
          //             cardType: 'Debit Card',
          //             creditAccountName: doRoute["merchantName"],
          //             creditAccountNumber: doRoute["customerRef"],
          //             terminalId: doRoute["terminalId"],
          //             authCode: doRoute["authCode"],
          //             responseCode: doRoute["responseCode"],
          //             stan: doRoute["STAN"],
          //             rrn: doRoute['rrn'],
          //             narration: doRoute['messageReason'],
          //             amount: doRoute["amount"],
          //             transactionTime: doRoute["responseTime"],
          //           );
          //   },
          // );
          // }
        } catch (error) {
          log("Error occurred during server connection $error");
        } finally {}
        break;
      case 'onBluetoothBondFailed':
        Navigator.pop(context!);
        showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (context) {
            return Container();
            // return CredioDialogScaffold(
            //   showClose: true,
            //   padded: false,
            //   child: DialogMessage(
            //     messageType: MessageType.Error,
            //     message: "Bonding with pos machine Failed",
            //   ),
            // );
          },
        );
        break;
      case 'bluetoothIsPowerOff2Mode':
        // posState = PosConnectionState.NotConnected;
        Navigator.pop(context!);
        showDialog(
          context: context!,
          barrierDismissible: false,
          builder: (context) {
            return Container();
            // return CredioDialogScaffold(
            //   showClose: true,
            //   padded: true,
            //   child: DialogMessage(
            //     messageType: MessageType.Error,
            //     message: "Bonding with pos machine Failed",
            //   ),
            // );
          },
        );
        break;
      case 'onReturnGetPinInputResult':
        log("result.....");
        // numPinField = int.parse(parameters!);
        break;
      case 'onReturnGetPinResult':
        log("result.....");
        notifyListeners();
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
        onTap: () {
          // if (readers!.contains(items![position])) {
          //   connectToDevice(items![position]);
          // } else {
          //   showDialog(
          //       context: context,
          //       barrierDismissible: false,
          //       builder: (context) {
          //         this.context = context;
          //         return CredioDialogScaffold(
          //           showClose: true,
          //           padded: true,
          //           child: DialogMessage(
          //             messageType: MessageType.Error,
          //             message: "Please Use Your Activated Reader",
          //           ),
          //         );
          //       });
          // }
        },
        // title: CredioText(
        //   "${items![position].split('//')[0]}",
        //   style: CredioTextStyle.bold.copyWith(fontSize: 60),
        // ),
      );
    } else {
      return TextButton(
        onPressed: () {}, //connectToDevice(items![position]),
        child: const Text(
          "No device available",
        ),
      );
    }
  }

  Future<void> processItems(
    List<String>? items,
  ) async {
    log("items   - --- ${items!.map((e) => e)}");

    Navigator.pop(context!);

    try {
      showSelectionSheet(
        context!,
        onSelect: (data) async {
          await connectToDevice((data.selection)!);
        },
        title: "Select device",
        data: items.map((item) {
          var name = item.split("//")[0].replaceAll(regexPattern, '');

          return SelectionData(
            selection: item,
            title: name,
          );
        }).toList(),
      );
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

// Future<String> shareReceipt(
//     ScreenshotController controller,
//     String? date,
//     ) async {
//   try {
//     final image = await controller.capture(pixelRatio: 5);
//     final pdf = pw.Document();
//     pdf.addPage(
//       pw.Page(
//         margin: pw.EdgeInsets.zero,
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Image(
//               pw.MemoryImage(image!),
//             ),
//           );
//         },
//       ),
//     );
//     final dir = await getTemporaryDirectory();
//     final file = File(
//       "${dir.path}/credio_trans_receipt_${DateTime.now().toIso8601String()}_$date.pdf",
//     );
//     await file.writeAsBytes(await pdf.save());
//     Share.shareFiles(
//       [file.path],
//       mimeTypes: ["image/jpeg", "image/png", "application/pdf"],
//     );
//     return "success";
//   } catch (e) {
//     throw {
//       "statusCode": 400,
//       "data": {"message": "PDF generation failed"}
//     };
//   }
// }
}
