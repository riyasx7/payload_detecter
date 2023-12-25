import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:payload_detecter/MainScreen/Contractor/Contracter.dart';
import 'package:payload_detecter/MainScreen/PayLoaders/PayloaderPage.dart';
import 'package:payload_detecter/MainScreen/PayLoaders/QRScannerOverlay.dart';

import 'package:payload_detecter/constants/constants.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key, required this.type}) : super(key: key);
  final String type;

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool _screenOpened = false;

  @override
  void initState() {
    // TODO: implement initState
    this._screenWasClosed();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the scanner controller when the widget is disposed
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        appBar: AppBar(
          backgroundColor: bgColor,
          title: Text("Scanner",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          elevation: 0.0,
        ),
        body: Stack(
          children: [
            MobileScanner(
              allowDuplicates: false,
              controller: cameraController,
              onDetect: _foundBarcode,
            ),
            QRScannerOverlay(overlayColour: Colors.black.withOpacity(0.5))
          ],
        ));
  }

  void _foundBarcode(Barcode barcode, MobileScannerArguments? args) {
    print(barcode);
    if (!_screenOpened) {
      final String code = barcode.rawValue ?? "___";
      _screenOpened = false;
      if (widget.type == "Payloader") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PayloaderPage(storedBarcode: code)));
      }

      //here push navigation result page
      // Navigator.push(context, MaterialPageRoute(builder: (context)=> FoundScreen(value: code, screenClose: _screenWasClosed))).then((value) => print(value));

      // builder: builder) => FoundScreen(value: code, screenClose: _screenWasClosed))
    }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
