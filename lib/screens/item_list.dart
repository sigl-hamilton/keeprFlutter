import 'package:flutter/material.dart';
import 'package:keepr/screens/flutter_blue_app.dart';
import 'package:keepr/screens/nav_bar_color.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Keepr', home: ItemList());
  }
}

class ItemList extends StatefulWidget {
  @override
  createState() => ItemListState();
}

class ItemListState extends State<ItemList> {
  List<String> _todoItems = [];

  Widget _buildItemList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
        //    return SizedBox.shrink();
      },
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return Card(
        child: ListTile(
            leading: FlutterLogo(),
            trailing: Icon(Icons.more_vert),
            onTap: () => _promptRemoveTodoItem(index),
            title: Text(todoText)),
        elevation: 4.0);
  }

// Instead of autogenerating a todo item, _addTodoItem now accepts a string
  void _addTodoItem(String task) {
    // Only add the task if the user actually entered something
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
    }
  }

  // Much like _addTodoItem, this modifies the array of todo strings and
// notifies the app that the state has changed by using setState
  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  void _clearTodoItem() {
    setState(() => _todoItems.clear());
  }

// Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Supprimer "${_todoItems[index]}" de la liste ?'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Annuler'),
                    onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                    child: Text('Supprimer'),
                    onPressed: () {
                      _removeTodoItem(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    Navigator.of(context).push(
        // MaterialPageRoute will automatically animate the screen entry, as well
        // as adding a back button to close it
        MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Ajouter un objet'),
            flexibleSpace: NavBarColor()
          ),
          body: TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: InputDecoration(
                hintText: 'Enter le nom de l\'objet',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 10.0,
          title: Text('Keepr Mobile'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _clearTodoItem();
              },
            )
          ],
          flexibleSpace: NavBarColor()
        ),
        body: _buildItemList(),
        backgroundColor: Color(0xffbdbdbd),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                      heroTag: 'fab1',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FlutterBlueApp()));
                      },
                      tooltip: 'Bluetooth',
                      child: Icon(Icons.bluetooth_connected),
                      backgroundColor: Colors.deepPurple),
                  RaisedButton(
                    onPressed: () {},
                    elevation: 5,
                    color: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    child: Text('Scanner les objets'),
                  ),
                  FloatingActionButton(
                      heroTag: 'fab2',
                      onPressed: _pushAddTodoScreen,
                      tooltip: 'Ajouter un objet',
                      child: Icon(Icons.add),
                      backgroundColor: Color(0xff09203f)),
                ])),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }
}
