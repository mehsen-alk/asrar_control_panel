import 'package:asrar_control_panel/config/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../config/color_manager.dart';
import '../../../../../config/strings_manager.dart';
import '../../../../../config/styles_manager.dart';
import '../../../../../config/values_manager.dart';
import '../../../../../core/app/functions.dart';
import '../../blocs/course_bloc/course_bloc.dart';

class DeleteCoursesScreen extends StatelessWidget {
  const DeleteCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: BlocListener<CourseBloc, CourseState>(
          listener: (context, state) {
            if (state is DeleteCourseLoadingState) {
              showCustomDialog(context);
            } else if (state is CourseErrorState) {
              showCustomDialog(context, message: state.errorMessage);
              BlocProvider.of<CourseBloc>(context).add(GetCourseListEvent());
            } else if (state is CourseDeletedSuccessfullyState) {
              showCustomDialog(context,
                  message: AppStrings.deletedSuccessfully.tr(context));
              BlocProvider.of<CourseBloc>(context).add(GetCourseListEvent());
            }
          },
          child: BlocBuilder<CourseBloc, CourseState>(
            builder: (context, state) {
              if (state is CourseLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorManager.primary,
                  ),
                );
              } else if (state is GetCourseErrorState) {
                return Center(
                  child: Text(
                    state.errorMessage.tr(context),
                    style: getAlmaraiRegularStyle(
                      fontSize: AppSize.s20.sp,
                      color: ColorManager.error,
                    ),
                  ),
                );
              } else if (state is CourseLoadedState) {
                if (state.coursesList.isNotEmpty) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.coursesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: AppSize.s80.h,
                          margin: EdgeInsets.symmetric(
                            vertical: AppSize.s10.h,
                            horizontal: AppSize.s120.w,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: ColorManager.primary,
                            borderRadius: BorderRadius.circular(AppSize.s10.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(AppSize.s10.r),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        state.coursesList[index].courseImageUrl,
                                      ),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: ColorManager.grey,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppSize.s5.w,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        state.coursesList[index].courseTitile,
                                        style: getAlmaraiRegularStyle(
                                          fontSize: AppSize.s18.sp,
                                          color: ColorManager.white,
                                        ),
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        state.coursesList[index].coursePrice
                                                .startsWith("0")
                                            ? "????????????"
                                            : state
                                                .coursesList[index].coursePrice,
                                        style: getAlmaraiRegularStyle(
                                          fontSize: AppSize.s16.sp,
                                          color: ColorManager.white,
                                        ),
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                      Text(
                                        state.coursesList[index].timestamp
                                            .toDate()
                                            .toString(),
                                        style: getAlmaraiRegularStyle(
                                          fontSize: AppSize.s16.sp,
                                          color: ColorManager.white,
                                        ),
                                        maxLines: 1,
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  BlocProvider.of<CourseBloc>(context).add(
                                    DeleteCourseEvent(
                                      course: state.coursesList[index],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              )
                            ],
                          ),
                        );
                      });
                } else {
                  return Center(
                    child: Text(
                      AppStrings.noNews.tr(context),
                      style: getAlmaraiRegularStyle(
                        fontSize: AppSize.s25.sp,
                        color: ColorManager.primary,
                      ),
                    ),
                  );
                }
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
