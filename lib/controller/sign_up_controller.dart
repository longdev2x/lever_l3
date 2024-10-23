import 'package:get/get.dart';
import 'package:timesheet/data/model/body/user.dart';

class SignUpController extends GetxController implements GetxService {
  User user = User(
    gender: 'Nam',
    dob: DateTime.now().subtract(const Duration(days: 7260)),
  );

  void updateInfor({
    String? username,
    DateTime? dob,
    String? email,
    String? displayName,
    String? firstName,
    String? lastName,
    String? birthPlace,
    String? gender,
    String? university,
    String? password,
    String? confirmPassword,
    int? year,
  }) {
    user = user.copyWith(
      username: username,
      dob: dob,
      birthPlace: birthPlace,
      email: email,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      university: university,
      password: password,
      confirmPassword: confirmPassword,
      year: year,
    );
    update();
  }

  String? firstValidate() {
    if (user.firstName == null || user.firstName!.trim().length < 2) {
      return 'Họ cần lớn hơn 1 ký tự';
    }
    if (user.lastName == null || user.lastName!.trim().length < 2) {
      return 'Tên cần lớn hơn 1 ký tự';
    }
    if (user.birthPlace == null || user.birthPlace!.length < 2) {
      return 'Nơi sinh trống';
    }
    if (user.email == null || !user.email!.contains('@')) {
      return 'Email chưa đúng định dạng';
    }
    if (user.university == null || user.university!.isEmpty) {
      return 'Tên trường không được bỏ trống';
    }
    if (user.year == null || user.year! < 0 || user.year! > 8) {
      return 'Năm học từ 1 đến 8';
    }
    return null;
  }

  String? secondValidate() {
    if(user.displayName == null || user.displayName!.trim().length < 3 || user.username!.trim().length > 30) {
      return 'Tên hiển thị cần nằm trong khoảng từ 3 đến 30 ký tự';
    }
    if(user.username == null || user.username!.trim().length < 3 || user.username!.trim().length > 30) {
      return 'Username cần nằm trong khoảng từ 3 đến 30 ký tự';
    }
    if(user.password == null || user.password!.length < 6) {
      return 'Password cần lớn hơn 6 ký tự';
    }
    if(user.confirmPassword == null || user.confirmPassword != user.password) {
      return 'Mật khẩu xác nhận không trùng khớp';
    }
    return null;
  }
}
