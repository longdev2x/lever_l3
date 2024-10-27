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


class EditMemberUserScreen extends StatefulWidget {
  final User objUser;
  const EditMemberUserScreen({super.key, required this.objUser});

  @override
  State<EditMemberUserScreen> createState() => _EditMemberUserScreenState();
}

class _EditMemberUserScreenState extends State<EditMemberUserScreen> {
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
    _lastNameController.text = widget.objUser.lastName ?? '';
    _firstNameController.text = widget.objUser.firstName ?? '';
    _displayNameController.text = widget.objUser.displayName ?? '';
    _birthPlaceController.text = widget.objUser.birthPlace ?? '';
    _universityController.text = widget.objUser.university ?? '';
    _dobController.text = DateConverter.getOnlyFomatDate(
        widget.objUser.dob ?? DateTime.now().subtract(const Duration(days: 7200)));
    _yearController.text = widget.objUser.year != null ? widget.objUser.year.toString() : '';
  }

  void _onGenderPick(String gender) {
    Get.find<ProfileController>().updateUserForAdmin(widget.objUser, gender: gender);
  }

  void _onSubmit() {
    int? year;
    if (_displayNameController.text.trim().length < 5) {
      AppToast.showToast('${'display_name'.tr} ${'must_be_greater'.trParams({
        'number' : '4'
      })}');
      return;
    }
    year = int.tryParse(_yearController.text);
    if (year == null || year < 1 || year > 7) {
      AppToast.showToast('${'year_student'} ${'must_be_between'.trParams({
        'number1' : '1',
        'number2' : '7'
      })}');
      return;
    }

    Get.find<ProfileController>().updateUserForAdmin(
      widget.objUser,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      displayName: _displayNameController.text.trim(),
      birthPlace: _birthPlaceController.text.trim(),
      university: _universityController.text.trim(),
      year: year,
    );
  }

  void _onDatePicker() async {
    DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime.now().subtract(const Duration(days: 100000)),
        lastDate: DateTime.now(),
        initialDate: DateTime.now().subtract(const Duration(days: 7200)));
    Get.find<ProfileController>().updateUserForAdmin(widget.objUser, dob: date);
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
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
              child: Column(
                children: [
                  ProfileAvatarWidget(avatar: widget.objUser.image),
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
                          isChose: widget.objUser.gender == 'M'),
                      SizedBox(width: 10.w),
                      _genderPicker(
                          onTap: () {
                            _onGenderPick('F');
                          },
                          iconPath: Images.icGenderWoman,
                          text: 'female'.tr,
                          isChose: widget.objUser.gender == 'F'),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  AppTextField(
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
                      '${'edit'.tr} ${'security_information'.tr}!',
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
          isChose
              ? Positioned(
                  top: 5.h,
                  right: 5.w,
                  child: const AppImageAsset(
                    imagePath: Images.icCheckTick,
                    height: 30,
                    width: 30,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
