import 'package:credio_reader/components/app_loader.dart';
import 'package:credio_reader/components/dimensions.dart';
import 'package:credio_reader/components/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum MessageType {
  Error,
  Warning,
  Success,
  Info,
  Pending,
}

class DialogMessage extends StatelessWidget {
  final dynamic message;
  final MessageType messageType;
  final String? route;
  final TextAlign textAlign;
  final bool? fullDialog;
  final bool _isConfirm;
  final bool _isAction;
  final Color? color;
  final VoidCallback? action;

  DialogMessage({
    required this.message,
    this.messageType = MessageType.Info,
    this.fullDialog,
    this.textAlign = TextAlign.center,
    this.route,
    this.color,
  })  : _isConfirm = false,
        action = null,
        _isAction = false;

  DialogMessage.confirm({
    required this.message,
    this.messageType = MessageType.Info,
    this.textAlign = TextAlign.center,
    this.color,
    required this.route,
  })  : _isConfirm = true,
        fullDialog = false,
        action = null,
        _isAction = false;
  DialogMessage.action({
    required this.message,
    required this.action,
    this.color,
    this.messageType = MessageType.Warning,
    this.textAlign = TextAlign.center,
    required this.route,
  })  : _isAction = true,
        fullDialog = false,
        _isConfirm = false;
  String _parsedMessage() {
    if (message is String) {
      return message;
    } else if (message is Map || message is List) {
      final List<String> messageArr = message is Map
          ? message.values.map((it) => "$it").toList()
          : message.map((it) => "$it").toList();
      return messageArr.join("; ");
    } else {
      return "";
    }
  }

  Widget _messageIcon() {
    switch (messageType) {
      case MessageType.Error:
        return Icon(
          Icons.error_outline,
          size: 30,
          color: const Color(0xFFF35656),
        );
      case MessageType.Success:
        return Icon(
          Icons.sentiment_satisfied,
          size: 30,
          color: const Color(0xFF4CAF50),
        );
      case MessageType.Warning:
        return Icon(
          Icons.warning,
          size: 30,
          color: Color(0xFFF35656).withGreen(100),
        );
      case MessageType.Pending:
        return Apploader(color: color);
      default:
        return Icon(
          Icons.notifications,
          size: 30,
          color: Colors.black,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return (messageType == MessageType.Pending && (fullDialog ?? false))
        ? ScaleTransitionWidget()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: _isConfirm || _isAction
                ? CrossAxisAlignment.stretch
                : CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (!_isConfirm) _messageIcon(),
              SizedBox(
                height: CredioScaleUtil(context).sizer.setHeight(
                      1,
                    ),
              ),
              Flexible(
                child: message is Widget
                    ? message
                    : Text(
                        _parsedMessage(),
                        textAlign: TextAlign.center,
                      ),
              ),
              if (_isConfirm || _isAction)
                SizedBox(
                  height: CredioScaleUtil(context).sizer.setHeight(3),
                ),
              if (_isConfirm)
                ElevatedButton(
                  child: Text("Proceed"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              if (_isAction)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text("Cancel"),
                        // textColor: CredioColors.white,
                        // color: CredioColors.darkGrey,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    SizedBox(
                      width: CredioScaleUtil(context).sizer.setWidth(2.5),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text("Proceed"),
                        // color: CredioColors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                          action!();
                        },
                      ),
                    ),
                  ],
                )
            ],
          );
  }
}

class ScaleTransitionWidget extends StatefulWidget {
  @override
  _ScaleTransitionWidgetState createState() => _ScaleTransitionWidgetState();
}

class _ScaleTransitionWidgetState extends State<ScaleTransitionWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(
          milliseconds: 2000,
        ),
        vsync: this,
        value: 0.1,
        lowerBound: 0,
        upperBound: 1);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.repeat(reverse: true);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaler = context.scaler;
    return Container(
      color: Colors.white,
      height: scaler.sizer.height,
      width: scaler.sizer.width,
      child: ScaleTransition(
        scale: _animation,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/wine_logo.svg",
              height: scaler.sizer.setHeight(10),
              width: scaler.sizer.setHeight(10),
            ),
          ],
        ),
      ),
    );
  }
}
