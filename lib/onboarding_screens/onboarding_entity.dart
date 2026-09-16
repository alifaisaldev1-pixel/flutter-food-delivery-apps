class onboardingEntity {
  //model class for onboarding data
  final String image;
  final String title;
  final String description;
  
  // Constructor
  onboardingEntity({
    required this.image,
    required this.title,
    required this.description,
    
  });
}

//list of onboarding data
final List<onboardingEntity> onboarding_data = [
  onboardingEntity(
    image: 'assets/images/onboarding_images/onboarding_image1.png',
    title: 'All Your Favourite',
    description:
        'Get all your loved foods in one ones place you just place the order we do the rest',
  
  ),
  onboardingEntity(
    image: 'assets/images/onboarding_images/onboarding_image2.png',
    title: 'Order from Chosen chef',
    description: 'Get all your loved foods in one ones place you just place the order we do the rest',
  ),
  onboardingEntity(
    image: 'assets/images/onboarding_images/onboarding_image3.png',
    title: 'Free delivery offers',
    description:
        'Get all your loved foods in one ones place you just place the order we do the rest',
  ),
];
