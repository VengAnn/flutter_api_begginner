import 'package:flutter/material.dart';

class DetialScreen extends StatelessWidget {
  const DetialScreen({this.image, this.description, super.key});
  final String? description;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Image.network(
              "$image",
              height: 100,
            ),
            Text("$description"),
          ],
        ),
      ),
    );
  }
}
