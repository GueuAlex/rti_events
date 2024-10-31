import 'package:flutter/material.dart';
import 'package:rti_events/config/app_text.dart';

class ScanHistory extends StatelessWidget {
  static const routeName = '/scan_history';
  const ScanHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: AppText.normal('historique'),
      ),
    );
  }
}
