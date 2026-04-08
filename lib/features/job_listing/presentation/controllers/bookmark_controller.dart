import 'package:dio/dio.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';

import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/network/constants/key_constants.dart';
import '../../../../core/network/services/secure_store_services.dart';

class BookmarkController extends GetxController {
  final RxList<Map<String, dynamic>> savedJobs = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  String _getId(Map<String, dynamic> job) {
    final raw = job['raw'] ?? {};
    return job['id']?.toString() ??
        raw['_id']?.toString() ??
        raw['id']?.toString() ??
        job.hashCode.toString();
  }

  bool contains(Map<String, dynamic> job) {
    final id = _getId(job);
    return savedJobs.any((j) => j['id'] == id);
  }

  /// Adds a job to local saved list and attempts to persist bookmark on server.
  /// Returns true when bookmark API call succeeded (or already contained).
  Future<bool> addJob(Map<String, dynamic> job) async {
    if (contains(job)) return true;

    // Prepare local snapshot (keeps existing UI behaviour)
    final raw = job['raw'] ?? {};
    final title = raw['title'] ?? job['title'] ?? '';
    final company = raw['companyId'] != null
        ? raw['companyId']['cname'] ?? ''
        : (raw['recruiterId'] != null
              ? '${raw['recruiterId']['firstName'] ?? ''} ${raw['recruiterId']['sureName'] ?? ''}'
                    .trim()
              : job['company'] ?? '');
    final location = raw['location'] ?? job['location'] ?? '';
    final logoUrl = raw['companyId'] != null
        ? raw['companyId']['clogo'] ?? ''
        : (raw['recruiterId'] != null ? raw['recruiterId']['photo'] ?? '' : '');

    final snapshot = {
      'id': _getId(job),
      'title': title,
      'company': company,
      'location': location,
      'logoUrl': logoUrl,
      // keep original payload for actions/navigation
      'original': job,
    };

    // Attempt to call bookmark API
    try {
      final secure = SecureStoreServices();
      final token = await secure.retrieveData(KeyConstants.accessToken);
      final userId = await secure.retrieveData(KeyConstants.userId);

      if (userId == null || userId.isEmpty) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      final dio = Dio();
      dio.options.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      if (token != null && token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final jobId = job['id']?.toString() ?? (raw['_id']?.toString() ?? raw['id']?.toString());
      final url = ApiConstants.bookmarks.create;

      final payload = {
        'userId': userId,
        'jobId': jobId,
      };

      DPrint.log('📤 Bookmark POST -> $url');
      DPrint.log('Headers: ${dio.options.headers}');
      DPrint.log('Payload: $payload');

      final response = await dio.post(url, data: payload);

      DPrint.log('👈 Bookmark POST Response (${response.statusCode}): ${response.data}');

      // Consider 200/201 as success. The API may return the created bookmark object directly.
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Add locally only after successful server persist
        savedJobs.add(snapshot);
        return true;
      }

      Get.snackbar('Error', response.data?['message'] ?? 'Failed to bookmark job');
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to bookmark job');
      return false;
    }
  }

