import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flow/providers/auth_provider.dart';
import 'package:flow/providers/theme_provider.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _showLogoutConfirm(BuildContext context, UserAuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of your account?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await authProvider.logout(); 
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select Theme', style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System Default'),
              onTap: () {
                themeProvider.setTheme(ThemeMode.system);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Light'),
              onTap: () {
                themeProvider.setTheme(ThemeMode.light);
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('Dark'),
              onTap: () {
                themeProvider.setTheme(ThemeMode.dark);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
    final user = authProvider.user;

    String displayName = 'My Account';
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      displayName = user.displayName!;
    } else if (user?.email != null) {
      displayName = user!.email!.split('@')[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('More', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 20, 
        // ignore: deprecated_member_use
        shadowColor: Colors.black.withOpacity(0.5), 
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F3D32), Color(0xFF5F806F)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            // User Profile Section
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  // ignore: deprecated_member_use
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.15),
                  child: Icon(Icons.person, size: 36, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Preferences
            const Text('Preferences', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            _buildListTile('Theme', 'Tap to change', onTap: () => _showThemeDialog(context)),
            _buildListTile('Currency', 'LKR (Rs.)', onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Currency is set to Sri Lankan Rupees (Rs.) by default.'))
              );
            }),
            
            const SizedBox(height: 24),
            
            // App Info
            const Text('App', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            _buildListTile('About Flow', 'v1.0.0', onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Flow',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset('assets/images/logo.png', height: 40),
                children: const [
                  Text('A personal expense tracker built with Flutter and Firebase.'),
                ]
              );
            }),
            
            const SizedBox(height: 40),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutConfirm(context, authProvider),
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            
            const SizedBox(height: 100), 
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, String subtitle, {Color? textColor, required VoidCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor ?? Colors.black87)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
    );
  }
}