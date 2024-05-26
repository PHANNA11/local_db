import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_db/database/connect_db.dart';
import 'package:local_db/model/user_model.dart';
import 'package:local_db/screen/add_user_sceen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Database'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserModel> listUser = [];
  Future<void> getDataFromDatabase() async {
    await ConnectDB().getUsers().then((value) {
      setState(() {
        listUser = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
          onRefresh: getDataFromDatabase,
          child: ListView.builder(
            itemCount: listUser.length,
            itemBuilder: (context, index) {
              return ListTile(
                onLongPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddEdiitUser(
                          userModel: listUser[index],
                        ),
                      ));
                },
                leading: CircleAvatar(
                  backgroundImage:
                      FileImage(File(listUser[index].image.toString())),
                ),
                title: Text(listUser[index].name.toString()),
                subtitle: Text(listUser[index].positoin.toString()),
                trailing: IconButton(
                    onPressed: () async {
                      await ConnectDB()
                          .deleteUser(id: listUser[index].id!)
                          .then((value) {
                        getDataFromDatabase();
                      });
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEdiitUser(),
              ));
        },
        tooltip: 'Decrement',
        child: const Icon(Icons.add),
      ),
    );
  }
}
