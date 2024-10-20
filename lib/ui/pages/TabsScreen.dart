import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'ProfileScreen.dart'; // Ensure this path is correct
import 'EditProfileScreen.dart'; // Ensure this path is correct
import 'CameraPage.dart'; // Ensure this path is correct

class TabsScreen extends StatefulWidget {
  final String name;
  final int totalCalories;

  TabsScreen({required this.name, required this.totalCalories});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPageIndex = 0;
  late String _name;
  late int _totalCalories;
  late String _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedPageIndex = _tabController.index;
      });
    });
    _name = widget.name;
    _totalCalories = widget.totalCalories;
    _profileImageUrl = ''; // Initialize with a default value or from widget if provided
  }

  void _updateProfileData(String name, int age, int caloriesLimit, String? imageUrl) {
    setState(() {
      _name = name;
      _totalCalories = caloriesLimit;
      _profileImageUrl = imageUrl ?? _profileImageUrl;
    });
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: TabBarView(
        controller: _tabController,
        children: [
          HomePage(name: _name, totalCalories: _totalCalories),
          Camera(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: "Camera",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
