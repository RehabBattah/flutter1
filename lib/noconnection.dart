import 'package:flutter/material.dart';

class NoConnectoin extends StatelessWidget {
  const NoConnectoin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator(),),);
  }
}
