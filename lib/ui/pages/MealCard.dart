import 'package:flutter/material.dart';
import '../model/meal.dart';


class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(right: 20, bottom: 50),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.asset(meal.imagePath, width: 80, fit: BoxFit.fill),
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 3),
                    Text(meal.mealTime, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.blueGrey)),
                    Text(meal.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black)),
                    Text("${meal.kiloCaloriesBurnt} kcal", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.blueGrey)),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.access_time, size: 15, color: Colors.black12),
                        const SizedBox(width: 8),
                        Text("${meal.timeTaken} min", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Colors.blueGrey)),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
