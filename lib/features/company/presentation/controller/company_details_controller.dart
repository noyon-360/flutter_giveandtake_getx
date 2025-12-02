import 'package:get/get.dart';
import 'package:karlfive/core/base/base_controller.dart';
import '../../data/model/company_details_model.dart';



class CompanyDetailsController extends BaseController {
  var company = CompanyDetailsModel(
    logoUrl: "",
    recruiterName: "John D.",
    recruiterRole: "Design Services",
    location: "Berlin, Germany",
    aboutUs: "Perferendis non vero",
    website: "Not provided",
    industry: "IT",
    companySize: "1212 Employees",
    specialties: "Voluptatem repudiand",
    address: "Abasto, Argentina",
    elevatorPitchUrl: "",
    employees: [
      Employee(name: "Eric Perez", role: "Recruiter", phone: "23165033"),
    ],
  ).obs;
}
