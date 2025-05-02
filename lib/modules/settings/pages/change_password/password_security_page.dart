import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/settings/cubit/change_password/change_password_cubit.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class PasswordSecurityPage extends StatefulWidget {
  const PasswordSecurityPage({super.key});

  @override
  State<PasswordSecurityPage> createState() => _PasswordSecurityPageState();
}

class _PasswordSecurityPageState extends State<PasswordSecurityPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    bool hasBottomSafeArea = bottomPadding > 0;
    return BlocProvider(
      create: (context) => ChangePasswordCubit(settingsRepository: sl()),
      child: Builder(builder: (context) {
        return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state.changePasswordStatus == ChangePasswordStatus.success) {
              context.showSnackBar('Password Changed Successfully!');
              Navigator.pop(context);
            } else if (state.changePasswordStatus == ChangePasswordStatus.failure) {
              context.showSnackBar(state.errorMsg);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(title: 'Security'),
              body: Container(
                margin: EdgeInsets.all(16.cw),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      InputField.password(
                        hintText: 'Current password',
                        controller: passwordController,
                        suffixIconPath:
                            state.isCurrentPasswordHidden ? 'assets/images/svg/ic_pwd_hidden.svg' : 'assets/images/svg/ic_pwd_shown.svg',
                        obscureText: state.isCurrentPasswordHidden,
                        onSuffixIconTap: () {
                          context.read<ChangePasswordCubit>().toggleCurrentPassword();
                        },
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.ch),
                      Text(
                          'Your password needs to be at least 8 characters long.\nInclude some words and phrases to make it even more safer'),
                      SizedBox(height: 16.ch),
                      InputField.password(
                        hintText: 'New Password',
                        controller: newPasswordController,
                        suffixIconPath:
                            state.isNewPasswordHidden ? 'assets/images/svg/ic_pwd_hidden.svg' : 'assets/images/svg/ic_pwd_shown.svg',
                        obscureText: state.isNewPasswordHidden,
                        onSuffixIconTap: () {
                          context.read<ChangePasswordCubit>().toggleNewPasswordPassword();
                        },
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          } else if (value.trim().length < 8) {
                            return "Password must be 8 characters long";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.ch),
                      InputField.password(
                        hintText: 'Confirm Your Password',
                        controller: confirmNewPasswordController,
                        suffixIconPath:
                            state.isConfirmNewPasswordHidden ? 'assets/images/svg/ic_pwd_hidden.svg' : 'assets/images/svg/ic_pwd_shown.svg',
                        obscureText: state.isConfirmNewPasswordHidden,
                        onSuffixIconTap: () {
                          context.read<ChangePasswordCubit>().toggleConfirmNewPasswordPassword();
                        },
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Password is required';
                          } else if (value.trim().length < 8) {
                            return "Password must be 8 characters long";
                          } else if (newPasswordController.text != confirmNewPasswordController.text) {
                            return "Password doesn't match";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.cw),
                padding: EdgeInsets.only(bottom: hasBottomSafeArea ? bottomPadding : 30.ch),
                child: PrimaryButton.filled(
                  isLoading: state.changePasswordStatus == ChangePasswordStatus.loading,
                  onTap: () {
                    bool isFormValidated = _formKey.currentState?.validate() == true;
                    if (isFormValidated) {
                      context.closeKeyboard();
                      final password = passwordController.text.trim();
                      final newPassword = newPasswordController.text.trim();

                      if (password == newPassword) {
                        context.showSnackBar("Old password can't be used");
                        return;
                      }
                      context.read<ChangePasswordCubit>().changePassword(password, newPassword);
                    }
                  },
                  title: 'Update',
                  backgroundColor: context.colorScheme.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
