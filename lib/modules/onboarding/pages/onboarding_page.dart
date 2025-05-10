import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mywords/common/components/primary_button.dart';
import 'package:mywords/config/routes/route_manager.dart';
import 'package:mywords/constants/app_keys.dart';
import 'package:mywords/core/analytics/analytics_service.dart';
import 'package:mywords/core/di/service_locator.dart';
import 'package:mywords/core/storage/storage_service.dart';
import 'package:mywords/modules/onboarding/cubit/onboarding.dart';
import 'package:mywords/modules/onboarding/models/onboarding_model.dart';
import 'package:mywords/utils/extensions/extended_context.dart';
import 'package:mywords/utils/extensions/size_extension.dart';

class OnboardingPage extends StatefulWidget {
  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final _analyticsService = sl<AnalyticsService>();

  int _currentPage = 0;
  final items = OnboardingModel.items;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(sessionRepository: sl(), analyticsService: sl()),
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
                itemBuilder:
                    (context, index) => Container(
                      padding: EdgeInsets.all(18.cw) + EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                      child: Image.asset(items[index].image),
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
                height: 300.ch,
                padding: EdgeInsets.symmetric(horizontal: 24.cw, vertical: 30.ch),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      items[_currentPage].title,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineLarge?.copyWith(fontSize: 24.csp, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 16.ch),
                    Text(
                      items[_currentPage].description,
                      maxLines: 4,
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyMedium?.copyWith(height: 1.5),
                    ),
                    SizedBox(height: 22.ch),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        items.length,
                        (index) => Container(
                          width: _currentPage == index ? 24.cw : 8.cw,
                          height: 8.ch,
                          margin: EdgeInsets.symmetric(horizontal: 4.cw),
                          decoration: BoxDecoration(
                            color: _currentPage == index ? context.colorScheme.primary : Color(0xffE7E7E7),
                            borderRadius: BorderRadius.circular(5.cw),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 22.ch),
                    Builder(
                      builder: (context) {
                        return Row(
                          children: [
                            Expanded(
                              child: PrimaryButton.filled(
                                onTap: () {
                                  context.read<OnboardingCubit>().complete(OnboardingCompletionType.skipped);
                                  Navigator.pushNamedAndRemoveUntil(context, RouteManager.login, (route) => false);
                                },
                                title: 'Skip',
                                backgroundColor: Color(0xffF6F0FF),
                                textColor: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 16.cw),
                            Expanded(
                              child: PrimaryButton.filled(
                                onTap: () {
                                  if (_currentPage < 3) {
                                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                                  } else {
                                    context.read<OnboardingCubit>().complete(OnboardingCompletionType.completed);
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
