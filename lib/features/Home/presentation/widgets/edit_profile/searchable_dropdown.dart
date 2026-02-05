import 'package:flutter/material.dart';

/// Custom searchable dropdown with filter
class SearchableDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;
  final double maxHeight;

  const SearchableDropdown({
    Key? key,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.maxHeight = 200,
  }) : super(key: key);

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  late TextEditingController _searchController;
  late List<String> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showSearchDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.value ?? widget.hint,
                style: TextStyle(
                  color: widget.value == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    _searchController.clear();
    _filteredItems = widget.items;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Search'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search TextField
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search ${widget.hint.toLowerCase()}...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (query) {
                      setState(() {
                        if (query.isEmpty) {
                          _filteredItems = widget.items;
                        } else {
                          _filteredItems = widget.items
                              .where((item) =>
                                  item.toLowerCase().contains(query.toLowerCase()))
                              .toList();
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Filtered List
                  Expanded(
                     // Handle finite height for the list within dialog
                     // Using a constrained box or ensuring parent has height
                     // Expanded usually works if Column is min, but Alert content is wrapped.
                     child: SizedBox(
                       height: widget.maxHeight,
                       child: _filteredItems.isEmpty
                           ? Center(
                               child: Text(
                                 'No results found',
                                 style: TextStyle(color: Colors.grey.shade600),
                               ),
                             )
                           : ListView.builder(
                               itemCount: _filteredItems.length,
                               itemBuilder: (context, index) {
                                 final item = _filteredItems[index];
                                 return ListTile(
                                   title: Text(item),
                                   onTap: () {
                                     widget.onChanged(item);
                                     Navigator.pop(context);
                                   },
                                   selected: widget.value == item,
                                   selectedTileColor: Colors.blue.shade100,
                                 );
                               },
                             ),
                     ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          );
        },
      ),
    );
  }
}
