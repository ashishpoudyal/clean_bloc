import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/common/widgets/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignup>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUseLoggedIn>(_isUserLoggedIn);
  }

  void _isUserLoggedIn(AuthIsUseLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser({});
    res.fold(
      (l) {
        emit(AuthFailure(l.message));
      },
      (r) {
        _emitAuthSuccess(r, emit);
      },
    );
  }

  void _onAuthSignUp(AuthSignup event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userSignUp(UserSignUpParams(
        email: event.email, password: event.password, name: event.name));

    response.fold(
      (l) {
        emit(AuthFailure(l.message));
      },
      (r) {
        _emitAuthSuccess(r, emit);
      },
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final response = await _userLogin(
        UserLoginParams(email: event.email, password: event.password));

    response.fold(
      (l) {
        emit(AuthFailure(l.message));
      },
      (r) {
        _emitAuthSuccess(r, emit);
      },
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSucess(user));
  }
}
