import '../data/models/content_page.dart';

const builtInContentTypes = <String>[
  'about',
  'privacy',
  'candidate',
  'recruiter',
  'company',
  'terms',
];

bool isCustomPage(ContentPageIdentity page) {
  final type = page.type;
  return type != null &&
      type.isNotEmpty &&
      !page.isSystem &&
      !builtInContentTypes.contains(type);
}
