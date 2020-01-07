import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:keepr/screens/nav_bar_color.dart';
import 'package:keepr/screens/rfid_object.dart';
import 'package:flutter/scheduler.dart';


class DeviceList extends StatefulWidget {
  const DeviceList({Key key, this.device});
  final BluetoothDevice device;

  @override
  createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {
  List<String> todoItems = [];
  int testing = 0;


  addTodoItem(String task) {
    if (task.length > 0) {
     // SchedulerBinding.instance.addPostFrameCallback((_) => setState(() => todoItems.add(task)));
    setState(() => todoItems.add(task));
    }
  }

  _removeTodoItem(int index) {
    setState(() => todoItems.removeAt(index));
  }

  _clearTodoItem() {
    setState(() => todoItems.clear());
  }

  startScanning() {
    addTodoItem("Objet " + testing.toString());
    setState(() {
      testing = testing + 1;
    });
  }

  Widget _buildDeviceList() {
    return todoItems.isEmpty
        ? Center(child: Text('Scannez les objets bluetooth !'))
        : ListView.builder(
            itemCount: todoItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.bluetooth_searching),
                      trailing: Icon(Icons.more_vert),
                      onTap: () => {},
                      title: Text(todoItems[index])),
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
            body: Column(children: [
              Expanded(child: _buildDeviceList()),
              Expanded(child: SensorPage(device: widget.device, addTodoItem: addTodoItem))
            ]),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.search), onPressed: () => startScanning())));
  }
}
