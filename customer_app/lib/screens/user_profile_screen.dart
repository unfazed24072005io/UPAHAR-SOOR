import 'package:flutter/material.dart';
import 'package:shared_models/models/app_config.dart';
import 'package:shared_models/models/user.dart';

class UserProfileScreen extends StatelessWidget {
  final User currentUser = User(
    id: 'user1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+91 9876543210',
    addresses: [
      '123 Main Street, Mumbai, Maharashtra - 400001',
      '456 Park Avenue, Delhi, Delhi - 110001'
    ],
    wishlist: ['1', '2'],
    joinedDate: DateTime(2024, 1, 1),
  );

  UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 32),
            
            // Account Information
            _buildSectionHeader('Account Information'),
            const SizedBox(height: 16),
            _buildInfoCard('Personal Details', Icons.person, _navigateToPersonalDetails),
            const SizedBox(height: 12),
            _buildInfoCard('Addresses', Icons.location_on, _navigateToAddresses),
            const SizedBox(height: 12),
            _buildInfoCard('Payment Methods', Icons.payment, _navigateToPaymentMethods),
            
            const SizedBox(height: 32),
            
            // App Settings
            _buildSectionHeader('App Settings'),
            const SizedBox(height: 16),
            _buildInfoCard('Notifications', Icons.notifications, _navigateToNotifications),
            const SizedBox(height: 12),
            _buildInfoCard('Privacy & Security', Icons.security, _navigateToPrivacy),
            const SizedBox(height: 12),
            _buildInfoCard('Help & Support', Icons.help, _navigateToHelp),
            
            const SizedBox(height: 32),
            
            // Logout Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red),
              ),
              child: TextButton(
                onPressed: _logout,
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppConfig.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppConfig.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 20),
          
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser.name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentUser.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConfig.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Member since ${currentUser.joinedDate.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConfig.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Edit Button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _editProfile,
              icon: Icon(
                Icons.edit,
                color: AppConfig.primaryColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppConfig.textPrimary,
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildInfoCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConfig.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConfig.primaryColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppConfig.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppConfig.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppConfig.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppConfig.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    // Navigate to edit profile screen
    print('Edit profile tapped');
  }

  void _navigateToPersonalDetails() {
    print('Personal details tapped');
  }

  void _navigateToAddresses() {
    print('Addresses tapped');
  }

  void _navigateToPaymentMethods() {
    print('Payment methods tapped');
  }

  void _navigateToNotifications() {
    print('Notifications tapped');
  }

  void _navigateToPrivacy() {
    print('Privacy tapped');
  }

  void _navigateToHelp() {
    print('Help tapped');
  }

  void _logout() {
    print('Logout tapped');
  }
}
