import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_avatar.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/');
        }
      },
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.go('/home'),
            ),
            title: const Text('Profil', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Avatar Header
                Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.neonGreen, width: 3),
                          ),
                          child: AppAvatar(name: user?.name ?? 'User', size: 100, bg: Colors.transparent),
                        ),
                        Positioned(
                          bottom: -10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.neonGreen,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('PRO', style: TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(user?.name ?? 'Pengguna', style: const TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(user?.email ?? '', style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: Colors.white54)),
                  ],
                ),
                const SizedBox(height: 32),
                
                // General Settings
                _buildSectionTitle('Pengaturan'),
                _buildSettingsCard(
                  children: [
                    _Row(icon: Icons.person_outline, title: 'Informasi Pribadi', onTap: () => context.go('/akun/personal-info')),
                    _Row(icon: Icons.account_balance_wallet_outlined, title: 'Kartu Tersimpan', onTap: () => context.go('/akun/saved-cards')),
                    _Row(icon: Icons.verified_user_outlined, title: 'Keamanan (2FA)', right: const Text('Aktif', style: TextStyle(color: AppColors.neonGreen, fontSize: 12)), onTap: () => context.go('/setup-2fa')),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Preferences
                _buildSectionTitle('Preferensi'),
                _buildSettingsCard(
                  children: [
                    _Row(icon: Icons.notifications_none, title: 'Notifikasi', right: _Toggle(), onTap: () {}),
                    _Row(icon: Icons.dark_mode_outlined, title: 'Mode Gelap', right: _Toggle(), onTap: () {}),
                    _Row(icon: Icons.language, title: 'Bahasa', right: const Text('ID', style: TextStyle(color: Colors.white54, fontSize: 12)), onTap: () {}),
                  ],
                ),
                const SizedBox(height: 32),

                // Logout Button
                GestureDetector(
                  onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.red.withOpacity(0.3)),
                    ),
                    child: const Center(
                      child: Text('Keluar', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.red)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(child: Text('Danantara · v1.0.0', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: Colors.white54))),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white54)),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    List<Widget> separatedChildren = [];
    for (int i = 0; i < children.length; i++) {
      separatedChildren.add(children[i]);
      if (i < children.length - 1) {
        separatedChildren.add(const Divider(height: 1, color: Colors.white12, indent: 56));
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(children: separatedChildren),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Widget? right;

  const _Row({required this.icon, required this.title, required this.onTap, this.right});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: const TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
            right ?? const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatefulWidget {
  @override
  State<_Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<_Toggle> {
  bool _on = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _on = !_on),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          color: _on ? AppColors.neonGreen : Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(2),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
