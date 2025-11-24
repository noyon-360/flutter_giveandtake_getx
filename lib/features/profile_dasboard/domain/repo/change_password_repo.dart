import '../../../../core/network/network_result.dart';
import '../../data/models/change_password_request_model.dart';

abstract class ChangePasswordRepo {
  NetworkResult<void> changePassword(ChangePasswordRequestModel request);
}
