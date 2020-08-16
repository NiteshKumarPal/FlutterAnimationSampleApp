import 'dart:math';

import 'package:animation_app/Widgets/Cats.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;
  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -55.0, end: -102.0).animate(
      CurvedAnimation(parent: catController, curve: Curves.easeIn),
    );

    boxController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    boxAnimation = Tween(begin: 20.0, end: 35.0).animate(
      CurvedAnimation(parent: boxController, curve: Curves.easeIn),
    );

    boxController.forward();

    boxAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Animation'),
        ),
        body: GestureDetector(
          child: Center(
            child: Stack(
              overflow: Overflow.visible,
              children: [
                buildCatAnimation(),
                buildBox(),
                buildLeftFlap(),
                buildRightFlap()
              ],
            ),
          ),
          onTap: onTap,
        ));
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    }
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          left: 0.0,
          right: 0.0,
        );
      },
      child: Cats(),
    );
  }

  Widget buildBox() {
    return Container(
      width: 250,
      height: 200,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
        left: 3.0,
        child: AnimatedBuilder(
          animation: boxAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: getAngle(angle: boxAnimation.value),
              child: child,
              alignment: Alignment.topRight,
            );
          },
          child: Container(
            width: 10,
            height: 120,
            color: Colors.brown,
          ),
        ));
  }

  Widget buildRightFlap() {
    return Positioned(
        right: 3.0,
        child: AnimatedBuilder(
          animation: boxAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: getAngle(angle: -boxAnimation.value),
              child: child,
              alignment: Alignment.topLeft,
            );
          },
          child: Container(
            width: 10,
            height: 120,
            color: Colors.brown,
          ),
        ));
  }

  double getAngle({@required double angle}) {
    return angle * pi / 180;
  }
}
