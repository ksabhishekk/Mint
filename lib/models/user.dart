import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String profileNo;
  final int totalPoints;
  final int currentStreak;
  final List<String> achievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileNo,
    required this.totalPoints,
    required this.currentStreak,
    required this.achievements,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json, [String? uid]) {
    return User(
      id: uid ?? json['id'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      profileNo: json['profileNo'] ?? "",
      totalPoints: json['totalPoints'] ?? 0,
      currentStreak: json['currentStreak'] ?? 0,
      achievements: (json['achievements'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      createdAt: (json['createdAt'] is Timestamp)
        ? (json['createdAt'] as Timestamp).toDate()
        : DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: (json['updatedAt'] is Timestamp)
        ? (json['updatedAt'] as Timestamp).toDate()
        : DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'profileNo': profileNo,
    'totalPoints': totalPoints,
    'currentStreak': currentStreak,
    'achievements': achievements,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  User copyWith({
    String? name,
    String? email,
    String? profileNo,
    int? totalPoints,
    int? currentStreak,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileNo: profileNo ?? this.profileNo,
      totalPoints: totalPoints ?? this.totalPoints,
      currentStreak: currentStreak ?? this.currentStreak,
      achievements: achievements ?? this.achievements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
