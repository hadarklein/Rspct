// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:math';

import 'package:flutter/material.dart';

class CircleAnimatorWidget extends StatefulWidget {
  const CircleAnimatorWidget({ 
    Key? key,
    required this.child,
    this.innerColor = Colors.deepOrange,
    this.outerColor = Colors.deepOrange,
    this.innerAnimation = Curves.linear,
    this.outerAnimation = Curves.linear,
    this.size = 200,
    this.innerAnimationSeconds = 30,
    this.outerAnimationSeconds = 30,
    this.reverse = true,
    this.innerSizeMultiplier = 0.85,
    this.childSizeMultiplier = 0.7,
  }) : super(key: key);

  final Color innerColor;
  final Color outerColor;
  final Curve innerAnimation;
  final Curve outerAnimation;
  final double size;
  final int innerAnimationSeconds;
  final int outerAnimationSeconds;
  final Widget child;
  final bool reverse;
  final double innerSizeMultiplier;
  final double childSizeMultiplier;

  @override
  State<CircleAnimatorWidget> createState() => _CircleAnimatorWidgetState();
}

class _CircleAnimatorWidgetState extends State<CircleAnimatorWidget> 
  with TickerProviderStateMixin {
  
  late Animation<double> innerAnimation;
  late Animation<double> outerAnimation;
  late AnimationController innerController;
  late AnimationController outerController;

  @override
  void initState() {
    super.initState();
    initAnimations();
  }

  @override
  void dispose() {
    innerController.dispose();
    outerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          outerArc(),
          innerArc(),
          childWidget()
        ],
      ),
    );
  }

  Widget outerArc() {
    return Center(
      child: RotationTransition(
        turns: outerAnimation,
        child: CustomPaint(
          painter: Arc1Painter(
            color: widget.outerColor
          ),
          child: Container(
            height: widget.size,
            width: widget.size,
          ),
        ),
      ),
    );
  }

  Widget innerArc() {
    return Center(
      child: RotationTransition(
        turns: innerAnimation,
        child: CustomPaint(
          painter: Arc2Painter(
            color: widget.innerColor
          ),
          child: Container(
            height: widget.innerSizeMultiplier * widget.size,
            width: widget.innerSizeMultiplier * widget.size,
          ),
        ),
      ),
    );
  }

  Widget childWidget() {
    return Center(
      child: Container(
        height: widget.childSizeMultiplier * widget.size,
        width: widget.childSizeMultiplier * widget.size,
        child: widget.child,
      ),
    );
  }

  void initAnimations() {
    innerController = AnimationController(
      duration: Duration(seconds: widget.innerAnimationSeconds),
      vsync: this);
    
    outerController = AnimationController(
      duration: Duration(seconds: widget.outerAnimationSeconds),
      vsync: this
    );

    innerAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: innerController, 
        curve: Interval(0.0, 1.0, curve: widget.innerAnimation)
      )
    );

    outerAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: outerController, 
        curve: Interval(0.0, 1.0, curve: widget.outerAnimation)
      )
    );

    widget.reverse ? 
      outerAnimation = ReverseAnimation(outerAnimation) : 
      outerAnimation = outerAnimation;
    
    innerController.repeat();
    outerController.repeat();
  }
}

class Arc1Painter extends CustomPainter {
  Arc1Painter({required this.color});
  
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    canvas.drawArc(rect, 0.0, 0.67 * pi, false, paint);
    canvas.drawArc(rect, 0.74 * pi, 0.65 * pi, false, paint);
    canvas.drawArc(rect, 1.46 * pi, 0.47 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc2Painter extends CustomPainter {
  Arc2Painter({required this.color});
  
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);
    canvas.drawArc(rect, 0.15, 0.9 * pi, false, paint);
    canvas.drawArc(rect, 1.05 * pi, 0.9 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}