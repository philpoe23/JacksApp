import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocketbase/pocketbase.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tablet App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: TabletApp(),
    );
  }
}

class TabletApp extends StatefulWidget {
  @override
  State<TabletApp> createState() => _TabletAppState();
}

class ToDoList {
  final String task;
  final bool complete;
  final String? dateCreated;

  const ToDoList(
      {required this.task, required this.complete, required this.dateCreated});
}

class _TabletAppState extends State<TabletApp> {
  final pb = PocketBase('http://203.153.232.253/jacks-app');
  List<ToDoList> toDo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    fetchRecords();
  }

  fetchRecords() async {
    final records = await pb.collection('toDoList').getFullList(
          sort: '-created',
        );

    for (var data in records) {
      setState(() {
        toDo.add(ToDoList(
            task: data.data['task'],
            complete: data.data['complete'],
            dateCreated: data.data['dateCreated']));
      });
    }

    log("Length: ${toDo.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[500],
        title: Text(
          'Kitchen app',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.account_circle),
                  onPressed: () {
                    // Perform account badge action
                  },
                ),
                Text(
                  'Nicholas Bird',
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[100],
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ListTile(title: Text("To Do"))),
                    Divider(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.72,
                      child: ListView.builder(
                        itemCount: toDo.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(toDo[index].task),
                            leading: Icon(
                              toDo[index].complete
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: toDo[index].complete
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: GridView.count(
                crossAxisCount: 4,
                children: [
                  createButton('Temperature'),
                  createButton('Daily Clean'),
                  createButton('Weekly Clean'),
                  createButton('Time Sheet'),
                  createButton('Pantry List'),
                  createButton('History'),
                  createButton('Stock'),
                  createButton('Orders'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createButton(String label) {
    return GestureDetector(
      onTap: () {
        // Navigate to the respective page
      },
      child: Card(
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
