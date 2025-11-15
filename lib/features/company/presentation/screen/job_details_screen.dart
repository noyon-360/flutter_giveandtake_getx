import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:karlfive/features/company/presentation/widget/custom_text_field.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/job_details_controller.dart';
import '../widget/job_details_widget.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class JobDetailsPage extends StatefulWidget {
  const JobDetailsPage({super.key});

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {
  final JobDetailsController controller = Get.put(JobDetailsController());

  /// Publish Now Toggle
  bool publishNow = true;

  /// Calendar Date
  DateTime? _selectedDate;

  /// Job Description Controller
  final HtmlEditorController _jobDescriptionController = HtmlEditorController();

  /// Application Requirements State
  final Map<String, String> requirements = {
    "Address": "Optional",
    "Resume": "Optional",
    "Cover Letter": "Optional",
    "Reference": "Optional",
    "Website": "Optional",
    "Start Date": "Optional",
    "Name": "Optional",
    "Email": "Optional",
    "Phone": "Optional",
    "Valid visa for job location": "Optional",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 46),

            /// --- Job Details Header ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.only(bottom: 16),
              child: const Center(
                child: Text(
                  "Job Details",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Job Information Fields
            JobTextField(
              label: "Job Title",
              hint: "Senior Product Designer",
              value: controller.jobTitle,
            ),
            JobTextField(
              label: "Description (Optional)",
              hint: "Design & User Experience",
              value: controller.description,
            ),
            JobTextField(
              label: "Location",
              hint: "London, UK",
              value: controller.location,
            ),
            JobTextField(
              label: "Employment Type",
              hint: "Full-time",
              value: controller.employmentType,
            ),
            JobTextField(
              label: "Compensation (Optional)",
              hint: "\$65,000 - \$75,000 annual base",
              value: controller.compensation,
            ),
            JobTextField(
              label: "Experience (Optional)",
              hint: "5+ years",
              value: controller.experience,
            ),

            const SizedBox(height: 20),

            /// --- Job Description Section ---
            const Text(
              "Job Description",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: HtmlEditor(
                controller: _jobDescriptionController,
                htmlEditorOptions: HtmlEditorOptions(
                  hint: "Write the full job description here...",
                  shouldEnsureVisible: true,
                ),
                htmlToolbarOptions: HtmlToolbarOptions(
                  defaultToolbarButtons: [
                    StyleButtons(),
                    FontSettingButtons(),
                    ColorButtons(),
                    ListButtons(),
                    ParagraphButtons(),
                    // BoldButton(),
                    // UnderlineButton(),
                  ],
                  toolbarPosition: ToolbarPosition
                      .belowEditor, // Moves the toolbar below the editor
                ),
                otherOptions: OtherOptions(height: 200),
                // Apply custom icon theme here to make icons smaller
                // iconTheme: IconThemeData(
                //   size:
                //       18, // Adjust the icon size here (smaller size for the toolbar icons)
                // ),
              ),
            ),
            const SizedBox(height: 24),

            /// --- Publish Now ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Publish Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Switch(
                  value: publishNow,
                  onChanged: (val) {
                    setState(() => publishNow = val);
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// --- Schedule Publish ---
            const Text(
              "Schedule Publish",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            Opacity(
              opacity: publishNow ? 0.4 : 1,
              child: IgnorePointer(
                ignoring: publishNow,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // 👇 Control the calendar size using SizedBox
                  child: SizedBox(
                    height: 280, // smaller calendar height (adjust as needed)
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: DateTime.now(),
                      rowHeight: 32, // reduces row height to make it compact
                      selectedDayPredicate: (day) =>
                          _selectedDate != null &&
                          isSameDay(_selectedDate, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() => _selectedDate = selectedDay);
                      },
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      /// 🗓 Days of Week (Only Sunday in Red)
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: const TextStyle(color: Colors.black87),
                        weekendStyle: const TextStyle(color: Colors.black87),
                        dowTextFormatter: (date, locale) {
                          if (date.weekday == DateTime.sunday) {
                            return 'Sun'; // customize short name if needed
                          }
                          return DateFormat.E(locale).format(date);
                        },
                        decoration: const BoxDecoration(),
                      ),

                      /// Customize Sunday text in Calendar days
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final isSunday = day.weekday == DateTime.sunday;
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isSunday ? Colors.red : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                        todayBuilder: (context, day, focusedDay) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: day.weekday == DateTime.sunday
                                    ? Colors.red
                                    : Colors.black,
                              ),
                            ),
                          );
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),

                      calendarStyle: const CalendarStyle(
                        outsideDaysVisible: false,
                        todayDecoration: BoxDecoration(
                          color: Colors.black12,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        selectedTextStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// --- TIP Section ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- TIP with info text ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "TIP: \n\n",
                              style: TextStyle(
                                color: Color(0xFF2B7FD0), // ✅ TIP in blue
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  "Job boards will often reject jobs that do not have quality job descriptions. "
                                  "To ensure that your job description matches the requirements for job boards, consider the following guidelines:\n\n"
                                  "• Job descriptions should be clear, well-written, and informative\n"
                                  "• Job descriptions with 700-2,000 characters get the most interaction\n"
                                  "• Do not use discriminatory language\n"
                                  "• Do not post offensive or inappropriate content\n"
                                  "• Be honest about the job requirement details\n"
                                  "• Help the candidate understand the expectations for this role\n\n",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                /// --- Extra container for "For more tips..." ---
                Container(
                  padding: const EdgeInsets.all(8),
                  // decoration: BoxDecoration(
                  //   // color: Colors.grey.shade200,
                  //   borderRadius: BorderRadius.circular(6),
                  // ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text:
                              "For more tips on writing good job descriptions, ",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: "read our article",
                          style: const TextStyle(
                            color: Color(
                              0xFF2B7FD0,
                            ), // ✅ Highlight link in blue
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Add your navigation or URL launch here
                              print("Read our article clicked");
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// --- Application Requirement Section ---
            const Text(
              "Application Requirement",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              "What personal info would you like to gather about each applicant?",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 16),

            ...requirements.keys.map((req) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Blue circle with checkmark
                        Container(
                          height: 14,
                          width: 14,
                          decoration: const BoxDecoration(
                            color: Color(0xFF007BFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 10,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          req,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _styledToggle(req, "Optional", true),
                        const SizedBox(width: 6),
                        _styledToggle(req, "Required", false),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 30),

            /// --- Save Button ---
            /// --- Add Custom Questions Section ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Add Custom Questions Section ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA), // light gray background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Add Custom Questions",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 6),

                      GestureDetector(
                        onTap: () {
                          // handle "Ask a question" tap
                        },
                        child: const Text(
                          "Ask a question",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF2B7FD0), // blue
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      CustomTextField(
                        label: "",
                        hintText:
                            "What excites you most about this role and our company?",
                      ),
                      const SizedBox(height: 10),

                      /// Question Box (white border only)
                      // Container(
                      //   width: double.infinity,
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: Color(0xFFEAEAEA),
                      //     borderRadius: BorderRadius.circular(6),
                      //     border: Border.all(
                      //       color: Colors.white,
                      //     ), // white border only
                      //   ),
                      //   child: const Text(
                      //     "What excites you most about this role and our company?",
                      //     style: TextStyle(
                      //       fontSize: 10,
                      //       color: Color(0xFF707070),
                      //       fontWeight: FontWeight.w400,
                      //       height: 1.4,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// --- Approve / Reject Buttons (outside container)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Approve Button
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1CB933)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {
                        // handle approve action
                      },
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Reject Button
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFB30505)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                      ),
                      onPressed: () {
                        // handle reject action
                      },
                      child: const Text(
                        "Reject",
                        style: TextStyle(
                          color: Color(0xFF191919),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggleButton(String field, String value) {
    bool isSelected = requirements[field] == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          requirements[field] = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _styledToggle(String field, String value, bool isOptional) {
    bool isSelected = requirements[field] == value;

    Color bgColor;
    Color textColor;

    if (isOptional) {
      bgColor = isSelected ? const Color(0xFF2B7FD0) : Color(0xFFF1F4F5);
      textColor = isSelected ? Color(0xFFFFFFFF) : Color(0xFF9EC7DC);
    } else {
      bgColor = isSelected ? Colors.grey.shade300 : Color(0xFFF1F4F5);
      textColor = isSelected ? Colors.black54 : Color(0xFF9EC7DC);
    }

    return GestureDetector(
      onTap: () => setState(() => requirements[field] = value),

      // child: SizedBox(
      //   height: 14,
      //   width: 37,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(value, style: TextStyle(color: textColor, fontSize: 13)),
      ),
    );
  }
}
