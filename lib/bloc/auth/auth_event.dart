part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  //const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final Usuario user;
  final File? imgUsuario;
  SignUpRequested(this.email, this.password, this.user, this.imgUsuario);
}

class UpdateRequested extends AuthEvent {
  final Usuario user;
  UpdateRequested(this.user);
}

class GoogleSignInRequested extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class IniUnAuthenticated extends AuthEvent {}
