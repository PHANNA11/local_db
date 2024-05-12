import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:local_db/database/connect_db.dart';
import 'package:local_db/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void getDataFromDatabase() async {
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
      body: ListView.builder(
        itemCount: listUser.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(),
            title: Text(listUser[index].name.toString()),
            subtitle: Text(listUser[index].positoin.toString()),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await ConnectDB().insertUser(
              user: UserModel(
                  name: 'Kaka', gender: 'female', age: 22, positoin: 'Design'));
        },
        tooltip: 'Decrement',
        child: const Icon(Icons.add),
      ),
    );
  }
}
