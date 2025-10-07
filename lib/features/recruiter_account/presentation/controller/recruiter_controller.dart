import 'dart:developer' as DPrint;

import 'package:get/get.dart';
import 'package:karlfive/features/recruiter_account/data/models/get_company_response_model.dart';
import 'package:karlfive/features/recruiter_account/domain/repo/repo.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/network/services/multiple_form_data_manager.dart';

class RecruiterController extends BaseController {
  final Repo _recruiterRepo;
  var isSkipLoading = false.obs;
  var isContinueLoading = false.obs;

  final companies = <GetCompanyResponseModel>[].obs;
  final selectedCompany = Rxn<GetCompanyResponseModel>();

  final MultiFormDataManager _multiFormDataManager = MultiFormDataManager();


  RecruiterController(this._recruiterRepo);

  final Rxn<GetCompanyResponseModel> userInfo = Rxn<GetCompanyResponseModel>();
  @override
  void onInit() {
    super.onInit();
    fetchCompany();         //Fetch when controller is created
  }

  // // fetch company
  // Future<void> fetchCompany() async {
  //   setLoading(true);
  //   setError("");
  //
  //   final result = await _recruiterRepo.fetchCompany();
  //   result.fold((fail) {
  //     setError(fail.message);
  //     DPrint.log('data fetch failed');
  //     setLoading(false);
  //   }, (success) {
  //     userInfo.value = success.data;
  //     DPrint.log(success.message);
  //     setLoading(false);
  //   });
  // }

  Future<void> fetchCompany() async {
    setLoading(true);
    setError('');

    final result = await _recruiterRepo.fetchCompany();

    result.fold((fail) {
      setError(fail.message);
      setLoading(false);
    }, (success) {
      // use the helper function you defined
      companies.value = success.data as List<GetCompanyResponseModel>;
      setLoading(false);
    });
  }


  // Future<void> updatePersonalInfo(String name,
  //     String age,
  //     String gender,
  //     String nationality,) async {
  //   setLoading(true);
  //   setError('');
  //
  //   DPrint.log('Nationality: $nationality');
  //
  //   _multiFormDataManager.addTextData("name", name);
  //   _multiFormDataManager.addTextData("age", age);
  //   _multiFormDataManager.addTextData("gender", gender);
  //   _multiFormDataManager.addTextData("nationality", nationality);
  //
  //
  //   final formRequest = await _multiFormDataManager.toFormDataAsync();
  //
  //   final result = await _profileRepository.updatePersonalInfo(formRequest);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log('Personal info: ${fail.message}');
  //       isLoading(false);
  //     },
  //         (success) async {
  //       DPrint.log('Personal info: ${success.message}');
  //       await fetchProfile();
  //       Get.back();
  //       isLoading(false);
  //       setError(success.message);
  //     },
  //   );
  // }
  //
  //
  // Future<void> changePassword(String oldPassword, String newPassword) async{
  //   setLoading(true);
  //   setError('');
  //
  //   final request = ChangePasswordRequest(oldPassword: oldPassword, newPassword: newPassword);
  //   final result = await _profileRepository.changePass(request);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log("change pass success result : ${fail.message}");
  //       setLoading(false);
  //     },
  //         (success) {
  //       DPrint.log("change pass success result : ${success.message}");
  //       Get.back();
  //       setLoading(false);
  //     },
  //   );
  // }
  //
  // Future<void> uploadPhoto(File image) async {
  //   setLoading(true);
  //   setError('');
  //
  //   _multiFormDataManager.addImageFile(image, key: "avatar");
  //
  //   final formRequest = await _multiFormDataManager.toFormDataAsync();
  //
  //   final result = await _profileRepository.uploadPhoto(formRequest);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log('Upload photo: ${fail.message}');
  //       isLoading(false);
  //     },
  //         (success) {
  //       DPrint.log('Upload photo: ${success.message}');
  //       fetchProfile();
  //       Get.back();
  //       setError(success.message);
  //       _multiFormDataManager.clear();
  //       isLoading(false);
  //     },
  //   );
  // }
  //
  // Future<void> tradingProfileSetup(
  //     final String tradingExperience,
  //     final String assetsOfInterest,
  //     final String mainGoal,
  //     final String riskAppetite,
  //     final List<String> preferredLearning,
  //     ) async {
  //   setLoading(true);
  //   setError('');
  //
  //   final profile = TradingProfile(tradingExperience: tradingExperience, assetsOfInterest: assetsOfInterest, mainGoal: mainGoal, riskAppetite: riskAppetite, preferredLearning: preferredLearning);
  //   final toJson = jsonEncode(profile.toJson());
  //
  //
  //   _multiFormDataManager.addTextData("treding_profile", toJson);
  //
  //
  //   final formRequest = await _multiFormDataManager.toFormDataAsync();
  //
  //   final result = await _profileRepository.tradingInfo(formRequest);
  //
  //   result.fold(
  //         (fail) {
  //       setError(fail.message);
  //       DPrint.log('Trading info: ${fail.message}');
  //       isLoading(false);
  //     },
  //         (success) {
  //       DPrint.log('Trading info: ${success.message}');
  //       Get.back();
  //       isLoading(false);
  //
  //       _multiFormDataManager.clear();
  //       setError(success.message);
  //     },
  //   );
  // }
}