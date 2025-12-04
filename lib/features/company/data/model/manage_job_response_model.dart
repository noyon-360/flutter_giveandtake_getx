// manage_job_response_model.dart
import 'dart:convert';

List<ManageJobResponseModel> manageJobResponseModelFromJson(String str) =>
    List<ManageJobResponseModel>.from(
      json.decode(str).map((x) => ManageJobResponseModel.fromJson(x)),
    );

String manageJobResponseModelToJson(List<ManageJobResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ManageJobResponseModel {
  final String id;
  final String userId;
  final CompanyId companyId;
  final String title;
  final String description;
  final String? salaryRange;
  final String location;
  final String? shift;
  final List<dynamic> responsibilities;
  final List<dynamic> educationExperience;
  final List<dynamic> benefits;
  final int vacancy;
  final int counter;
  final List<double> embedding;
  final String experience;
  final DateTime deadline;
  final String status;
  final String jobCategoryId;
  final String name;
  final String role;
  final String compensation;
  final bool arcrivedJob;
  final List<ApplicationRequirement> applicationRequirement;
  final List<CustomQuestion> customQuestion;
  final String jobApprove;
  final bool adminApprove;
  final DateTime publishDate;
  final String employementType;
  final String locationType;
  final String careerStage;
  final String? websiteUrl;
  final DateTime expiryDate;
  final String billingPlanType;
  final DateTime? deactivatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int applicantCount;
  final String derivedStatus;

  ManageJobResponseModel({
    required this.id,
    required this.userId,
    required this.companyId,
    required this.title,
    required this.description,
    this.salaryRange,
    required this.location,
    this.shift,
    required this.responsibilities,
    required this.educationExperience,
    required this.benefits,
    required this.vacancy,
    required this.counter,
    required this.embedding,
    required this.experience,
    required this.deadline,
    required this.status,
    required this.jobCategoryId,
    required this.name,
    required this.role,
    required this.compensation,
    required this.arcrivedJob,
    required this.applicationRequirement,
    required this.customQuestion,
    required this.jobApprove,
    required this.adminApprove,
    required this.publishDate,
    required this.employementType,
    required this.locationType,
    required this.careerStage,
    this.websiteUrl,
    required this.expiryDate,
    required this.billingPlanType,
    this.deactivatedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.applicantCount,
    required this.derivedStatus,
  });

factory ManageJobResponseModel.fromJson(Map<String, dynamic> json) =>
    ManageJobResponseModel(
      id: json["_id"],
      userId: json["userId"],
      companyId: CompanyId.fromJson(json["companyId"] ?? {}),
      title: json["title"],
      description: json["description"],
      salaryRange: json["salaryRange"],
      location: json["location"],
      shift: json["shift"],
      responsibilities: json["responsibilities"] != null
          ? List<dynamic>.from(json["responsibilities"])
          : [],
      educationExperience: json["educationExperience"] != null
          ? List<dynamic>.from(json["educationExperience"])
          : [],
      benefits: json["benefits"] != null
          ? List<dynamic>.from(json["benefits"])
          : [],
      vacancy: json["vacancy"] ?? 0,
      counter: json["counter"] ?? 0,
      embedding: json["embedding"] != null
          ? List<double>.from(json["embedding"].map((x) => x.toDouble()))
          : [],
      experience: json["experience"] ?? "",
      deadline: json["deadline"] != null
          ? DateTime.parse(json["deadline"])
          : DateTime.now(),
      status: json["status"] ?? "",
      jobCategoryId: json["jobCategoryId"] ?? "",
      name: json["name"] ?? "",
      role: json["role"] ?? "",
      compensation: json["compensation"] ?? "",
      arcrivedJob: json["arcrivedJob"] ?? false,
      applicationRequirement: json["applicationRequirement"] != null
          ? List<ApplicationRequirement>.from(json["applicationRequirement"]
              .map((x) => ApplicationRequirement.fromJson(x)))
          : [],
      customQuestion: json["customQuestion"] != null
          ? List<CustomQuestion>.from(
              json["customQuestion"].map((x) => CustomQuestion.fromJson(x)))
          : [],
      jobApprove: json["jobApprove"] ?? "",
      adminApprove: json["adminApprove"] ?? false,
      publishDate: json["publishDate"] != null
          ? DateTime.parse(json["publishDate"])
          : DateTime.now(),
      employementType: json["employement_Type"] ?? "",
      locationType: json["location_Type"] ?? "",
      careerStage: json["career_Stage"] ?? "",
      websiteUrl: json["website_Url"],
      expiryDate: json["expiryDate"] != null
          ? DateTime.parse(json["expiryDate"])
          : DateTime.now(),
      billingPlanType: json["billingPlanType"] ?? "",
      deactivatedAt: json["deactivatedAt"] != null
          ? DateTime.parse(json["deactivatedAt"])
          : null,
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
      applicantCount: json["applicantCount"] ?? 0,
      derivedStatus: json["derivedStatus"] ?? "Pending",
    );


  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "companyId": companyId.toJson(),
    "title": title,
    "description": description,
    "salaryRange": salaryRange,
    "location": location,
    "shift": shift,
    "responsibilities": List<dynamic>.from(responsibilities.map((x) => x)),
    "educationExperience": List<dynamic>.from(
      educationExperience.map((x) => x),
    ),
    "benefits": List<dynamic>.from(benefits.map((x) => x)),
    "vacancy": vacancy,
    "counter": counter,
    "embedding": List<dynamic>.from(embedding.map((x) => x)),
    "experience": experience,
    "deadline": deadline.toIso8601String(),
    "status": status,
    "jobCategoryId": jobCategoryId,
    "name": name,
    "role": role,
    "compensation": compensation,
    "arcrivedJob": arcrivedJob,
    "applicationRequirement": List<dynamic>.from(
      applicationRequirement.map((x) => x.toJson()),
    ),
    "customQuestion": List<dynamic>.from(customQuestion.map((x) => x.toJson())),
    "jobApprove": jobApprove,
    "adminApprove": adminApprove,
    "publishDate": publishDate.toIso8601String(),
    "employement_Type": employementType,
    "location_Type": locationType,
    "career_Stage": careerStage,
    "website_Url": websiteUrl,
    "expiryDate": expiryDate.toIso8601String(),
    "billingPlanType": billingPlanType,
    "deactivatedAt": deactivatedAt?.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "applicantCount": applicantCount,
    "derivedStatus": derivedStatus,
  };
}

