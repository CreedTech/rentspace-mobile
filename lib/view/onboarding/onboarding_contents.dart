class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "SpaceRent",
    image: "assets/onboarding_img1.png",
    desc:
        "We’re excited to have you join Spacerent!!! Save 70% of your rent consistently & have access to 30% to complete it.",
  ),
  OnboardingContents(
    title: "Virtual Account",
    image: "assets/onboarding_img2.png",
    desc:
        "Earn Space Points for airtime top-ups by completing various saving activities on our app.",
  ),
];
