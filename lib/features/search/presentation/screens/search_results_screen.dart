import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/company/data/model/seach_all_user_response_model.dart';
import 'package:giveandtake/features/company/presentation/screen/public_view_seach_screen.dart';
import 'package:giveandtake/features/job_listing/presentation/screens/job_details_screen.dart';
import 'package:giveandtake/features/job_listing/presentation/widgets/job_card.dart';
import 'package:giveandtake/features/public_view/screens/public_view_candidate_screens.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/recruiter_public_view.dart';
import 'package:giveandtake/features/search/presentation/controller/search_controller.dart';

/// Full search-results screen (web /all-users parity) with a People tab and a
/// Jobs tab, both seeded by the shared query in [GlobalSearchController].
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen>
    with SingleTickerProviderStateMixin {
  final GlobalSearchController controller = Get.find<GlobalSearchController>();
  late final TabController _tabController;
  late final TextEditingController _searchField;

  static const Color _accent = Color(0xFF2B7FD0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchField = TextEditingController(text: controller.query.value);
    // Load jobs for the current query and keep them fresh on edits.
    controller.onResultsScreenOpen();
  }

  @override
  void dispose() {
    controller.onResultsScreenClose();
    _tabController.dispose();
    _searchField.dispose();
    super.dispose();
  }

  void _openProfile(SeachAllUserResponseModel u) {
    final slug = u.slug;
    if (slug.isEmpty) {
      Get.snackbar('Unavailable', 'This user has no public profile');
      return;
    }
    final role = u.role.toLowerCase();
    if (role == 'candidate') {
      Get.to(() => PublicViewCandidateScreen(slug: slug));
    } else if (role == 'recruiter') {
      Get.to(() => RecruiterPublicViewScreen(slug: slug));
    } else {
      Get.to(() => PublicViewSeachScreen(slug: slug));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: _accent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Search Results',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(108),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchField,
                  onChanged: controller.onQueryChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search people, companies, jobs...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: TabBar(
                  controller: _tabController,
                  labelColor: _accent,
                  unselectedLabelColor: Colors.black54,
                  indicatorColor: _accent,
                  tabs: const [
                    Tab(text: 'People'),
                    Tab(text: 'Jobs'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPeopleTab(),
          _buildJobsTab(),
        ],
      ),
    );
  }

  // ---------------- People tab ----------------
  Widget _buildPeopleTab() {
    return Column(
      children: [
        _buildPeopleFilters(),
        Expanded(
          child: Obx(() {
            if (controller.isPeopleLoading.value &&
                controller.peopleVisible.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.peopleError.value.isNotEmpty &&
                controller.peopleVisible.isEmpty) {
              return _emptyState(
                icon: Icons.error_outline,
                title: controller.peopleError.value,
              );
            }
            if (controller.peopleVisible.isEmpty) {
              return _emptyState(
                icon: Icons.search_off,
                title: controller.query.value.trim().isEmpty
                    ? 'Type to search people'
                    : 'No results found for "${controller.query.value}".',
                subtitle: 'Try searching for people, companies, or locations',
              );
            }
            return NotificationListener<ScrollNotification>(
              onNotification: (info) {
                if (info.metrics.pixels >=
                        info.metrics.maxScrollExtent - 200 &&
                    controller.peopleHasMore.value) {
                  controller.loadMorePeople();
                }
                return false;
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 4, bottom: 16),
                itemCount: controller.peopleVisible.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.peopleVisible.length) {
                    return controller.peopleHasMore.value
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child:
                                Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox(height: 8);
                  }
                  return _peopleTile(controller.peopleVisible[index]);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPeopleFilters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedRole.value,
                    items: const [
                      DropdownMenuItem(
                          value: 'All Roles', child: Text('All Roles')),
                      DropdownMenuItem(
                          value: 'candidate', child: Text('Candidates')),
                      DropdownMenuItem(
                          value: 'recruiter', child: Text('Recruiters')),
                      DropdownMenuItem(
                          value: 'company', child: Text('Companies')),
                    ],
                    onChanged: (v) {
                      if (v != null) controller.updateRole(v);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Immediate'),
              selected: controller.isImmediate.value,
              selectedColor: Colors.green.withOpacity(0.15),
              checkmarkColor: Colors.green,
              onSelected: controller.toggleImmediate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _peopleTile(SeachAllUserResponseModel user) {
    final isImmediate = user.immediatelyAvailable == true;
    return ListTile(
      onTap: () => _openProfile(user),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.grey[300],
        backgroundImage:
            (user.avatar?.url != null && user.avatar!.url!.isNotEmpty)
                ? NetworkImage(user.avatar!.url!)
                : null,
        child: (user.avatar?.url == null || user.avatar!.url!.isEmpty)
            ? Text(
                (user.name.isNotEmpty ? user.name[0] : '?').toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              user.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          if (isImmediate) ...[
            const SizedBox(width: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Immediate',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          const SizedBox(width: 8),
          _roleIcon(user.role),
        ],
      ),
      subtitle: Text(
        user.address.isNotEmpty ? user.address : 'N/A',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _roleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'candidate':
        return const Icon(Icons.person_outline, color: Colors.green, size: 18);
      case 'company':
        return const Icon(Icons.business, color: Colors.purple, size: 18);
      case 'recruiter':
        return const Icon(Icons.how_to_reg, color: Colors.blue, size: 18);
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------- Jobs tab ----------------
  Widget _buildJobsTab() {
    return Obx(() {
      if (controller.isJobsLoading.value && controller.jobs.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.jobsError.value.isNotEmpty && controller.jobs.isEmpty) {
        return _emptyState(
          icon: Icons.error_outline,
          title: controller.jobsError.value,
        );
      }
      if (controller.jobs.isEmpty) {
        return _emptyState(
          icon: Icons.work_off_outlined,
          title: controller.query.value.trim().isEmpty
              ? 'Type to search jobs'
              : 'No jobs found for "${controller.query.value}".',
        );
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (info) {
          if (info.metrics.pixels >= info.metrics.maxScrollExtent - 200 &&
              controller.jobsHasMore.value) {
            controller.loadMoreJobs();
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          itemCount: controller.jobs.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.jobs.length) {
              return controller.isJobsMoreLoading.value
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : const SizedBox(height: 8);
            }
            final job = controller.jobs[index];
            return JobCard(
              title: job.title,
              company: job.companyId?.cname ?? 'Unknown',
              location: job.location,
              duration: job.employementType,
              salary: job.salaryRange,
              timePosted: job.timePostedFormatted,
              logoUrl: job.companyId?.clogo,
              onTap: () => Get.to(
                () => JobDetailsScreen(jobData: job.toDisplayMap()),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
