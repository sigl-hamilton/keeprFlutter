import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:keepr/screens/nav_bar_color.dart';
import 'widgets.dart';

class MyBluetoothApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return DeviceList();
          }
          return BluetoothOffScreen(state: state);
        });
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue,
      backgroundColor: Color(0xff280038),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Your Bluetooth Adapter is ${state.toString().substring(15)}.\nPlease open your bluetooth on the phone !',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceList extends StatefulWidget {
  @override
  createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {
  List<String> _todoItems = [];
  FlutterBlue flutterBlue = FlutterBlue.instance;

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
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    StreamBuilder<List<ScanResult>>(
      stream: FlutterBlue.instance.scanResults,
      initialData: [],
      builder: (c, snapshot) => Column(
        children: snapshot.data.map((r) => _addTodoItem(r.toString())),
      ),
    );

    /*   _addTodoItem("start scanning");
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    //debugPrint(flutterBlue.scanResults.toString());
    flutterBlue.scanResults.listen((scanResultList) {
      scanResultList.map((scanResult) => {
            //   _addTodoItem(scanResult.device.name),
            setState(() => {_todoItems.add("value")}),
            debugPrint(scanResult.toString()),
            debugPrint("hello")
          });
    }); */
    flutterBlue.stopScan();
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

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Find Devices'),
          flexibleSpace: NavBarColor(),
        ),
        body: _buildDeviceList(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search), onPressed: () => startScanning()));
  }
}
