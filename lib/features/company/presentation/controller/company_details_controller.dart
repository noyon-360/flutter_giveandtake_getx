import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import '../../../../core/network/services/auth_storage_service.dart';
import '../../data/model/all_user_response_model.dart';
import '../../data/model/company_details_model.dart';
import '../../data/model/single_Company_response_model.dart';
import '../../domain/repo/company_repo.dart';



class CompanyDetailsController extends BaseController {
   final CompanyRepository _companyRepo;
  final AuthStorageService _authStorageService;

  CompanyDetailsController(this._companyRepo, this._authStorageService);

    final Rxn<SingleCompanyResponseModel> userInfo =
      Rxn<SingleCompanyResponseModel>();
      var recruiters = <AllUserResponseModel>[].obs;


  // var company = CompanyDetailsModel(
  //   logoUrl: "",
  //   recruiterName: "John D.",
  //   recruiterRole: "Design Services",
  //   location: "Berlin, Germany",
  //   aboutUs: "Perferendis non vero",
  //   website: "Not provided",
  //   industry: "IT",
  //   companySize: "1212 Employees",
  //   specialties: "Voluptatem repudiand",
  //   address: "Abasto, Argentina",
  //   elevatorPitchUrl: "",
  //   employees: [
  //     Employee(name: "Eric Perez", role: "Recruiter", phone: "23165033"),
  //   ],
  // ).obs;


Future<void> fetchCompanyProfile() async {
  setLoading(true);
  setError("");

  final userId = await _authStorageService.getUserId();
  if (userId == null || userId.isEmpty) {
    setError('User ID not found. Please log in again.');
    Get.snackbar('Error', 'User ID not found. Please log in again.');
    setLoading(false);
    return;
  }

  final result = await _companyRepo.fetchCompanyInfo(userId);

  result.fold(
    (fail) {
      setError(fail.message);
      DPrint.log('data fetch failed: ${fail.message}');
      setLoading(false);
    },
  (success) {
      // success is NetworkSuccess<SingleCompanyResponseModel>
      // → extract the actual model using .data
      userInfo.value = success.data;  // ← THIS IS THE CORRECT WAY
      
      DPrint.log("Loaded ${success.data.companies.length} companies");
      DPrint.log("Loaded ${success.data.honors.length} honors");
      setLoading(false);
    },
  );
  }

  
}
