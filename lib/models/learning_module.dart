class LearningModule {
  final String id;
  final String title;
  final String description;
  final String category;
  final String content;
  final int pointsReward;
  final bool isCompleted;
  final List<QuizQuestion> quiz;
  final DateTime createdAt;
  final DateTime updatedAt;

  LearningModule({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.content,
    this.pointsReward = 100,
    this.isCompleted = false,
    this.quiz = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'content': content,
    'pointsReward': pointsReward,
    'isCompleted': isCompleted,
    'quiz': quiz.map((q) => q.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory LearningModule.fromJson(Map<String, dynamic> json) => LearningModule(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    category: json['category'] as String,
    content: json['content'] as String,
    pointsReward: json['pointsReward'] as int? ?? 100,
    isCompleted: json['isCompleted'] as bool? ?? false,
    quiz: (json['quiz'] as List<dynamic>?)
      ?.map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
      .toList() ?? [],
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  LearningModule copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? content,
    int? pointsReward,
    bool? isCompleted,
    List<QuizQuestion>? quiz,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => LearningModule(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    content: content ?? this.content,
    pointsReward: pointsReward ?? this.pointsReward,
    isCompleted: isCompleted ?? this.isCompleted,
    quiz: quiz ?? this.quiz,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctAnswerIndex': correctAnswerIndex,
  };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    question: json['question'] as String,
    options: (json['options'] as List<dynamic>).cast<String>(),
    correctAnswerIndex: json['correctAnswerIndex'] as int,
  );
}
