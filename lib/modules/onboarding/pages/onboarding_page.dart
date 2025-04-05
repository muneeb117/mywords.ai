import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/modules/onboarding/cubit/onboarding.dart';
import 'package:mywords/modules/onboarding/models/onboarding_model.dart';
import 'package:mywords/utils/extensions/extended_context.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final items = OnboardingModel.items;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(sessionRepository: sl()),
      child: Scaffold(
        backgroundColor: Color(0xff601FBE),
        body: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: items.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.all(18) + EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                  child: Image.asset(
                    items[index].image,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                width: double.infinity,
                height: 290,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(items[_currentPage].title,
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        )),
                    SizedBox(height: 16),
                    Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
                        maxLines: 3,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(height: 1.5)),
                    SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        items.length,
                        (index) => Container(
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: _currentPage == index ? context.colorScheme.primary : Color(0xffE7E7E7),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22),
                    Builder(
                      builder: (context) {
                        return Row(
                          children: [
                            Expanded(
                              child: PrimaryButton.filled(
                                onTap: () {
                                  context.read<OnboardingCubit>().complete();
                                  Navigator.pushNamedAndRemoveUntil(context, RouteManager.login, (route) => false);
                                },
                                title: 'Skip',
                                backgroundColor: Color(0xffF6F0FF),
                                textColor: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: PrimaryButton.filled(
                                onTap: () {
                                  if (_currentPage < 3) {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    context.read<OnboardingCubit>().complete();
                                    sl<StorageService>().setBool(AppKeys.isNewUser, false);
                                    Navigator.pushNamedAndRemoveUntil(context, RouteManager.login, (route) => false);
                                  }
                                },
                                title: 'Continue',
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
