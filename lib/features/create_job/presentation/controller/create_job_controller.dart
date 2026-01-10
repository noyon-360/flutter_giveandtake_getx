import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../domain/category_repo.dart';

class CreateJobPostingController extends GetxController {
  final jobTitleController = TextEditingController();
  final compensationController = TextEditingController();
  final expirationDateController = TextEditingController();
  final departmentController = TextEditingController();

  // Reactive dropdown values
  var selectedCountry = ''.obs;
  var selectedCity = ''.obs;
  var selectedEmploymentType = ''.obs;
  var selectedExperienceLevel = ''.obs;
  var jobTitleManuallyEdited = false.obs;

  // Lists
  var countriesList = <String>[].obs;
  var allCountriesData = <Map<String, dynamic>>[].obs;
  var citiesList = <String>[].obs;

  // Search filters
  var searchCountryText = ''.obs;
  var searchCityText = ''.obs;

  var isLoadingCountries = false.obs;

  var selectedCategory = ''.obs;
  var selectedRole = ''.obs;
  var jobCategories = <String>[].obs;
  var rolesList = <String>[].obs;
  var isLoadingCategories = false.obs;
  var isLoadingRoles = false.obs;

  final RxString selectedJobCategory = ''.obs;
  final RxString selectedJobRole = ''.obs;

  // final ApiClient apiClient = ApiClient();

  final CategoryRepository _categoryRepository;

  CreateJobPostingController(this._categoryRepository);

  // final CategoryController categoryController = Get.put(
  //   CategoryController(CategoryRepoImpl(apiClient: ApiClient())),
  // );

  final String apiUrl = "https://test.evpitch.com/api/v1/countries";
  // final String categoryApiUrl =
  //     "https://api.evpitch.com/api/v1/category/job-category";

  @override
  void onInit() {
    super.onInit();
    fetchCountriesAndCities();
    // categoryController.fetchJobCategories();
  }

  /// Fetch all countries and cities
  Future<void> fetchCountriesAndCities() async {
    try {
      isLoadingCountries.value = true;
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> countryData = data["data"];

        allCountriesData.assignAll(
          countryData.map(
            (e) => {
              "country": e["country"],
              "cities": List<String>.from(e["cities"]),
            },
          ),
        );

        countriesList.assignAll(
          allCountriesData.map((e) => e["country"] as String),
        );
      } else {
        Get.snackbar(
          "Error",
          "Failed to load countries (${response.statusCode})",
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Error fetching countries: $e");
    } finally {
      isLoadingCountries.value = false;
    }
  }

  /// When a country is selected, load its cities
  void fetchCities(String country) {
    final matched = allCountriesData.firstWhereOrNull(
      (e) => e["country"] == country,
    );
    if (matched != null) {
      citiesList.assignAll(List<String>.from(matched["cities"]));
    } else {
      citiesList.clear();
    }
  }

  /// Filtered lists based on search
  List<String> get filteredCountries {
    if (searchCountryText.value.isEmpty) return countriesList;
    return countriesList
        .where(
          (c) =>
              c.toLowerCase().contains(searchCountryText.value.toLowerCase()),
        )
        .toList();
  }

  List<String> get filteredCities {
    if (searchCityText.value.isEmpty) return citiesList;
    return citiesList
        .where(
          (c) => c.toLowerCase().contains(searchCityText.value.toLowerCase()),
        )
        .toList();
  }

  
}
