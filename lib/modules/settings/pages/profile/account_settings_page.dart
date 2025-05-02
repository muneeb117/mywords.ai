import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/custom_appbar.dart';
import 'package:mywords/common/components/custom_text_field.dart';
import 'package:mywords/common/components/loading_indicator.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/modules/settings/cubit/get_profile/get_profile_cubit.dart';
import 'package:mywords/utils/extensions/email_validator.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetProfileCubit>(
      create: (context) => GetProfileCubit(settingsRepository: sl())..getProfile(),
      child: Builder(
        builder: (context) {
          return AccountSettingsView();
        },
      ),
    );
  }
}

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends State<AccountSettingsView> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Account Settings'),
      body: BlocConsumer<GetProfileCubit, GetProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.getProfileStatus == GetProfileStatus.loading) {
            return LoadingIndicator(bgColor: context.colorScheme.onSurface);
          }
          if (state.getProfileStatus == GetProfileStatus.success) {
            fullNameController.text = state.fullName;
            emailController.text = state.email;
          }
          return Container(
            margin: EdgeInsets.all(16.cw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: RoundedImage(imageUrl: null),
                // ),
                SizedBox(height: 10.ch),
                Text('Full Name', style: context.textTheme.titleMedium),
                SizedBox(height: 8.ch),
                InputField(
                  hintText: 'Your full name',
                  prefixIconPath: '',
                  hasPrefixIcon: false,
                  enabled: false,
                  controller: fullNameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.ch),
                Text('Email', style: context.textTheme.titleMedium),
                SizedBox(height: 8.ch),
                InputField.email(
                  hintText: 'Email',
                  hasPrefixIcon: false,
                  enabled: false,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    } else if (!value.isValidEmail) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
