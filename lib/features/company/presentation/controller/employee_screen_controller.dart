// import 'package:get/get.dart';

// import '../../../../core/base/base_controller.dart';
// import '../../../../core/network/services/auth_storage_service.dart';
// import '../../data/model/employee_fetch_single_model.dart';
// import '../../domain/repo/company_repo.dart';

// class CompanyEmployeesController extends BaseController {
//   final CompanyRepository _companyRepo = Get.find();
//   final AuthStorageService _authStorageService = Get.find();

//   var employees = Rx<EmployeeFetchSingleModel?>(null);
//   var isLoading = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchEmployees();
//   }

//   Future<void> fetchEmployees() async {
//     isLoading.value = true;
//     final userId = await _authStorageService.getUserId();
//     if (userId == null) return;

//     final result = await _companyRepo.fetchEmployee(userId);
//     result.fold(
//       (fail) => Get.snackbar("Error", fail.message),
//       (success) {
//         employees.value = success.data;
//       },
//     );
//     isLoading.value = false;
//   }
// }