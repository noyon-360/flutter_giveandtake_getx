import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/features/company/data/model/company_details_model.dart';

import '../controller/company_details_controller.dart';
import '../controller/employee_screen_controller.dart';

class CompanyEmployeesScreen extends StatefulWidget {
  const CompanyEmployeesScreen({super.key});

  @override
  State<CompanyEmployeesScreen> createState() => _CompanyEmployeesScreenState();
}

class _CompanyEmployeesScreenState extends State<CompanyEmployeesScreen> {
  final CompanyDetailsController controller =
      Get.find<CompanyDetailsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      
      await controller.fetchEmployee();
    }); // Hit API once here
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
         elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text("Internal Recruiters")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final emp = controller.employee.value;

        if (emp == null || emp.employees.isEmpty) {
          return const Center(child: Text("No recruiters found"));
        }

        return 
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicWidth(
            // This forces the table to expand
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Recruiter Name")),
                DataColumn(label: Text("Role")),
                DataColumn(label: Text("Action")),
              ],
              rows: emp.employees
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(Text(e.name)),
                        DataCell(Text(e.role)),
                        DataCell(Icon(Icons.delete_outline, color: Colors.red) ,
                          onTap: () => controller.removeRecruiter( e.id),),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }),
    );
  }
}
