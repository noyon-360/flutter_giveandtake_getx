import 'package:flutter/material.dart';

/// Custom searchable dropdown with inline filter (no popup)
class SearchableDropdown extends StatefulWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const SearchableDropdown({
    Key? key,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SearchableDropdown> createState() => _SearchableDropdownState();
}

class _SearchableDropdownState extends State<SearchableDropdown> {
  late TextEditingController _searchController;
  bool _showDropdown = false;
  final FocusNode _focusNode = FocusNode();
  String? _previousValue;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.value ?? '');
    _previousValue = widget.value;
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() => _showDropdown = false);
      }
    });
  }

  @override
  void didUpdateWidget(SearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync if the value passed from parent changed
    if (oldWidget.value != widget.value) {
      _searchController.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Extra safety: if the controller text is out of sync with widget.value
    // and the user is NOT currently focusing/typing, force sync it.
    if (!_focusNode.hasFocus && _searchController.text != (widget.value ?? '')) {
      _searchController.text = widget.value ?? '';
    }

    final filtered = widget.items
        .where((item) => item.toLowerCase().contains(_searchController.text.toLowerCase()))
        .take(5)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: _searchController.text.isEmpty ? widget.hint : null,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      widget.onChanged(null);
                      setState(() {});
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          onChanged: (query) {
            setState(() {
              _showDropdown = query.isNotEmpty;
            });
          },
          onTap: () {
            setState(() {
              _showDropdown = true;
            });
          },
        ),
        if (_showDropdown && filtered.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.white,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      _searchController.text = filtered[index];
                      widget.onChanged(filtered[index]);
                      setState(() {
                        _showDropdown = false;
                      });
                      _focusNode.unfocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Text(
                        filtered[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
