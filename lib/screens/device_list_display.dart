import 'package:flutter/material.dart';
import 'package:keepr/screens/nav_bar_color.dart';


class DeviceListDisplay extends StatefulWidget {
  @override
  createState() => DeviceListDisplayState();
   List<String> todoItems = [];
   DeviceListDisplay({Key key, this.todoItems});
}

class DeviceListDisplayState extends State<DeviceListDisplay> {

  Widget _buildDeviceListDisplay() {
    return widget.todoItems.isEmpty
        ? Center(child: Text('Scannez les objets bluetooth !'))
        : ListView.builder(
            itemCount: widget.todoItems.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  child: ListTile(
                      leading: Icon(Icons.bluetooth_searching),
                      trailing: Icon(Icons.more_vert),
                      onTap: () => {},
                      title: Text(widget.todoItems[index])),
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
        body: _buildDeviceListDisplay(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.search), onPressed: () => (){}));
  }
}
