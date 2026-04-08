import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:giveandtake/core/contracts/web/profile_contract.dart';
import 'package:http/http.dart' as http;

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({http.Client? client}) : client = client ?? http.Client();

  final http.Client client;
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();

  @override
  Future<UserModel> fetchUser() async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/user/single');
    final token = await _authStorageService.getAccessToken();

    if (token == null || token.isEmpty) {
      throw Exception('No access token found. Please log in again.');
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
      if (data == null) {
        throw Exception('Missing data in response');
      }
      return UserModel.fromJson(data);
    }

    throw Exception('Failed to fetch user: ${resp.statusCode} ${resp.body}');
  }

  @override
  Future<UserModel> updateUser(
    Map<String, dynamic> payload, {
    File? imageFile,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/user/update');
    final token = await _authStorageService.getAccessToken();
    final normalizedPayload = _buildProfilePayload(payload);

    if (token == null || token.isEmpty) {
      throw Exception('No access token found. Please log in again.');
    }

    final request = http.MultipartRequest('PATCH', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields.addAll(
        normalizedPayload.map((k, v) => MapEntry(k, v.toString())),
      );

    if (imageFile != null && await imageFile.exists()) {
      final fileName = imageFile.path.split('/').last;
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          imageFile.path,
          filename: fileName,
        ),
      );
    }

    final streamedResponse = await request.send();
    final resp = await http.Response.fromStream(streamedResponse);

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception('Missing data in response');
      }
      return UserModel.fromJson(data);
    }

    throw Exception('Failed to update user: ${resp.statusCode} ${resp.body}');
  }

  Map<String, dynamic> _buildProfilePayload(Map<String, dynamic> payload) {
    final rawName = payload['name']?.toString().trim() ?? '';
    String firstName = payload['firstName']?.toString().trim() ?? '';
    String surname = payload['surname']?.toString().trim() ?? '';

    if (rawName.isNotEmpty && (firstName.isEmpty || surname.isEmpty)) {
      final parts = rawName
          .split(RegExp(r'\s+'))
          .where((part) => part.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) {
        firstName = parts.first;
        surname = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      }
    }

    return ProfilePayloadBuilder.buildUpdate(
      PersonalInfoInput(
        firstName: firstName,
        surname: surname,
        address: payload['address']?.toString() ?? '',
      ),
    );
  }
}
