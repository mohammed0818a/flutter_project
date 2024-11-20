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
    title: "Add your business and get customers",
    image: "images/image1.png",
    desc: "Remember to keep track of your professional accomplishments.",
  ),
  OnboardingContents(
    title: "Display your work for free",
    image: "images/image2.png",
    desc: "But you must add your own means of communication.",
  ),
  OnboardingContents(
    title: "You can also update and delete",
    image: "images/image3.png",
    desc:
        "You can edit and delete only what you have posted, and be sure to add a picture ",
  ),
];
