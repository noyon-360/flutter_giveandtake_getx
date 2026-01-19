import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:karlfive/core/theme/input_decoration_extensions.dart';
import '../controller/country_city_controller.dart';
class CountryCitySearchableDropdown extends StatelessWidget {
  const CountryCitySearchableDropdown({
    super.key,
    required this.controller,
  });

  final LocationController controller;


  void _showSearchDialog({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Function(String?) onSelected,
  }) {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredItems = List.from(items);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(title),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  //  Search Field
                  TextField(
                    controller: searchController,
                    decoration: context.primaryInputDecoration.copyWith(
                      hintText: "Search...",
                      prefixIcon: const Icon(Icons.search,color: Color(0xFF787878),),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredItems = items
                            .where((item) =>
                            item.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Scrollable List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            onSelected(item); //safe call
                            Get.back();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 Country Dropdown
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Country*',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Obx(() {
                return InkWell(
                  onTap: () => _showSearchDialog(
                    context: context,
                    title: "Select Country",
                    items: controller.countries,
                    onSelected: (selected) {
                      if (selected != null) {
                        controller.onCountrySelected(selected);
                      }
                    },
                  ),
                  child: InputDecorator(
                    decoration: context.primaryInputDecoration.copyWith(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      (controller.selectedCountry.value?.isEmpty ?? true)
                          ? "Select country"
                          : controller.selectedCountry.value ?? "",
                    )
                  ),
                );
              }),
            ],
          ),
        ),

        const SizedBox(width: 19),

        // 🔹 City Dropdown (filtered by selected country)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'City*',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              Obx(() {
                return InkWell(
                  onTap: controller.cities.isEmpty
                      ? null
                      : () => _showSearchDialog(
                    context: context,
                    title: "Select City",
                    items: controller.cities,
                    onSelected: (selected) {
                      if (selected != null) {
                        controller.onCitySelected(selected);
                      }
                    },
                  ),
                  child: InputDecorator(
                    decoration: context.primaryInputDecoration.copyWith(
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(
                      (controller.selectedCity.value?.isEmpty ?? true)
                          ? "Select city"
                          : controller.selectedCity.value ?? "",
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
