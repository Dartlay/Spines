class User {
  final String uid;
  final String? email;
  final String? displayName;
  final bool isEmailVerified;

  const User({
    required this.uid,
    this.email,
    this.displayName,
    this.isEmailVerified = false,
  });
}
