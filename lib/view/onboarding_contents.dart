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
        "Save 70% of your rent for a minimum of 180 days and get up to 30% as loan.",
  ),
  OnboardingContents(
    title: "Virtual Account",
    image: "assets/onboarding_img2.png",
    desc:
        "Instantly recharge Airtime, Data, Cable TV, Electricity, and more with RentSpace Technology. Our advanced tech ensures seamless utility payments.",
  ),
  // OnboardingContents(
  //   title: "On demand and runtime location",
  //   image: "assets/slider1.png",
  //   desc:
  //       "We pick up from your desired location at your preferred date and time",
  // ),
];
