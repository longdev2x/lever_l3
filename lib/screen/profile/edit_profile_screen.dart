import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/profile_controller.dart';
import 'package:timesheet/data/model/body/user.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/screen/profile/widgets/profile_avatar_widget.dart';
import 'package:timesheet/utils/color_resources.dart';

import 'package:timesheet/utils/images.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_image.dart';
import 'package:timesheet/view/app_text.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _birthPlaceController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _birthPlaceController.dispose();
    _displayNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _universityController.dispose();
    _yearController.dispose();
    _dobController.dispose();
  }

  @override
  void initState() {
    super.initState();
    User objUser = Get.find<ProfileController>().user!;
    _lastNameController.text = objUser.lastName ?? '';
    _firstNameController.text = objUser.firstName ?? '';
    _displayNameController.text = objUser.displayName ?? '';
    _birthPlaceController.text = objUser.birthPlace ?? '';
    _universityController.text = objUser.university ?? '';
    _dobController.text = DateConverter.getOnlyFomatDate(
        objUser.dob ?? DateTime.now().subtract(const Duration(days: 7200)));
    _yearController.text = objUser.year != null ? objUser.year.toString() : '';
  }

  void _onGenderPick(String gender) {
    Get.find<ProfileController>().updateInfo(gender: gender);
  }

  void _onSubmit() async {
    int? year;
    if (_displayNameController.text.trim().length < 5) {
      AppToast.showToast('${'display_name'.tr} ${'must_be_greater'.trParams({
            'number': '4'
          })}');
      return;
    }
    year = int.tryParse(_yearController.text);
    if (year == null || year < 1 || year > 7) {
      AppToast.showToast('${'year_student'} ${'must_be_between'.trParams({
            'number1': '1',
            'number2': '7'
          })}');
      return;
    }

    int statusCode = await Get.find<ProfileController>().updateInfo(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      displayName: _displayNameController.text.trim(),
      birthPlace: _birthPlaceController.text.trim(),
      university: _universityController.text.trim(),
      year: year,
    );

    if (statusCode == 200) {
      AppToast.showToast('Cập nhật thành công');
      Get.back();
    }
  }

  void _onDatePicker() async {
    DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 100000)),
        lastDate: DateTime.now(),
        initialDate: DateTime.now().subtract(const Duration(days: 7200)));
    Get.find<ProfileController>().updateInfo(dob: date);
  }

  void _updateTextField(User objUser) {
    if (objUser.dob != null) {
      _dobController.text = DateConverter.getOnlyFomatDate(objUser.dob!);
    }
  }

  Widget _genderPicker({
    required Function() onTap,
    bool isChose = false,
    required String iconPath,
    required String text,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 70.h,
            width: 130.w,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: isChose
                    ? ColorResources.getGreyColor()
                    : ColorResources.getWhiteColor(),
                borderRadius: BorderRadius.circular(16.r)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImageAsset(
                  imagePath: iconPath,
                  color: Colors.black,
                  height: 25,
                  width: 25,
                ),
                SizedBox(height: 3.h),
                AppText14(
                  text,
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
          ),
          if (isChose)
            Positioned(
              top: 5.h,
              right: 5.w,
              child: const AppImageAsset(
                imagePath: Images.icCheckTick,
                height: 30,
                width: 30,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AppConfirm(
                title: 'edits_will_not_be_saved'.tr,
                onConfirm: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('edit_profile'.tr),
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          _updateTextField(controller.user!);
          User objUser = controller.user!;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 0),
              child: Column(
                children: [
                  const ProfileAvatarWidget(),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          lable: 'last_name'.tr,
                          controller: _lastNameController,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: AppTextField(
                          lable: 'first_name'.tr,
                          controller: _firstNameController,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(
                    lable: 'display_name'.tr,
                    controller: _displayNameController,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _genderPicker(
                          onTap: () {
                            _onGenderPick('M');
                          },
                          iconPath: Images.icGenderMan,
                          text: 'male'.tr,
                          isChose: objUser.gender == 'M' ||
                              (objUser.gender != 'M' && objUser.gender != 'F')),
                      SizedBox(width: 10.w),
                      _genderPicker(
                          onTap: () {
                            _onGenderPick('F');
                          },
                          iconPath: Images.icGenderWoman,
                          text: 'female'.tr,
                          isChose: objUser.gender == 'F'),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(
                    lable: 'Ngày sinh',
                    controller: _dobController,
                    readOnly: true,
                    onTap: _onDatePicker,
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(
                    lable: 'birth_place'.tr,
                    controller: _birthPlaceController,
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(
                    lable: 'university'.tr,
                    controller: _universityController,
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(
                    lable: 'year_student'.tr,
                    controller: _yearController,
                  ),
                  SizedBox(height: 20.h),
                  AppButton(
                    name: 'update'.tr,
                    ontap: _onSubmit,
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () {},
                    child: AppText16(
                      '${'edit'.tr} ${'security_information'.tr.toLowerCase()}!',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
