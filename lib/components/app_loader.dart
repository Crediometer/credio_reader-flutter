import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Apploader extends StatelessWidget {
  final Color? color;
  const Apploader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isIOS
          ? CupertinoActivityIndicator(
              radius: 15,
              color: color ?? const Color(0xffB11226),
            )
          : CircularProgressIndicator(
              color: color ?? const Color(0xffB11226),
            ),
    );
  }
}
