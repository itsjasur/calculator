import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class MyTap extends StatefulWidget {
  final Widget child;
  final Function? onTap;
  final Function? onLongPress;
  final double borderRadius;

  const MyTap({super.key, required this.child, this.onTap, this.borderRadius = 0, this.onLongPress});

  @override
  State<MyTap> createState() => _MyTapState();
}

class _MyTapState extends State<MyTap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  Timer? _longPressTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 50))
      ..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(_controller);
  }

  void _startLongPressAction() {
    if (widget.onLongPress != null) {
      _longPressTimer = Timer.periodic(const Duration(milliseconds: 130), (timer) {
        Vibration.vibrate(duration: 10, amplitude: 50);
        widget.onLongPress!();
      });
    }
  }

  void _stopLongPressAction() {
    _longPressTimer?.cancel();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.white10,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: () {
          Vibration.vibrate(duration: 10, amplitude: 50);
          if (widget.onTap != null) widget.onTap!();
        },
        // onLongPress: _startLongPressAction,
        onTapDown: (details) {
          _controller.forward();
          _startLongPressAction();
        },
        onTapUp: (details) {
          _stopLongPressAction();
          _controller.reverse();
        },
        onTapCancel: () {
          _stopLongPressAction();
          _controller.reverse();
        },
        child: widget.child,
      ),
    );
  }
}
