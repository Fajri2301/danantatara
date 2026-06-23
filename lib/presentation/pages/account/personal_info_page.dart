import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../widgets/app_field.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({super.key});

  @override
  State<PersonalInfoPage> createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  String _name = 'Fajri Khaerullah';
  String _email = 'fajrisantuy23@gmail.com';
  String _phone = '+62 812 3456 7890';
  String _dob = '23 Januari 2001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.canPop() ? context.pop() : context.go('/akun'),
        ),
        title: const Text('Informasi Pribadi', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  AppField(
                    value: _name,
                    onChanged: (v) => setState(() => _name = v),
                    label: 'Nama Lengkap',
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  AppField(
                    value: _email,
                    onChanged: (v) => setState(() => _email = v),
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  AppField(
                    value: _phone,
                    onChanged: (v) => setState(() => _phone = v),
                    label: 'Nomor Telepon',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  AppField(
                    value: _dob,
                    onChanged: (v) => setState(() => _dob = v),
                    label: 'Tanggal Lahir',
                    keyboardType: TextInputType.datetime,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Profil berhasil diperbarui', style: TextStyle(fontFamily: 'Inter', color: Colors.black)),
                    backgroundColor: AppColors.neonGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.neonGreen,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppColors.neonGreen.withOpacity(0.3), blurRadius: 8)],
                ),
                child: const Center(
                  child: Text('Simpan Perubahan', style: TextStyle(fontFamily: 'Inter', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
