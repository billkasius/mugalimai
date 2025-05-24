// lib/features/settings/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animate_do/animate_do.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../shared/localization/generated/l10n.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!; // Используем ваш класс

    // Остальной код остается тем же...


    return Scaffold(
        body: CustomScrollView(
        slivers: [
        // Красивый AppBar
        SliverAppBar(
        expandedHeight: 200,
        floating: false,
        pinned: true,
        backgroundColor: Colors.deepPurple,
        flexibleSpace: FlexibleSpaceBar(
        title: Text(
        l10n.settings,
        style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
    ),
    ),
    background: Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
    Colors.deepPurple,
    Colors.purple,
    Colors.purpleAccent,
    ],
    ),
    ),
    child: Stack(
    children: [
    // Декоративные элементы
    Positioned(
    top: 50,
    right: -30,
    child: Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white.withOpacity(0.1),
    ),
    ),
    ),
    Positioned(
    bottom: -20,
    left: -20,
    child: Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: Colors.white.withOpacity(0.1),
    ),
    ),
    ),
    // Иконка настроек
    const Positioned(
    bottom: 60,
    left: 20,
    child: Icon(
    Icons.settings,
    size: 60,
    color: Colors.white24,
    ),
    ),
    ],
    ),
    ),
    ),
    ),

          // Контент
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),

                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    if (state is SettingsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is SettingsLoaded) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Основные настройки
                          FadeInDown(
                            child: _buildSectionTitle(context, l10n.language),
                          ),

                          const SizedBox(height: 16),

                          // Язык
                          FadeInLeft(
                            delay: const Duration(milliseconds: 100),
                            child: _buildLanguageCard(context, l10n, state),
                          ),

                          const SizedBox(height: 12),

                          // Тема
                          FadeInRight(
                            delay: const Duration(milliseconds: 200),
                            child: _buildThemeCard(context, l10n, state),
                          ),

                          const SizedBox(height: 24),

                          // Уведомления
                          FadeInDown(
                            delay: const Duration(milliseconds: 300),
                            child: _buildSectionTitle(context, 'Уведомления'),
                          ),

                          const SizedBox(height: 16),

                          // Настройки уведомлений
                          FadeInLeft(
                            delay: const Duration(milliseconds: 400),
                            child: _buildNotificationsCard(context, l10n, state),
                          ),

                          const SizedBox(height: 24),

                          // О приложении
                          FadeInDown(
                            delay: const Duration(milliseconds: 500),
                            child: _buildSectionTitle(context, 'О приложении'),
                          ),

                          const SizedBox(height: 16),

                          // Информация о приложении
                          FadeInUp(
                            delay: const Duration(milliseconds: 600),
                            child: _buildAppInfoCard(context, l10n),
                          ),

                          const SizedBox(height: 12),

                          // Дополнительные опции
                          FadeInUp(
                            delay: const Duration(milliseconds: 700),
                            child: _buildAdditionalOptionsCard(context, l10n),
                          ),

                          const SizedBox(height: 20),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ]),
            ),
          ),
        ],
        ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple[800],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, S l10n, SettingsLoaded state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.language, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.language,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    l10n.russian,
                    'ru',
                    Icons.flag,
                    Colors.red,
                    state.locale.languageCode == 'ru',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    l10n.kyrgyz,
                    'ky',
                    Icons.flag,
                    Colors.blue,
                    state.locale.languageCode == 'ky',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildLanguageOption(
                    context,
                    l10n.english,
                    'en',
                    Icons.flag,
                    Colors.green,
                    state.locale.languageCode == 'en',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context,
      String title,
      String languageCode,
      IconData icon,
      Color color,
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () {
        context.read<SettingsBloc>().add(ChangeLanguage(Locale(languageCode)));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCard(BuildContext context, S l10n, SettingsLoaded state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.palette, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.theme,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildThemeOption(
                    context,
                    l10n.lightTheme,
                    Icons.light_mode,
                    Colors.orange,
                    ThemeMode.light,
                    state.themeMode == ThemeMode.light,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    l10n.darkTheme,
                    Icons.dark_mode,
                    Colors.indigo,
                    ThemeMode.dark,
                    state.themeMode == ThemeMode.dark,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildThemeOption(
                    context,
                    'Системная',
                    Icons.settings_system_daydream,
                    Colors.purple,
                    ThemeMode.system,
                    state.themeMode == ThemeMode.system,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      ThemeMode themeMode,
      bool isSelected,
      ) {
    return GestureDetector(
      onTap: () {
        context.read<SettingsBloc>().add(ChangeTheme(themeMode));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? color : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard(BuildContext context, S l10n, SettingsLoaded state) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.notifications, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Text(
                  'Уведомления',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSwitchTile(
              context,
              'Включить уведомления',
              Icons.notifications_active,
              state.notificationsEnabled,
                  (value) {
                context.read<SettingsBloc>().add(ToggleNotifications(value));
              },
            ),
            const Divider(),
            _buildSwitchTile(
              context,
              'Звуковые уведомления',
              Icons.volume_up,
              state.soundNotifications,
                  (value) {
                context.read<SettingsBloc>().add(ToggleSoundNotifications(value));
              },
              enabled: state.notificationsEnabled,
            ),
            const Divider(),
            _buildSwitchTile(
              context,
              'Вибрация уведомлений',
              Icons.vibration,
              state.vibrationNotifications,
                  (value) {
                context.read<SettingsBloc>().add(ToggleVibrationNotifications(value));
              },
              enabled: state.notificationsEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      BuildContext context,
      String title,
      IconData icon,
      bool value,
      ValueChanged<bool> onChanged, {
        bool enabled = true,
      }) {
    return Row(
      children: [
        Icon(
          icon,
          color: enabled ? Colors.grey[700] : Colors.grey[400],
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: enabled ? Colors.grey[800] : Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
          activeColor: Colors.green,
        ),
      ],
    );
  }

  Widget _buildAppInfoCard(BuildContext context, S l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.info, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  'Информация о приложении',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Версия приложения', _packageInfo?.version ?? '1.0.0'),
            const SizedBox(height: 8),
            _buildInfoRow('Номер сборки', _packageInfo?.buildNumber ?? '1'),
            const SizedBox(height: 8),
            _buildInfoRow('Разработано', 'Командой MadNomad'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptionsCard(BuildContext context, S l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildOptionTile(
            context,
            'Связаться с поддержкой',
            Icons.support_agent,
            Colors.blue,
                () => _launchUrl('mailto:support@mugalimai.com'),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            'Оценить приложение',
            Icons.star_rate,
            Colors.orange,
                () => _showComingSoonDialog(context),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            'Поделиться приложением',
            Icons.share,
            Colors.green,
                () => _showComingSoonDialog(context),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            'Политика конфиденциальности',
            Icons.privacy_tip,
            Colors.purple,
                () => _showComingSoonDialog(context),
          ),
          const Divider(height: 1),
          _buildOptionTile(
            context,
            l10n.logout,
            Icons.logout,
            Colors.red,
                () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Скоро'),
        content: const Text('Эта функция будет доступна в следующем обновлении.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти'),
        content: const Text('Вы уверены, что хотите выйти из приложения?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Здесь добавить логику выхода
            },
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}


