part of 'auth_bloc.dart';

//@immutable
abstract class AuthState extends Equatable {
  const AuthState();
/* 
  @override
  List<Object> get props => []; */
}

class Loading extends AuthState {
  @override
  List<Object> get props => [];
}

class Authenticated extends AuthState {
  final Usuario? usuario;
  const Authenticated({required this.usuario});
  @override
  List<Object> get props => [usuario!];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);
  @override
  List<Object?> get props => [error];
}

class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}
