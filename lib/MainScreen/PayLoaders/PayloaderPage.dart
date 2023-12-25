import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payload_detecter/AuthenticationPage/component/radial_painter.dart';
import 'package:payload_detecter/MainScreen/Contractor/drawer_menu.dart';

import 'package:payload_detecter/constants/constants.dart';

class PayloaderPage extends StatefulWidget {
  const PayloaderPage({super.key, required this.storedBarcode});
  final String storedBarcode;
  @override
  State<PayloaderPage> createState() => _PayloaderPageState();
}

class _PayloaderPageState extends State<PayloaderPage> {

  bool isclick = false;
  bool start = false;
  double percentage = 0;
  double weight = 0;
  String Load = "No Load";
  String trainId = "";
  String WagonId = "";
  bool Allignment = false;
  double WagonWeight = 0;
  double Capacity = 0;
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> getliveFromServer() async {
    while (start) {
      try {
        final response = await http.get(Uri.parse(
            'http://${widget.storedBarcode}:5000/stream_weight')); //130.0.8.65
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          setState(() {
            // return jsonify({'weight': weight,'max_weight':max_weight, 'wegan_id': wegan_id,'train_no':train_no,'percent':percent,'streaming':streaming,'align':align}),200
            Capacity = data['max_weight'];
            percentage = data['percent'];
            weight = data['weight'];
            trainId = data['train_no'];
            WagonId = data['wegan_id'];
            WagonWeight = data['wagon_weight'];
            Allignment = data['align'];
            if (weight > Capacity) {
              Load = "overload";
            } else if (weight < Capacity - 0.10) {
              Load = "underload";
            } else {
              Load = "ExactLoad";
            }
            isclick = false;
          });
        }
      } catch (error) {
        setState(() {
          percentage = 0;
          WagonWeight = 0;
          weight = 0;
          Allignment = false;
          isclick = false;
          Load = "No Load";
          WagonId = "";
          trainId = "";
          start = false;
        });

        print(error);
        print(widget.storedBarcode);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back))
        ],
      ),
      drawer: DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: height,
            padding: const EdgeInsets.all(appPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'find while loading ',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Train Id: $trainId',
                        style: const TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: appPadding,
                ),
                Container(
                  margin: const EdgeInsets.all(appPadding),
                  padding: const EdgeInsets.all(appPadding),
                  height: 330,
                  child: CustomPaint(
                    foregroundPainter: RadialPainter(
                      bgColor: textColor.withOpacity(0.1),
                      lineColor: percentage > 100 ? Colors.red : primaryColor,
                      percent: percentage > 100
                          ? (percentage / 100) - 100
                          : percentage / 100,
                      width: 18.0,
                    ),
                    child: Center(
                      child: isclick
                          ? const CircularProgressIndicator()
                          : Text(
                              "${percentage.toStringAsFixed(1)}%",
                              style: const TextStyle(
                                  color: textColor,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ),
                Text("WagonId : ${WagonId}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text("WagonWeight : ${WagonWeight}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text("WagonCapacity : ${Capacity}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Alignment :${Allignment ? "Correctly Aligned" : "not Aligned"}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Allignment ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  " Weight : ${weight.toString()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text("Load : ${Load}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text("WagonId : ${WagonId}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                Text("WagonWeight : ${WagonWeight}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: primaryColor,
                      size: 10,
                    ),
                    const SizedBox(
                      width: appPadding / 2,
                      height: 70,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          start = true;
                          isclick = true;
                          getliveFromServer();
                        });
                      },
                      child: Text(
                        'start',
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
