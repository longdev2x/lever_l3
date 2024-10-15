import 'package:timesheet/data/model/body/role.dart';

class User {
  int? id;
  String? username;
  bool? active;
  String? birthPlace;
  String? confirmPassword;
  String? displayName;
  DateTime? dob;
  String? email;
  String? firstName;
  String? lastName;
  String? gender;
  String? image;
  String? university;
  String? password;
  int? countDayCheckin;
  int? countDayTracking;
  int? year;
  Role? roles;

  User({
    this.id,
    this.username,
    this.active,
    this.birthPlace,
    this.confirmPassword,
    this.displayName,
    this.dob,
    this.email,
    this.firstName,
    this.lastName,
    this.password,
    this.gender,
    this.image,
    this.university,
    this.year,
    this.roles,
    this.countDayCheckin,
    this.countDayTracking,
  });

  User copyWith({
    String? username,
    bool? active,
    String? birthPlace,
    String? confirmPassword,
    String? displayName,
    DateTime? dob,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? image,
    String? university,
    String? password,
    int? countDayCheckin,
    int? countDayTracking,
    int? year,
    Role? roles,
  }) =>
      User(
        id: id,
        active: active ?? this.active,
        birthPlace: birthPlace ?? this.birthPlace,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        countDayCheckin: countDayCheckin ?? this.countDayCheckin,
        countDayTracking: countDayTracking ?? this.countDayTracking,
        displayName: displayName ?? this.displayName,
        dob: dob ?? this.dob,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        gender: gender ?? this.gender,
        image: image ?? this.image,
        lastName: lastName ?? this.lastName,
        password: password ?? this.password,
        roles: roles ?? this.roles,
        university: university ?? this.university,
        username: username ?? this.username,
        year: year ?? this.year,
      );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      active: json['active'],
      birthPlace: json['birthPlace'],
      confirmPassword: json['confirmPassword'],
      displayName: json['displayName'],
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      password: json['password'],
      gender: json['gender'],
      image: json['image'],
      university: json['university'],
      year: json['year'],
      countDayCheckin: json['countDayCheckin'],
      countDayTracking: json['countDayTracking'],
      roles: (json['roles'] as List<dynamic>?)
          ?.map((roleJson) => Role.fromJson(roleJson))
          .toList()
          .first,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'active': active,
      'birthPlace': birthPlace,
      'confirmPassword': confirmPassword,
      "displayName": displayName,
      'dob': dob?.toIso8601String(),
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      // 'roles': roles?.map((roles) => roles.toJson()).toList(),
      'university': university,
      'year': year,
      'gender': gender,
      'image': image,
      'countDayCheckin': countDayCheckin,
      'countDayTracking': countDayTracking,
      // 'hasPhoto':hasPhoto
    };
  }
}
