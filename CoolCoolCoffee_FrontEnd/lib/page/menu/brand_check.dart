import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrandCheck extends StatelessWidget {
  final String brand;
  const BrandCheck({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(brand),
      ),
    );
  }
}
