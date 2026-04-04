import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  // ──────────────────────────────────────────────
  // Observables - using RxnString is fine, but many prefer '' as default
  // ──────────────────────────────────────────────
  final countries = <String>[].obs;
  final cities = <String>[].obs;

  final selectedCountry = RxnString(); // or final selectedCountry = ''.obs;
  final selectedCity = RxnString();    // or final selectedCity = ''.obs;

  // Using late + final is safer for maps that won't change structure
  late final Map<String, List<String>> _countryCityMap = {};

  // Loading & error states (very important for UX)
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  void setInitialCountryAndCity(String country, String city) {
    selectedCountry.value = country.trim().isNotEmpty ? country : null;
    if (country.trim().isNotEmpty) {
      onCountrySelected(country); // This will load cities safely
    }
    selectedCity.value = city.trim().isNotEmpty ? city : null;
  }

  @override
  void onInit() {
    super.onInit();
    fetchCountriesWithCities();
  }

  Future<void> fetchCountriesWithCities() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse('https://test.evpitch.com/api/v1/countries'),
        headers: {
          'Accept': 'application/json',
          // Add authorization header if needed in future
          // 'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // More defensive parsing
        final countryList = data['data'] as List<dynamic>? ?? [];

        _countryCityMap.clear();

        for (final countryData in countryList) {
          final countryName = countryData['country'] as String?;
          final citiesList = countryData['cities'] as List<dynamic>?;

          if (countryName != null && citiesList != null && citiesList.isNotEmpty) {
            _countryCityMap[countryName] = citiesList
                .map((c) => c.toString().trim())
                .where((c) => c.isNotEmpty)
                .toList();
          }
        }

        countries.assignAll(_countryCityMap.keys.toList()..sort());
        print("✓ Loaded ${countries.length} countries");
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print("Error loading countries: $e");
      print(stack);
      // Optional: Get.snackbar('Error', 'Failed to load countries');
    } finally {
      isLoading.value = false;
    }
  }

  void onCountrySelected(String? country) {
    selectedCountry.value = country;

    if (country != null && country.isNotEmpty) {
      final countryCities = _countryCityMap[country] ?? [];
      cities.assignAll(countryCities..sort());
      // Usually reset city when country changes
      selectedCity.value = null;
      print("→ Loaded ${cities.length} cities for '$country'");
    } else {
      cities.clear();
      selectedCity.value = null;
    }
  }

  void onCitySelected(String? city) {
    selectedCity.value = city;
  }

  // Optional: Helpful utility methods
  bool get hasCountries => countries.isNotEmpty;
  bool get hasCities => cities.isNotEmpty;

  void clearSelection() {
    selectedCountry.value = null;
    selectedCity.value = null;
    cities.clear();
  }

  // Call this when user wants to reload (pull-to-refresh, retry button)
  Future<void> retryFetch() => fetchCountriesWithCities();

  @override
  void onClose() {
    // Rarely needed for http, but good practice
    super.onClose();
  }
}