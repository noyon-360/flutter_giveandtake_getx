import 'package:flutter/material.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import 'package:giveandtake/features/recruiter_account/presentation/controller/recruiter_controller.dart';
import 'package:giveandtake/core/services/get_user_profile_service.dart';
import 'package:giveandtake/core/theme/app_colors.dart';
import 'package:giveandtake/features/auth/data/models/user_model.dart';
import 'package:giveandtake/features/auth/presentation/controller/auth_controller.dart';
import 'package:giveandtake/features/auth/presentation/screens/login_screen.dart';
import 'package:giveandtake/features/company/presentation/controller/company_account_controller.dart';
import 'package:giveandtake/features/company/presentation/controller/company_details_controller.dart';
import 'package:giveandtake/features/elevator/presentation/controller/resume_check_controller.dart';
import 'package:giveandtake/features/home_static_screens/data/models/contactus_model.dart';
import 'package:giveandtake/features/home_static_screens/presentation/screen/contact_us_screen.dart';
import 'package:giveandtake/features/job_listing/presentation/screens/bookmark_jobs_screen.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/create_recruiter_account.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/recruiter_page.dart';
import 'package:giveandtake/features/recruiter_account/presentation/screens/recruiter_public_view.dart';

import '../../../search/presentation/controller/search_controller.dart';
import '../../../company/presentation/screen/public_view_seach_screen.dart';
import '../../../search/presentation/screens/search_results_screen.dart';
import '../../../company/presentation/widget/custom_search_company.dart';
import '../../../home_static_screens/presentation/screen/Terms_screen.dart';
import '../../../home_static_screens/presentation/screen/aboutus_screen.dart';
import '../../../home_static_screens/presentation/screen/blog.dart';
import '../../../home_static_screens/presentation/screen/frequently_questions.dart';
import '../../../home_static_screens/presentation/screen/privacy_policy.dart';
import '../../../job_listing/presentation/screens/all_jobs_screen.dart';
import '../../../profile_dasboard/presentation/screens/change_pass_screen.dart';
import '../../../profile_dasboard/presentation/screens/job_history.dart';
import '../../../profile_dasboard/presentation/screens/payment_history.dart';
import '../../../public_view/screens/public_view_candidate_screens.dart';
import '../screen/candidate_profile_screen.dart';
import '../screens/my_plan_screen.dart';

// ---- Role-flow screens (recruiter) ----
import '../../../recruiter_account/presentation/screens/edit_profile_page.dart';
import '../../../recruiter_account/presentation/screens/create_job_screen.dart';
import '../../../recruiter_account/presentation/screens/all_jobs_screen.dart'
    as recruiter_jobs;
import '../../../recruiter_account/presentation/screens/public_view_screen.dart';
import '../../../recruiter_account/presentation/screens/connect_with_company_page.dart';
import '../../../recruiter_account/presentation/screens/company_info_screen.dart';
import '../../../recruiter_account/presentation/screens/change_password_screen.dart';

// ---- Role-flow screens (company) ----
import '../../../company/presentation/controller/company_details_controller.dart';
import '../../../company/presentation/screen/company_edit_profile.dart';
import '../../../company/presentation/screen/manage_job_req_screen.dart';
import '../../../company/presentation/screen/employee_screen.dart';
import '../../../company/presentation/screen/recruiter_request_screen.dart';
import '../../../company/presentation/screen/company_change_password_screen.dart';
import '../../../company/presentation/screen/connect_company_dialog_screen.dart';

