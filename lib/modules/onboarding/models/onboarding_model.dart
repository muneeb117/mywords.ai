class OnboardingModel {
  static final List<OnboardingItem> items = [
    OnboardingItem(
      title: 'Welcome to MyWords.AI',
      description:
          "Explore powerful AI tools designed to humanize your writing, detect AI content, and create flawless documents in seconds.",
      image: 'assets/images/png/onboarding_mockup_one.png',
    ),
    OnboardingItem(
      title: 'Detect AI Content Instantly',
      description:
          "Make AI-written content undetectable by Turnitin, GPTZero, and Originality.AI - perfect for students, writers, and professionals who need natural, human-like text.",
      image: 'assets/images/png/onboarding_mockup_two.png',
    ),
    OnboardingItem(
      title: 'Write Smarter, Not Harder',
      description:
          "Use the AI Writer to create essays, emails, and more from a single prompt - fast, easy, and human-like.",
      image: 'assets/images/png/onboarding_mockup_three.png',
    ),
    OnboardingItem(
      title: 'Humanize Your AI Text',
      description:
          "Rewrite AI-generated content so it passes detection tools like Turnitin and GPTZero while sounding natural and authentic.",
      image: 'assets/images/png/onboarding_mockup_four.png',
    ),
  ];
}

class OnboardingItem {
  final String title;
  final String description;
  final String image;

  OnboardingItem({required this.title, required this.description, required this.image});
}