  /// Fetch bookmarks for current user from server and populate [savedJobs].
  Future<void> fetchBookmarks() async {
    isLoading.value = true;
    try {
      final secure = SecureStoreServices();
      final token = await secure.retrieveData(KeyConstants.accessToken);
      final userId = await secure.retrieveData(KeyConstants.userId);

      if (userId == null || userId.isEmpty) {
        Get.snackbar('Error', 'User not logged in');
        isLoading.value = false;
        return;
      }

      final dio = Dio();
      dio.options.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      if (token != null && token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      final url = ApiConstants.bookmarks.user(userId);

      DPrint.log('📤 Bookmark GET -> $url');
      DPrint.log('Headers: ${dio.options.headers}');

      final response = await dio.get(url);

      DPrint.log('👈 Bookmark GET Response (${response.statusCode}): ${response.data}');

      if (response.statusCode == 200) {
        dynamic responseData = response.data;

        // Handle envelope formats: {status: 'success', data: {...}} or direct {bookmarks: [...]}
        List<dynamic> bookmarks = [];
        try {
          if (responseData is Map<String, dynamic>) {
            if (responseData.containsKey('bookmarks')) {
              bookmarks = responseData['bookmarks'] as List<dynamic>;
            } else if (responseData.containsKey('data') &&
                responseData['data'] is Map<String, dynamic>) {
              final inner = responseData['data'] as Map<String, dynamic>;
              bookmarks = inner['bookmarks'] as List<dynamic>? ??
                  inner['data'] as List<dynamic>? ??
                  [];
            }
          } else if (responseData is List) {
            bookmarks = responseData as List<dynamic>;
          }
        } catch (e) {
          DPrint.log('Error parsing bookmarks response: $e');
        }

        savedJobs.clear();

        for (final b in bookmarks) {
          // b may be a bookmark object with 'jobId' or may be the job object itself
          final jobObj = (b is Map && b.containsKey('jobId')) ? b['jobId'] as Map<String, dynamic>? : (b as Map<String, dynamic>?);
          if (jobObj == null) continue; // skip bookmarks without job

          final raw = jobObj;
          final title = raw['title'] ?? '';
          final company = raw['companyId'] != null
              ? raw['companyId']['cname'] ?? ''
              : (raw['recruiterId'] != null
                  ? '${raw['recruiterId']['firstName'] ?? ''} ${raw['recruiterId']['sureName'] ?? ''}'.trim()
                  : '');
          final location = raw['location'] ?? '';
          final logoUrl = raw['companyId'] != null
              ? raw['companyId']['clogo'] ?? ''
              : (raw['recruiterId'] != null ? raw['recruiterId']['photo'] ?? '' : '');

          final snapshot = {
            'id': raw['_id']?.toString() ?? raw['id']?.toString() ?? '',
            'title': title,
            'company': company,
            'location': location,
            'logoUrl': logoUrl,
            'original': {'raw': raw, 'id': raw['_id'] ?? raw['id']},
          };

          savedJobs.add(snapshot);
        }
      } else {
        Get.snackbar('Error', 'Failed to load bookmarks');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load bookmarks');
    } finally {
      isLoading.value = false;
    }
  }

  /// Unsaves/removes a bookmark by calling the update API with bookmarked: false.
  /// Returns true on success, false on failure. Shows snackbar feedback.
  Future<bool> unsaveJob(Map<String, dynamic> job) async {
    try {
      final secure = SecureStoreServices();
      final token = await secure.retrieveData(KeyConstants.accessToken);
      final userId = await secure.retrieveData(KeyConstants.userId);

      if (userId == null || userId.isEmpty) {
        Get.snackbar('Error', 'User not logged in');
        return false;
      }

      final dio = Dio();
      dio.options.headers.addAll({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      });
      if (token != null && token.isNotEmpty) {
        dio.options.headers['Authorization'] = 'Bearer $token';
      }

      // Extract jobId from the job snapshot or its original data
      final raw = job['raw'] ?? job['original']?['raw'] ?? {};
      final jobId = job['id']?.toString() ?? raw['_id']?.toString() ?? raw['id']?.toString();

      DPrint.log('🔍 Job data for unsave:');
      DPrint.log('  job[id]: ${job['id']}');
      DPrint.log('  raw[_id]: ${raw['_id']}');
      DPrint.log('  raw[id]: ${raw['id']}');
      DPrint.log('  Extracted jobId: $jobId');
      DPrint.log('  Full job object: $job');

      final url = ApiConstants.bookmarks.update;

      final payload = {
        'userId': userId,
        'jobId': jobId,
        'bookmarked': false,
      };

      DPrint.log('📤 Bookmark UPDATE (unsave) -> $url');
      DPrint.log('Headers: ${dio.options.headers}');
      DPrint.log('Payload: $payload');

      // Try PATCH method instead of POST (more RESTful for updates)
      final response = await dio.patch(url, data: payload);

      DPrint.log('👈 Bookmark UPDATE Response (${response.statusCode}): ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Remove from local list after successful server update
        final id = job['id'] ?? _getId(job);
        savedJobs.removeWhere((j) => j['id'] == id);
        // Don't show snackbar here - let the caller handle UI feedback
        return true;
      }

      // Don't show snackbar here - let the caller handle UI feedback
      return false;
    } on DioException catch (dioError) {
      DPrint.log('❌ DioException unsaving job:');
      DPrint.log('Status Code: ${dioError.response?.statusCode}');
      DPrint.log('Response Data: ${dioError.response?.data}');
      DPrint.log('Error Message: ${dioError.message}');
      DPrint.log('Error Type: ${dioError.type}');
      
      // Don't show snackbar here - let the caller handle UI feedback
      return false;
    } catch (e, stackTrace) {
      DPrint.log('❌ Unexpected error unsaving job: $e');
      DPrint.log('Stack trace: $stackTrace');
      // Don't show snackbar here - let the caller handle UI feedback
      return false;
    }
  }

  void removeJob(Map<String, dynamic> job) {
    final id = job['id'] ?? _getId(job);
    savedJobs.removeWhere((j) => j['id'] == id);
  }
}
