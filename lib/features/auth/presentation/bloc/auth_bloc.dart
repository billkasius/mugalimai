import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/user_model.dart';
import '../../../../injection_container.dart' as di;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SharedPreferences _prefs = di.sl<SharedPreferences>();

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    final isLoggedIn = _prefs.getBool(AppConstants.isLoggedInKey) ?? false;

    if (isLoggedIn) {
      // Создаем моковые данные пользователя для демо
      final user = UserModel(
        id: '1',
        firstName: 'Айбек',
        lastName: 'Сыдыков',
        email: 'aibek@school01.kg',
        schoolName: 'Школа-гимназия №1',
        schoolNumber: '01',
      );
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // Имитация задержки API
    await Future.delayed(const Duration(seconds: 2));

    // Простая валидация для демо
    if (event.email.isNotEmpty && event.password.isNotEmpty) {
      // Сохраняем статус авторизации
      await _prefs.setBool(AppConstants.isLoggedInKey, true);

      // Создаем моковые данные пользователя
      final user = UserModel(
        id: '1',
        firstName: 'Айбек',
        lastName: 'Сыдыков',
        email: event.email,
        schoolName: 'Школа-гимназия №1',
        schoolNumber: '01',
      );

      emit(AuthAuthenticated(user: user));
    } else {
      emit(const AuthError(message: 'Неверный email или пароль'));
    }
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    await _prefs.setBool(AppConstants.isLoggedInKey, false);
    emit(AuthUnauthenticated());
  }
}
