import 'package:credio_reader/components/extensions.dart';
import 'package:flutter/material.dart';

class CredioDialogScaffold extends StatelessWidget {
  final Widget child;
  final bool showClose;
  final bool? padded;
  final Color? color;

  final Future? future;

  CredioDialogScaffold({
    required this.child,
    required this.showClose,
    required this.padded,
    this.color =  const Color(0xffB11226),
    this.future,
  });

  @override
  Widget build(BuildContext context) {
    final scaler = context.scaler;
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Container(
          margin: padded!
              ? scaler.insets.only(
                  left: 7,
                  right: 7,
                )
              : null,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              scaler.fontSizer.sp(50),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (showClose)
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                      
                        Navigator.of(context).pop(null);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(scaler.fontSizer.sp(50)),
                            bottomLeft:
                                Radius.circular(scaler.fontSizer.sp(50)),
                          ),
                        ),
                        padding: scaler.insets.all(3),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: scaler.fontSizer.sp(50),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: scaler.insets.only(
                    top: showClose ? 0 : 3,
                    bottom: 3,
                    left: 4,
                    right: 4,
                  ),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
