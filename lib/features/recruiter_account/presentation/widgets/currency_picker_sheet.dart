import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/recruiter_account/data/models/get_currency_response_model.dart';

/// A nicely-styled, searchable bottom sheet for picking a currency.
/// Shared by the Create Job and Edit Job screens.
Future<GetCurrencyResponseModel?> showCurrencyPickerSheet(
  BuildContext context, {
  required List<GetCurrencyResponseModel> currencies,
  GetCurrencyResponseModel? selectedCurrency,
}) {
  final searchController = TextEditingController();
  final filteredCurrencies = RxList<GetCurrencyResponseModel>(
    List.from(currencies),
  );
  final hasQuery = false.obs;

  return showModalBottomSheet<GetCurrencyResponseModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: SizedBox(
            height: MediaQuery.of(ctx).size.height * 0.7,
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
                const Text(
                  'Select Currency',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Obx(
                    () => TextField(
                      controller: searchController,
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Search currency',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        suffixIcon: hasQuery.value
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  searchController.clear();
                                  hasQuery.value = false;
                                  filteredCurrencies.assignAll(currencies);
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        hasQuery.value = value.isNotEmpty;
                        final query = value.toLowerCase();
                        filteredCurrencies.assignAll(
                          currencies.where(
                            (c) =>
                                c.currencyName.toLowerCase().contains(query) ||
                                c.symbol.toLowerCase().contains(query) ||
                                c.code.toLowerCase().contains(query),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Obx(() {
                    if (filteredCurrencies.isEmpty) {
                      return const Center(child: Text('No currencies found'));
                    }
                    return ListView.separated(
                      itemCount: filteredCurrencies.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (_, index) {
                        final c = filteredCurrencies[index];
                        final isSelected = selectedCurrency?.id == c.id;
                        return ListTile(
                          title: Text('${c.currencyName} (${c.symbol})'),
                          trailing: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Color(0xFF2B7FD0),
                                )
                              : null,
                          onTap: () => Navigator.pop(ctx, c),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
