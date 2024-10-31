import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:timesheet/controller/tracking_controller.dart';
import 'package:timesheet/data/model/body/tracking_entity.dart';
import 'package:timesheet/helper/date_converter.dart';
import 'package:timesheet/utils/color_resources.dart';
import 'package:timesheet/view/app_button.dart';
import 'package:timesheet/view/app_text_field.dart';
import 'package:timesheet/view/app_toast.dart';

class TrackingDetail extends StatefulWidget {
  final TrackingEntity objTracking;
  const TrackingDetail({super.key, required this.objTracking});

  @override
  State<TrackingDetail> createState() => _TrackingDetailState();
}

class _TrackingDetailState extends State<TrackingDetail> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.objTracking.content ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (_controller.text.isEmpty) {
      AppToast.showToast('input_field_is_empty'.tr);
      return;
    }
    int statusCode = await Get.find<TrackingController>()
        .editTracking(widget.objTracking, newContent: _controller.text);

    if (statusCode == 200) {
      AppToast.showToast('update_successful'.tr);
      Get.back();
    }
  }

  void _onDelete() async {
    if (widget.objTracking.id == null) {
      AppToast.showToast('Can\'t delete');
    }

    showDialog(
      context: context,
      builder: (context) => AppConfirm(
        title: 'are_you_sure_to_delete_this_schedule'.tr,
        onConfirm: () async {
          int statusCode = await Get.find<TrackingController>()
              .deleteTracking(id: widget.objTracking.id!);

          if (statusCode == 200) {
            AppToast.showToast('delete_successful'.tr);
          } else {
            AppToast.showToast('delete_not_successful'.tr);
          }

          if (context.mounted) {
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.objTracking.date != null
            ? Text(
                '${DateConverter.getWeekDay(widget.objTracking.date!)}, ${DateConverter.getOnlyFomatDate(widget.objTracking.date!)} - ${DateConverter.getHoursMinutes(widget.objTracking.date!)}')
            : const Text('Nội dung tracking'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 16.w,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppTextAreaField(
                hintText: 'Nội dung',
                controller: _controller,
              ),
              SizedBox(height: 50.h),
              AppButton(
                name: 'update'.tr,
                ontap: _onSubmit,
              ),
              SizedBox(height: 30.h),
              AppButton(
                name: 'Delete'.tr,
                ontap: _onDelete,
                bgColor: ColorResources.getRedColor(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
