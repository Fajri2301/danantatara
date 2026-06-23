import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/app_avatar.dart';

const _contacts = [
  {'id': '1', 'name': 'Alina', 'sub': '0812-3456-7890', 'fav': true},
  {'id': '2', 'name': 'Mark', 'sub': '0856-1122-3344', 'fav': true},
  {'id': '3', 'name': 'Rosa', 'sub': '0813-9988-7766', 'fav': false},
  {'id': '4', 'name': 'David', 'sub': '0821-4455-6677', 'fav': false},
];

const _banks = [
  {'id': 'bca', 'name': 'BCA', 'sub': 'Bank Central Asia', 'tone': 'blue'},
  {'id': 'bni', 'name': 'BNI', 'sub': 'Bank Negara Indonesia', 'tone': 'amber'},
];

class TransferPage extends StatefulWidget {
  const TransferPage({super.key});
  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  String _tab = 'dkg';
  String _q = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => context.go('/home'),
        ),
        title: const Text('Kirim Uang', style: TextStyle(fontFamily: 'Poppins', color: AppColors.ink, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.line2,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildTab('Danantara', 'dkg'),
                  _buildTab('Bank', 'bank'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.slate500.withOpacity(0.2)),
              ),
              child: TextField(
                style: const TextStyle(color: AppColors.ink),
                onChanged: (v) => setState(() => _q = v),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _tab == 'dkg' ? 'Cari kontak...' : 'Cari bank...',
                  hintStyle: const TextStyle(color: AppColors.slate500),
                  icon: const Icon(Icons.search, color: AppColors.slate500),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _tab == 'dkg' ? _buildContacts() : _buildBanks(),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, String value) {
    final active = _tab == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() { _tab = value; _q = ''; }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active ? AppColors.glowLime : null,
          ),
          child: Center(
            child: Text(label, style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: active ? AppColors.bg : AppColors.slate600,
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildContacts() {
    final filtered = _contacts.where((c) => (c['name'] as String).toLowerCase().contains(_q.toLowerCase())).toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final c = filtered[i];
        return GestureDetector(
          onTap: () => context.go('/transfer/amount', extra: {'recipient': c, 'channel': 'dkg'}),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                AppAvatar(name: c['name'] as String, size: 48, bg: AppColors.line2),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['name'] as String, style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                      Text(c['sub'] as String, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate500)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.slate500),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanks() {
    final filtered = _banks.where((b) => (b['name'] as String).toLowerCase().contains(_q.toLowerCase())).toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filtered.length,
      itemBuilder: (context, i) {
        final b = filtered[i];
        return GestureDetector(
          onTap: () => context.go('/transfer/amount', extra: {'recipient': b, 'channel': 'bank'}),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: AppColors.line2, borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(b['name'] as String, style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: AppColors.primary))),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b['sub'] as String, style: const TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.ink)),
                      const Text('Fee: \$0.00', style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.slate500)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.slate500),
              ],
            ),
          ),
        );
      },
    );
  }
}
