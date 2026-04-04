import 'dart:io';

import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';

class ProfileController extends GetxController {
  final UserRepository repository;

  ProfileController({UserRepository? repository})
    : repository = repository ?? UserRepositoryImpl();

  final _isLoading = false.obs;
  final _error = RxnString();
  final _user = Rxn<UserModel>();
  final countries = <String>[].obs;
  final selectedCountry = Rx<String?>(null);

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  UserModel? get user => _user.value;

  @override
  void onInit() {
    super.onInit();
    fetchUser();
    fetchCountries();
  }

  void fetchCountries() {
    final countryList = [
      'Afghanistan', 'Albania', 'Algeria', 'Andorra', 'Angola', 'Argentina', 'Armenia',
      'Australia', 'Austria', 'Azerbaijan', 'Bahamas', 'Bahrain', 'Bangladesh', 'Barbados',
      'Belarus', 'Belgium', 'Belize', 'Benin', 'Bhutan', 'Bolivia', 'Bosnia and Herzegovina',
      'Botswana', 'Brazil', 'Brunei', 'Bulgaria', 'Burkina Faso', 'Burundi', 'Cambodia',
      'Cameroon', 'Canada', 'Cape Verde', 'Central African Republic', 'Chad', 'Chile',
      'China', 'Colombia', 'Comoros', 'Congo', 'Costa Rica', 'Croatia', 'Cuba', 'Cyprus',
      'Czech Republic', 'Czechia', 'Denmark', 'Djibouti', 'Dominica', 'Dominican Republic',
      'East Timor', 'Ecuador', 'Egypt', 'El Salvador', 'Equatorial Guinea', 'Eritrea',
      'Estonia', 'Ethiopia', 'Fiji', 'Finland', 'France', 'Gabon', 'Gambia', 'Georgia',
      'Germany', 'Ghana', 'Greece', 'Grenada', 'Guatemala', 'Guinea', 'Guinea-Bissau',
      'Guyana', 'Haiti', 'Honduras', 'Hungary', 'Iceland', 'India', 'Indonesia', 'Iran',
      'Iraq', 'Ireland', 'Israel', 'Italy', 'Jamaica', 'Japan', 'Jordan', 'Kazakhstan',
      'Kenya', 'Kiribati', 'Kosovo', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Latvia', 'Lebanon',
      'Lesotho', 'Liberia', 'Libya', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Madagascar',
      'Malawi', 'Malaysia', 'Maldives', 'Mali', 'Malta', 'Marshall Islands', 'Mauritania',
      'Mauritius', 'Mexico', 'Micronesia', 'Moldova', 'Monaco', 'Mongolia', 'Montenegro',
      'Morocco', 'Mozambique', 'Myanmar', 'Namibia', 'Nauru', 'Nepal', 'Netherlands',
      'New Zealand', 'Nicaragua', 'Niger', 'Nigeria', 'North Korea', 'North Macedonia',
      'Norway', 'Oman', 'Pakistan', 'Palau', 'Palestine', 'Panama', 'Papua New Guinea',
      'Paraguay', 'Peru', 'Philippines', 'Poland', 'Portugal', 'Qatar', 'Romania', 'Russia',
      'Rwanda', 'Saint Kitts and Nevis', 'Saint Lucia', 'Saint Vincent and the Grenadines',
      'Samoa', 'San Marino', 'Sao Tome and Principe', 'Saudi Arabia', 'Senegal', 'Serbia',
      'Seychelles', 'Sierra Leone', 'Singapore', 'Slovakia', 'Slovenia', 'Solomon Islands',
      'Somalia', 'South Africa', 'South Korea', 'South Sudan', 'Spain', 'Sri Lanka', 'Sudan',
      'Suriname', 'Sweden', 'Switzerland', 'Syria', 'Taiwan', 'Tajikistan', 'Tanzania',
      'Thailand', 'Timor-Leste', 'Togo', 'Tonga', 'Trinidad and Tobago', 'Tunisia', 'Turkey',
      'Turkmenistan', 'Tuvalu', 'Uganda', 'Ukraine', 'United Arab Emirates', 'United Kingdom',
      'United States', 'Uruguay', 'Uzbekistan', 'Vanuatu', 'Vatican City', 'Venezuela',
      'Vietnam', 'Yemen', 'Zambia', 'Zimbabwe'
    ];
    countries.value = countryList;
  }

  Future<void> fetchUser() async {
    try {
      _isLoading.value = true;
      _error.value = null;
      final u = await repository.fetchUser();
      _user.value = u;
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> updateUser(Map<String, dynamic> payload, {File? imageFile}) async {
    try {
      _isLoading.value = true;
      _error.value = null;

      // Optimistically update UI immediately
      if (_user.value != null) {
        final current = _user.value!;
        _user.value = UserModel(
          id: current.id,
          name: payload['name'] ?? current.name,
          email: payload['email'] ?? current.email,
          phoneNum: payload['phoneNum'] ?? current.phoneNum,
          address: payload['address'] ?? current.address,
          avatarUrl: current.avatarUrl,
          role: current.role,
          deactivate: current.deactivate,
          dateOfdeactivate: current.dateOfdeactivate,
          refreshToken: current.refreshToken,
          title: current.title,
          isValid: current.isValid,
          payAsYouGo: current.payAsYouGo,
        );
      }

      // Then call the API in background
      final updated = await repository.updateUser(payload, imageFile: imageFile);
      _user.value = updated;
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }


}
