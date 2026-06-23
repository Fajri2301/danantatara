import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_avatar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hideBalance = false;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(AccountLoadRequested());
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;
        final fullName = user?.name ?? 'User';

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, accountState) {
              final balance = accountState is AccountLoaded ? accountState.account.balance : 0.0;
              final txns = accountState is AccountLoaded ? accountState.transactions : <TransactionEntity>[];
              
              return RefreshIndicator(
                onRefresh: () async => context.read<AccountBloc>().add(AccountRefreshRequested()),
                color: AppColors.bg,
                backgroundColor: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Massive Green Container
                      Container(
                        padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 16, 20, 24),
                        decoration: const BoxDecoration(
                          color: Color(0xFFAACF31), // Darker green from user
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildHeader(fullName),
                            const SizedBox(height: 24),
                            _buildBalanceCard(balance, context),
                            const SizedBox(height: 8),
                            // Downward indicator tab
                            Container(
                              width: 40,
                              height: 6,
                              decoration: BoxDecoration(
                                color: AppColors.bg.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Bottom Dark Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPPOBGrid(),
                            const SizedBox(height: 4), // Extremely tight gap as requested
                            _buildVirtualCard(fullName),
                            const SizedBox(height: 16),
                            _buildRecentTransactions(txns),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(String fullName) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bg, width: 2), // Changed to dark border
              ),
              child: AppAvatar(name: fullName, size: 32, bg: Colors.transparent),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.bg, // Dark verified badge
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified, size: 10, color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(fullName, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black)),
              const Text('@danantara_user', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.black54)),
            ],
          ),
        ),
        _buildIconBtn(Icons.emoji_events),
        const SizedBox(width: 8),
        _buildIconBtn(Icons.notifications),
      ],
    );
  }

  Widget _buildIconBtn(IconData icon) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8), // Dark icons on green background
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: AppColors.primary, size: 16),
    );
  }

  Widget _buildBalanceCard(double balance, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDFF26E), // Lighter green for balance card
        borderRadius: BorderRadius.circular(24), // Rounder to match dribbble
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Saldo', style: TextStyle(fontFamily: 'Inter', fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.more_horiz, color: Colors.black, size: 18),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(_hideBalance ? CurrencyFormatter.maskBalance() : CurrencyFormatter.format(balance),
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black, letterSpacing: -1)),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _hideBalance = !_hideBalance),
                child: Icon(_hideBalance ? Icons.visibility_off : Icons.visibility, color: Colors.black54, size: 18),
              )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_upward, color: Colors.green, size: 12),
                SizedBox(width: 4),
                Text('24%', style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(width: 6),
                Text('Minggu lalu', style: TextStyle(fontFamily: 'Inter', fontSize: 9, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildQuickActions(context), // Quick actions moved inside
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.arrow_outward, 'label': 'Kirim', 'route': '/transfer'},
      {'icon': Icons.call_received, 'label': 'Minta', 'route': '/topup'},
      {'icon': Icons.qr_code_scanner, 'label': 'Bayar', 'route': '/payment'},
      {'icon': Icons.account_balance_wallet, 'label': 'Tarik', 'route': '/topup'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) {
        return Column(
          children: [
            GestureDetector(
              onTap: () => context.go(a['route'] as String),
              child: Container(
                width: 44, // Slightly smaller since it is nested
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85), // Dark buttons on green background
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(a['icon'] as IconData, color: const Color(0xFFDFF26E), size: 20),
              ),
            ),
            const SizedBox(height: 6),
            Text(a['label'] as String, style: const TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        );
      }).toList(),
    );
  }

  // Removed _buildFavouriteContacts() as requested

  Widget _buildPPOBGrid() {
    final actions = [
      {'icon': Icons.phone_android, 'label': 'Pulsa'},
      {'icon': Icons.bolt, 'label': 'PLN'},
      {'icon': Icons.water_drop, 'label': 'PDAM'},
      {'icon': Icons.health_and_safety, 'label': 'BPJS'},
      {'icon': Icons.wifi, 'label': 'Internet'},
      {'icon': Icons.tv, 'label': 'TV Kabel'},
      {'icon': Icons.train, 'label': 'Tiket'},
      {'icon': Icons.more_horiz, 'label': 'Lainnya'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Pembayaran', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)), // Improved contrast
            GestureDetector(
              onTap: () {},
              child: const Text('Lihat Semua', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Color(0xFFDFF26E))),
            ),
          ],
        ),
        const SizedBox(height: 12), // Reduced spacing from 16 to 12
        GridView.builder(
          padding: EdgeInsets.zero, // Remove implicit GridView padding
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final p = actions[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDFF26E).withOpacity(0.12), // Slightly more visible background
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(p['icon'] as IconData, color: const Color(0xFFDFF26E), size: 20),
                ),
                const SizedBox(height: 6),
                Text(p['label'] as String, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.w500, color: Colors.white70), maxLines: 1, overflow: TextOverflow.ellipsis), // White text for better contrast
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildVirtualCard(String name) {
    return Container(
      width: double.infinity,
      height: 170, // Taller to match credit card aspect ratio
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2B2B2B), // Deep obsidian
            Color(0xFF111111),
            Color(0xFF050505),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(0, 16),
            blurRadius: 30,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header: Logo & NFC
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mock Brand Logo
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-8, 0),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              // NFC Icon
              Transform.rotate(
                angle: 1.5708, // 90 degrees
                child: Icon(Icons.wifi, color: Colors.white.withOpacity(0.4), size: 20),
              ),
            ],
          ),
          
          // Chip & Card Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Golden Chip
              Container(
                width: 34,
                height: 26,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE0C879), Color(0xFFA67C00)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black38, width: 1),
                ),
                child: Center(
                  child: Container(
                    width: 18,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              Text(
                'WORLD ELITE',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.0,
                  color: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),

          // Card Numbers (Embossed)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              '4123',
              '8901',
              '2345',
              '2026'
            ].map((num) => Text(
              num,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 18, // Reduced from 24 to fix overflow
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5, // Reduced from 2.0
                color: Color(0xFFD1D1D1),
                shadows: [
                  Shadow(color: Colors.white24, offset: Offset(1, 1), blurRadius: 1),
                  Shadow(color: Colors.black87, offset: Offset(-1, -1), blurRadius: 1),
                ],
              ),
            )).toList(),
          ),

          // Footer: Cardholder & Valid Thru
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARDHOLDER',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Color(0xFFD1D1D1),
                      shadows: [
                        Shadow(color: Colors.white24, offset: Offset(1, 1), blurRadius: 1),
                        Shadow(color: Colors.black87, offset: Offset(-1, -1), blurRadius: 1),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VALID THRU',
                    style: TextStyle(
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '12/30',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Color(0xFFD1D1D1),
                      shadows: [
                        Shadow(color: Colors.white24, offset: Offset(1, 1), blurRadius: 1),
                        Shadow(color: Colors.black87, offset: Offset(-1, -1), blurRadius: 1),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(List<TransactionEntity> txns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Transaksi Terakhir', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)), // Improved contrast
            GestureDetector(
              onTap: () => context.go('/history'),
              child: const Text('Lihat Semua', style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Color(0xFFDFF26E))), // Match "Lihat Semua" styling
            ),
          ],
        ),
        const SizedBox(height: 16),
        txns.isEmpty
            ? const Center(child: Text('Belum ada transaksi', style: TextStyle(color: AppColors.slate500)))
            : Column(
                children: txns.take(4).map((txn) {
                  final isIncome = txn.isCredit;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3), // Darker transparent card
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(10)),
                          child: Icon(isIncome ? Icons.arrow_downward : Icons.arrow_upward, size: 18, color: isIncome ? const Color(0xFFDFF26E) : Colors.redAccent),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(txn.description, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                              const SizedBox(height: 2),
                              Text('Trx ID: ${txn.id.toString()}', style: const TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.white54)),
                            ],
                          ),
                        ),
                        Text('${isIncome ? '+' : '-'}${CurrencyFormatter.format(txn.amount.abs())}', 
                          style: TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.bold, color: isIncome ? const Color(0xFFDFF26E) : Colors.redAccent)),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

}
