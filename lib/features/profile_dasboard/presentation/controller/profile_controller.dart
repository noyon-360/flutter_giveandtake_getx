import 'dart:io';

import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final UserRepository repository;

  ProfileController({UserRepository? repository})
    : repository = repository ?? UserRepositoryImpl();

  final _isLoading = false.obs;
  final _error = RxnString();
  final _user = Rxn<UserModel>();

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  UserModel? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      _isLoading.value = true;
      _error.value = null;
      final u = await repository.fetchUser();
      _user.value = u;
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateUser(Map<String, dynamic> payload, {File? imageFile}) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      // Optimistically update UI immediately
      if (_user.value != null) {
        final current = _user.value!;
        _user.value = UserModel(
          id: current.id,
          name: payload['name'] ?? current.name,
          email: payload['email'] ?? current.email,
          phoneNum: payload['phoneNum'] ?? current.phoneNum,
          address: payload['address'] ?? current.address,
          avatarUrl: current.avatarUrl,
          role: current.role,
          deactivate: current.deactivate,
          dateOfdeactivate: current.dateOfdeactivate,
          refreshToken: current.refreshToken,
          title: current.title,
          isValid: current.isValid,
          payAsYouGo: current.payAsYouGo,
        );
      }

      // Then call the API in background
      final updated = await repository.updateUser(payload, imageFile: imageFile);
      _user.value = updated;
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }


}
