class Contents {
  static List<Map<String, dynamic>> menuItems = [
    {"product": "Takoyaki", "image": 'images/takoyaki.jpg'},
    {"product": "Burgers", "image": 'images/burgers.jpg'},
    {"product": "Fries", "image": 'images/fries.jpg'},
    {"product": "Milktea", "image": 'images/milktea.jpg'},
    {"product": "Fried Noodles", "image": 'images/friednoodles.jpg'},
    {"product": "Hotdog", "image": 'images/hotdog.jpg'},
  ];

  static List<Map<String, dynamic>> takoyakiMenu = [
    {
      "product": "Takoyaki Vegetable",
      "product_id": "1",
      "image": "images/takoyaki_cartoon .jpg",
      "price": 30,
      "prices": {"4": 30 * 1, "8": 30 * 2, "12": 30 * 3},
    },
    {
      "product": "Takoyaki Cheese",
      "product_id": "2",
      "image": "images/takoyaki_cartoon .jpg",
      "price": 35,
      "prices": {"4": 35 * 1, "8": 35 * 2, "12": 35 * 3},
    },
    {
      "product": "Takoyaki Ham and Cheese",
      "product_id": "3",
      "image": "images/takoyaki_cartoon .jpg",
      "price": 45,
      "prices": {"4": 45 * 1, "8": 45 * 2, "12": 45 * 3},
    },
    {
      "product": "Takoyaki Bacon and Cheese",
      "product_id": "4",
      "image": "images/takoyaki_cartoon .jpg",
      "price": 45,
      "prices": {"4": 45 * 1, "8": 45 * 2, "12": 45 * 3},
    },
    {
      "product": "Takoyaki Double Cheese",
      "product_id": "5",
      "image": "images/takoyaki_cartoon .jpg",
      "price": 40,
      "prices": {"4": 40 * 1, "8": 40 * 2, "12": 40 * 3},
    },
    {
      "product": "Takoyaki Crab",
      "product_id": "6",
      "image": "images/takoyaki_cartoon .jpg",
      "price": 50,
      "prices": {"4": 50 * 1, "8": 50 * 2, "12": 50 * 3},
    },
    {
      "product": "Takoyaki Octopus",
      "product_id": "7",
      "image": "images/takoyaki_cartoon .jpg",
      "price": 60,
      "prices": {"4": 60 * 1, "8": 60 * 2, "12": 60 * 3},
    },
    {
      "product": "Takoyaki Shawarma",
      "product_id": "8",
      "image": "images/takoyaki_cartoon .jpg",
      "price": 45,
      "prices": {"4": 45 * 1, "8": 45 * 2, "12": 45 * 3},
    },
  ];
  static List takoyakiOrderQty = [
    {"qty": "4"},
    {"qty": "8"},
    {"qty": "12"},
  ];
}
