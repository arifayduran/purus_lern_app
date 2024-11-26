// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyRotatingSvg extends StatefulWidget {
  final String assetPath;
  final Color color;
  final double height;

  const MyRotatingSvg({
    super.key,
    required this.assetPath,
    this.color = Colors.white,
    this.height = 20,
  });

  @override
  State<MyRotatingSvg> createState() => _MyRotatingSvgState();
}

class _MyRotatingSvgState extends State<MyRotatingSvg>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _controller.value * 2 * 3.14159,
      child: SvgPicture.asset(
        widget.assetPath,
        color: widget.color,
        height: widget.height,
        alignment: Alignment.center,
      ),
    );
  }
}
