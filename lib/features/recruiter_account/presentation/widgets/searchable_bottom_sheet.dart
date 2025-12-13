import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchableBottomSheet extends StatelessWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelect;

  SearchableBottomSheet(BuildContext context, {
    super.key,
    required this.title,
    required this.items,
    required this.onSelect,
  });

  final TextEditingController searchController = TextEditingController();
  late final RxList<String> filteredItems =
  RxList<String>(List.from(items));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (query) {
                    filteredItems.assignAll(
                      items
                          .where(
                            (item) => item
                            .toLowerCase()
                            .contains(query.toLowerCase()),
                      )
                          .toList(),
                    );
                  },
                ),
              ),
              Obx(
                    () => Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final value = filteredItems[index];
                      return ListTile(
                        title: Text(value),
                        onTap: () {
                          onSelect(value);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
