class User {
  final String id;
  final String name;
  final String email;
  final int totalPoints;
  final int currentStreak;
  final List<String> achievements;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.achievements = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'totalPoints': totalPoints,
    'currentStreak': currentStreak,
    'achievements': achievements,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    totalPoints: json['totalPoints'] as int? ?? 0,
    currentStreak: json['currentStreak'] as int? ?? 0,
    achievements: (json['achievements'] as List<dynamic>?)?.cast<String>() ?? [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  User copyWith({
    String? id,
    String? name,
    String? email,
    int? totalPoints,
    int? currentStreak,
    List<String>? achievements,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    totalPoints: totalPoints ?? this.totalPoints,
    currentStreak: currentStreak ?? this.currentStreak,
    achievements: achievements ?? this.achievements,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
