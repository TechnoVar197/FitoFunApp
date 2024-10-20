import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Corrected here

  Future<Map<String, dynamic>?> fetchUserInfo() async {
    User? user = _auth.currentUser;
    if (user == null) {
      print("No user logged in");
      return null;
    }

    try {
      DocumentSnapshot userInfo = await _firestore.collection('users').doc(user.uid).get();
      if (userInfo.exists) {
        return userInfo.data() as Map<String, dynamic>?;
      } else {
        print("User document does not exist");
        return null;
      }
    } catch (e) {
      print("Error fetching user info: $e");
      return null;
    }
  }

  Future<void> updateUserInfo(String name, int age, int caloriesLimit, String? imageUrl) async {
    User? user = _auth.currentUser;
    if (user == null) {
      print("No user logged in");
      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'age': age,
        'caloriesLimit': caloriesLimit,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print("Error updating user info: $e");
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
