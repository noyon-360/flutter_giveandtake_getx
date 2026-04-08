import 'web_contract_utils.dart';

class PersonalInfoInput {
  const PersonalInfoInput({
    required this.firstName,
    required this.surname,
    required this.address,
  });

  final String firstName;
  final String surname;
  final String address;
}

class ProfilePayloadBuilder {
  static Map<String, dynamic> buildUpdate(PersonalInfoInput input) => {
    'name': combineName(input.firstName, input.surname),
    'address': input.address.trim(),
  };
}
