class UserReviewModel {
  final bool success;
  final List<Review> results;

  UserReviewModel({
    required this.success,
    required this.results,
  });

  factory UserReviewModel.fromJson(Map<String, dynamic> json) {
    return UserReviewModel(
      success: json['success'],
      results: (json['results'] as List)
          .map((review) => Review.fromJson(review))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'results': results.map((review) => review.toJson()).toList(),
    };
  }
}

class Review {
  final String id;
  final String user;
  final Doctor doctor;
  final int rating;
  final String comment;
  final String createdAt;
  final String updatedAt;
  final int version;

  Review({
    required this.id,
    required this.user,
    required this.doctor,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      user: json['user'],
      doctor: Doctor.fromJson(json['doctor']),
      rating: json['rating'],
      comment: json['comment'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'doctor': doctor.toJson(),
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
    };
  }
}

class Doctor {
  final String id;
  final String name;

  Doctor({
    required this.id,
    required this.name,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}