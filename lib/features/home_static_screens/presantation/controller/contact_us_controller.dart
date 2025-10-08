import '../../../../core/base/base_controller.dart';
import '../../../../core/utils/debug_print.dart';
import '../../data/models/contact_us_request_model.dart';
import '../../domain/repo/contact_us_rep.dart';



class ContactUsController extends BaseController {
  final ContactUsRepo _contactUsRepo;

  ContactUsController(this._contactUsRepo);

  Future<void> createContact({
    required String firstName,
    required String lastName,
    required String address,
    required String phoneNumber,
    required String subject,
    required String yourCompany,
  }) async {
    final request = ContactUsRequestModel(
      firstName: firstName,
      lastName: lastName,
      address: address,
      phoneNumber: phoneNumber,
      subject: subject,
      yourCompony: yourCompany,
    );
    DPrint.log("Contact Us create data : ${request.toJson()}");

    final result = await _contactUsRepo.createContact(request);

    result.fold((fail) {
      DPrint.log("concat us create fail : ${fail.message}");
    }, (success) {
      DPrint.log("concat us create success : ${success.message}");

    });

  }
}