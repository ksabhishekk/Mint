import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fire;
import 'package:mintworth/models/user.dart';

class UserService {
  // Fetch the current user's profile (from Firestore)
  Future<User> getCurrentUser() async {
    final uid = fire.FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    if (data != null) return User.fromJson(data);
    throw Exception('No user profile found in Firestore.');
  }

  // Save/update the current user's profile
  Future<void> saveUser(User user) async {
    final uid = fire.FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update(user.toJson());
  }

  // Add points to the user's profile
  Future<void> addPoints(int points) async {
    final user = await getCurrentUser();
    final updated = user.copyWith(
      totalPoints: user.totalPoints + points,
      updatedAt: DateTime.now(),
    );
    await saveUser(updated);
  }

  // Increment user's current streak
  Future<void> incrementStreak() async {
    final user = await getCurrentUser();
    final updated = user.copyWith(
      currentStreak: user.currentStreak + 1,
      updatedAt: DateTime.now(),
    );
    await saveUser(updated);
  }

  // Add achievement if not already present
  Future<void> addAchievement(String achievement) async {
    final user = await getCurrentUser();
    if (user.achievements.contains(achievement)) return;
    final updated = user.copyWith(
      achievements: [...user.achievements, achievement],
      updatedAt: DateTime.now(),
    );
    await saveUser(updated);
  }
}
