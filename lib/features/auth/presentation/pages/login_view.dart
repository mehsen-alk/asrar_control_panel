import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/strings_manager.dart';
import '../../../../config/app_localizations.dart';
import '../../../../config/values_manager.dart';
import '../../../../core/app/extensions.dart';
import '../../../../core/app/functions.dart';
import '../../data/models/requests.dart';
import '../bloc/authentication_bloc.dart';
import '../common/functions.dart';
import '../common/widgets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.signIn.tr(context)),
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          manageDialog(context, state);
        },
        child: Center(
          child: Card(
            child: SizedBox(
              height: AppSize.s500.h,
              width: AppSize.s500.h,
              child: const LoginForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final TextEditingController _emailTextEditingController =
      TextEditingController();

  final TextEditingController _passwordTextEditingController =
      TextEditingController();

  bool validateEmail = false;
  bool validatePassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 8.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppStrings.accessToControlPanel.tr(context)),
            SizedBox(
              height: AppSize.s50.h,
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFrom(
                    controller: _emailTextEditingController,
                    icon: Icons.email_outlined,
                    label: AppStrings.email.tr(context),
                    onTap: () {
                      setState(() {
                        validateEmail = true;
                      });
                    },
                    validator: (v) {
                      if (validateEmail) {
                        if (v.nullOrEmpty()) {
                          return AppStrings.pleaseEnterEmail.tr(context);
                        }

                        if (!isEmailFormatCorrect(v!)) {
                          return AppStrings.emailFormatNotCorrect.tr(context);
                        }
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: AppSize.s20.h),
                  TextFrom(
                    onTap: () {
                      setState(() {
                        validatePassword = true;
                      });
                    },
                    controller: _passwordTextEditingController,
                    icon: Icons.lock_outline,
                    label: AppStrings.password.tr(context),
                    validator: (v) {
                      if (validatePassword) {
                        if (v.nullOrEmpty() || v!.length < 6) {
                          return AppStrings.passwordShouldAtLeast6Character
                              .tr(context);
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: AppSize.s50.h,
            ),
            FullElevatedButton(
              onPressed: () {
                setState(() {
                  validateEmail = true;
                  validatePassword = true;
                });
                if (_key.currentState!.validate()) {
                  BlocProvider.of<AuthenticationBloc>(context).add(
                      LoginButtonPressed(LoginRequest(
                          _emailTextEditingController.text,
                          _passwordTextEditingController.text)));
                }
              },
              text: AppStrings.signIn.tr(context),
            )
          ],
        ),
      ),
    );
  }
}
