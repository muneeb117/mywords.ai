class OnboardingModel {
  static final List<OnboardingItem> items = [
    OnboardingItem(
      title: 'Onboarding One',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
      image: 'assets/images/png/onboarding_mockup_one.png',
    ),
    OnboardingItem(
      title: 'Onboarding Two',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
      image: 'assets/images/png/onboarding_mockup_two.png',
    ),
    OnboardingItem(
      title: 'Onboarding Three',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
      image: 'assets/images/png/onboarding_mockup_three.png',
    ),
    OnboardingItem(
      title: 'Onboarding Four',
      description:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard",
      image: 'assets/images/png/onboarding_mockup_four.png',
    ),
  ];
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}
