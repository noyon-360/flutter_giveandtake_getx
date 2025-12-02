import '../../../../core/network/network_result.dart';
import '../../data/model/all_user_response_model.dart';

abstract class CompanyRepository {
  NetworkResult<List<AllUserResponseModel>> fetchAllUsers();
}