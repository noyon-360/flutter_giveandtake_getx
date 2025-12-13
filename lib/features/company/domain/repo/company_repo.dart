import 'package:dio/dio.dart';

import '../../../../core/network/network_result.dart';
import '../../data/model/all_user_response_model.dart';
import '../../data/model/company_response_model.dart';
import '../../data/model/single_Company_response_model.dart';
import '../../data/model/update_company_response_model.dart';

abstract class CompanyRepository {
  NetworkResult<List<AllUserResponseModel>> fetchAllUsers();
  NetworkResult<CompanyResponseModel> createCompany(FormData formData);
  NetworkResult<SingleCompanyResponseModel> fetchCompanyInfo(String userId);
  NetworkResult<UpdateCompanyResponseModel> updateCompanyInfo(String userId,FormData formData,);
}
