import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:karlfive/core/network/constants/api_constants.dart';
import 'package:karlfive/core/network/models/network_success.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../../../core/network/network_result.dart';
import '../models/about_content_model.dart';
import 'about_repo.dart';

class AboutRepositoryImpl implements AboutRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  NetworkResult<AboutContentModel> getAboutContent() async {
    final response = await _apiClient.get(
      ApiConstants.content.about,
      fromJsonT: (json) => AboutContentModel.fromJson(json),
      options: Options(headers: {'Accept': 'application/json'}),
    );

    return response.fold(
          (failure) => Left(failure),
          (success) => Right(success.data as NetworkSuccess<AboutContentModel>),
    );
  }
}
