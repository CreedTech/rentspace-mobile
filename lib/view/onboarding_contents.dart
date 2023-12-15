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
    title: "Fast and seamless delivery",
    image: "assets/slider1.png",
    desc:
        "We delivery your parcels to every corner, no location is beyond your reach",
  ),
  OnboardingContents(
    title: "24 hours delivery",
    image: "assets/slider2.png",
    desc:
        "We delivery your parcels to every corner, no location is beyond oyr reach",
  ),
  // OnboardingContents(
  //   title: "On demand and runtime location",
  //   image: "assets/slider1.png",
  //   desc:
  //       "We pick up from your desired location at your preferred date and time",
  // ),
];
