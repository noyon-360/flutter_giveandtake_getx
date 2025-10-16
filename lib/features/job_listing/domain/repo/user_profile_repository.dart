import '../../../../core/network/network_result.dart';
import '../../data/models/user_profile_model.dart';

abstract class UserProfileRepository {
  NetworkResult<UserProfileModel> getUserProfile();
}
