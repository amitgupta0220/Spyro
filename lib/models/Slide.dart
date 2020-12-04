class Slide {
  String title;
  String description;
  String imagePath;
  Slide({this.title, this.description, this.imagePath});

  static List<Slide> slides = [
    Slide(
        title: 'Hyper Local',
        description: 'Now All Your Local Stores\n Are At Your Fingertips.',
        imagePath: 'assets/images/pageone.png'),
    Slide(
        title: 'Quick Bites',
        description: 'Search And Find Your Favourite\n Street Food Vendor',
        imagePath: 'assets/images/pagetwo.png'),
    Slide(
        title: 'Get Rewarded',
        description: 'Add Your Local Stores And\n Earn Reward Points',
        imagePath: 'assets/images/pagethree.png'),
    Slide(
        title: 'Chat',
        description: 'Make Friends, Create Groups\n And Connect With Seller',
        imagePath: 'assets/images/pagefour.png')
  ];
}
