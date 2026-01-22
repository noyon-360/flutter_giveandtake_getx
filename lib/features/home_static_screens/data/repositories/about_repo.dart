import 'package:dartz/dartz.dart';
import 'package:giveandtake/core/network/network_result.dart';
import '../../../../core/network/models/network_failure.dart';
import '../../data/models/about_content_model.dart';

abstract class AboutRepository {
  NetworkResult<AboutContentModel> getAboutContent();
}
