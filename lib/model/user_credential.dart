class UserCredential {
  final String email;
  final String password;
  UserCredential({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}