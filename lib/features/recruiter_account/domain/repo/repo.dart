import '../../../../core/network/network_result.dart';
import '../../data/models/get_company_response_model.dart';

abstract class Repo{
  NetworkResult<List<GetCompanyResponseModel>> fetchCompany();
}