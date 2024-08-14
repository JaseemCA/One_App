import 'package:equatable/equatable.dart';
import 'package:oneappcounter/entity/login_response_entity.dart';


class LoginResponse extends Equatable {
  final String accessToken;
  final dynamic user;
  final dynamic branch;
  final dynamic systemBranch;

  const LoginResponse(
      this.accessToken, this.user, this.branch, this.systemBranch);

  @override
  List<Object?> get props => [accessToken, user, branch, systemBranch];

  static LoginResponse fromEntity(LoginResponseEntity entity) {
    return LoginResponse(
      entity.accessToken,
      entity.user,
      entity.branch,
      entity.systemBranch,
    );
  }

  // @override
  // String toString() {
  //
  //   return 'Login Response: access token: $accessToken, user :$user,branch: $branch, system branch: $systemBranch';
  // }

  Map<String, Object> toJson() {
    return {
      'access_token': accessToken,
      'user': user,
      'branch': branch,
      'system_branch': systemBranch
    };
  }

  static LoginResponse fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      json['access_token'] as String,
      json['user'],
      json['branch'],
      json['system_branch'],
    );
  }
}
