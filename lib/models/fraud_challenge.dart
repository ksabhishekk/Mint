class FraudChallenge {
  final String id;
  final String title;
  final String scenario;
  final String type;
  final List<String> redFlags;
  final String correctAction;
  final List<String> options;
  final int correctOptionIndex;
  final int pointsReward;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  FraudChallenge({
    required this.id,
    required this.title,
    required this.scenario,
    required this.type,
    required this.redFlags,
    required this.correctAction,
    required this.options,
    required this.correctOptionIndex,
    this.pointsReward = 50,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'scenario': scenario,
    'type': type,
    'redFlags': redFlags,
    'correctAction': correctAction,
    'options': options,
    'correctOptionIndex': correctOptionIndex,
    'pointsReward': pointsReward,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory FraudChallenge.fromJson(Map<String, dynamic> json) => FraudChallenge(
    id: json['id'] as String,
    title: json['title'] as String,
    scenario: json['scenario'] as String,
    type: json['type'] as String,
    redFlags: (json['redFlags'] as List<dynamic>).cast<String>(),
    correctAction: json['correctAction'] as String,
    options: (json['options'] as List<dynamic>).cast<String>(),
    correctOptionIndex: json['correctOptionIndex'] as int,
    pointsReward: json['pointsReward'] as int? ?? 50,
    isCompleted: json['isCompleted'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  FraudChallenge copyWith({
    String? id,
    String? title,
    String? scenario,
    String? type,
    List<String>? redFlags,
    String? correctAction,
    List<String>? options,
    int? correctOptionIndex,
    int? pointsReward,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FraudChallenge(
    id: id ?? this.id,
    title: title ?? this.title,
    scenario: scenario ?? this.scenario,
    type: type ?? this.type,
    redFlags: redFlags ?? this.redFlags,
    correctAction: correctAction ?? this.correctAction,
    options: options ?? this.options,
    correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
    pointsReward: pointsReward ?? this.pointsReward,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
