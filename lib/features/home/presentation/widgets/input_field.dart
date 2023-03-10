import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/values_manager.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.labelAndHintText,
    required this.regExp,
    required this.controller,
    required this.height,
  }) : super(key: key);
  final String labelAndHintText;
  final RegExp regExp;
  final TextEditingController controller;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: height,
        width: AppSize.s130.w,
        margin: EdgeInsets.symmetric(vertical: AppSize.s10.h),
        child: TextFormField(
          controller: controller,
          maxLines: null,
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.allow(regExp),
          ],
          expands: true,
          decoration: InputDecoration(
            labelText: labelAndHintText,
            hintText: labelAndHintText
          ),
        ),
      ),
    );
  }
}
