import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/core/common/widgets/app_scaffold.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:html/parser.dart' as html_parser;

import '../../data/models/leave_company_request_model.dart';

class CompanyInformation extends StatefulWidget {
  const CompanyInformation({super.key});

  @override
  State<CompanyInformation> createState() => _CompanyInformationState();
}

class _CompanyInformationState extends State<CompanyInformation> {
  final RecruiterController recruiterController =
      Get.find<RecruiterController>();
  final ScrollController horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await recruiterController.fetchProfile();
      await recruiterController.getJob(); // <-- ADD THIS LINE
    });
  }

  String htmlToPlainText(String htmlString) {
    final document = html_parser.parse(htmlString);
    return document.body?.text ?? '';
  }

  void _leaveCompany(company) {
    recruiterController.leaveCompany(
      company.cname,
      company.aboutUs,
      company.industry,
      company.country,
      company.city,
      company.zipcode,
      company.cemail,
      company.clogo,
      company.banner,
      company.slug,
      List<String>.from(company.employeesId ?? []),
      (company.sLink ?? [])
          .map<SocialLinkRequest>(
            (e) => SocialLinkRequest(label: e.label, url: e.url),
          )
          .toList(),
      List<String>.from(company.service ?? []),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text(
          "Company Information",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2B7FD0),
        elevation: 0,

        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // <-- Drawer icon visible
      ),
      body: Obx(() {
        final user = recruiterController.userInfo.value;
        final company = user?.companyId;

        if (recruiterController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (user == null || company == null) {
          return const Center(child: Text("No company information found"));
        }

        return Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// LEFT SECTION
              Card(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// COMPANY LOGO
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 115,
                          height: 115,
                          color: Colors.green.shade100,
                          child: Image.network(
                            company.clogo,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// NAME + EMAIL
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${user.firstName} ${user.sureName}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Text(
                          company.cname,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2B7FD0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(
                              Icons.email_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              user.emailAddress,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              /// RIGHT SECTION — ABOUT US
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "About Us",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          company.aboutUs.isNotEmpty
                              ? htmlToPlainText(company.aboutUs)
                              : "No description provided.",
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: Color.fromARGB(255, 227, 130, 24),
                        ),
                      ),
                      child: Obx(
                        () => GestureDetector(
                          onTap: recruiterController.isLoading.value
                              ? null
                              : () {
                                  Get.defaultDialog(
                                    title: "Leave Company?",
                                    titleStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    content: const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        "You will be disconnected from this company and your future job posts will no longer link to it.",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          /// CANCEL BUTTON
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              side: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      8,
                                                    ), // 👈 circular
                                              ),
                                            ),
                                            onPressed: () => Get.back(),
                                            child: const Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(width: 12),

                                          /// LEAVE BUTTON
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      8,
                                                    ), // 👈 circular
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                              _leaveCompany(company);
                                            },
                                            child: const Text(
                                              "Leave Company",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: recruiterController.isLoading.value
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Leave Company',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 170, 29, 29),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
