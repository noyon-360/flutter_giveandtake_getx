import '../../../../core/network/network_result.dart';
import '../../data/models/content_response.dart';

abstract class ContentRepository {
  NetworkResult<ContentResponse> getContentByType(String type);
}
