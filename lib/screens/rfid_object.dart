import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:developer';

import 'package:flutter/scheduler.dart';
import 'package:keepr/screens/api.dart';

class SensorPage extends StatefulWidget {
  const SensorPage(
      {Key key,
      this.device,
      this.addTodoItem,
      this.getItemState,
      this.setItemState})
      : super(key: key);
  final BluetoothDevice device;
  final Function addTodoItem;
  final Function getItemState;
  final Function setItemState;

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
  final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
  bool isReady;
  Stream<List<int>> stream;
  List<double> traceDust = List();
  Map<String, bool> rfidMap;
  TextEditingController textController;



  @override
  void initState() {
    super.initState();
    isReady = false;
    rfidMap = Map<String, bool>();
    textController = TextEditingController();
    connectToDevice();
  }

  connectToDevice() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    new Timer(const Duration(seconds: 15), () {
      if (!isReady) {
        disconnectFromDevice();
        _Pop();
      }
    });

    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      _Pop();
      return;
    }

    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      _Pop();
      return;
    }

    List<BluetoothService> services = await widget.device.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            stream = characteristic.value;

            setState(() {
              isReady = true;
            });
          }
        });
      }
    });

    if (!isReady) {
      _Pop();
    }
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  void promptAddItem(String name) async {
    if (name.length > 0) {
      await Future.delayed(Duration.zero);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text(
                    'Ajouter l\'objet avec l\'UID "${name}" à la liste des objets surveillés ?'),
                content: TextField(
                  controller: textController,
                  decoration:
                      InputDecoration(hintText: "Entrez le nom de l'objet"),
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text('Annuler'),
                      onPressed: () => Navigator.of(context).pop()),
                  FlatButton(
                      child: Text('Ajouter'),
                      onPressed: () {
                        widget.addTodoItem(
                            textController.text + " (" + name + ")");
                        apiPost(textController.text, name);
                        Navigator.of(context).pop();
                      })
                ]);
          });
    }
  }

  void mySetItemState(String name, bool value) async {
    await Future.delayed(Duration.zero);
    widget.setItemState(name, value);
    return;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: !isReady
            ? Center(
                child: Text(
                  "Waiting...",
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              )
            : Container(
                child: StreamBuilder<List<int>>(
                  stream: stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.hasError)
                      return Text('Error: ${snapshot.error}');

                    if (snapshot.connectionState == ConnectionState.active) {
                      var currentValue = _dataParser(snapshot.data);
                      traceDust.add(double.tryParse(currentValue) ?? 0);
                      var id = '${currentValue}';

                      if (!rfidMap.containsKey(id)) {
                        rfidMap[id] = true;
                        promptAddItem(id);
                      } else {
                        rfidMap[id] = !rfidMap[id];
                      }

                      /* if (widget.getItemState(id) == null) {
                        mySetItemState(id,true);
                        promptAddItem(id);
                      } else {
                        mySetItemState(id,!widget.getItemState(id));
                      } */

                      log('read from bluetooth ' + id);
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Le capteur est en marche',
                              style: TextStyle(fontSize: 14)),
                            id.isEmpty
                              ? Text('Aucun objet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24))
                              : rfidMap[id]
                                  ? Text(
                                      'L\'objet (${id})\n est actuellement dans le sac',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24))
                                  : Text(
                                      'Attention, l\'objet (${id})\n n\'est plus présent dans le sac',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24))
                        ],
                      ));
                    } else {
                      return Text('Check the stream');
                    }
                  },
                ),
              ));
  }
}
