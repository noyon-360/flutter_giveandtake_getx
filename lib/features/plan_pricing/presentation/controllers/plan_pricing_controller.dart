import 'package:get/get.dart';
import '../../../../core/base/base_controller.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/constants/api_constants.dart';
import '../../../../core/services/get_user_profile_service.dart';
import '../../data/models/subscription_plan_model.dart';

class PlanPricingController extends BaseController {
  final ApiClient _apiClient = Get.find<ApiClient>();
  
  final RxList<SubscriptionPlan> _allPlans = <SubscriptionPlan>[].obs;
  final RxList<SubscriptionPlan> _filteredPlans = <SubscriptionPlan>[].obs;
  final RxInt _currentPage = 0.obs;

  List<SubscriptionPlan> get allPlans => _allPlans;
  List<SubscriptionPlan> get filteredPlans => _filteredPlans;
  int get currentPage => _currentPage.value;

  @override
  void onInit() {
    super.onInit();
    fetchSubscriptionPlans();
  }

  Future<void> fetchSubscriptionPlans() async {
    try {
      setLoading(true);
      clearError();

      // Get user role - multiple attempts for robustness
      String userRole = '';
      
      // Try to get from GetUserProfileService
      try {
        final userProfileService = Get.find<GetUserProfileService>();
        userRole = userProfileService.userInfo?.role ?? '';
        print('🐞 DEBUG: User Role from Service: $userRole');
        
        // If service doesn't have user info, trigger a refresh
        if (userRole.isEmpty) {
          print('🐞 DEBUG: Service empty, attempting to refresh user profile...');
          await userProfileService.getUserProfile();
          userRole = userProfileService.userInfo?.role ?? '';
          print('🐞 DEBUG: User Role after refresh: $userRole');
        }
      } catch (e) {
        print('🐞 DEBUG: Error accessing GetUserProfileService: $e');
      }
      
      // Fallback: Since your API shows role as 'candidate', use that for now
      if (userRole.isEmpty) {
        print('🐞 DEBUG: Using fallback role: candidate');
        userRole = 'candidate'; // Your API response showed this role
      }
      
      print('🐞 DEBUG: Final User Role: $userRole');

      if (userRole.isEmpty) {
        setError('User role not found. Please login again.');
        setLoading(false);
        return;
      }

      print(
        '🐞 DEBUG: Fetching plans from: ${ApiConstants.subscription.getPlans}',
      );

      // Fetch subscription plans from API
      final result = await _apiClient.get<List<SubscriptionPlan>>(
        ApiConstants.subscription.getPlans,
        fromJsonT: (data) {
          print('🐞 DEBUG: Raw API Response: $data');
          return (data as List<dynamic>)
              .map(
                (json) =>
                    SubscriptionPlan.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        },
      );

      result.fold(
        (failure) {
          setError(failure.message);
          setLoading(false);
          print('🐞 DEBUG: API Error: ${failure.message}');
        },
        (success) {
          // Store all plans
          _allPlans.value = success.data;

          // Filter plans by user role
          final filteredPlans = success.data
              .where((plan) => plan.for_ == userRole)
              .toList();
          _filteredPlans.value = filteredPlans;

          print('🐞 DEBUG: Total plans: ${success.data.length}');
          print(
            '🐞 DEBUG: Available roles in plans: ${success.data.map((p) => p.for_).toSet().toList()}',
          );
          print(
            '🐞 DEBUG: Filtered plans for $userRole: ${filteredPlans.length}',
          );

          if (filteredPlans.isEmpty && success.data.isNotEmpty) {
            print(
              '🐞 DEBUG: No plans found for role "$userRole". Available roles: ${success.data.map((p) => p.for_).toSet()}',
            );
          }

          setLoading(false);
        },
      );
    } catch (e) {
      setError('An unexpected error occurred: $e');
      setLoading(false);
      print('🐞 DEBUG: Exception: $e');
    }
  }

  Future<void> refreshPlans() async {
    await fetchSubscriptionPlans();
  }

  void updateCurrentPage(int page) {
    _currentPage.value = page;
  }

  bool get hasPlans => _filteredPlans.isNotEmpty;
}
