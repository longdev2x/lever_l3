import 'package:timesheet/data/model/body/role.dart';

class User {
  int? id;
  String? username;
  bool? active;
  bool? setPassword;
  bool? changePass;
  bool? hasPhoto;
  String? birthPlace;
  String? confirmPassword;
  String? displayName;
  DateTime? dob;
  String? email;
  String? firstName;
  String? tokenDevice;
  String? lastName;
  String? gender;
  String? image;
  String? university;
  String? password;
  int? countDayCheckin;
  int? countDayTracking;
  int? year;
  List<Role>? roles;

  User({
    this.id,
    this.username,
    this.active,
    this.changePass,
    this.setPassword,
    this.hasPhoto,
    this.birthPlace,
    this.confirmPassword,
    this.displayName,
    this.tokenDevice,
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
    bool? changePass,
    bool? hasPhoto,
    bool? setPassword,
    String? birthPlace,
    String? tokenDevice,
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
    List<Role>? roles,
  }) =>
      User(
        id: id,
        active: active ?? this.active,
        changePass: changePass ?? this.changePass,
        setPassword: setPassword ?? this.setPassword,
        hasPhoto: hasPhoto ?? this.hasPhoto,
        tokenDevice: tokenDevice ?? this.tokenDevice,
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

  factory User.fromJson(Map<String, dynamic>? json) {
    final roleList = json?['roles'] != null || (json?['roles'] as List).isNotEmpty
        ? (json!['roles'] as List<dynamic>?)
            ?.map((roleJson) => Role.fromJson(roleJson))
            .toList()
        : [Role(null, 'ROLE_USER', 'ROLE_USER')];

    return User(
      id: json?['id'],
      username: json?['username'],
      active: json?['active'],
      changePass: json?['changePass'],
      hasPhoto: json?['hasPhoto'],
      setPassword: json?['setPassword'],
      tokenDevice: json?['tokenDevice'],
      birthPlace: json?['birthPlace'],
      confirmPassword: json?['confirmPassword'],
      displayName: json?['displayName'],
      dob: json?['dob'] != null ? DateTime.tryParse(json?['dob']) : null,
      email: json?['email'],
      firstName: json?['firstName'],
      lastName: json?['lastName'],
      password: json?['password'],
      gender: json?['gender'],
      image: json?['image'],
      university: json?['university'],
      year: json?['year'],
      countDayCheckin: json?['countDayCheckin'],
      countDayTracking: json?['countDayTracking'],
      roles: roleList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'active': active,
      'birthPlace': birthPlace,
      'setPassword': setPassword,
      'changePass': changePass,
      'confirmPassword': confirmPassword,
      "displayName": displayName,
      'dob': dob?.toIso8601String(),
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'university': university,
      'year': year,
      'gender': gender,
      'image': image,
      'tokenDevice': tokenDevice,
      'countDayCheckin': countDayCheckin,
      'countDayTracking': countDayTracking,
      'hasPhoto': hasPhoto,
      'roles': roles?.map((roles) => roles.toJson()).toList(),
    };
  }
}
