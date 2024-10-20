import 'package:flutter/material.dart';

class IngredientProgress extends StatelessWidget {
  final String ingredient;
  final int leftAmount;
  final double progress, width;
  final Color progressColor;

  const IngredientProgress({
    Key? key,
    required this.ingredient,
    required this.leftAmount,
    required this.progress,
    required this.progressColor,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(ingredient.toUpperCase(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 10,
                  width: width,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Colors.black12),
                ),
                Container(
                  height: 10,
                  width: width * progress,
                  decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(5)), color: progressColor),
                )
              ],
            ),
            const SizedBox(width: 10),
            Text("${leftAmount}g left"),
          ],
        ),
      ],
    );
  }
}
