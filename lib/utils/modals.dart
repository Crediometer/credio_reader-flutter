import 'dart:async';

import 'package:credio_reader/components/dialog_message.dart';
import 'package:credio_reader/components/dialog_scaffold.dart';
import 'package:credio_reader/utils/helper.dart';
import 'package:flutter/material.dart';

enum FutureState {
  loading,
  complete,
  fail,
}

Future<T?> formSubmitDialog<T>({
  required BuildContext context,
  required Future<T> future,
  bool? fullDialog = false,
  String? errorMessage =
      "An unexpected error occurred and the request failed, please try again",
  String prompt = "Processing My Request",
  String? successMessage,
  VoidCallback? action,
  bool forceErrorMessage = false,
}) async {
  ValueNotifier<FutureState> isResolved = ValueNotifier(
    FutureState.loading,
  );
  final T? result = await showGeneralDialog<T>(
    context: context,
    barrierDismissible: false,
    pageBuilder: (context, ____, _______) {
      return WillPopScope(
        child: ValueListenableBuilder(
          valueListenable: isResolved,
          builder: (context, FutureState val, _) {
            return CredioDialogScaffold(
              future: future,
              padded: !fullDialog!,
              showClose: isResolved.value != FutureState.loading,
              child: FutureBuilder(
                future: future,
                builder: (context, res) {
                  if (res.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        Timer(
                          Duration(
                              milliseconds:
                                  successMessage == null ? 500 : 3000),
                          () {
                            Navigator.of(context).pop(res.data);
                          },
                        );
                      },
                    );
                    if (successMessage == null) {
                      return DialogMessage(
                        message: "",
                        fullDialog: fullDialog,
                        messageType: MessageType.Pending,
                      );
                    }
                    return DialogMessage(
                      message: successMessage,
                      messageType: MessageType.Success,
                    );
                  }

                  if (res.hasError) {
                    if (res.error is Map &&
                        (res.error! as Map)["statusCode"] == 301) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          isResolved.value = FutureState.complete;
                        },
                      );

                      return DialogMessage.action(
                        message: parseError(res.error, errorMessage),
                        messageType: MessageType.Warning,
                        route: "",
                        action: action ?? () {},
                      );
                    }
                    WidgetsBinding.instance?.addPostFrameCallback(
                      (_) {
                        isResolved.value = FutureState.complete;
                      },
                    );

                    return DialogMessage(
                      message: parseError(res.error, errorMessage),
                      messageType: MessageType.Error,
                    );
                  }
                  return DialogMessage(
                    message: prompt,
                    messageType: MessageType.Pending,
                  );
                },
              ),
            );
          },
        ),
        onWillPop: () async => isResolved.value == FutureState.complete,
      );
    },
  );
  return result;
}
