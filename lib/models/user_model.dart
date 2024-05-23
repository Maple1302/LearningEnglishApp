class UserModel {
  final String uid;
  final String? email;
  final String completedLessons;
  final String progress; 
  final String? username;
  final String streak;
  final String language;
  final String heart;
  final String gem;

  UserModel({
    required this.uid,
    this.email,
    required this.completedLessons,
    required this.progress,
    required this.username,
    required this.streak,
    required this.language,
    required this.heart,
    required this.gem,
  });

  // Phương thức để chuyển đối tượng thành Map (JSON)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'completedLessons': completedLessons,
      'progress': progress,
      'username': username,
      'streak': streak,
      'language': language,
      'heart': heart,
      'gem': gem,
    };
  }

  // Phương thức để tạo đối tượng từ Map (JSON)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      completedLessons: map['completedLessons'],
      progress: map['progress'],
      username: map['username'],
      streak: map['streak'],
      language: map['language'],
      heart: map['heart'],
      gem: map['gem'],
    );
  }
}