// ---- Shared "My Plan" pricing (recruiter + company) ----
import '../../../company_pricing/presentation/screens/plan_pricing_screen(company).dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _isLoggedIn = false;
  String? _role; // candidate / recruiter / company — drives the My Account flow
  GetUserProfileService? _profileService;
  late final AuthController _authController;

  final _searchController = TextEditingController();

  late final GlobalSearchController controller;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
    controller = Get.find<GlobalSearchController>();
    try {
      _profileService = Get.find<GetUserProfileService>();
    } catch (_) {
      // Profile service not registered — header falls back to generic labels.
    }
    _loadAuthStatus();

    // Drive the server-backed (debounced) search from the text field.
    _searchController.addListener(() {
      controller.onQueryChanged(_searchController.text);
    });

    // Reset any previous search when the drawer opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchController.clear();
      controller.onQueryChanged('');
    });
  }

  Future<void> _loadAuthStatus() async {
    final accessToken = await _authController.authStorageService.getAccessToken();
    final role = await _authController.authStorageService.getUserRole();
    if (!mounted) return;
    setState(() {
      _isLoggedIn = accessToken != null && accessToken.isNotEmpty;
      _role = role;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool get _effectiveIsLoggedIn => _authController.isLoggedIn.value || _isLoggedIn;

  String get _effectiveRole =>
      (_profileService?.userInfoRx.value?.role ?? _role ?? '').toLowerCase();

  /// Handles the "Elevator Pitch & Resume" button with role-based navigation:
  ///  - Guest (no token)  → LoginScreen
  ///  - Candidate         → existing ResumeCheckController flow (unchanged)
  ///  - Recruiter         → calls fetchRecruiterInfo API; if not found → setup,
  ///                        else → RecruiterPageScreen
  ///  - Company           → calls fetchCompanyInfo API; if companies list is
  ///                        non-empty → company dashboard, else → account setup
  Future<void> _handleElevatorPitch() async {
    final authController = Get.find<AuthController>();

    // 1. Guest: no access token → go to LoginScreen
    final accessToken = await authController.authStorageService
        .getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      Get.to(() => const LoginScreen());
      return;
    }

    final userRole = await authController.authStorageService.getUserRole();

    // 2. Candidate: keep existing behaviour
    if (userRole == 'candidate') {
      final resumeController = Get.put(ResumeCheckController());
      resumeController.checkResumeAndNavigate();
      return;
    }

    // 3. Recruiter: fetch recruiter profile and navigate accordingly
    if (userRole == 'recruiter') {
      final userId = await authController.authStorageService.getUserId();
      if (userId == null || userId.isEmpty) {
        Get.snackbar('Error', 'User ID not found. Please log in again.');
        return;
      }

      // Show loading overlay
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        // Route on a real recruiter profile, not the always-null message.
        final hasProfile =
            await Get.find<RecruiterController>().hasRecruiterProfile();
        if (Get.isDialogOpen ?? false) Get.back();
        DPrint.log('Recruiter hasProfile: $hasProfile');
        if (hasProfile) {
          Get.to(() => const RecruiterPageScreen());
        } else {
          Get.to(() => CreateRecruiterAccount());
        }
      } catch (e) {
        if (Get.isDialogOpen ?? false) Get.back();
        DPrint.log('Recruiter fetch error: $e');
        Get.to(() => CreateRecruiterAccount());
      }
      return;
    }

    // 4. Company: fetch company info and navigate based on whether company exists
    if (userRole == 'company') {
      final companyController = Get.find<CompanyAccountController>();
      await companyController.navigateFromElevatorPitch();
      return;
    }

    // 5. Other roles: fallback
    Get.snackbar(
      'Not Available',
      'This feature is not available for your account type.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ---- Role-specific "My Account" menu -------------------------------------

  /// Picks the menu items for the logged-in user's role. Candidate is the
  /// default (and the fallback for an unknown role).
  List<Widget> _accountTilesForRole() {
    switch (_effectiveRole) {
      case 'recruiter':
        return _recruiterTiles();
      case 'company':
        return _companyTiles();
      case 'candidate':
      default:
        return _candidateTiles();
    }
  }

  List<Widget> _candidateTiles() {
    return [
      ListTileForNav(
        liconPath: "assets/icons/home.png",
        title: "My Profile",
        onTap: () {
          Get.back();
          Get.to(() => const CandidateProfileScreen());
        },
      ),
      ListTileForNav(
        liconPath: "assets/icons/list.png",
        title: "Job History",
        onTap: () {
          Get.back();
          Get.to(() => const JobHistoryScreen());
        },
      ),
      ListTileForNav(
        liconPath: "assets/icons/book-open-01.png",
        title: "Payment History",
        onTap: () {
          Get.back();
          Get.to(() => const PaymentHistoryScreen());
        },
      ),
      ListTileForNav(
        liconPath: "assets/icons/list.png",
        title: "All Plans",
        onTap: () {
          Get.back();
          Get.to(() => const MyPlanScreen());
        },
      ),
      ListTileForNav(
        title: "Bookmarked Jobs",
        liconPath: "assets/icons/book-open-01.png",
        onTap: () {
          Get.back();
          Get.to(() => BookmarkJobsScreen());
        },
      ),
      ListTileForNav(
        liconPath: "assets/icons/changepass.png",
        title: "Change Password",
        onTap: () {
          Get.back();
          Get.to(() => ChangePasswordScreen());
        },
      ),
    ];
  }

  List<Widget> _recruiterTiles() {
    return [
      ListTileForNav(
        icon: Icons.edit,
        title: "Edit Profile",
        onTap: _openRecruiterEditProfile,
      ),
      ListTileForNav(
        icon: Icons.business_center_outlined,
        title: "Post a Job",
        onTap: () {
          Get.back();
          Get.to(() => CreateJobScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.business_center,
        title: "Manage Jobs",
        onTap: () {
          Get.back();
          Get.to(() => recruiter_jobs.AllJobsScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.public,
        title: "Public View",
        onTap: () {
          Get.back();
          Get.to(() => PublicViewScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.post_add,
        title: "Connect with Company",
        onTap: () {
          final isConnected =
              Get.find<RecruiterController>().userInfo.value?.companyId != null;
          if (isConnected) {
            Get.snackbar(
              "Information",
              "You are already connected with a company",
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
          Get.back();
          Get.to(() => ConnectCompanyPage());
        },
      ),
      ListTileForNav(
        icon: Icons.info_outline,
        title: "Company Information",
        onTap: () {
          Get.back();
          Get.to(() => CompanyInformation());
        },
      ),
      ListTileForNav(
        icon: Icons.next_plan_outlined,
        title: "My Plan",
        onTap: () {
          Get.back();
          Get.to(() => PlanPricingScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.lock_outline,
        title: "Change Password",
        onTap: () {
          Get.back();
          Get.to(() => ChangePassword());
        },
      ),
    ];
  }

  List<Widget> _companyTiles() {
    return [
      ListTileForNav(
        icon: Icons.work_outline,
        title: "Manage Jobs",
        onTap: () {
          Get.back();
          Get.to(() => ManageJobPostScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.post_add_outlined,
        title: "Post a Job",
        onTap: () {
          Get.back();
          Get.to(() => CreateJobScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.edit,
        title: "Edit Profile",
        onTap: _openCompanyEditProfile,
      ),
      ListTileForNav(
        icon: Icons.person_add_alt,
        title: "Add Company Recruiters",
        onTap: () {
          Get.back();
          Get.to(() => const RecruiterDialogContent());
        },
      ),
      ListTileForNav(
        icon: Icons.person_2_outlined,
        title: "Internal Recruiters",
        onTap: () {
          Get.back();
          Get.to(() => CompanyEmployeesScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.edit_calendar_sharp,
        title: "My Plan",
        onTap: () {
          Get.back();
          Get.to(() => PlanPricingScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.person_add_outlined,
        title: "Recruiter Requests",
        onTap: () {
          Get.back();
          Get.to(() => RecruiterRequestsScreen());
        },
      ),
      ListTileForNav(
        icon: Icons.lock_clock_outlined,
        title: "Change Password",
        onTap: () {
          Get.back();
          Get.to(() => CompanyChangePasswordScreen());
        },
      ),
    ];
  }

  /// Edit Profile needs the recruiter profile loaded — fetch it first if the
  /// drawer was opened without visiting the recruiter dashboard.
  Future<void> _openRecruiterEditProfile() async {
    Get.back(); // close the drawer
    final ctrl = Get.find<RecruiterController>();
    var user = ctrl.userInfo.value;
    if (user == null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await ctrl.fetchProfile();
      if (Get.isDialogOpen ?? false) Get.back();
      user = ctrl.userInfo.value;
    }
    if (user != null) {
      Get.to(() => EditProfilePage(recruiterResponseModel: user!));
    } else {
      Get.snackbar('Error', 'Could not load your profile. Please try again.');
    }
  }

  /// Company Edit Profile needs the company profile loaded — fetch if missing.
  Future<void> _openCompanyEditProfile() async {
    Get.back();
    final ctrl = Get.find<CompanyDetailsController>();
    var info = ctrl.userInfo.value;
    if (info == null) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      await ctrl.fetchCompanyProfile();
      if (Get.isDialogOpen ?? false) Get.back();
      info = ctrl.userInfo.value;
    }
    if (info != null) {
      Get.to(() => CompanyEditAccountPage(companyData: info!));
    } else {
      Get.snackbar('Error', 'Could not load company profile.');
    }
  }

  /// Drawer header: a profile card after login, a sign-in prompt before it.
  /// Replaces the old "Back" row — the X closes the drawer.
  Widget _buildHeader() {
    final closeButton = IconButton(
      icon: const Icon(Icons.close, color: Colors.black),
      tooltip: 'Close',
      onPressed: () => Get.back(),
    );

    if (!_effectiveIsLoggedIn) {
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.centerRight, child: closeButton),
            const Text(
              'Welcome to EVPitch',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A3E74),
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Log in to access your profile, jobs and more.',
              style: TextStyle(fontSize: 13, color: Color(0xFF777777)),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.to(() => const LoginScreen());
                },
                child: const Text('Log in / Sign up'),
              ),
            ),
          ],
        ),
      );
    }

    Widget headerBody(UserModel? user) {
      final name = (user?.name ?? '').trim().isNotEmpty == true
          ? user!.name
          : 'Your account';
      final avatarUrl = _resolveHeaderAvatarUrl(user);
      final role = (user?.role ?? '').trim();
      final hasAvatar = avatarUrl != null && avatarUrl.isNotEmpty;

      return Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.centerRight, child: closeButton),
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: hasAvatar ? NetworkImage(avatarUrl) : null,
                  child: !hasAvatar
                      ? Text(
                          (name.isNotEmpty ? name[0] : '?').toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A3E74),
                        ),
                      ),
                      if (role.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _roleBadge(role),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    // Only wrap in Obx when the reactive service is available, otherwise Obx
    // would find no observable to listen to and throw.
    if (_profileService == null) return headerBody(null);
    return Obx(() => headerBody(_profileService!.userInfoRx.value));
  }

  Widget _roleBadge(String role) {
    final color = _roleColor(role);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        role[0].toUpperCase() + role.substring(1),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _roleColor(String role) {
    switch (role.toLowerCase()) {
      case 'candidate':
        return Colors.green;
      case 'company':
        return Colors.purple;
      case 'recruiter':
        return AppColors.primaryBlue;
      default:
        return const Color(0xFF777777);
    }
  }

  String? _resolveHeaderAvatarUrl(UserModel? user) {
    final role = (user?.role ?? '').toLowerCase();

    if (role == 'company' && Get.isRegistered<CompanyDetailsController>()) {
      final companyInfo = Get.find<CompanyDetailsController>().userInfo.value;
      final companies = companyInfo?.companies ?? const [];
      if (companies.isNotEmpty && companies.first.clogo.trim().isNotEmpty) {
        return companies.first.clogo.trim();
      }
    }

    if (role == 'recruiter' && Get.isRegistered<RecruiterController>()) {
      final recruiter = Get.find<RecruiterController>().userInfo.value;
      if (recruiter != null && recruiter.photo.trim().isNotEmpty) {
        return recruiter.photo.trim();
      }
    }

    final profileImage = user?.profileImage?.trim();
    if (profileImage != null && profileImage.isNotEmpty) {
      return profileImage;
    }

    return null;
  }

  /// Small uppercase label that introduces a group of drawer items.
  Widget _sectionHeader(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: Color(0xFF9AA0A6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Drawer(
      backgroundColor: AppColors.primaryWhite,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildHeader(),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 48,
                    child: CustomSearchCompany(
                      hintText: "Search people...",
                      controller: _searchController,
                      onChanged: (value) {
                        controller.onQueryChanged(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reactive search results
                  Obx(() {
                    final searchQuery = controller.query.value.trim();
                    final users = controller.suggestions;

                    if (searchQuery.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    // Server request in flight, nothing to show yet.
                    if (controller.isPeopleLoading.value && users.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (controller.peopleError.value.isNotEmpty &&
                        users.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            controller.peopleError.value,
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    if (users.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'No results found for "$searchQuery".',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    }

                    return Container(
                      constraints: const BoxConstraints(maxHeight: 340),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Scrollable list
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                return ListTile(
                                  dense: true,
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: user.avatar?.url != null
                                        ? NetworkImage(user.avatar!.url!)
                                        : null,
                                    child: user.avatar?.url == null
                                        ? Text(
                                            (user.name?[0] ?? '?')
                                                .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
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
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (user.role.toLowerCase() ==
                                          'candidate') ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.person_outline,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                      ] else if (user.role.toLowerCase() ==
                                          'company') ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.business,
                                          color: Colors.purple,
                                          size: 18,
                                        ),
                                      ] else if (user.role.toLowerCase() ==
                                          'recruiter') ...[
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.how_to_reg,
                                          color: Colors.blue,
                                          size: 18,
                                        ),
                                      ],
                                    ],
                                  ),
                                  subtitle: Text(user.address),
                                  // trailing: const Icon(Icons.person_outline),
                                  onTap: () {
                                    final slug = user.slug;

                                    if (slug == null || slug.isEmpty) {
                                      Get.snackbar(
                                        'Error',
                                        'This user has no public profile',
                                      );
                                      return;
                                    }

                                    if (user.role.toLowerCase() ==
                                        'candidate') {
                                      Get.to(
                                        () => PublicViewCandidateScreen(
                                          slug: slug,
                                        ),
                                      );
                                    } else if (user.role.toLowerCase() ==
                                        'recruiter') {
                                      Get.to(
                                        () => RecruiterPublicViewScreen(
                                          slug: slug,
                                        ),
                                      );
                                    } else {
                                      Get.to(
                                        () => PublicViewSeachScreen(slug: slug),
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),

                          const Divider(height: 1),

                          TextButton(
                            onPressed: () {
                              Get.to(() => const SearchResultsScreen());
                            },
                            child: const Text("Show All Results"),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // ── BROWSE ──────────────────────────────────────────────
            _sectionHeader("Browse"),
            // Elevator Pitch & Resume is candidate-facing — hide it for recruiters.
            ListTileForNav(
              title: "Jobs",
              liconPath:
                  "assets/icons/list.png", // Reusing list icon or suitable one
              onTap: () {
                Get.to(() => const AllJobsScreen());
              },
            ),
            ListTileForNav(
              title: "Blogs",
              onTap: () {
                Get.to(() => BlogScreen());
              },
            ),

            // ── MY ACCOUNT (after login only — role-specific flow) ──
            if (_effectiveIsLoggedIn) ...[
              _sectionHeader("My Account"),
              ..._accountTilesForRole(),
            ],

            // ── HELP & INFO ─────────────────────────────────────────
            _sectionHeader("Help & Info"),
            ListTileForNav(
              liconPath: "assets/icons/home.png",
              title: "About Us",
              onTap: () {
                Get.to(() => AboutUs());
              },
            ),
            ListTileForNav(
              liconPath: "assets/icons/list.png",
              title: "Privacy Policy",
              onTap: () {
                Get.to(() => PrivacyPolicy());
              },
            ),
            ListTileForNav(
              liconPath: "assets/icons/book-open-01.png",
              title: "Terms & Conditions",
              onTap: () {
                Get.to(() => TermsandConditions());
              },
            ),
            ListTileForNav(
              liconPath: "assets/icons/Icon (5).png",
              title: "Frequently Asked Questions",
              onTap: () {
                Get.to(() => FrequentlyQuestions());
              },
            ),
            // Auth-only: shown after login
            if (_effectiveIsLoggedIn)
              ListTileForNav(
                liconPath: "assets/icons/contactus.png",
                title: "Contact Us",
                onTap: () {
                  Get.to(() => ContactUsScreen(member: EditProfileModel()));
                },
              ),

            const Divider(
              height: 24,
              thickness: 0.6,
              indent: 16,
              endIndent: 16,
            ),

            // ── Auth action ─────────────────────────────────────────
            ListTileForNav(
              title: _effectiveIsLoggedIn ? "Logout" : "Login",
              liconPath: "assets/icons/logout_icon_dawer.png",
              titleColor: _effectiveIsLoggedIn
                  ? AppColors.deleteButtonBackground
                  : AppColors.primaryBlue,
              onTap: () {
                if (_effectiveIsLoggedIn) {
                  _authController.logout();
                  return;
                }

                Get.back();
                Get.to(() => const LoginScreen());
              },
            ),
          ],
        ),
      ),
    ));
  }
}

class ListTileForNav extends StatelessWidget {
  final String? title;
  final String? liconPath;
  final String? ticonPath;
  final VoidCallback onTap;
  final bool isExpanded;
  final Color? titleColor;
  final IconData? icon;

  const ListTileForNav({
    super.key,
    required this.title,
    required this.onTap,
    this.liconPath,
    this.ticonPath,
    this.isExpanded = false,
    this.titleColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: ticonPath != null
          ? Transform.rotate(
              angle: isExpanded
                  ? 3.14159
                  : 0, // Rotate 180 degrees when expanded
              child: Image.asset(
                ticonPath!,
                fit: BoxFit.cover,
                width: 15,
                height: 9,
              ),
            )
          : null,
      leading: icon != null
          ? Icon(icon, size: 20, color: titleColor ?? const Color(0xff333333))
          : (liconPath != null
                ? Image.asset(liconPath!, width: 16, height: 16)
                : null),
      title: Text(
        title ?? '',
        style: TextStyle(
          color: titleColor ?? const Color(0xff333333),
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -1,
        ),
      ),
      onTap: () => onTap(),
    );
  }
}
