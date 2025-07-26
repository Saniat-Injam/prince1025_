/// FAQ Category model
/// Represents a category of FAQs
class FAQCategory {
  final String id;
  final String name;
  final String createdAt;
  final String updatedAt;

  const FAQCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create FAQCategory from JSON response
  factory FAQCategory.fromJson(Map<String, dynamic> json) {
    return FAQCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  /// Convert FAQCategory to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'FAQCategory{id: $id, name: $name}';
  }
}

/// FAQ Item model
/// Represents a single FAQ with question, answer, and category
class FAQItem {
  final String id;
  final String question;
  final String answer;
  final String categoryId;
  final String createdAt;
  final String updatedAt;
  final FAQCategory category;

  const FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  /// Create FAQItem from JSON response
  factory FAQItem.fromJson(Map<String, dynamic> json) {
    return FAQItem(
      id: json['id'] ?? '',
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
      categoryId: json['categoryId'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      category: FAQCategory.fromJson(json['category'] ?? {}),
    );
  }

  /// Convert FAQItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'categoryId': categoryId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'category': category.toJson(),
    };
  }

  @override
  String toString() {
    return 'FAQItem{id: $id, question: $question, category: ${category.name}}';
  }
}
