class ApiConstants {
  /// [Base Configuration]
  static const String baseDomain = 'http://10.10.5.67:5007';// soykot ip
  // static const String baseDomain = 'https://api.evpitch.com';
  static const String baseUrl = '$baseDomain/api/v1';

  // add by zafor
  // static const String baseDomain = 'https://api.evpitch.com';
  // static const String baseDomain = 'http://10.10.5.88:5001'; // zafor
  //add by zafor end

  //static const String baseDomain = 'https://api.evpitch.com';
  // static const String baseDomain = 'http://10.10.5.67:5001';//eshita
  // static const String baseDomain = 'http://10.10.5.53:5001';//eshita
  // static const String baseDomain = 'http://10.10.5.33:5001';//eshita

  // static const String baseUrl = '$baseDomain/api/v1';

  // static const String baseDomain = 'https://api.evpitch.com';
  // static const String baseDomain = 'http://10.10.5.3:5000'; // iftikhar
  // static const String baseUrl = '$baseDomain/api/v1';

  /// [Headers]
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  /// [Endpoint Groups]
  static AuthEndpoints get auth => AuthEndpoints();

  static UserEndpoints get user => UserEndpoints();
  static NotificationEndpoints get notification => NotificationEndpoints();

  static TeamEndpointcs get team => TeamEndpointcs();
  static LeagueEndpoints get league => LeagueEndpoints();

  static ContactEndpoints get contact => ContactEndpoints();

  static PaymentEndpoints get payment => PaymentEndpoints();
  static PaypalEndpoints get paypal => PaypalEndpoints();
  static RecruiterAccountApi get recruiter => RecruiterAccountApi();
  static JobEndpoints get jobs => JobEndpoints();
  static SubscriptionEndpoints get subscription => SubscriptionEndpoints();
  static ContentEndpoints get content => ContentEndpoints();
  static ElevatorPitchVideo get elevatorPitchVideo => ElevatorPitchVideo();
  static CategoryEndpoints get category => CategoryEndpoints();
  static AlluserEndpoints get allusers => AlluserEndpoints();
  static CompanyAccountApi get company => CompanyAccountApi();
  static ResumeEndpoints get resume => ResumeEndpoints();
}

class ResumeEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/create-resume';
  final String getResume = '$_base/get-resume';
  final String createResume = '$_base/create-resume';
}

class JobEndpoints {
  String getJobs(int page, int limit, {String? search}) {
    String url = '${ApiConstants.baseUrl}/jobs?page=$page&limit=$limit';
    if (search != null && search.isNotEmpty) {
      url += '&search=${Uri.encodeQueryComponent(search)}';
    }
    return url;
  }
  
  final String applyJob = '${ApiConstants.baseUrl}/applied-jobs';
}

class RecruiterAccountApi {
  final String getCompany = '${ApiConstants.baseUrl}/all/companies';
  final String changePass = '${ApiConstants.baseUrl}/user/change-password';
  final String getCategory = '${ApiConstants.baseUrl}/category/job-category';
  final String getCurrency = '${ApiConstants.baseUrl}/courency';
  final String uploadVideo = '${ApiConstants.baseUrl}/all/companies';
  final String createJob = '${ApiConstants.baseUrl}/jobs';
  final String getJob = '${ApiConstants.baseUrl}/jobs/recruiter/company';
  final String connectCompany =
      '${ApiConstants.baseUrl}/company/apply-for-company-employee';
  final String follow = '${ApiConstants.baseUrl}/following/follow';
  //final String yourJob = '${ApiConstants.baseUrl}/jobs/recruiter/company';

  static const String _base = '${ApiConstants.baseUrl}/recruiter';
  String createRecruiterAccount = '$_base/recruiter-account';
  String fetchRecruiterInfo(String userId) =>
      '$_base/recruiter-account/$userId';
  String updateRecruiter(String userId) => '$_base/recruiter-account/$userId';
  String getSingleJob(String jobId) => '${ApiConstants.baseUrl}/jobs/$jobId';
  String updateSingleJob(String jobId) => '${ApiConstants.baseUrl}/jobs/update/$jobId';
  String updateArchieveJob(String jobId) => '${ApiConstants.baseUrl}/jobs/$jobId/archive';
}

