import 'package:flutter/material.dart';

class SwipeWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<double>? onChange;
  final ValueChanged<double>? onActionPerformed;
  final Function(double, double, double)? onButtonTap;

  SwipeWidget({
    required this.child,
    this.onChange,
    this.onButtonTap,
    this.onActionPerformed,
    Key? key,
  }) : super(key: key);

  @override
  _SwipeWidgetState createState() => _SwipeWidgetState();
}

// final swipeWidgetKey = GlobalKey<_SwipeWidgetState>();
class _SwipeWidgetState extends State<SwipeWidget> {
  final ValueNotifier<double> offsetXNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> offsetYNotifier = ValueNotifier(0.0);
  final ValueNotifier<double> rotationNotifier = ValueNotifier(0.0);

  // double offsetY = 0.0;
  // double rotation = 0.0;

  void onPanUpdate(DragUpdateDetails details) {
    offsetXNotifier.value += details.delta.dx;
    offsetYNotifier.value += details.delta.dy;
    rotationNotifier.value += (details.delta.dx * 0.0005);
    if (widget.onChange != null) widget.onChange!(offsetXNotifier.value);
  }

  void onPanEnd(DragEndDetails details) {
    if (offsetXNotifier.value > 220) {
      // Dismiss to the right
    } else if (offsetXNotifier.value < -220) {
      // Dismiss to the left
    }
    if (widget.onActionPerformed != null)
      widget.onActionPerformed!(offsetXNotifier.value);
    offsetXNotifier.value = 0.0;
    offsetYNotifier.value = 0.0;
    rotationNotifier.value = 0.0;
  }

  void performTransition(bool vl) async {
    offsetXNotifier.value = vl ? 100.0 : -100.0;
    offsetYNotifier.value = vl ? 50.0 : -50.0;
    rotationNotifier.value = vl ? 0.1 : -0.1;

    // reset values
    await Future.delayed(Duration(milliseconds: 100));
    offsetXNotifier.value = 0.0;
    offsetYNotifier.value = 0.0;
    rotationNotifier.value = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: ValueListenableBuilder<double>(
        valueListenable: offsetXNotifier,
        builder: (context, offsetX, child) {
          return Transform.rotate(
            angle: rotationNotifier.value,
            child: Transform.translate(
              offset: Offset(offsetX, 0),
              // offset: Offset(offsetXNotifier.value, offsetY),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(offsetX == 0 ? 0 : 10),
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    offsetXNotifier.dispose();
    offsetYNotifier.dispose();
    rotationNotifier.dispose();
    super.dispose();
  }
}

class SwipeWidgetController with ChangeNotifier {
  double get offsetX => offsetX;
  double _offsetX = 0.0;

  double get offsetY => offsetY;
  double _offsetY = 0.0;

  double get rotation => rotation;
  double _rotation = 0.0;

  double get opacity => opacity;
  double _opacity = 0.0;

  void updateVls(DragUpdateDetails details) {
    _offsetX += details.delta.dx;
    _offsetY += details.delta.dy;
    _rotation += (details.delta.dx * 0.0005);

    double temp =
        _offsetX.isNegative ? (_offsetX * -0.005) : (_offsetX * 0.005);
    _opacity = temp.clamp(0.0, 1.0);
    notifyListeners();
  }

  void resetVls() {
    _offsetX = 0.0;
    _offsetY = 0.0;
    _rotation = 0.0;
    notifyListeners();
  }
}
