class PublicViewJobsResponseModel {
  final String id;
  final String userId;
  final Company company;
  final String title;
  final String description;
  final String? salaryRange;
  final String location;
  final String? shift;
  final String? responsibilities;
  final String? educationExperience;
  final String? benefits;
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
  final String websiteUrl;
  final DateTime expiryDate;
  final String billingPlanType;
  final DateTime? deactivatedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  PublicViewJobsResponseModel({
    required this.id,
    required this.userId,
    required this.company,
    required this.title,
    required this.description,
    this.salaryRange,
    required this.location,
    this.shift,
    this.responsibilities,
    this.educationExperience,
    this.benefits,
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
    required this.websiteUrl,
    required this.expiryDate,
    required this.billingPlanType,
    this.deactivatedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PublicViewJobsResponseModel.fromJson(Map<String, dynamic> json) {
    return PublicViewJobsResponseModel(
      id: json['_id'],
      userId: json['userId'],
      company: Company.fromJson(json['companyId']),
      title: json['title'],
      description: json['description'],
      salaryRange: json['salaryRange'],
      location: json['location'],
      shift: json['shift'],
      responsibilities: json['responsibilities'],
      educationExperience: json['educationExperience'],
      benefits: json['benefits'],
      vacancy: json['vacancy'],
      counter: json['counter'],
      embedding: List<double>.from(json['embedding']),
      experience: json['experience'],
      deadline: DateTime.parse(json['deadline']),
      status: json['status'],
      jobCategoryId: json['jobCategoryId'],
      name: json['name'],
      role: json['role'],
      compensation: json['compensation'],
      arcrivedJob: json['arcrivedJob'],
      applicationRequirement: (json['applicationRequirement'] as List)
          .map((e) => ApplicationRequirement.fromJson(e))
          .toList(),
      customQuestion: (json['customQuestion'] as List)
          .map((e) => CustomQuestion.fromJson(e))
          .toList(),
      jobApprove: json['jobApprove'],
      adminApprove: json['adminApprove'],
      publishDate: DateTime.parse(json['publishDate']),
      employementType: json['employement_Type'],
      locationType: json['location_Type'],
      careerStage: json['career_Stage'],
      websiteUrl: json['website_Url'],
      expiryDate: DateTime.parse(json['expiryDate']),
      billingPlanType: json['billingPlanType'],
      deactivatedAt: json['deactivatedAt'] != null
          ? DateTime.parse(json['deactivatedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "companyId": company.toJson(),
        "title": title,
        "description": description,
        "salaryRange": salaryRange,
        "location": location,
        "shift": shift,
        "responsibilities": responsibilities,
        "educationExperience": educationExperience,
        "benefits": benefits,
        "vacancy": vacancy,
        "counter": counter,
        "embedding": embedding,
        "experience": experience,
        "deadline": deadline.toIso8601String(),
        "status": status,
        "jobCategoryId": jobCategoryId,
        "name": name,
        "role": role,
        "compensation": compensation,
        "arcrivedJob": arcrivedJob,
        "applicationRequirement":
            applicationRequirement.map((e) => e.toJson()).toList(),
        "customQuestion": customQuestion.map((e) => e.toJson()).toList(),
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
      };
}

class Company {
  final String id;
  final String userId;
  final String clogo;
  final String banner;
  final String aboutUs;
  final String slug;
  final String cname;
  final String country;
  final String city;
  final String zipcode;
  final String cemail;
  final List<SocialLink> sLink;
  final String industry;
  final List<dynamic> service;
  final List<String> employeesId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.userId,
    required this.clogo,
    required this.banner,
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

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'],
      userId: json['userId'],
      clogo: json['clogo'],
      banner: json['banner'],
      aboutUs: json['aboutUs'],
      slug: json['slug'],
      cname: json['cname'],
      country: json['country'],
      city: json['city'],
      zipcode: json['zipcode'],
      cemail: json['cemail'],
      sLink: (json['sLink'] as List)
          .map((e) => SocialLink.fromJson(e))
          .toList(),
      industry: json['industry'],
      service: List<dynamic>.from(json['service']),
      employeesId: List<String>.from(json['employeesId']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "clogo": clogo,
        "banner": banner,
        "aboutUs": aboutUs,
        "slug": slug,
        "cname": cname,
        "country": country,
        "city": city,
        "zipcode": zipcode,
        "cemail": cemail,
        "sLink": sLink.map((e) => e.toJson()).toList(),
        "industry": industry,
        "service": service,
        "employeesId": employeesId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class SocialLink {
  final String label;
  final String url;
  final String id;

  SocialLink({required this.label, required this.url, required this.id});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      label: json['label'],
      url: json['url'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() =>
      {"label": label, "url": url, "_id": id};
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

  factory ApplicationRequirement.fromJson(Map<String, dynamic> json) {
    return ApplicationRequirement(
      requirement: json['requirement'],
      status: json['status'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() =>
      {"requirement": requirement, "status": status, "_id": id};
}

class CustomQuestion {
  final String question;
  final String id;

  CustomQuestion({required this.question, required this.id});

  factory CustomQuestion.fromJson(Map<String, dynamic> json) {
    return CustomQuestion(
      question: json['question'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {"question": question, "_id": id};
}