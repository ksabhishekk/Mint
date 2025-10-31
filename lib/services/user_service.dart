import 'package:mintworth/models/user.dart';
import 'package:mintworth/services/local_storage_service.dart';

class UserService {
  static const String _key = 'user';

  Future<User> getCurrentUser() async {
    final json = LocalStorageService.getJson(_key);
    if (json != null) return User.fromJson(json);

    final newUser = User(
      id: 'user1',
      name: 'Sai Abhishek',
      email: 'ab@email.com',
      totalPoints: 450,
      currentStreak: 5,
      achievements: ['First Investment', 'Quiz Master'],
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );
    await saveUser(newUser);
    return newUser;
  }

  Future<void> saveUser(User user) async {
    await LocalStorageService.saveJson(_key, user.toJson());
  }

  Future<void> addPoints(int points) async {
    final user = await getCurrentUser();
    final updated = user.copyWith(
      totalPoints: user.totalPoints + points,
      updatedAt: DateTime.now(),
    );
    await saveUser(updated);
  }

  Future<void> incrementStreak() async {
    final user = await getCurrentUser();
    final updated = user.copyWith(
      currentStreak: user.currentStreak + 1,
      updatedAt: DateTime.now(),
    );
    await saveUser(updated);
  }

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
