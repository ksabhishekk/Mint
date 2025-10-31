import 'package:flutter/material.dart';
import 'package:mintworth/models/user.dart';
import 'package:mintworth/services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = UserService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _userService.getCurrentUser();
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildProfileHeader(theme),
          const SizedBox(height: 24),
          _buildStatsCards(theme),
          const SizedBox(height: 24),
          _buildAchievements(theme),
          const SizedBox(height: 24),
          _buildInfoSection(theme),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]),
            child: Icon(Icons.person, size: 60, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Text(_user!.name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_user!.email, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text('${_user!.currentStreak} Day Streak', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('Total Points', _user!.totalPoints.toString(), Icons.stars, Colors.amber, theme)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard('Achievements', _user!.achievements.length.toString(), Icons.emoji_events, Colors.purple, theme)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAchievements(ThemeData theme) {
    final allAchievements = [
      {'name': 'First Investment', 'icon': Icons.trending_up, 'color': Colors.green},
      {'name': 'Quiz Master', 'icon': Icons.school, 'color': Colors.blue},
      {'name': 'Budget Pro', 'icon': Icons.account_balance_wallet, 'color': Colors.orange},
      {'name': 'Fraud Detective', 'icon': Icons.shield, 'color': Colors.red},
      {'name': '7 Day Streak', 'icon': Icons.local_fire_department, 'color': Colors.amber},
      {'name': 'Early Adopter', 'icon': Icons.star, 'color': Colors.purple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: allAchievements.map((achievement) {
              final isUnlocked = _user!.achievements.contains(achievement['name']);
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isUnlocked ? (achievement['color'] as Color).withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: isUnlocked ? Border.all(color: achievement['color'] as Color, width: 2) : null,
                    ),
                    child: Icon(achievement['icon'] as IconData, color: isUnlocked ? achievement['color'] as Color : Colors.grey, size: 32),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 80,
                    child: Text(
                      achievement['name'] as String,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(color: isUnlocked ? theme.colorScheme.onSurface : Colors.grey, fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Mint', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
          child: Column(
            children: [
              _buildInfoTile(Icons.info_outline, 'Version', '1.0.0', theme),
              const Divider(),
              _buildInfoTile(Icons.policy_outlined, 'Privacy Policy', '', theme),
              const Divider(),
              _buildInfoTile(Icons.description_outlined, 'Terms of Service', '', theme),
              const Divider(),
              _buildInfoTile(Icons.help_outline, 'Help & Support', '', theme),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: Text('Empowering young Indians with financial literacy', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey), textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String trailing, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          if (trailing.isNotEmpty) Text(trailing, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
          if (trailing.isEmpty) Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
