import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eventflutter/modelo/usuario.dart';
import 'package:eventflutter/services/auth_fireStore.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthFireStore authFireStore;
  late Usuario? usuario;
  AuthBloc({required this.authFireStore}) : super(UnAuthenticated()) {
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        usuario = await authFireStore.signIn(
            email: event.email, password: event.password);
        emit(Authenticated(usuario: usuario));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        usuario = await authFireStore.signUp(
            email: event.email,
            password: event.password,
            user: event.user,
            imagen: event.imgUsuario);
        emit(Authenticated(usuario: usuario));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<UpdateRequested>((event, emit) async {
      emit(Loading());
      try {
        emit(Authenticated(usuario: event.user));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<GoogleSignInRequested>((event, emit) async {
      emit(Loading());
      try {
        usuario = await authFireStore.signInWithGoogle();
        emit(Authenticated(usuario: usuario));
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      try {
        await authFireStore.signOut();
        emit(const Authenticated(usuario: null));
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<IniUnAuthenticated>((event, emit) async {
      emit(Loading());
      try {
        //emit(const Authenticated(usuario: null));
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
  }
}
