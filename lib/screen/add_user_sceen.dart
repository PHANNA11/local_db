import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  File? image;

  void initData() {
    setState(() {
      nameController.text = widget.userModel!.name.toString();
      genderController.text = widget.userModel!.gender.toString();
      ageController.text = widget.userModel!.age.toString();
      positoinController.text = widget.userModel!.positoin.toString();
      image = File(widget.userModel!.image.toString());
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => pickImageDialog(),
                );
              },
              child: Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    image: image == null
                        ? const DecorationImage(
                            // fit: BoxFit.cover,
                            image: AssetImage('assets/image/empty_image.png'))
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(image!.path))),
                    color: Colors.white),
              ),
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
                        positoin: positoinController.text,
                        image: image!.path))
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
                        positoin: positoinController.text,
                        image: image!.path),
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

  Widget pickImageDialog() {
    return AlertDialog(
      backgroundColor: Colors.white, //#008000
      content: SizedBox(
          height: 150,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                onTap: () async {
                  pickImageData(source: ImageSource.camera);
                },
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
              ),
              ListTile(
                onTap: () async {
                  pickImageData(source: ImageSource.gallery);
                },
                leading: const Icon(Icons.image),
                title: const Text('Gallaey'),
              ),
            ],
          )),
    );
  }

  Future<void> pickImageData({required ImageSource source}) async {
    var getImage = await ImagePicker().pickImage(source: source);
    setState(() {
      image = File(getImage!.path);
    });
    Navigator.pop(context);
  }
}
