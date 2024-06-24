part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AuthSignup extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignup({required this.email, required this.password, required this.name});
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  AuthLogin({
    required this.email,
    required this.password,
  });
}
class AuthIsUseLoggedIn extends AuthEvent {
  
}
