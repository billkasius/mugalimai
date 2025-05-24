import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/education/presentation/pages/education_page.dart';
import '../../features/classes/presentation/pages/classes_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../shared/widgets/main_wrapper.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/';
  static const String education = '/education';
  static const String classes = '/classes';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final isLoggedIn = authState is AuthAuthenticated;
      final isLoggingIn = state.uri.toString() == login;

      // Если не авторизован и не на странице логина - перенаправляем на логин
      if (!isLoggedIn && !isLoggingIn) {
        return login;
      }

      // Если авторизован и на странице логина - перенаправляем на главную
      if (isLoggedIn && isLoggingIn) {
        return home;
      }

      return null; // Остаемся на текущей странице
    },
    routes: [
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainWrapper(child: child),
        routes: [
          GoRoute(
            path: home,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: education,
            builder: (context, state) => const EducationPage(),
          ),
          GoRoute(
            path: classes,
            builder: (context, state) => const ClassesPage(),
          ),
          GoRoute(
            path: settings,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}
