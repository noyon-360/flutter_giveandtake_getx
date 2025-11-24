import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../data/models/content_response.dart';
import '../../domain/repositories/content_repository.dart';

class HomeController extends BaseController {
  final ContentRepository _contentRepository;

  HomeController(this._contentRepository);

  // Reactive content storage
  final Rx<ContentResponse?> candidateContent = Rx<ContentResponse?>(null);
  final Rx<ContentResponse?> recruiterContent = Rx<ContentResponse?>(null);
  final Rx<ContentResponse?> companyContent = Rx<ContentResponse?>(null);

  // Loading states for each type
  final RxBool isCandidateLoading = false.obs;
  final RxBool isRecruiterLoading = false.obs;
  final RxBool isCompanyLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch all content when controller initializes
    fetchAllContent();
  }

  /// Fetch all content types in parallel
  Future<void> fetchAllContent() async {
    await Future.wait([
      fetchCandidateContent(),
      fetchRecruiterContent(),
      fetchCompanyContent(),
    ]);
  }

  /// Fetch candidate content
  Future<void> fetchCandidateContent() async {
    isCandidateLoading.value = true;
    try {
      final result = await _contentRepository.getContentByType('candidate');
      result.fold(
        (failure) {
          print('❌ Failed to fetch candidate content: ${failure.message}');
        },
        (success) {
          candidateContent.value = success.data;
          print('✅ Candidate content fetched successfully: ${success.data.title}');
        },
      );
    } catch (e, stackTrace) {
      print('❌ Exception fetching candidate content: $e');
      print('❌ Stack trace: $stackTrace');
    } finally {
      isCandidateLoading.value = false;
    }
  }

  /// Fetch recruiter content
  Future<void> fetchRecruiterContent() async {
    isRecruiterLoading.value = true;
    try {
      final result = await _contentRepository.getContentByType('recruiter');
      result.fold(
        (failure) {
          print('❌ Failed to fetch recruiter content: ${failure.message}');
        },
        (success) {
          recruiterContent.value = success.data;
          print('✅ Recruiter content fetched successfully');
        },
      );
    } catch (e) {
      print('❌ Exception fetching recruiter content: $e');
    } finally {
      isRecruiterLoading.value = false;
    }
  }

  /// Fetch company content
  Future<void> fetchCompanyContent() async {
    isCompanyLoading.value = true;
    try {
      final result = await _contentRepository.getContentByType('company');
      result.fold(
        (failure) {
          print('❌ Failed to fetch company content: ${failure.message}');
        },
        (success) {
          companyContent.value = success.data;
          print('✅ Company content fetched successfully');
        },
      );
    } catch (e) {
      print('❌ Exception fetching company content: $e');
    } finally {
      isCompanyLoading.value = false;
    }
  }
}
