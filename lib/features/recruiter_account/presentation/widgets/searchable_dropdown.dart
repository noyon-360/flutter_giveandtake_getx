// import 'package:flutter/material.dart';
// import 'package:karlfive/core/theme/input_decoration_extensions.dart';
//
// class SearchableDropdown extends StatefulWidget {
//   final String title;
//   final List<String> items;
//   final String? selectedItem;
//   final Function(String) onSelected;
//
//   const SearchableDropdown({
//     super.key,
//     required this.title,
//     required this.items,
//     this.selectedItem,
//     required this.onSelected,
//   });
//
//   @override
//   _SearchableDropdownState createState() => _SearchableDropdownState();
// }
//
// class _SearchableDropdownState extends State<SearchableDropdown> {
//   late TextEditingController searchController;
//   List<String> filteredItems = [];
//
//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     filteredItems = List.from(widget.items);
//   }
//
//   @override
//   void didUpdateWidget(covariant SearchableDropdown oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.items != widget.items) {
//       filteredItems = List.from(widget.items);
//     }
//   }
//
//   void _filter(String query) {
//     setState(() {
//       filteredItems = widget.items
//           .where((item) => item.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }
//
//   void _openDialog() {
//     searchController.clear();
//     filteredItems = List.from(widget.items);
//
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         insetPadding: const EdgeInsets.all(16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           height: 350,
//           child: Column(
//             children: [
//               TextField(
//                 controller: searchController,
//                 onChanged: _filter,
//                 decoration: const InputDecoration(
//                   prefixIcon: Icon(Icons.search, color: Color(0xFF787878)),
//                   hintText: "Search...",
//                   contentPadding: EdgeInsets.all(8),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Expanded(
//                 child: RawScrollbar(
//                   thumbVisibility: true,
//                   thickness: 6,
//                   radius: const Radius.circular(8),
//                   child: ListView.builder(
//                     padding: EdgeInsets.zero,
//                     itemCount: filteredItems.length,
//                     itemBuilder: (context, index) {
//                       final item = filteredItems[index];
//                       return DropdownMenuItem(
//                         value: item,
//                         child: ListTile(
//                           title: Text(item),
//                           onTap: () {
//                             widget.onSelected(item);
//                             Navigator.of(context).pop();
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _openDialog,
//       child: InputDecorator(
//         decoration: context.primaryInputDecoration.copyWith(
//           border: const OutlineInputBorder(),
//           suffixIcon: const Icon(Icons.arrow_drop_down),
//         ),
//         child: Text(
//           widget.selectedItem?.isNotEmpty == true
//               ? widget.selectedItem!
//               : widget.title,
//           style: const TextStyle(fontSize: 14),
//         ),
//       ),
//     );
//   }
// }
