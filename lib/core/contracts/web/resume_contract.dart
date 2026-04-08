import 'dart:io';

import 'multipart_payload.dart';
import 'web_contract_utils.dart';

enum WebMutationType { create, update, delete }

extension WebMutationTypeX on WebMutationType {
  String get wireValue {
    switch (this) {
      case WebMutationType.create:
        return 'create';
      case WebMutationType.update:
        return 'update';
      case WebMutationType.delete:
        return 'delete';
    }
  }
}

class ResumeSocialLinkInput {
  const ResumeSocialLinkInput({
    required this.label,
    required this.url,
    this.id,
    this.mutation = WebMutationType.create,
  });

  final String label;
  final String url;
  final String? id;
  final WebMutationType mutation;

  Map<String, dynamic> toCreateJson() => {
    'label': label,
    'url': url,
  };

  Map<String, dynamic> toUpdateJson() => {
    if (id != null) '_id': id,
    'type': id == null ? WebMutationType.create.wireValue : mutation.wireValue,
    'label': label,
    'url': url,
  };
}

class CandidateExperienceInput {
  const CandidateExperienceInput({
    this.id,
    this.mutation = WebMutationType.create,
    required this.company,
    required this.position,
    required this.country,
    required this.city,
    required this.zip,
    required this.jobDescription,
    required this.jobCategory,
    this.startDate,
    this.endDate,
    this.currentlyWorking = false,
  });

  final String? id;
  final WebMutationType mutation;
  final String company;
  final String position;
  final String country;
  final String city;
  final String zip;
  final String jobDescription;
  final String jobCategory;
  final String? startDate;
  final String? endDate;
  final bool currentlyWorking;

  Map<String, dynamic> toCreateJson() => {
    'company': company,
    'position': position,
    'country': country,
    'city': city,
    'zip': zip,
    'startDate': normalizeMonthYearToIso(startDate),
    'endDate': currentlyWorking ? null : normalizeMonthYearToIso(endDate),
    'currentlyWorking': currentlyWorking,
    'jobDescription': jobDescription,
    'jobCategory': jobCategory,
  };

  Map<String, dynamic> toUpdateJson() => {
    if (id != null) '_id': id,
    'type': id == null ? WebMutationType.create.wireValue : mutation.wireValue,
    'company': company,
    'position': position,
    'country': country,
    'city': city,
    'zip': zip,
    'startDate': normalizeMonthYearToIso(startDate),
    'endDate': currentlyWorking ? null : normalizeMonthYearToIso(endDate),
    'currentlyWorking': currentlyWorking,
    'jobDescription': jobDescription,
    'jobCategory': jobCategory,
  };
}

class CandidateEducationInput {
  const CandidateEducationInput({
    this.id,
    this.mutation = WebMutationType.create,
    required this.university,
    required this.degree,
    required this.fieldOfStudy,
    required this.country,
    required this.city,
    this.startDate,
    this.graduationDate,
    this.currentlyStudying = false,
  });

  final String? id;
  final WebMutationType mutation;
  final String university;
  final String degree;
  final String fieldOfStudy;
  final String country;
  final String city;
  final String? startDate;
  final String? graduationDate;
  final bool currentlyStudying;

  Map<String, dynamic> toCreateJson() => {
    'university': university,
    'degree': degree,
    'fieldOfStudy': fieldOfStudy,
    'country': country,
    'city': city,
    'startDate': normalizeMonthYearToIso(startDate),
    'graduationDate':
        currentlyStudying ? null : normalizeMonthYearToIso(graduationDate),
    'currentlyStudying': currentlyStudying,
  };

  Map<String, dynamic> toUpdateJson() => {
    if (id != null) '_id': id,
    'type': id == null ? WebMutationType.create.wireValue : mutation.wireValue,
    'university': university,
    'degree': degree,
    'fieldOfStudy': fieldOfStudy,
    'country': country,
    'city': city,
    'startDate': normalizeMonthYearToIso(startDate),
    'graduationDate':
        currentlyStudying ? null : normalizeMonthYearToIso(graduationDate),
    'currentlyStudying': currentlyStudying,
  };
}

class CandidateAwardInput {
  const CandidateAwardInput({
    this.id,
    this.mutation = WebMutationType.create,
    required this.title,
    required this.programeName,
    this.programeDate,
    required this.description,
  });

  final String? id;
  final WebMutationType mutation;
  final String title;
  final String programeName;
  final String? programeDate;
  final String description;

  Map<String, dynamic> toCreateJson() => {
    'title': title,
    'programeName': programeName,
    'programeDate': normalizeMonthYearToIso(programeDate),
    'description': description,
  };

