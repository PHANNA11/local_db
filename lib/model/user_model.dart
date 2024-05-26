import 'package:local_db/database/constant.dart';

class UserModel {
  int? id;
  String? name;
  String? gender;
  int? age;
  String? positoin;
  String? image;
  UserModel(
      {this.id, this.name, this.gender, this.age, this.positoin, this.image});
// Convert Object data => Map
  Map<String, dynamic> toMap() {
    return {
      fName: name,
      fGender: gender,
      fAge: age,
      fPositoin: positoin,
      fImage: image,
    };
  }
// Covert map => Object data

  UserModel.fromMap(Map<String, dynamic> map)
      : id = map[fId],
        name = map[fName],
        gender = map[fGender],
        age = map[fAge],
        positoin = map[fPositoin],
        image = map[fImage];
}
