//import 'dart:html';

import 'package:flutter/material.dart';

import 'models/item.dart';
//import 'package:flutter/cupertino.dart; --> IOS
//imoprt 'package:flutter/widget.dart; --> Generic

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = new List<Item>();
  var financeItems = new List<Item>();

  HomePage() {
    items = [];
    items.add(Item(title: "Tarefa de Cálculo", done: true));
    items.add(Item(title: "Aprender Dart", done: true));
    items.add(Item(title: "Limpar a casa", done: false));
  }

  FinanceList() {
    financeItems = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskController = TextEditingController();

  void add() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.send),
                    hintText: 'Informe a tarefa',
                    fillColor: Colors.lightBlue,
                  ),
                  controller: newTaskController,
                  onSubmitted: (value) {
                    setState(() {
                      widget.items.add(
                          Item(title: newTaskController.text, done: false));
                      newTaskController.clear();
                    });
                  },
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      widget.items.add(
                          Item(title: newTaskController.text, done: false));
                      newTaskController.clear();
                    });
                  },
                  child: Text("Pronto"),
                  color: Colors.green,
                )
              ],
            ),
            height: 1000,
          );
        });

    // setState(() {
    //   widget.items.add(Item(title: newTaskController.text, done: false));
    //   newTaskController.clear();
    // });
  }

  void removeTask(int index) {
    setState(() {
      widget.items.removeAt(index);
    });
  }

  //////////////////////////////BottomNavigation
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0 ? "Lista de Tarefas" : "Suas Finanças",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _selectedIndex == 0
          ? ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (BuildContext ctx, int index) {
                final item = widget.items[index];
                return CheckboxListTile(
                  title: Text(item.title),
                  key: Key(item.title),
                  value: item.done,
                  onChanged: (value) {
                    setState(() {
                      item.done = value;
                    });
                  },
                );
              },
            )
          : ListView.builder(itemBuilder: (BuildContext ctx, int index) {}),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Tarefas',
              backgroundColor: Colors.white),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: 'Finança')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue,
        onTap: _onItemTapped,
      ),
    );
  }
}
