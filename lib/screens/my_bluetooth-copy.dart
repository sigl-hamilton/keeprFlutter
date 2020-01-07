/* import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:keepr/screens/nav_bar_color.dart';
import 'dart:async';
import 'dart:convert' show utf8;

class DeviceList extends StatefulWidget {
  const DeviceList({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {
  // BLUETOOTH INFO
  final String SERVICE_UUID = "0000ffe0-0000-1000-8000-00805f9b34fb";
  final String CHARACTERISTIC_UUID = "0000ffe1-0000-1000-8000-00805f9b34fb";
  bool isReady;
  Stream<List<int>> stream;
  List<double> traceDust = List();

  @override
  void initState() {
    super.initState();
    isReady = false;
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
    try {
      await widget.device.connect();
    } catch (e) {
      widget.device.disconnect();
      await widget.device.connect();
    }

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

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) =>
            new AlertDialog(
              title: Text('Are you sure?'),
              content: Text('Do you want to disconnect device and go back?'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No')),
                new FlatButton(
                    onPressed: () {
                      disconnectFromDevice();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes')),
              ],
            ) ??
            false);
  }

  _Pop() {
    Navigator.of(context).pop(true);
  }

  String _dataParser(List<int> dataFromDevice) {
    return utf8.decode(dataFromDevice);
  }

  // DEVICE LIST-------------------------------------------------------------------------------------
  List<String> _todoItems = [];
  _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  _clearTodoItem() {
    setState(() => _todoItems.clear());
  }

  startScanning() {
    _addTodoItem("fsdf");
  }

  Widget _buildDeviceList() {
    return _todoItems.isEmpty
        ? Center(child: Text('Scannez les objets bluetooth !'))
        : ListView.builder(
            itemCount: _todoItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.bluetooth_searching),
                      trailing: Icon(Icons.more_vert),
                      onTap: () => {},
                      title: Text(_todoItems[index])),
                  elevation: 4.0);
            },
          );
  }

  Widget _sensor() {
    return StreamBuilder<List<int>>(
                        stream: stream,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<int>> snapshot) {
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            var currentValue = _dataParser(snapshot.data);
                            traceDust.add(double.tryParse(currentValue) ?? 0);

                           Timer _timer = new Timer(const Duration(milliseconds: 600), () {_addTodoItem('${currentValue}');
                            });
                    
                          
                            return Text('${currentValue}');
                          } else {
                            return Text('Check the stream');
                          }
                        },
                      )
  }

 

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Find Devices'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _clearTodoItem();
                },
              )
            ],
            flexibleSpace: NavBarColor(),
          ),
          body: Container(
              child: !isReady
                  ? Center(
                      child: Text(
                        "Waiting...",
                        style: TextStyle(fontSize: 24, color: Colors.red),
                      ),
                    )
                  : Column(children: <Widget>[
                      Expanded(child: _buildDeviceList()),
                      Expanded(
                          child: )
                    ])),
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.search), onPressed: () => startScanning())),
    );
  }
}
 */