import 'dart:convert';
import 'dart:io';

import 'multipart_payload.dart';
import 'web_contract_utils.dart';

class WebSocialLinkInput {
  const WebSocialLinkInput({required this.label, required this.url});

  final String label;
  final String url;
}

class RecruiterAccountInput {
  const RecruiterAccountInput({
    required this.userId,
    required this.firstName,
    required this.sureName,
    required this.title,
    required this.bio,
    required this.country,
    required this.city,
    this.zipCode,
    this.emailAddress,
    this.phoneNumber,
    this.companyId,
    required this.socialLinks,
    this.photo,
    this.banner,
  });

  final String userId;
  final String firstName;
  final String sureName;
  final String title;
  final String bio;
  final String country;
  final String city;
  final String? zipCode;
  final String? emailAddress;
  final String? phoneNumber;
  final String? companyId;
  final List<WebSocialLinkInput> socialLinks;
  final File? photo;
  final File? banner;
}

class CompanyHonorInput {
  const CompanyHonorInput({
    required this.title,
    required this.programeName,
    required this.programeDate,
    required this.description,
  });

  final String title;
  final String programeName;
  final String programeDate;
  final String description;

  Map<String, dynamic> toJson() => {
    'title': title,
    'programeName': programeName,
    'issuer': programeName,
    'programeDate': normalizeMonthYearToIso(programeDate),
    'description': description,
  };
}

class CompanyAccountInput {
  const CompanyAccountInput({
    required this.userId,
    required this.cname,
    required this.cemail,
    required this.aboutUs,
    required this.industry,
    required this.country,
    required this.city,
    required this.zipcode,
    required this.service,
    required this.employeesId,
    required this.awardsAndHonors,
    required this.socialLinks,
    this.clogo,
    this.banner,
  });

  final String userId;
  final String cname;
  final String cemail;
  final String aboutUs;
  final String industry;
  final String country;
  final String city;
  final String zipcode;
  final List<String> service;
  final List<String> employeesId;
  final List<CompanyHonorInput> awardsAndHonors;
  final List<WebSocialLinkInput> socialLinks;
  final File? clogo;
  final File? banner;
}

class RecruiterPayloadBuilder {
  static MultipartPayload buildCreate(RecruiterAccountInput input) {
    final payload = MultipartPayload();
    _fillRecruiterFields(payload, input, includeIdentityFields: true);
    return payload;
  }

  static MultipartPayload buildUpdate(RecruiterAccountInput input) {
    final payload = MultipartPayload();
    _fillRecruiterFields(payload, input, includeIdentityFields: false);
    return payload;
  }

  static void _fillRecruiterFields(
    MultipartPayload payload,
    RecruiterAccountInput input, {
    required bool includeIdentityFields,
  }) {
    payload.putField('userId', input.userId);
    payload.putField('firstName', input.firstName);
    payload.putField('sureName', input.sureName);
    payload.putField('title', input.title);
    payload.putField('bio', input.bio);
    payload.putField('country', input.country);
    payload.putField('city', input.city);

    if (includeIdentityFields) {
      payload.putField('emailAddress', input.emailAddress);
      payload.putField('phoneNumber', input.phoneNumber);
      payload.putField('zipCode', input.zipCode);
    } else if (nullIfBlank(input.zipCode) != null) {
      payload.putField('zipCode', input.zipCode);
    }

    if (nullIfBlank(input.companyId) != null) {
      payload.putField('companyId', input.companyId);
    }

    for (var index = 0; index < input.socialLinks.length; index++) {
      final link = input.socialLinks[index];
      payload.putField('sLink[$index][label]', link.label);
      payload.putField('sLink[$index][url]', link.url);
    }

    payload.putFile('photo', input.photo);
    payload.putFile('banner', input.banner);
  }
}

class CompanyPayloadBuilder {
  static MultipartPayload build(CompanyAccountInput input) {
    final payload = MultipartPayload();

    payload.putField('userId', input.userId);
    payload.putField('cname', input.cname);
    payload.putField('cemail', input.cemail);
    payload.putField('aboutUs', input.aboutUs);
    payload.putField('industry', input.industry);
    payload.putField('country', input.country);
    payload.putField('city', input.city);
    payload.putField('zipcode', input.zipcode);
    payload.putField('service', jsonEncode(input.service));
    payload.putField('employeesId', jsonEncode(input.employeesId));
    payload.putField(
      'AwardsAndHonors',
      encodeJsonList(input.awardsAndHonors.map((item) => item.toJson()).toList()),
    );
    payload.putField(
      'honors',
      encodeJsonList(input.awardsAndHonors.map((item) => item.toJson()).toList()),
    );
    payload.putField(
      'sLink',
      jsonEncode(
        input.socialLinks
            .map((link) => {'label': link.label, 'url': link.url})
            .toList(),
      ),
    );
    payload.putFile('clogo', input.clogo);
    payload.putFile('banner', input.banner);

    return payload;
  }
}
