import 'package:flutter/material.dart';

class NavBarColor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xff280038),
            Color(0xff09203f)
          ], // Couleur de la nav bar
        ),
      ),
    );
  }
}
