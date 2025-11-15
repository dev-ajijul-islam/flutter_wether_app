import 'dart:ui';

import 'package:flutter/material.dart';

class BlurBg extends StatelessWidget {
   const BlurBg({super.key, required this.child,this.padding});

  final Widget child;
  final EdgeInsets ? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
        child: Container(
          padding: padding?? EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          decoration: BoxDecoration(color: Colors.white24),
          child: child,
        ),
      ),
    );
  }
}
