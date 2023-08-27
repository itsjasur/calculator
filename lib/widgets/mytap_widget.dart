import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class MyTap extends StatefulWidget {
  final Widget child;
  final Function? onTap;
  final double borderRadius;

  const MyTap({super.key, required this.child, this.onTap, this.borderRadius = 0});

  @override
  State<MyTap> createState() => _MyTapState();
}

class _MyTapState extends State<MyTap> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 50))
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
    return Transform.scale(
      scale: _scaleAnimation.value,
      child: InkWell(
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.white10,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        onTap: () {
          Vibration.vibrate(duration: 10, amplitude: 200);
          if (widget.onTap != null) widget.onTap!();
        },
        onTapDown: (details) {
          _controller.forward();
        },
        onTapUp: (details) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: widget.child,
      ),
    );
  }
}
