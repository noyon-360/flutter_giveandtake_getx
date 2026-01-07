import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  var countries = <String>[].obs;
  var cities = <String>[].obs;

  var selectedCountry = RxnString();
  var selectedCity = RxnString();

  // Map to store country -> cities
  Map<String, List<String>> countryCityMap = {};

  @override
  void onInit() {
    super.onInit();
    fetchCountriesWithCities();
  }

  Future<void> fetchCountriesWithCities() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.10.5.33:5004/api/v1/countries'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        for (var country in data['data']) {
          if (country['cities'] != null && (country['cities'] as List).isNotEmpty) {
            countryCityMap[country['country']] = List<String>.from(country['cities']);
          }
        }

        countries.value = countryCityMap.keys.toList();
        print("Countries loaded: ${countries.length}");
      } else {
        print("Failed to load countries");
      }
    } catch (e) {
      print("Error fetching countries: $e");
    }
  }

  void onCountrySelected(String? country) {
    selectedCountry.value = country;
    if (country != null) {
      cities.value = countryCityMap[country] ?? [];
      selectedCity.value = null;
      print("Loaded ${cities.length} cities for $country");
    } else {
      cities.clear();
      selectedCity.value = null;
    }
  }

  void onCitySelected(String? city) {
    selectedCity.value = city;
  }
}