  Map<String, dynamic> toUpdateJson() => {
    if (id != null) '_id': id,
    'type': id == null ? WebMutationType.create.wireValue : mutation.wireValue,
    'title': title,
    'programeName': programeName,
    'programeDate': normalizeMonthYearToIso(programeDate),
    'description': description,
  };
}

class CandidateResumeCreateInput {
  const CandidateResumeCreateInput({
    required this.userId,
    required this.type,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.title,
    required this.country,
    required this.city,
    required this.zip,
    required this.aboutUs,
    required this.immediatelyAvailable,
    required this.skills,
    required this.certifications,
    required this.languages,
    required this.socialLinks,
    required this.experiences,
    required this.educationList,
    required this.awardsAndHonors,
    this.photo,
    this.banner,
  });

  final String userId;
  final String type;
  final String firstName;
  final String lastName;
  final String email;
  final String title;
  final String country;
  final String city;
  final String zip;
  final String aboutUs;
  final bool immediatelyAvailable;
  final List<String> skills;
  final List<String> certifications;
  final List<String> languages;
  final List<ResumeSocialLinkInput> socialLinks;
  final List<CandidateExperienceInput> experiences;
  final List<CandidateEducationInput> educationList;
  final List<CandidateAwardInput> awardsAndHonors;
  final File? photo;
  final File? banner;
}

class CandidateResumeUpdateInput extends CandidateResumeCreateInput {
  const CandidateResumeUpdateInput({
    required this.resumeId,
    required super.userId,
    required super.type,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.title,
    required super.country,
    required super.city,
    required super.zip,
    required super.aboutUs,
    required super.immediatelyAvailable,
    required super.skills,
    required super.certifications,
    required super.languages,
    required super.socialLinks,
    required super.experiences,
    required super.educationList,
    required super.awardsAndHonors,
    super.photo,
    super.banner,
  });

  final String resumeId;
}

class ResumePayloadBuilder {
  static MultipartPayload buildCreate(CandidateResumeCreateInput input) {
    final payload = MultipartPayload();

    payload.putField('userId', input.userId);
    payload.putField(
      'resume',
      encodeJson({
        'type': input.type,
        'firstName': input.firstName,
        'lastName': input.lastName,
        'email': input.email,
        'title': input.title,
        'country': input.country,
        'city': input.city,
        'zip': normalizeZip(input.zip),
        'aboutUs': input.aboutUs,
        'immediatelyAvailable': input.immediatelyAvailable,
        'skills': input.skills,
        'certifications': input.certifications,
        'languages': input.languages,
        'sLink': input.socialLinks.map((link) => link.toCreateJson()).toList(),
      }),
    );
    payload.putField(
      'experiences',
      encodeJsonList(input.experiences.map((item) => item.toCreateJson()).toList()),
    );
    payload.putField(
      'educationList',
      encodeJsonList(
        input.educationList.map((item) => item.toCreateJson()).toList(),
      ),
    );
    payload.putField(
      'awardsAndHonors',
      encodeJsonList(
        input.awardsAndHonors.map((item) => item.toCreateJson()).toList(),
      ),
    );
    payload.putFile('photo', input.photo);
    payload.putFile('banner', input.banner);

    return payload;
  }

  static MultipartPayload buildUpdate(CandidateResumeUpdateInput input) {
    final payload = MultipartPayload();

    payload.putField('userId', input.userId);
    payload.putField(
      'resume',
      encodeJson({
        '_id': input.resumeId,
        'type': WebMutationType.update.wireValue,
        'firstName': input.firstName,
        'lastName': input.lastName,
        'email': input.email,
        'title': input.title,
        'country': input.country,
        'city': input.city,
        'zipCode': normalizeZip(input.zip),
        'aboutUs': input.aboutUs,
        'immediatelyAvailable': input.immediatelyAvailable,
        'skills': input.skills,
        'certifications': input.certifications,
        'languages': input.languages,
        'sLink': input.socialLinks.map((link) => link.toUpdateJson()).toList(),
      }),
    );
    payload.putField(
      'experiences',
      encodeJsonList(input.experiences.map((item) => item.toUpdateJson()).toList()),
    );
    payload.putField(
      'educationList',
      encodeJsonList(
        input.educationList.map((item) => item.toUpdateJson()).toList(),
      ),
    );
    payload.putField(
      'awardsAndHonors',
      encodeJsonList(
        input.awardsAndHonors.map((item) => item.toUpdateJson()).toList(),
      ),
    );
    payload.putFile('photo', input.photo);
    payload.putFile('banner', input.banner);

    return payload;
  }
}
