import 'dart:convert';

import 'package:get/get.dart';
import 'package:giveandtake/core/base/base_controller.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';
import 'package:giveandtake/features/auth/domain/repo/auth_repo.dart';

import '../../features/auth/data/models/user_model.dart';

class GetUserProfileService extends BaseController {
  final AuthRepository _authRepository;
  final AuthStorageService _authStorageService;

  GetUserProfileService(this._authRepository, this._authStorageService) {
    // Load user data from storage when service is initialized
    _loadUserDataFromStorage();
  }

  final Rxn<UserModel> _userInfo = Rxn<UserModel>();
  UserModel? get userInfo => _userInfo.value;

  // Expose the internal Rx so UI can react to changes via Obx  (add by zafor)
  Rxn<UserModel> get userInfoRx => _userInfo;

  // Load user data from secure storage
  Future<void> _loadUserDataFromStorage() async {
    try {
      final userDataJson = await _authStorageService.getUserData();
      if (userDataJson != null && userDataJson.isNotEmpty) {
        final userMap = json.decode(userDataJson) as Map<String, dynamic>;
        _userInfo.value = UserModel.fromJson(userMap);
      }
    } catch (e) {
      // If there's an error loading user data, just continue with null user
      print('Error loading user data from storage: $e');
    }
  }

  // Store user data to secure storage
  Future<void> _storeUserDataToStorage(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      
      // Store both the full user data JSON and the individual userId
      await Future.wait([
        _authStorageService.storeUserData(userJson),
        _authStorageService.storeUserId(user.id), // Store userId separately for easy access
      ]);
      
      print('✅ Stored user data to secure storage:');
      print('   userId: ${user.id}');
      print('   userData: ${userJson.substring(0, 50)}...');
    } catch (e) {
      print('Error storing user data: $e');
    }
  }

  // Set user info (called from login or other places)
  void setUserInfo(UserModel user) {
    _userInfo.value = user;
    _storeUserDataToStorage(user);
  }

  Future<void> getUserProfile() async {
    final result = await _authRepository.getUserProfile();

    result.fold((fail) {}, (success) {
      _userInfo.value = success.data;
      _storeUserDataToStorage(success.data);
    });
  }

  // Clear user data (on logout)
  void clearUserData() {
    _userInfo.value = null;
  }
}
