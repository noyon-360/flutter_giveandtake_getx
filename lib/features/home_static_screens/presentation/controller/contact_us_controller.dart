import 'package:get/get.dart';

import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/debug_print.dart';
import '../../data/models/contact_us_request_model.dart';
import '../../domain/repo/contact_us_rep.dart';

class ContactUsController extends BaseController {
  final ContactUsRepo _contactUsRepo;

  ContactUsController(this._contactUsRepo);

  // UI state
  // use isLoading and errorMessage from BaseController
  final successMessage = ''.obs;

  void clearSuccess() => successMessage.value = '';

  Future<void> createContact({
    required String firstName,
    required String lastName,
    required String address,
    required String phoneNumber,
    required String subject,
    required String message,
  }) async {
    final request = ContactUsRequestModel(
      firstName: firstName,
      lastName: lastName,
      address: address,
      phoneNumber: phoneNumber,
      subject: subject,
      message: message,
    );
    DPrint.log("Contact Us create data : ${request.toJson()}");

    setLoading(true);
    clearError();
    successMessage.value = '';

    final result = await _contactUsRepo.createContact(request);

    result.fold(
      (failure) {
        DPrint.log("contact us create fail : ${failure.message}");
        setError(failure.message);
        setLoading(false);
      },
      (networkSuccess) {
        DPrint.log("contact us create success : ${networkSuccess.message}");
        // networkSuccess.data is ContactUsResponseModel
        successMessage.value = networkSuccess.message;
        setLoading(false);
      },
    );
  }
}
