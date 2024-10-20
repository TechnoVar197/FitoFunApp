  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:diet/ui/pages/meal_detail_screen.dart';
  import 'package:animations/animations.dart';
  import 'dart:math' as math;
  import '../model/meal.dart';
  import 'package:diet/ui/pages/ProfileScreen.dart';

  class HomePage extends StatelessWidget {
    final String name;
    final int totalCalories;
    final String? profileImageUrl; // Optional: might be null if not provided or not yet set

    const HomePage({
      Key? key,
      required this.name,
      required this.totalCalories,
      this.profileImageUrl, // This can be null, hence it's not required
    }) : super(key: key);
    @override
    Widget build(BuildContext context) {
      final height = MediaQuery.of(context).size.height;
      final width = MediaQuery.of(context).size.width;
      final today = DateTime.now();

      return Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              height: height * 0.35,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      top: 40, left: 32, right: 16, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "${DateFormat("EEEE").format(today)}, ${DateFormat("d MMMM").format(today)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                        subtitle: Text(
                          "Hello, $name",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        trailing: ClipOval(child: Image.asset("assets/user.png")),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: <Widget>[
                          _RadialProgress(
                            width: width * 0.4,
                            height: width * 0.4,
                            progress: totalCalories / 2500, // Assuming 2500 as the total calorie goal
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _IngredientProgress(
                                ingredient: "Protein",
                                progress: 0.3,
                                progressColor: Colors.green,
                                leftAmount: 72,
                                width: width * 0.28,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              _IngredientProgress(
                                ingredient: "Carbs",
                                progress: 0.2,
                                progressColor: Colors.red,
                                leftAmount: 252,
                                width: width * 0.28,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              _IngredientProgress(
                                ingredient: "Fat",
                                progress: 0.1,
                                progressColor: Colors.yellow,
                                leftAmount: 61,
                                width: width * 0.28,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: height * 0.38,
              left: 0,
              right: 0,
              child: SizedBox(
                height: height * 0.50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 8,
                        left: 32,
                        right: 16,
                      ),
                      child: Text(
                        "MEALS FOR TODAY",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 32,
                            ),
                            // Assuming meals is a list of Meal objects
                            for (int i = 0; i < meals.length; i++)
                              _MealCard(
                                meal: meals[i],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  class _IngredientProgress extends StatelessWidget {
    final String ingredient;
    final int leftAmount;
    final double progress, width;
    final Color progressColor;

    const _IngredientProgress({
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
          Text(
            ingredient.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 10,
                    width: width,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.black12,
                    ),
                  ),
                  Container(
                    height: 10,
                    width: width * progress,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      color: progressColor,
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Text("${leftAmount}g left"),
            ],
          ),
        ],
      );
    }
  }

  class _RadialProgress extends StatelessWidget {
    final double height, width, progress;

    const _RadialProgress({
      Key? key,
      required this.height,
      required this.width,
      required this.progress,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return CustomPaint(
        painter: _RadialPainter(
          progress: progress,
        ),
        child: SizedBox(
          height: height,
          width: width,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${(2500 - (progress * 2500).round()).toString()}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF200087),
                    ),
                  ),
                  TextSpan(text: "\n"),
                  TextSpan(
                    text: "kcal left",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF200087),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  class _RadialPainter extends CustomPainter {
    final double progress;

    _RadialPainter({required this.progress});

    @override
    void paint(Canvas canvas, Size size) {
      Paint paint = Paint()
        ..strokeWidth = 10
        ..color = const Color(0xFF200087)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      Offset center = Offset(size.width / 2, size.height / 2);
      double relativeProgress = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        -90 * math.pi / 180, // Convert -90 degrees to radians
        -relativeProgress,
        false,
        paint,
      );
    }

    @override
    bool shouldRepaint(CustomPainter oldDelegate) {
      return true;
    }
  }

  class _MealCard extends StatelessWidget {
    final Meal meal;

    const _MealCard({Key? key, required this.meal}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(
          right: 20,
          bottom: 10,
        ),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: OpenContainer(
                  closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  transitionDuration: const Duration(milliseconds: 1000),
                  openBuilder: (context, _) {
                    return MealDetailScreen(
                      meal: meal,
                    );
                  },
                  closedBuilder: (context, openContainer) {
                    return GestureDetector(
                      onTap: openContainer,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        child: Image.asset(
                          meal.imagePath,
                          width: 150,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
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
                      const SizedBox(height: 5),
                      Text(
                        meal.mealTime,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "${meal.kiloCaloriesBurnt} kcal",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Icon(
                            Icons.access_time,
                            size: 15,
                            color: Colors.black12,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${meal.timeTaken} min",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
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

  class HomeScreen extends StatelessWidget {
    final String name;
    final int age;
    final int caloriesLimit;
    final String profileImageUrl;

    HomeScreen({
      required this.name,
      required this.age,
      required this.caloriesLimit,
      required this.profileImageUrl,
    });

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome, $name!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Age: $age',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Calories Limit: $caloriesLimit',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      );
    }
  }