class Categories {
  static List<List<String>> categoriesList = [
    [
      'Street Food',
      'https://eatyourworld.com/blog/wp-content/uploads/2019/12/vada-pav-vendor-mumbai.jpg'
    ],
    [
      'Hardware Shop',
      'https://c8.alamy.com/comp/PG8A4X/product-display-in-a-hardware-store-PG8A4X.jpg'
    ],
    [
      'Pets',
      'https://www.crn.com/resources/025c-0f3247198c32-7caef631a12d-1000/pets.jpg'
    ],
    [
      'Only Vegan','https://www.heartfoundation.org.nz/images/nutrition/page-heros/plant-based-diet.jpg'
    ],
    [
      'Home Garden',
      'https://www.gardeners.com/on/demandware.static/-/Library-Sites-SharedLibrary/default/dweb66681a/Articles/Gardening/Hero_Thumbnail/8569-victory-garden.jpg'
    ],
    [
      'Local Stores',
      'https://i.pinimg.com/originals/19/d4/f2/19d4f21e99d16a12f17ac7e79e18b226.jpg'
    ],
    [
      'Find Mechanic',
      'https://www.cashcarsbuyer.com/wp-content/uploads/2020/04/Ask-A-Mechanic.jpg'
    ]
  ];

  static Map<String, List<String>> subCategoriesList = {
    'Street Food': [
      'Vadapav',
      'South Indian',
      'Chat',
      'Sandwich',
      'Chinese',
      'North Indian',
      'Tea Corner',
      'Others'
    ],
    'Hardware Shop': [
      'Electrical',
      'Plumbing',
      'Glass',
      'Lighting',
      'Electronics',
      'Others'
    ],
    'Pets': ['Pet Cafe', 'Pet Clinic', 'Pet Salon', 'Aquariums', 'Others'],
    'Only Vegan': ['Stores', 'Food Outlets', 'Others'],
    'Home Garden': [
      'Pots',
      'Plants',
      'Manure',
      'Gardening Acessories',
      'Others'
    ],
    'Find Mechanic': ['Car', 'Scooter/MotorCycle', 'Three Wheeler'],
    'Local Stores': [
      'Grocery',
      'Opticians',
      'Imitation Jewellery',
      'Mobile Shops',
      'Home Appliances',
      'Pooja Accessories',
      'General Stores',
      'Toy Stores',
      'Cycle Shops',
      'Medical',
      'Others'
    ]
  };
}
