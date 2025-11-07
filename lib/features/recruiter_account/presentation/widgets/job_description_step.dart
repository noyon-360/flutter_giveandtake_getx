import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:intl/intl.dart';
import '../controller/job_posting_controller.dart';

class JobDescriptionStep extends StatelessWidget {
  const JobDescriptionStep({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobPostingController>();
    final htmlController = HtmlEditorController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 760;

          /// LEFT SIDE — Job Description Editor
          Widget left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Job Description',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              const Text(
                'Job Description',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),

              // HTML Editor
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    HtmlEditor(
                      controller: htmlController,
                      htmlEditorOptions: HtmlEditorOptions(
                        hint: "Describe the job role...",
                        initialText: controller.jobDescriptionHtml.value,
                        autoAdjustHeight: false, adjustHeightForKeyboard: false
                      ),
                      htmlToolbarOptions: const HtmlToolbarOptions(

                        defaultToolbarButtons: [
                          StyleButtons(), // Added this line — includes "Normal Text" option
                          FontButtons(),
                          ListButtons(),
                          ParagraphButtons(),
                          InsertButtons(),
                          OtherButtons(),
                        ],
                      ),
                      otherOptions: const OtherOptions(
                        height: 250,
                        //This hides the "Done" button in the editor view
                      ),
                      callbacks: Callbacks(
                        onChangeContent: (String? changed) {
                          controller.updateJobDescriptionHtml(changed ?? '');
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Character / Word Count
              Obx(() {
                final charCount = controller.characterCount.value;
                final wordCount = controller.wordCount.value;
                const wordMin = 20;
                const charMax = 2000;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Character count: $charCount/$charMax'),
                    const SizedBox(height: 6),
                    Text('Word count: $wordCount/$wordMin minimum'),
                  ],
                );
              }),
            ],
          );

          /// RIGHT SIDE — Tip + Publish Toggle + Calendar
          Widget right = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //TIP FIRST
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
                color: Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: isWide ? 300 : double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'TIP',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'To help candidates understand the job expectations, please only cite the actual skills, experience, qualifications and/or certifications required for this role.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //Publish Now switch
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Publish Now',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      value: controller.publishNow.value,
                      onChanged: (v) => controller.togglePublishNow(v),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 16),

              //Calendar when PublishNow == false
              Obx(() {
                if (controller.publishNow.value) return const SizedBox.shrink();

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: isWide ? 300 : double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Schedule Publish',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          CalendarDatePicker(
                            initialDate: controller.selectedDate.value,
                            firstDate: DateTime.now(),
                            lastDate:
                            DateTime.now().add(const Duration(days: 365)),
                            onDateChanged: (date) =>
                                controller.updateSelectedDate(date),
                          ),
                          const SizedBox(height: 8),
                          Obx(() {
                            final dateStr = DateFormat('dd/MM/yyyy')
                                .format(controller.selectedDate.value);
                            return Text('Selected date: $dateStr');
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );

          /// LAYOUT
          Widget mainContent;
          if (isWide) {
            mainContent = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: left),
                const SizedBox(width: 24),
                SizedBox(width: 320, child: right),
              ],
            );
          } else {
            mainContent = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                left,
                const SizedBox(height: 16),
                right,
              ],
            );
          }

          /// FINAL LAYOUT — main content + buttons at bottom
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mainContent,
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF2B7FD0)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {controller.previousStep();},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xFF2B7FD0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20),

                  Container(
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(color: Color(0xFF2B7FD0), borderRadius: BorderRadius.circular(8)),
                    child: ElevatedButton(
                      onPressed: () {controller.nextStep();},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                      ),
                      child: Text('Next', style: TextStyle(
                        color: Colors.white,fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
