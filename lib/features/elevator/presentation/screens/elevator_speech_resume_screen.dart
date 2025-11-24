import 'package:flutter/material.dart';
import 'package:karlfive/features/elevator/presentation/widgets/about_widget.dart';
import 'package:karlfive/features/elevator/presentation/widgets/awards_widget.dart';
import 'package:karlfive/features/elevator/presentation/widgets/contact_card.dart';
import 'package:karlfive/features/elevator/presentation/widgets/education_widget.dart';
import 'package:karlfive/features/elevator/presentation/widgets/experience_widget.dart';
import 'package:karlfive/features/elevator/presentation/widgets/skill_widget.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/title_with_edit_logo.dart';

class ElevatorSpeechResumeScreen extends StatelessWidget {
  const ElevatorSpeechResumeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("Elevator Speech Resume")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(height: 30),
                  TitleWithEditLogo(
                    title: "Elevator Speech Resume",
                    onPress: () {
                      //* <--- Handle edit action --->
                    },
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 72.0),
                    child: Text(
                      "Get a quick glimps of my work and creative process through this video portfolio",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: screenWidth - (16 * 2),
                      height: 105,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          color: Colors.black,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Center(
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TitleWithEditLogo(
                    title: "My Resume",
                    onPress: () {
                      //* <--- Handle edit action --->
                    },
                  ),
                  SizedBox(height: 16),

                  //! <----- CONTACT ----->
                  ContactCard(),

                  SizedBox(height: 16),

                  Divider(
                    color: AppColors.textFieldLightGrey,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                  ),

                  SizedBox(height: 16),

                  //! <----- ABOUT ----->
                  AboutWidget(),

                  SizedBox(height: 16),

                  Divider(
                    color: AppColors.textFieldLightGrey,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                  ),

                  SizedBox(height: 16),

                  //! <----- SKILLS ----->
                  SkillsWidget(),

                  SizedBox(height: 16),

                  Divider(
                    color: AppColors.textFieldLightGrey,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                  ),

                  SizedBox(height: 16),

                  //! <----- EXPERIENCE ----->
                  ExperienceWidget(),

                  SizedBox(height: 16),

                  Divider(
                    color: AppColors.textFieldLightGrey,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                  ),

                  SizedBox(height: 16),

                  //! <----- EDUCATION ----->
                  EducationWidget(),

                  SizedBox(height: 16),

                  Divider(
                    color: AppColors.textFieldLightGrey,
                    thickness: 2,
                    indent: 16,
                    endIndent: 16,
                  ),

                  SizedBox(height: 16),

                  //! <----- AWARD ----->
                  AwardsWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
