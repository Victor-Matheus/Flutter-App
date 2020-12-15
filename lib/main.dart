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
      initialRoute: 'todo',
      routes: {
        'todo': (context) => TodoPage(),
        'finance': (context) => FinancePage()
      },
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: TodoPage(),
    );
  }
}

int _selectedIndex = 0;

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final DataRepository repository = DataRepository();

  bool isLoading = false;

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

  //////////////////////////////BottomNavigation

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //_selectedIndex == 0 ? "" : Navigator.pushNamed(context, "finance");
      if (_selectedIndex == 1) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("finance", (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildTodoPage(context);
  }

  Widget _buildTodoPage(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Tarefas",
            style: TextStyle(color: Colors.white),
          ),
          toolbarHeight: 100,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: repository.getTodoStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return _buildList(context, snapshot.data.documents);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addTodoItem();
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
    isLoading = true;
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final todoItem = Item.fromSnapshot(snapshot);
    if (todoItem == null) {
      return Container();
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Dismissible(
            child: CheckboxListTile(
                title: Text(todoItem.title == null ? "" : todoItem.title),
                value: todoItem.done == null ? false : todoItem.done,
                secondary: Icon(Icons.filter_center_focus),
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    todoItem.done = value;
                    repository.updateTodoItem(todoItem);
                  });
                }),
            key: Key(todoItem.title == null ? "" : todoItem.title),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red[700].withOpacity(0.85),
              child: Stack(
                children: <Widget>[
                  Positioned(
                      right: 25,
                      top: 15,
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
            onDismissed: (direction) {
              repository.deleteTodoItem(snapshot.documentID);
              showDialog(
                  barrierColor: Color(0x00000000),
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    Future.delayed(Duration(seconds: 2), () {
                      Navigator.of(context).pop(true);
                    });
                    return AlertDialog(
                      title: Center(child: Text("Tarefa removida")),
                      backgroundColor: Colors.lightGreen[600],
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    );
                  });
            }));
  }
}
//////////////////////////////////////////////////////////////////////////////////////////////

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final DataRepository repository = DataRepository();

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

  @override
  Widget build(BuildContext context) {
    return _buildFinancePage(context);
  }

  Widget _buildFinancePage(BuildContext context) {
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;

        if (_selectedIndex == 0) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("todo", (Route<dynamic> route) => false);
        }
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Finanças",
            style: TextStyle(color: Colors.white),
          ),
          toolbarHeight: 100,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: repository.getFinanceStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return _buildList(context, snapshot.data.documents);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addFinanceItem();
          },
          tooltip: "Add FinanceItems",
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
      children:
          snapshot.map((data) => _buildListFinaceItem(context, data)).toList(),
    );
  }

  Widget _buildListFinaceItem(BuildContext context, DocumentSnapshot snapshot) {
    final financeItem = FinanceItem.fromSnapshot(snapshot);
    if (financeItem == null) {
      Container();
    }

    AlertDialogFinanceItemWidget dialogWidget = AlertDialogFinanceItemWidget();

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
              trailing: Container(
                  width: 100,
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.yellow[600],
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Atualizar gasto"),
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
                                            financeItem.value = dialogWidget
                                                        .financeItemValue ==
                                                    null
                                                ? financeItem.value
                                                : dialogWidget.financeItemValue;
                                            financeItem.title = dialogWidget
                                                        .financeItemTitle ==
                                                    null
                                                ? financeItem.title
                                                : dialogWidget.financeItemTitle;
                                            dialogWidget.financeItemTitle;

                                            repository
                                                .updateFinanceItem(financeItem);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Adicionar"))
                                    ],
                                  );
                                });
                          }),
                      IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red[700],
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Excluir gasto"),
                                    content: Text(
                                        "Tem certeza que deseja excluir este gasto ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: Text("Não")),
                                      FlatButton(
                                          onPressed: () {
                                            repository.deleteFinanceItem(
                                                snapshot.documentID);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Sim"))
                                    ],
                                  );
                                });
                          })
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////

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
            decoration: InputDecoration(hintText: "Título"),
            onChanged: (text) => widget.financeItemTitle = text,
          ),
          TextField(
              decoration: InputDecoration(hintText: "Valor"),
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
