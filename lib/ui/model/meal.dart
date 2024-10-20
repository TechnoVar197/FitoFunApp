class Meal {
  final String mealTime, name, imagePath, kiloCaloriesBurnt, timeTaken;
  final String Description;
  final List Nutrients;

  Meal({required this.mealTime, required this.name, required this.imagePath, required this.kiloCaloriesBurnt, required this.timeTaken, required this.Description, required this.Nutrients});
}

final meals = [
  Meal(
      mealTime: "BREAKFAST",
      name: "Dosa",
      kiloCaloriesBurnt: "271",
      timeTaken: "10",
      imagePath: "assets/fruit_granola.jpg",
      Nutrients: [
        "Carbs 29 grams",
        "Protein 3.9 grams",
        "Fat 3.7 grams",
        "Fibre 0.9 grams",
        "Sodium 94 mg",
        "Potassium 76 mg",
        "Cholesterol 1 mg",
      ],
      Description:
          'Dosa is loaded with vitamins and minerals and is low in saturated fats. Moreover, it has a decent amount of protein and fibre as well. To get the goodness of more nutrients and keep your palate happy, you can easily pair up dosas with coconut chutneys and sambar.'),
  Meal(
      mealTime: "DINNER",
      name: "Roti with Curry",
      kiloCaloriesBurnt: "106",
      timeTaken: "15",
      imagePath: "assets/pesto_pasta.jpg",
      Nutrients: [
        "Carbs 22.3 grams (82%)",
        "Protein 3.8 grams (14%)",
        "Fat 0.5 grams (4%)",

      ],
      Description:
          '''Whole-wheat rotis are typically prepared out of dough kneaded from a mixture of whole-wheat flour, oil, and salt. The dough is then divided into portions, and each portion is rolled into a thin circle, which is cooked on a pan or open flame until it puffs up.
          Here is a table that indicates the number of roti calories in one medium-sized roti of 18 cms diameter
          '''),
  Meal(
      mealTime: "SNACK",
      name: "Fruit Bowl",
      kiloCaloriesBurnt: "414",
      timeTaken: "16",
      imagePath: "assets/keto_snack.jpg",
      Nutrients: [
        "33 g	pineapple",
        "30 g	bananas",
        "30.2 g	grape",
        "36 g	kiwi",
        "33.2 g	strawberries",
      ],
      Description:
          '''With the right quantity and type of fruits, a fruit salad can work wonders for you, for it will provide you with a power-packed dose of fibre, vitamins and antioxidants. At the same time, you will also get a wide range of health benefits, right from lower blood pressure levels to weight management.'''),
];
