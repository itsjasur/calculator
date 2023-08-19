import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class MyTap extends StatefulWidget {
  final Widget child;
  final Function? onTap;

  const MyTap({super.key, required this.child, this.onTap});

  @override
  State<MyTap> createState() => _MyTapState();
}

class _MyTapState extends State<MyTap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100))
      ..addListener(() {
        setState(() {});
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap!();
      },
      onTapDown: (details) {
        // Vibration.vibrate(duration: 50, amplitude: 355);
        _controller.forward();
      },
      onTapUp: (details) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: Transform.scale(
        scale: _scaleAnimation.value,
        child: widget.child,
      ),
    );
  }
}
