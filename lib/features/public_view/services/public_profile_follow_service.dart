import 'package:get/get.dart';
import 'package:giveandtake/core/network/api_client.dart';
import 'package:giveandtake/core/network/constants/api_constants.dart';
import 'package:giveandtake/core/network/services/auth_storage_service.dart';

class PublicProfileFollowService {
  PublicProfileFollowService({
    ApiClient? apiClient,
    AuthStorageService? authStorageService,
  }) : _apiClient = apiClient ?? ApiClient(),
       _authStorageService =
           authStorageService ?? Get.find<AuthStorageService>();

  final ApiClient _apiClient;
  final AuthStorageService _authStorageService;

  Future<String?> get currentUserId => _authStorageService.getUserId();

  /// True when the logged-in user is the owner of [targetUserId]'s profile.
  /// Used to hide the Follow button on your own public profile (web parity:
  /// the web hides Follow when `myId === userId`).
  Future<bool> isOwnProfile(String targetUserId) async {
    if (targetUserId.isEmpty) return false;
    final userId = await currentUserId;
    return userId != null && userId.isNotEmpty && userId == targetUserId;
  }

  /// Public follower count for a recruiter/company profile.
  ///
  /// The backend keys both recruiters and companies on `recruiterId` (a User id)
  /// when counting, exactly like the web app's
  /// `GET /following/count?recruiterId=<targetUserId>`. No auth required.
  Future<int> followerCount(String targetUserId) async {
    if (targetUserId.isEmpty) return 0;

    final result = await _apiClient.get<Map<String, dynamic>>(
      '${ApiConstants.baseUrl}/following/count?recruiterId=$targetUserId',
      fromJsonT: (json) =>
          (json as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
    );

    return result.fold((_) => 0, (success) {
      final count = success.data['count'];
      if (count is num) return count.toInt();
      return 0;
    });
  }

  Future<bool> isFollowing(String targetUserId) async {
    final userId = await currentUserId;
    if (userId == null || userId.isEmpty || targetUserId.isEmpty) {
      return false;
    }

    final result = await _apiClient.get<Map<String, dynamic>>(
      '${ApiConstants.baseUrl}/user/single',
      fromJsonT: (json) =>
          (json as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
    );

    return result.fold((_) => false, (success) {
      final following = success.data['following'];
      if (following is! List) return false;

      return following.any((item) {
        if (item is String) return item == targetUserId;
        if (item is Map) {
          final id = item['_id']?.toString() ?? item['id']?.toString();
          return id == targetUserId;
        }
        return false;
      });
    });
  }

  Future<bool> toggleRecruiter({
    required String targetUserId,
    required bool currentlyFollowing,
  }) {
    return _toggle(
      payload: {'recruiterId': targetUserId},
      targetUserId: targetUserId,
      currentlyFollowing: currentlyFollowing,
    );
  }

  Future<bool> toggleCompany({
    required String targetUserId,
    required String companyObjectId,
    required bool currentlyFollowing,
  }) {
    return _toggle(
      payload: {
        // Matches the web app and the current backend lookup source.
        'recruiterId': targetUserId,
        'companyId': companyObjectId,
      },
      targetUserId: targetUserId,
      currentlyFollowing: currentlyFollowing,
    );
  }

  Future<bool> _toggle({
    required Map<String, dynamic> payload,
    required String targetUserId,
    required bool currentlyFollowing,
  }) async {
    final userId = await currentUserId;
    if (userId == null || userId.isEmpty) {
      throw const PublicProfileFollowException(
        'Please log in to follow this profile.',
      );
    }
    if (targetUserId.isEmpty) {
      throw const PublicProfileFollowException('This profile cannot be followed.');
    }
    if (targetUserId == userId) {
      throw const PublicProfileFollowException(
        'You cannot follow your own profile.',
      );
    }

    final requestPayload = {
      'userId': userId,
      ...payload,
    };
    final endpoint = currentlyFollowing
        ? '${ApiConstants.baseUrl}/following/unfollow'
        : '${ApiConstants.baseUrl}/following/follow';

    final result = currentlyFollowing
        ? await _apiClient.delete<Map<String, dynamic>>(
            endpoint,
            data: requestPayload,
            fromJsonT: (json) =>
                (json as Map?)?.cast<String, dynamic>() ??
                <String, dynamic>{},
          )
        : await _apiClient.post<Map<String, dynamic>>(
            endpoint,
            data: requestPayload,
            fromJsonT: (json) =>
                (json as Map?)?.cast<String, dynamic>() ??
                <String, dynamic>{},
          );

    return result.fold((fail) {
      final message = fail.message;
      if (!currentlyFollowing && message.contains('Already following')) {
        return true;
      }
      if (currentlyFollowing &&
          (message.contains('not found') || message.contains('Not following'))) {
        return false;
      }
      throw PublicProfileFollowException(message);
    }, (_) => !currentlyFollowing);
  }
}

class PublicProfileFollowException implements Exception {
  const PublicProfileFollowException(this.message);

  final String message;

  @override
  String toString() => message;
}
