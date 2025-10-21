import 'dart:convert';
import 'dart:io';
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
      throw Exception('Failed to fetch user: ${resp.statusCode} — ${resp.body}');
    }
  }

  @override
  Future<UserModel> updateUser(Map<String, dynamic> payload, {File? imageFile}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/user/update');
    final token = await _authStorageService.getAccessToken();

    print('Sending update request to: $uri');
    print('Payload: $payload');
    print('Image file: ${imageFile?.path}');
    print('Token exists: ${token?.isNotEmpty}');

    if (token == null || token.isEmpty) {
      throw Exception('No access token found. Please login again.');
    }

    // Use MultipartRequest for form + image upload
    final request = http.MultipartRequest('PATCH', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(payload.map((k, v) => MapEntry(k, v.toString())));

    // Match your backend key name (check Postman: use `profileImage` not `avatar`)
    if (imageFile != null && await imageFile.exists()) {
      final fileName = imageFile.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path, filename: fileName),

      );
      print('Attached file: $fileName');
    } else {
      print('No image file selected');
    }

    final streamedResponse = await request.send();
    final resp = await http.Response.fromStream(streamedResponse);

    print('Response code: ${resp.statusCode}');
    print('Response body: ${resp.body}');

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
