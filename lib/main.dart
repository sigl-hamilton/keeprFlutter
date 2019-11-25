// Import MaterialApp and other widgets which we can use to quickly create a material app
import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: 'Keepr', home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  Widget _buildTodoList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
        //    return SizedBox.shrink();
      },
    );
  }

  Widget _buildTodoItem(String todoText, int index) {
    return new Card(
        child: ListTile(
            leading: FlutterLogo(),
            trailing: Icon(Icons.more_vert),
            onTap: () => _promptRemoveTodoItem(index),
            title: new Text(todoText)

        ),
        elevation: 4.0
    );
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
          return new AlertDialog(
              title: new Text('Supprimer "${_todoItems[index]}" de la liste ?'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Annuler'),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text('Supprimer'),
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
        new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(title: new Text('Ajouter un objet')),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addTodoItem(val);
              Navigator.pop(context); // Close the add todo screen
            },
            decoration: new InputDecoration(
                hintText: 'Enter le nom de l\'objet',
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        elevation: 10.0,
        title: new Text('Keepr Mobile'),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.delete),
            onPressed: () {
              _clearTodoItem();
            },
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xff280038),
                Color(0xff09203f)
              ], // Couleur de la nav bar
            ),
          ),
        ),
      ),
      body: _buildTodoList(),
      backgroundColor: Color(0xffbdbdbd),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          // pressing this button now opens the new screen
          tooltip: 'Ajouter un objet',
          child: new Icon(Icons.add)),
    );
  }
}
