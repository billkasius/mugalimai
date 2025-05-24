import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/settings/presentation/bloc/settings_event.dart';
import '../features/settings/presentation/bloc/settings_state.dart';
import '../shared/localization/generated/l10n.dart';
import 'themes/app_theme.dart';
import 'routes/app_routes.dart';
import '../features/settings/presentation/bloc/settings_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsBloc()..add(LoadSettings()),
        ),
        BlocProvider(
          create: (context) => AuthBloc()..add(CheckAuthStatus()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Mugalim AI',
            debugShowCheckedModeBanner: false,

            // Localization
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            locale: state is SettingsLoaded ? state.locale : const Locale('ru'),

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state is SettingsLoaded ? state.themeMode : ThemeMode.light,

            // Routing
            routerConfig: AppRoutes.router,
          );
        },
      ),
    );
  }
}
