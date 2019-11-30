import 'package:flutter/material.dart';
import 'package:keepr/screens/nav_bar_color.dart';
import 'dart:async';
import 'bt_controller.dart';

//void main() => runApp(ArduinoBT());

class ArduinoBT extends StatefulWidget {
  @override
  createState() => ArduinoBTState();
}

class ArduinoBTState extends State<ArduinoBT> {
  String sensorValue = "N/A";
  bool ledState = false;

  @override
  initState() {
    super.initState();
    //BTController.init(onData);
    scanDevices();
  }

  void onData(dynamic str) {
    setState(() {
      sensorValue = str;
    });
  }

  void switchLed() {
    setState(() {
      ledState = !ledState;
    });
    // BTController.transmit(ledState ? '0' : '1');
  }

  Future<void> scanDevices() async {
    // BTController.enumerateDevices().then((devices) {
    //    onGetDevices(devices);
    //  });
  }

  void onGetDevices(List<dynamic> devices) {
    Iterable<SimpleDialogOption> options = devices.map((device) {
      return SimpleDialogOption(
        child: Text(device.keys.first),
        onPressed: () {
          selectDevice(device.values.first);
        },
      );
    });

    SimpleDialog dialog = SimpleDialog(
      title: const Text('Choose a device'),
      children: options.toList(),
    );

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return dialog;
        });
  }

  selectDevice(String deviceAddress) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
    // BTController.connect(deviceAddress);
  }

  @override
  Widget build(BuildContext context) {
    Color color = ledState ? Colors.deepPurpleAccent : Colors.white24;
    TextTheme theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Bluetooth"),
          flexibleSpace: NavBarColor()),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Sensor Value',
                style: theme.display1.copyWith(color: Colors.white)),
            Text(sensorValue,
                style: theme.display2.copyWith(color: Colors.white)),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: color,
        onPressed: switchLed,
        tooltip: 'Increment',
        child: Icon(Icons.power_settings_new),
      ),
    );
  }
}
