// class EmployeeFetchSingleModel {
//   final Company? company;
//   final List<Employee> employees;
//   final List<dynamic> request;
//   final Meta? meta;

//   EmployeeFetchSingleModel({
//     this.company,
//     required this.employees,
//     required this.request,
//     this.meta,
//   });

//   factory EmployeeFetchSingleModel.fromJson(Map<String, dynamic>? json) {
//     if (json == null) {
//       return EmployeeFetchSingleModel(
//         company: null,
//         employees: [],
//         request: [],
//         meta: null,
//       );
//     }

//     return EmployeeFetchSingleModel(
//       company: json['company'] != null
//           ? Company.fromJson(json['company'] as Map<String, dynamic>)
//           : null,
//       employees: (json['employees'] as List<dynamic>? ?? [])
//           .map((e) => Employee.fromJson(e as Map<String, dynamic>?))
//           .toList(),
//       request: json['request'] ?? [],
//       meta: json['meta'] != null
//           ? Meta.fromJson(json['meta'] as Map<String, dynamic>)
//           : null,
//     );
//   }
// }

// // ---------------- EMPLOYEE MODEL ----------------

// class Employee {
//   final String id;
//   final String name;
//   final String slug;
//   final String email;
//   final String role;
//   final Photo? photo;
//   final List<String> skills;

//   Employee({
//     this.id = '',
//     this.name = '',
//     this.slug = '',
//     this.email = '',
//     this.role = '',
//     this.photo,
//     this.skills = const [],
//   });

//   factory Employee.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Employee();
//     return Employee(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       slug: json['slug'] ?? '',
//       email: json['email'] ?? '',
//       role: json['role'] ?? '',
//       photo: json['photo'] != null ? Photo.fromJson(json['photo']) : null,
//       skills: List<String>.from(json['skills'] ?? []),
//     );
//   }
// }

// // ---------------- COMPANY MODEL ----------------

// class Company {
//   final String id;
//   final String cname;
//   final String clogo;
//   final String industry;
//   final String aboutUs;
//   final String country;
//   final String city;

//   Company({
//     this.id = '',
//     this.cname = '',
//     this.clogo = '',
//     this.industry = '',
//     this.aboutUs = '',
//     this.country = '',
//     this.city = '',
//   });

//   factory Company.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Company();
//     return Company(
//       id: json['_id'] ?? '',
//       cname: json['cname'] ?? '',
//       clogo: json['clogo'] ?? '',
//       industry: json['industry'] ?? '',
//       aboutUs: json['aboutUs'] ?? '',
//       country: json['country'] ?? '',
//       city: json['city'] ?? '',
//     );
//   }
// }

// // ---------------- PHOTO MODEL ----------------

// class Photo {
//   final String url;

//   Photo({this.url = ''});

//   factory Photo.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Photo();
//     return Photo(url: json['url'] ?? '');
//   }
// }

// // ---------------- META MODEL ----------------

// class Meta {
//   final int currentPage;
//   final int totalPages;
//   final int totalItems;
//   final int itemsPerPage;

//   Meta({
//     this.currentPage = 1,
//     this.totalPages = 1,
//     this.totalItems = 0,
//     this.itemsPerPage = 10,
//   });

//   factory Meta.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return Meta();
//     return Meta(
//       currentPage: json['currentPage'] ?? 1,
//       totalPages: json['totalPages'] ?? 1,
//       totalItems: json['totalItems'] ?? 0,
//       itemsPerPage: json['itemsPerPage'] ?? 10,
//     );
//   }
// }

class EmployeeFetchSingleModel {
  final Company? company;
  final List<Employee> employees;
  final List<RequestModel> request;

  EmployeeFetchSingleModel({
    this.company,
    required this.employees,
    required this.request,
  });

  factory EmployeeFetchSingleModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return EmployeeFetchSingleModel(
        company: null,
        employees: [],
        request: [],
      );
    }

    return EmployeeFetchSingleModel(
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      employees: (json['employees'] as List<dynamic>? ?? [])
          .map((e) => Employee.fromJson(e))
          .toList(),
      request: (json['request'] as List<dynamic>? ?? [])
          .map((e) => RequestModel.fromJson(e))
          .toList(),
    );
  }
}


class Employee {
  final String id;
  final String name;
  final String slug;
  final String email;
  final String role;
  final Photo? photo;
  final List<String> skills;

  Employee({
    this.id = '',
    this.name = '',
    this.slug = '',
    this.email = '',
    this.role = '',
    this.photo,
    this.skills = const [],
  });

  factory Employee.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Employee();

    return Employee(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      photo: json['photo'] != null ? Photo.fromJson(json['photo']) : null,
      skills: List<String>.from(json['skills'] ?? []),
    );
  }
}

class Company {
  final String id;
  final String cname;
  final String clogo;
  final String industry;
  final String aboutUs;
  final String country;
  final String city;

  Company({
    this.id = '',
    this.cname = '',
    this.clogo = '',
    this.industry = '',
    this.aboutUs = '',
    this.country = '',
    this.city = '',
  });

  factory Company.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Company();

    return Company(
      id: json['_id'] ?? '',
      cname: json['cname'] ?? '',
      clogo: json['clogo'] ?? '',
      industry: json['industry'] ?? '',
      aboutUs: json['aboutUs'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
    );
  }
}
class RequestModel {
  final String id;
  final RequestUser? userId;
  final String company;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int version;

  RequestModel({
    this.id = '',
    this.userId,
    this.company = '',
    this.status = '',
    this.createdAt,
    this.updatedAt,
    this.version = 0,
  });

  factory RequestModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RequestModel();

    return RequestModel(
      id: json['_id'] ?? '',
      userId: json['userId'] != null
          ? RequestUser.fromJson(json['userId'])
          : null,
      company: json['company'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      version: json['__v'] ?? 0,
    );
  }
}
class RequestUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String slug;
  final Avatar? avatar;

  RequestUser({
    this.id = '',
    this.name = '',
    this.email = '',
    this.role = '',
    this.slug = '',
    this.avatar,
  });

  factory RequestUser.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RequestUser();

    return RequestUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      slug: json['slug'] ?? '',
      avatar: json['avatar'] != null
          ? Avatar.fromJson(json['avatar'])
          : null,
    );
  }
}
class Photo {
  final String url;

  Photo({this.url = ''});

  factory Photo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Photo();
    return Photo(url: json['url'] ?? '');
  }
}

class Avatar {
  final String url;

  Avatar({this.url = ''});

  factory Avatar.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Avatar();
    return Avatar(url: json['url'] ?? '');
  }
}
