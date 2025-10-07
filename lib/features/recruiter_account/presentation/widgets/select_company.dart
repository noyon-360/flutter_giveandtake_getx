import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/get_company_response_model.dart';
import '../controller/recruiter_controller.dart';

class CompanyDropdown extends StatelessWidget {
  final RecruiterController controller = Get.find<RecruiterController>();

  CompanyDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }

      if (controller.companies.isEmpty) {
        Text('No company found');
      }

      return DropdownButtonFormField<GetCompanyResponseModel>(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        hint:Text('Select Company'),
        value: controller.selectedCompany.value,
        onChanged: (value) {
          controller.selectedCompany.value = value;
        },
        items: controller.companies.map((company) {
          return DropdownMenuItem(
            value: company,
            child: SizedBox(
                width: 200,      // make sure this is wide enough for avatar + text
                height: 50,
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(company.clogo),
                    radius: 15,
                  ),
                  const SizedBox(width: 10),
                  Text(company.cname),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
