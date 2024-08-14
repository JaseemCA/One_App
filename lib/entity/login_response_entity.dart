import 'package:equatable/equatable.dart';

class LoginResponseEntity extends Equatable {
  final String accessToken;
  final dynamic user;
  final dynamic branch;
  final dynamic systemBranch;

  const LoginResponseEntity(
      this.accessToken, this.user, this.branch, this.systemBranch);

  @override
  List<Object?> get props => [accessToken, user, branch, systemBranch];

  static LoginResponseEntity fromJson(Map<String, dynamic> json) {
    return LoginResponseEntity(
      json['access_token'] as String,
      json['user'],
      json['branch'],
      json['system_branch'],
    );
  }

  Map<String, Object> toJson() {
    return {
      'accessToken': accessToken,
      'user': user,
      'branch': branch,
      'system_branch': systemBranch
    };
  }
}
