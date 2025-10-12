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

  // Checkbox states - now per-item instead of global
  var presentlyWorkHere = false.obs;

  // File paths
  var elevatorVideoPath = Rx<String?>(null);
  var photoPath = Rx<String?>(null);

  // Dynamic lists with individual checkbox states
  var experienceList = <Map<String, dynamic>>[
    {'presentlyWorkHere': false},
  ].obs;
  var educationList = <Map<String, dynamic>>[
    {'presentlyAttendHere': false},
  ].obs;
  var awardsList = <Map<String, dynamic>>[{}].obs;

  // Skills list
  var skillsList = <String>[].obs;

  // Other URLs list
  var otherUrlsList = <String>[].obs;

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
    experienceList.add({'presentlyWorkHere': false});
  }

  void addEducation() {
    educationList.add({'presentlyAttendHere': false});
  }

  void addAward() {
    awardsList.add({});
  }

  // Remove items
  void removeExperience(int index) {
    if (experienceList.length > 1) {
      experienceList.removeAt(index);
    }
  }

  void removeEducation(int index) {
    if (educationList.length > 1) {
      educationList.removeAt(index);
    }
  }

  void removeAward(int index) {
    if (awardsList.length > 1) {
      awardsList.removeAt(index);
    }
  }

  // Skills management
  void addSkill(String skill) {
    if (skill.trim().isNotEmpty && !skillsList.contains(skill.trim())) {
      skillsList.add(skill.trim());
    }
  }

  void removeSkill(int index) {
    skillsList.removeAt(index);
  }

  // Other URLs management
  void addOtherUrl() {
    otherUrlsList.add('');
  }

  void removeOtherUrl(int index) {
    otherUrlsList.removeAt(index);
  }

  // Toggle checkbox for specific item
  void togglePresentlyWorkHere(int index) {
    experienceList[index]['presentlyWorkHere'] =
        !(experienceList[index]['presentlyWorkHere'] ?? false);
    experienceList.refresh();
  }

  void togglePresentlyAttendHere(int index) {
    educationList[index]['presentlyAttendHere'] =
        !(educationList[index]['presentlyAttendHere'] ?? false);
    educationList.refresh();
  }

  // Save method
  void saveResume() {
    Get.snackbar('Success', 'Resume saved successfully!');
    // TODO: Implement actual save logic
  }
}
