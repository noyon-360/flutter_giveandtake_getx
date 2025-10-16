import 'package:get/get.dart';

class BookmarkController extends GetxController {
  final RxList<Map<String, dynamic>> savedJobs = <Map<String, dynamic>>[].obs;

  String _getId(Map<String, dynamic> job) {
    final raw = job['raw'] ?? {};
    return job['id']?.toString() ??
        raw['_id']?.toString() ??
        raw['id']?.toString() ??
        job.hashCode.toString();
  }

  bool contains(Map<String, dynamic> job) {
    final id = _getId(job);
    return savedJobs.any((j) => j['id'] == id);
  }

  void addJob(Map<String, dynamic> job) {
    if (contains(job)) return;

    final raw = job['raw'] ?? {};
    final title = raw['title'] ?? job['title'] ?? '';
    final company = raw['companyId'] != null
        ? raw['companyId']['cname'] ?? ''
        : (raw['recruiterId'] != null
              ? '${raw['recruiterId']['firstName'] ?? ''} ${raw['recruiterId']['sureName'] ?? ''}'
                    .trim()
              : job['company'] ?? '');
    final location = raw['location'] ?? job['location'] ?? '';
    final logoUrl = raw['companyId'] != null
        ? raw['companyId']['clogo'] ?? ''
        : (raw['recruiterId'] != null ? raw['recruiterId']['photo'] ?? '' : '');

    final snapshot = {
      'id': _getId(job),
      'title': title,
      'company': company,
      'location': location,
      'logoUrl': logoUrl,
      // keep original payload for actions/navigation
      'original': job,
    };

    savedJobs.add(snapshot);
  }

  void removeJob(Map<String, dynamic> job) {
    final id = job['id'] ?? _getId(job);
    savedJobs.removeWhere((j) => j['id'] == id);
  }
}
