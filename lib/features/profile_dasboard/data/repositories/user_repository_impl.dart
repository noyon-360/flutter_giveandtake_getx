import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final http.Client client;
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();

  UserRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  @override
  Future<UserModel> fetchUser() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/user/single');

    // Retrieve access token from AuthStorageService
    final token = await _authStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('No access token found. Please login again.');
    }

    final resp = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) throw Exception('Missing data in response');
      return UserModel.fromJson(data);
    } else {
      throw Exception(
        'Failed to fetch user: ${resp.statusCode} — ${resp.body}',
      );
    }
  }

  @override
  Future<UserModel> updateUser(Map<String, dynamic> payload) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/user/update');

    final token = await _authStorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('No access token found. Please login again.');
    }

    print('🛰️ PATCH ${uri.toString()}');
    print('📦 Payload: ${json.encode(payload)}');

    final resp = await client.patch(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(payload),
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) throw Exception('Missing data in response');
      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to update user: ${resp.statusCode} — ${resp.body}');
    }
  }

}
