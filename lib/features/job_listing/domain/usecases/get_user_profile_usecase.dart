import '../../../../core/network/network_result.dart';
import '../repo/user_profile_repository.dart';
import '../../data/models/user_profile_model.dart';

class GetUserProfileUseCase {
  final UserProfileRepository _repository;

  GetUserProfileUseCase(this._repository);

  NetworkResult<UserProfileModel> call() {
    return _repository.getUserProfile();
  }
}
