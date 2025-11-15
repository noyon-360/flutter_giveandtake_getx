class FetchRecruiterResponseModel {
  final String id;
  final String userId;
  final String bio;
  final String banner;
  final String photo;
  final String title;
  final String firstName;
  final String sureName;
  final String country;
  final String city;
  final String zipCode;
  final String emailAddress;
  final String phoneNumber;
  final List<SocialLink> sLink;
  final Company? companyId;
  final ElevatorPitch? elevatorPitch;

  FetchRecruiterResponseModel({
    required this.id,
    required this.userId,
    required this.bio,
    required this.banner,
    required this.photo,
    required this.title,
    required this.firstName,
    required this.sureName,
    required this.country,
    required this.city,
    required this.zipCode,
    required this.emailAddress,
    required this.phoneNumber,
    required this.sLink,
     this.companyId,
    this.elevatorPitch,
  });

  factory FetchRecruiterResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchRecruiterResponseModel(
      id: json["_id"],
      userId: json["userId"],
      bio: json["bio"],
      banner: json["banner"],
      photo: json["photo"],
      title: json["title"],
      firstName: json["firstName"],
      sureName: json["sureName"],
      country: json["country"],
      city: json["city"],
      zipCode: json["zipCode"],
      emailAddress: json["emailAddress"],
      phoneNumber: json["phoneNumber"],
      sLink: List<SocialLink>.from(
        json["sLink"].map((x) => SocialLink.fromJson(x)),
      ),
      companyId: json["companyId"] != null ? Company.fromJson(json["companyId"]) : null,
      elevatorPitch: json["elevatorPitch"] != null
          ? ElevatorPitch.fromJson(json["elevatorPitch"])
          : null,
    );
  }
}


class SocialLink {
  final String label;
  final String url;

  SocialLink({required this.label, required this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      label: json["label"],
      url: json["url"],
    );
  }
}

class Company {
  final String id;
  final String cname;
  final String country;
  final String city;
  final String cemail;
  final List<SocialLink> sLink;

  Company({
    required this.id,
    required this.cname,
    required this.country,
    required this.city,
    required this.cemail,
    required this.sLink,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json["_id"],
      cname: json["cname"],
      country: json["country"],
      city: json["city"],
      cemail: json["cemail"],
      sLink: List<SocialLink>.from(
        json["sLink"].map((x) => SocialLink.fromJson(x)),
      ),
    );
  }
}


class ElevatorPitch {
  final ElevatorVideo video;

  ElevatorPitch({required this.video});

  factory ElevatorPitch.fromJson(Map<String, dynamic> json) {
    return ElevatorPitch(
      video: ElevatorVideo.fromJson(json["video"]),
    );
  }
}

class ElevatorVideo {
  final String? hlsUrl;
  final String? encryptionKeyUrl;

  ElevatorVideo({
    this.hlsUrl,
    this.encryptionKeyUrl,
  });

  factory ElevatorVideo.fromJson(Map<String, dynamic> json) {
    return ElevatorVideo(
      hlsUrl: json["hlsUrl"],
      encryptionKeyUrl: json["encryptionKeyUrl"],
    );
  }
}
