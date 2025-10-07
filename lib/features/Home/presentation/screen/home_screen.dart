import 'package:flutter/material.dart';
import 'package:karlfive/core/common/widgets/app_scaffold.dart';
import 'package:karlfive/core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF5F6FF),
        title: Row(
          children: [
            Icon(Icons.menu, color: AppColors.textBlack),
            Spacer(),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.notifications_active_outlined,
                color: AppColors.primaryWhite,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: AppColors.homeHeadBackground,
        height: MediaQuery.of(context).size.height * 0.16,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello Mr. Saifullah",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                "Find your Dream Job",
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.textBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search your job",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textFieldLightGrey,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.textFieldLightGrey,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF3B9EFF),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 1,
                              color: Color(0xFF3B9EFF),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 2,
                              color: Color(0xFF3B9EFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // TODO: handle location
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        "assets/icons/home_search_location.png",
                        color: AppColors.primaryWhite,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      // TODO: handle filter
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        "assets/icons/home_filter_search.png",
                        color: AppColors.primaryWhite,
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
