import 'package:dio/dio.dart';

import '../../../../core/network/network_result.dart';
import '../../data/models/contact_us_request_model.dart';
import '../../data/models/contact_us_response_model.dart';
import '../../data/models/contactus_model.dart';



abstract class ContactUsRepo {
  NetworkResult<ContactUsResponseModel> createContact(ContactUsRequestModel request);
  NetworkResult<ReportData> report(FormData formData);
}