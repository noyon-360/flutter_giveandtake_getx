import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/network_result.dart';
import '../../domain/category_repo.dart';
import '../model/category_response_model.dart';

class CategoryRepoImpl implements CategoryRepository {
  final ApiClient _apiClient;

  CategoryRepoImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  NetworkResult<CategoryResponse> jobCategory() {
    return _apiClient.get<CategoryResponse>(
      ApiConstants.category.jobCategory,
      // data: request.toJson(),
      fromJsonT: (json) => CategoryResponse.fromJson(json),
      // isFormData: true
    );
  }
}
