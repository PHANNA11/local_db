import 'package:flutter/material.dart';

import '../database/connect_db.dart';
import '../model/user_model.dart';

class AddEdiitUser extends StatefulWidget {
  AddEdiitUser({super.key, this.userModel});
  UserModel? userModel;

  @override
  State<AddEdiitUser> createState() => _AddEdiitUserState();
}

class _AddEdiitUserState extends State<AddEdiitUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController positoinController = TextEditingController();

  void initData() {
    setState(() {
      nameController.text = widget.userModel!.name.toString();
      genderController.text = widget.userModel!.gender.toString();
      ageController.text = widget.userModel!.age.toString();
      positoinController.text = widget.userModel!.positoin.toString();
    });
  }

  void clearData() {
    nameController.text = '';
    genderController.text = '';
    ageController.text = '';
    positoinController.text = '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.userModel == null) {
      clearData();
    } else {
      initData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: genderController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'gender'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'age'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: positoinController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: 'positoin'),
            ),
          )
        ],
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () async {
          if (widget.userModel == null) {
            await ConnectDB()
                .insertUser(
                    user: UserModel(
                        name: nameController.text,
                        gender: genderController.text,
                        age: int.parse(ageController.text),
                        positoin: positoinController.text))
                .whenComplete(() {
              Navigator.pop(context);
            });
          } else {
            await ConnectDB()
                .updateUser(
                    user: UserModel(
                        name: nameController.text,
                        gender: genderController.text,
                        age: int.parse(ageController.text),
                        positoin: positoinController.text),
                    id: widget.userModel!.id!)
                .whenComplete(() {
              Navigator.pop(context);
            });
          }
        },
        child: Container(
          height: 50,
          width: double.infinity,
          color: Colors.blue,
          child: const Center(
            child: Text(
              'save',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
