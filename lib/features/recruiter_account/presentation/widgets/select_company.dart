import 'package:flutter/material.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/theme/input_decoration_extensions.dart';
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
        decoration: context.primaryInputDecoration.copyWith(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        hint:Text('Select Company', style: TextStyle(
          color: Color(0xFF787878),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),),
        value: controller.companies.firstWhereOrNull(
              (company) => company.id == controller.selectedCompany.value,
        ),
        onChanged: (value) {
          DPrint.log("Select Company Drop -> ${value!.id}");
          controller.selectedCompany.value = value.id;
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
                  Expanded(child: Text(company.cname, overflow: TextOverflow.ellipsis,)),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}
