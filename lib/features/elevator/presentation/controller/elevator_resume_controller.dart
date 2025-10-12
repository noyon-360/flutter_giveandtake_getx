import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ElevatorResumeController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Selected values
  var selectedTitle = 'Mr.'.obs;
  var selectedCountry = Rx<String?>(null);
  var selectedCity = Rx<String?>(null);
  var selectedJobTitle = Rx<String?>(null);
  var selectedStartMonth = Rx<String?>(null);
  var selectedStartYear = Rx<String?>(null);
  var selectedEndMonth = Rx<String?>(null);
  var selectedEndYear = Rx<String?>(null);
  var selectedAvailability = Rx<String?>(null);
  var selectedJobCategory = Rx<String?>(null);
  var selectedDegree = Rx<String?>(null);
  var selectedGradMonth = Rx<String?>(null);
  var selectedGradYear = Rx<String?>(null);

  // Checkbox states
  var presentlyWorkHere = false.obs;
  var presentlyAttendHere = false.obs;

  // File paths
  var elevatorVideoPath = Rx<String?>(null);
  var photoPath = Rx<String?>(null);

  // Dynamic lists
  var experienceList = <Map<String, dynamic>>[{}].obs;
  var educationList = <Map<String, dynamic>>[{}].obs;
  var awardsList = <Map<String, dynamic>>[{}].obs;

  // Dummy data
  final List<String> titles = ['Mr.', 'Mrs.', 'Ms.', 'Dr.'];

  final List<String> countries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'Germany',
    'France',
    'India',
    'China',
    'Japan',
  ];

  final List<String> cities = [
    'New York',
    'London',
    'Toronto',
    'Sydney',
    'Berlin',
    'Paris',
    'Mumbai',
    'Beijing',
    'Tokyo',
  ];

  final List<String> jobTitles = [
    'Software Engineer',
    'Product Manager',
    'Designer',
    'Data Scientist',
    'Marketing Manager',
    'Sales Executive',
    'HR Manager',
    'Business Analyst',
  ];

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final List<String> years = List.generate(
    50,
    (index) => (DateTime.now().year - index).toString(),
  );

  final List<String> availabilities = [
    'Immediately',
    'Within 2 weeks',
    'Within 1 month',
    'Within 2 months',
    'Within 3 months',
  ];

  final List<String> jobCategories = [
    'Technology',
    'Healthcare',
    'Finance',
    'Education',
    'Marketing',
    'Sales',
    'Human Resources',
    'Design',
    'Engineering',
  ];

  final List<String> degrees = [
    'High School',
    'Associate Degree',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'Doctorate',
    'Professional Certificate',
  ];

  // Image/Video picker methods
  Future<void> pickElevatorVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        elevatorVideoPath.value = video.path;
        Get.snackbar('Success', 'Video selected successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick video: $e');
    }
  }

  Future<void> pickPhoto() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        photoPath.value = image.path;
        Get.snackbar('Success', 'Photo selected successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick photo: $e');
    }
  }

  // Add more items
  void addExperience() {
    experienceList.add({});
  }

  void addEducation() {
    educationList.add({});
  }

  void addAward() {
    awardsList.add({});
  }

  // Save method
  void saveResume() {
    Get.snackbar('Success', 'Resume saved successfully!');
    // TODO: Implement actual save logic
  }
}
