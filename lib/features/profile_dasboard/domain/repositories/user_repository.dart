import 'dart:io';
import '../../data/models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> fetchUser();
  Future<UserModel> updateUser(Map<String, dynamic> payload, {File? imageFile});

}
