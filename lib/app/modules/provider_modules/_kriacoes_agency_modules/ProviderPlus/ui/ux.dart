import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pulse extends StatefulWidget {
  final Key? key;
  final Widget? child;
  final Duration? duration;
  final Duration? delay;
  final bool? infinite;
  final Function(AnimationController)? controller;
  final bool? manualTrigger;
  final bool? animate;

  Pulse(
      {this.key,
        this.child,
        this.duration = const Duration(milliseconds: 1000),
        this.delay = const Duration(milliseconds: 0),
        this.infinite = false,
        this.controller,
        this.manualTrigger = false,
        this.animate = true})
      : super(key: key) {
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  _PulseState createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool disposed = false;
  late Animation<double> animationInc;
  late Animation<double> animationDec;
  @override
  void dispose() {
    disposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);

    animationInc = Tween<double>(begin: 1, end: 1.5).animate(CurvedAnimation(
        parent: controller, curve: Interval(0, 0.5, curve: Curves.easeOut)));

    animationDec = Tween<double>(begin: 1.5, end: 1).animate(CurvedAnimation(
        parent: controller, curve: Interval(0.5, 1, curve: Curves.easeIn)));

    if (!widget.manualTrigger! && widget.animate!) {
      Future.delayed(widget.delay!, () {
        if (!disposed) {
          (widget.infinite!) ? controller.repeat() : controller.forward();
        }
      });
    }

    if (widget.controller is Function) {
      widget.controller!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate! && widget.delay!.inMilliseconds == 0) {
      controller.forward();
    }

    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext? context, Widget? child) {
          return Transform.scale(
            scale: (controller.value < 0.5)
                ? animationInc.value
                : animationDec.value,
            child: widget.child,
          );
        });
  }
}

class ElasticIn extends StatefulWidget {
  final Key? key;
  final Widget? child;
  final Duration? duration;
  final Duration? delay;
  final Function(AnimationController)? controller;
  final bool? manualTrigger;
  final bool? animate;

  ElasticIn(
      {this.key,
        this.child,
        this.duration = const Duration(milliseconds: 1000),
        this.delay = const Duration(milliseconds: 0),
        this.controller,
        this.manualTrigger = false,
        this.animate = true})
      : super(key: key) {
    if (manualTrigger == true && controller == null) {
      throw FlutterError('If you want to use manualTrigger:true, \n\n'
          'Then you must provide the controller property, that is a callback like:\n\n'
          ' ( controller: AnimationController) => yourController = controller \n\n');
    }
  }

  @override
  _ElasticInState createState() => _ElasticInState();
}

class _ElasticInState extends State<ElasticIn>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  bool disposed = false;
  late Animation<double> bouncing;
  late Animation<double> opacity;
  @override
  void dispose() {
    disposed = true;
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: widget.duration, vsync: this);

    opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Interval(0, 0.45)));

    bouncing = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut));

    if (!widget.manualTrigger! && widget.animate!) {
      Future.delayed(widget.delay!, () {
        if (!disposed) {
          controller.forward();
        }
      });
    }

    if (widget.controller is Function) {
      widget.controller!(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate! && widget.delay!.inMilliseconds == 0) {
      controller.forward();
    }

    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext? context, Widget? child) {
          return Transform.scale(
            scale: bouncing.value,
            child: Opacity(
              opacity: opacity.value,
              child: widget.child,
            ),
          );
        });
  }
}
