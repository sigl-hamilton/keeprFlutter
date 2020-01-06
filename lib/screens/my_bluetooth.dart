import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:keepr/screens/nav_bar_color.dart';
import 'package:keepr/screens/rfid_object.dart';

class DeviceList extends StatefulWidget {
  const DeviceList({Key key, this.device});
  final BluetoothDevice device;

  @override
  createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {
  List<String> _todoItems = [];
  int testing = 0;


  addTodoItem(String task) {
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
    addTodoItem("Objet " + testing.toString());
    setState(() {
      testing = testing + 1;
    });
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
                      // A essayer de remonter dans le parent
                      //  disconnectFromDevice();
                      Navigator.of(context).pop(true);
                    },
                    child: new Text('Yes')),
              ],
            ) ??
            false);
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Find Devices'),
              flexibleSpace: NavBarColor(),
            ),
            body: Column(children: [
              Expanded(child: _buildDeviceList()),
              Expanded(
                  child: SensorPage(
                      device: widget.device, addTodoItem: addTodoItem))
            ]),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.search), onPressed: () => startScanning())));
  }
}
