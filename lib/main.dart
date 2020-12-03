import 'package:TodoApp/models/financeItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'repository/dataRepository.dart';
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
  // var items = new List<Item>();
  // var financeItems = new List<FinanceItem>();
  // /////////////////////////////////////////
  // final DataRepository repository = DataRepository();

  // void content() {}

  // HomePage() {
  //   //var item = snapshot.map((value) => value.)
  //   items = [];
  //   items.add(Item("Tarefa de Cálculo", done: true));
  //   items.add(Item("Aprender Dart", done: true));
  //   items.add(Item("Limpar a casa", done: false));
  //   ////////////////////////////////////////////////////////////
  //   financeItems = [];
  //   financeItems.add(FinanceItem("Prestação do carro", 800));
  //   financeItems.add(FinanceItem("Roupas", 150));
  //   financeItems.add(FinanceItem("Comida", 400));
  // }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //var newTaskController = TextEditingController();
  final DataRepository repository = DataRepository();

  void _addTodoItem() {
    AlertDialogTodoWidget dialogWidget = AlertDialogTodoWidget();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Adicionar Tarefa"),
            content: dialogWidget,
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                  onPressed: () {
                    Item newItem = Item(dialogWidget.todoItem);
                    repository.addTodoItem(newItem);
                    Navigator.of(context).pop();
                  },
                  child: Text("Adicionar"))
            ],
          );
        });
  }

  void _addFinanceItem() {
    AlertDialogFinanceItemWidget dialogWidget = AlertDialogFinanceItemWidget();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Adicionar Gasto"),
            content: dialogWidget,
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              FlatButton(
                  onPressed: () {
                    FinanceItem newFinanceItem = FinanceItem(
                        dialogWidget.financeItemTitle,
                        dialogWidget.financeItemValue);
                    repository.addFinanceItem(newFinanceItem);
                    Navigator.of(context).pop();
                  },
                  child: Text("Confirmar"))
            ],
          );
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
    return _buildHome(context);
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(
  //         _selectedIndex == 0 ? "Lista de Tarefas" : "Suas Finanças",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     ),
  //     body: _selectedIndex == 0
  //         ? StreamBuilder<QuerySnapshot>(
  //             stream: repository.getTodoStream(),
  //             builder: (context, snapshot) {
  //               if (!snapshot.hasData) return LinearProgressIndicator();
  //               //HomePage(context, snapshot.data.documents);
  //               return ListView.builder(
  //                 itemCount: snapshot.data.documents.length,
  //                 itemBuilder: (BuildContext ctx, int index) {
  //                   final item = snapshot.data.documents[index];
  //                   return CheckboxListTile(
  //                     title: Text(item.data.toString()),
  //                   );
  //                 },
  //               );
  //             })
  //         // ? ListView.builder(
  //         //     itemCount: widget.items.length,
  //         //     itemBuilder: (BuildContext ctx, int index) {
  //         //       final item = widget.items[index];
  //         //       return CheckboxListTile(
  //         //         title: Text(item.title),
  //         //         key: Key(item.title),
  //         //         value: item.done,
  //         //         onChanged: (value) {
  //         //           setState(() {
  //         //             item.done = value;
  //         //           });
  //         //         },
  //         //       );
  //         //     },
  //         //   )
  //         : ListView.builder(
  //             itemCount: widget.financeItems.length,
  //             itemBuilder: (BuildContext ctx, int index) {
  //               final financeitem = widget.financeItems[index];
  //               return Center(
  //                   child: Card(
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     ListTile(
  //                       leading: Icon(Icons.monetization_on_outlined),
  //                       title: Text(financeitem.title),
  //                       subtitle: Text(financeitem.value.toString()),
  //                     ),
  //                     ButtonBar(
  //                       //overflowDirection: VerticalDirection.down,
  //                       children: <Widget>[
  //                         FlatButton(
  //                           child: Icon(Icons.edit),
  //                           onPressed: () {},
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //                 color: Colors.white,
  //                 shadowColor: Colors.grey[850],
  //               ));
  //             }),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: add,
  //       child: Icon(Icons.add),
  //       backgroundColor: Colors.green,
  //     ),
  //     bottomNavigationBar: BottomNavigationBar(
  //       items: const <BottomNavigationBarItem>[
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.track_changes),
  //             label: 'Tarefas',
  //             backgroundColor: Colors.white),
  //         BottomNavigationBarItem(
  //             icon: Icon(Icons.attach_money), label: 'Finança')
  //       ],
  //       currentIndex: _selectedIndex,
  //       selectedItemColor: Colors.lightBlue,
  //       onTap: _onItemTapped,
  //     ),
  //   );
  // }

  Widget _buildHome(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_selectedIndex == 0 ? "Tarefas" : "Meus gastos"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _selectedIndex == 0
              ? repository.getTodoStream()
              : repository.getFinanceStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();

            return _buildList(context, snapshot.data.documents);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _selectedIndex == 0 ? _addTodoItem() : _addFinanceItem();
          },
          tooltip: "Add Items",
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
        ));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot
          .map((data) => _selectedIndex == 0
              ? _buildListItem(context, data)
              : _buildListFinaceItem(context, data))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final todoItem = Item.fromSnapshot(snapshot);
    if (todoItem == null) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Expanded(child: Text(todoItem.title == null ? "" : todoItem.title)),
            Icon(Icons.today)
          ],
        ),
      ),
    );
  }

  Widget _buildListFinaceItem(BuildContext context, DocumentSnapshot snapshot) {
    final financeItem = FinanceItem.fromSnapshot(snapshot);
    if (financeItem == null) {
      Container();
    }
    return Container(
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.monetization_on_outlined),
              title: Text(financeItem.title == null ? "" : financeItem.title),
              subtitle: Text(financeItem.value == null
                  ? ""
                  : financeItem.value.toString()),
            )
          ],
        ),
      ),
    );
  }
}

class AlertDialogTodoWidget extends StatefulWidget {
  String todoItem;

  @override
  _AlertDialogTodoWidgetState createState() => _AlertDialogTodoWidgetState();
}

class _AlertDialogTodoWidgetState extends State<AlertDialogTodoWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Título da Tarefa"),
            onChanged: (text) => widget.todoItem = text,
          ),
        ],
      ),
    );
  }
}

class AlertDialogFinanceItemWidget extends StatefulWidget {
  String financeItemTitle;
  double financeItemValue;

  @override
  _AlertDialogFinanceItemWidgetState createState() =>
      _AlertDialogFinanceItemWidgetState();
}

class _AlertDialogFinanceItemWidgetState
    extends State<AlertDialogFinanceItemWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          TextField(
            autofocus: true,
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Título"),
            onChanged: (text) => widget.financeItemTitle = text,
          ),
          TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Valor"),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onChanged: (numb) =>
                  widget.financeItemValue = double.parse(numb)),
        ],
      ),
    );
  }
}
