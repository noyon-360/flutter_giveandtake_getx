// import 'package:get/get.dart';
// import 'package:karlfive/core/base/base_controller.dart';

// class ManageJobPostController extends BaseController {
//   var jobRequests = List.generate(
//     8,
//     (index) => {
//       "name": "Ken Adams",
//       "position": "Recruiter",
//       "company": "Abc ltd.",
//       "jobTitle": "Frontend Developer",
//       "image":
//           "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=80&q=80",
//     },
//   ).obs;

//   var currentPage = 1.obs;
//   final totalPages = 3;

//   void nextPage() {
//     if (currentPage.value < totalPages) currentPage.value++;
//   }

//   void previousPage() {
//     if (currentPage.value > 1) currentPage.value--;
//   }
// }
