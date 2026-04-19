class UserProfile {
  final String uid;
  final String? email;
  final String? name;
  final bool isPremium;

  UserProfile({
    required this.uid,
    this.email,
    this.name,
    required this.isPremium,
  });

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'name': name,
        'isPremium': isPremium,
      };

  static UserProfile fromMap(Map<String, dynamic> map) => UserProfile(
        uid: map['uid'] as String,
        email: map['email'] as String?,
        name: map['name'] as String?,
        isPremium: (map['isPremium'] as bool?) ?? false,
      );
}
