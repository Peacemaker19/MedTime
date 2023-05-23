import 'dart:io';
import 'package:medtime/models/userMedicalReport.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class User {
  User({required this.name, required this.email, required this.userDetails,this.image, id})
      : id = id ?? uuid.v4();
  File? image;
  String id, name, email;
  UserMedicalReport userDetails;
}
