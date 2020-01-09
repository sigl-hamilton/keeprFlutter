import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:keepr/screens/jsonget.dart';
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
  Map<String, bool> itemState;
  List<String> todoItems;
  int testing;
  bool loaded;

  @override
  void initState() {
    super.initState();
    todoItems = [];
    itemState = Map<String, bool>();
    testing = 0;
    loaded = false;
  }

  Future loadData() async {
    var a = await apiGet();
   
    for (var item in a) {
       log("hello " + item.name);
     addTodoItem(item.name + " (" + item.code + ")");
    }
   // a.map((item) => addTodoItem(item.name + " (" + item.code + ")"));
  }

  addTodoItem(String task) {
    if (task.length > 0) {
      log(task);
      // SchedulerBinding.instance.addPostFrameCallback((_) => setState(() => todoItems.add(task)));
      setState(() => todoItems.add(task));
      setState(() => itemState[task] = true);
    }
  }

  _removeTodoItem(int index) {
    setState(() => todoItems.removeAt(index));
  }

  _clearTodoItem() {
    setState(() => todoItems.clear());
    setState(() => itemState.clear());
    apiDelete();
  }

  updateTodoItem() {
    setState(() {});
  }

  getItemState(String key) {
    var res = itemState[key];
    if (res == null) return true;
    return itemState[key];
  }

  void setItemState(String key, bool value) {
    setState(() => itemState[key] = value);
  }

  startScanning() {
    addTodoItem("Objet " + testing.toString());
    setState(() {
      testing = testing + 1;
    });
  }

  Widget _buildDeviceList() {
    if (!loaded) {
      loadData();
      log("data loaded");
      setState(() => loaded = true);
    }
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
            resizeToAvoidBottomPadding: false,
            body: Column(children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: _buildDeviceList()),
              Expanded(
                  child: SensorPage(
                device: widget.device,
                addTodoItem: addTodoItem,
                getItemState: getItemState,
                setItemState: setItemState,
              ))
            ]),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.search), onPressed: () => apiDelete())));
  }
}
