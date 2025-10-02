import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import 'package:karlfive/features/auth/domain/repo/auth_repo.dart';

import '../../features/auth/data/models/user_model.dart';

class GetUserProfileService extends BaseController {
  final AuthRepository _authRepository;

  GetUserProfileService(this._authRepository);

  final Rxn<UserModel> _userInfo = Rxn<UserModel>();
  UserModel? get userInfo => _userInfo.value;


  Future<void> getUserProfile() async {
    final result = await _authRepository.getUserProfile();

    result.fold((fail) {

    }, (success) {
      _userInfo.value = success.data;
    });
  }
}
