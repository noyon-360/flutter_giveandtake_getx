
import '../../../../core/network/network_result.dart';
import '../data/model/category_response_model.dart';

abstract class CategoryRepository{ 
  NetworkResult<CategoryResponse> jobCategory();
}