class CompanyId {
  final String id;
  final String userId;
  final String? banner;
  final String aboutUs;
  final String slug;
  final String cname;
  final String country;
  final String city;
  final String zipcode;
  final String cemail;
  final List<SocialLink> sLink;
  final String industry;
  final List<String> service;
  final List<dynamic> employeesId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompanyId({
    required this.id,
    required this.userId,
    this.banner,
    required this.aboutUs,
    required this.slug,
    required this.cname,
    required this.country,
    required this.city,
    required this.zipcode,
    required this.cemail,
    required this.sLink,
    required this.industry,
    required this.service,
    required this.employeesId,
    required this.createdAt,
    required this.updatedAt,
  });

factory CompanyId.fromJson(Map<String, dynamic> json) => CompanyId(
      id: json["_id"] ?? "",
      userId: json["userId"] ?? "",
      banner: json["banner"],
      aboutUs: json["aboutUs"] ?? "",
      slug: json["slug"] ?? "",
      cname: json["cname"] ?? "",
      country: json["country"] ?? "",
      city: json["city"] ?? "",
      zipcode: json["zipcode"] ?? "",
      cemail: json["cemail"] ?? "",
      sLink: json["sLink"] != null
          ? List<SocialLink>.from(
              json["sLink"].map((x) => SocialLink.fromJson(x)))
          : [],
      industry: json["industry"] ?? "",
      service: json["service"] != null
          ? List<String>.from(json["service"])
          : [],
      employeesId: json["employeesId"] != null
          ? List<dynamic>.from(json["employeesId"])
          : [],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
    );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userId": userId,
    "banner": banner,
    "aboutUs": aboutUs,
    "slug": slug,
    "cname": cname,
    "country": country,
    "city": city,
    "zipcode": zipcode,
    "cemail": cemail,
    "sLink": List<dynamic>.from(sLink.map((x) => x.toJson())),
    "industry": industry,
    "service": List<dynamic>.from(service.map((x) => x)),
    "employeesId": List<dynamic>.from(employeesId.map((x) => x)),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class SocialLink {
  final String label;
  final String url;
  final String id;

  SocialLink({required this.label, required this.url, required this.id});

  factory SocialLink.fromJson(Map<String, dynamic> json) =>
      SocialLink(label: json["label"], url: json["url"] ?? "", id: json["_id"]);

  Map<String, dynamic> toJson() => {"label": label, "url": url, "_id": id};
}

class ApplicationRequirement {
  final String requirement;
  final String status;
  final String id;

  ApplicationRequirement({
    required this.requirement,
    required this.status,
    required this.id,
  });

  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) =>
      ApplicationRequirement(
        requirement: json["requirement"],
        status: json["status"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
    "requirement": requirement,
    "status": status,
    "_id": id,
  };
}

class CustomQuestion {
  final String question;
  final String id;

  CustomQuestion({required this.question, required this.id});

  factory CustomQuestion.fromJson(Map<String, dynamic> json) =>
      CustomQuestion(question: json["question"], id: json["_id"]);

  Map<String, dynamic> toJson() => {"question": question, "_id": id};
}
