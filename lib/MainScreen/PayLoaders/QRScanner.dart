import 'package:flutter/material.dart';
import 'package:payload_detecter/MainScreen/Contractor/drawer_menu.dart';

import 'package:payload_detecter/MainScreen/PayLoaders/scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key, required this.type});
  final String type;

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerMenu(),
      body: Center(
        child: ElevatedButton(
          child: Text("scan Qr"),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Scanner(type:widget.type,)));
          },
        ),
      ),
    );
  }
}