class ElevatorPitchVideo {
  static const String _base = '${ApiConstants.baseUrl}/elevator-pitch';

  String uploadVideo(String userId) => '$_base/video?userId=$userId';
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/user';

  final String login = '$_base/login';
  final String register = '$_base/register';
  final String verify = '$_base/verify';
  final String refreshToken = '${ApiConstants.baseUrl}/auth/refresh-token';

  // Password Reset Flow
  final String resetPass = '$_base/forget'; // Send OTP for forgot password
  final String otpVerifyResetPassword =
      '$_base/verify-reset-otp'; // OTP verification for password reset
  final String otpVerifyRegister =
      '$_base/verify'; // OTP verification (register flow)
  final String changePassword =
      '$_base/change-password'; // Change password with old and new

  // Security Questions
  final String defaultSecurityQuestions =
      '${ApiConstants.baseUrl}/default-security-questions';
  final String securityAnswers = '${ApiConstants.baseUrl}/security-answers';
  final String verifySecurityAnswers =
      '${ApiConstants.baseUrl}/verify-security-answers';
  final String changeEmail = '${ApiConstants.baseUrl}/change-email';
  final String resetPasswordWithToken =
      '${ApiConstants.baseUrl}/security-answers/reset-password';

  get otpVerifyReset => null;
}

class UserEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/user';
  final String updateProfile = '$_base/update';
  final String getUserProfile = '$_base/profile';

  // Account actions
  final String deactivate = '$_base/deactivate';
  final String disable = '$_base/disable';

  // final String create = '$_base/create';
}

class NotificationEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/notification';

  final String getnotifications = '$_base/getnotifications';
}

class TeamEndpointcs {
  static const String _base = '${ApiConstants.baseUrl}/team';

  final String create = '$_base/create';
}

class LeagueEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/league';

  final String getAllLeagues = '$_base/all-league';
}

class ContactEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/contact';
  // API endpoint is /contact/contact-us in the backend
  final String createContact = '$_base/contact-us';
}

class ContentEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/content';
  final String about = '$_base/about';
  final String privacy = '$_base/privacy';
  // Terms endpoint - some environments spell it 'trems' accidentally; provide both keys
  final String terms = '$_base/terms';
  final String trems = '$_base/trems';

  String getContentByType(String type) => '$_base/$type';
}

// New payment endpoints
class PaymentEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/payments';

  final String createPayment = '$_base/create-payment';

  final String confirmPayment = '$_base/confirm-payment';
  
  String getUserPayments(String userId, int page, int limit) =>
      '$_base/user/$userId?page=$page&limit=$limit';
}

// PayPal endpoints
class PaypalEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/payments/paypal';

  final String createOrder = '$_base/create-order';
}

// Subscription endpoints
class SubscriptionEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/subscription';

  final String getPlans = '$_base/plans';
}

class CategoryEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/category';
  final String jobCategory = '$_base/job-category';
}

class AlluserEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/all';
  final String alluser = '$_base/user';
}
class CompanyAccountApi {
  static const String _base = '${ApiConstants.baseUrl}/company';
  final String createcompany = '$_base';
    String fetchCompanyInfo(String userId) =>
      '$_base/user/$userId';

    String fetchEmployee(String userId) =>
      '${ApiConstants.baseUrl}/company/company-employess/skills/$userId';

      String fetchUpdateInfo(String userId) =>
      '$_base/$userId';

      String manageJobs(String companyId) =>
      '${ApiConstants.baseUrl}/all-jobs-for-company/company/$companyId';

      final String connectRecruiter = '$_base/add-employee-to-company';
      final String removeRecruiter = '$_base/remove-employee-to-company';
      String archiveJobs(String jobId) =>
      '${ApiConstants.baseUrl}/jobs/$jobId/archive';
      String applicantJob(String jobId) =>
      '${ApiConstants.baseUrl}/applied-jobs/job/$jobId';
      final String candidateResume =
      '${ApiConstants.baseUrl}/create-resume/get-resume/anjolie-reed';
       String status(String jobId) =>
      '${ApiConstants.baseUrl}/applied-jobs/$jobId/status';

      String fetchResume(String candidateUserId) =>
      '${ApiConstants.baseUrl}/resume/user/$candidateUserId';


      


}
