import 'package:flutter/material.dart';
import 'package:shared_models/models/app_config.dart';
import 'package:shared_models/models/user.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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

  bool _notificationsEnabled = true;
  bool _emailUpdates = true;

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
            _buildNotificationSwitch('Push Notifications', _notificationsEnabled, (value) {
              setState(() => _notificationsEnabled = value);
              _showSnackbar('Notifications ${value ? 'enabled' : 'disabled'}');
            }),
            const SizedBox(height: 12),
            _buildNotificationSwitch('Email Updates', _emailUpdates, (value) {
              setState(() => _emailUpdates = value);
              _showSnackbar('Email updates ${value ? 'enabled' : 'disabled'}');
            }),
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

  Widget _buildNotificationSwitch(String title, bool value, Function(bool) onChanged) {
    return Container(
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
              Icons.notifications,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppConfig.primaryColor,
          ),
        ],
      ),
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: currentUser.name,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: currentUser.email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: currentUser.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar('Profile updated successfully');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _navigateToPersonalDetails() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Full Name', currentUser.name),
            _buildDetailRow('Email', currentUser.email),
            _buildDetailRow('Phone', currentUser.phone),
            _buildDetailRow('Member Since', '${currentUser.joinedDate.day}/${currentUser.joinedDate.month}/${currentUser.joinedDate.year}'),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                ),
                child: const Text('CLOSE', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConfig.textPrimary,
            ),
          ),
          Text(
            value,
            style: TextStyle(color: AppConfig.textSecondary),
          ),
        ],
      ),
    );
  }

  void _navigateToAddresses() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Addresses',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...currentUser.addresses.map((address) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConfig.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: AppConfig.primaryColor),
                    const SizedBox(width: 12),
                    Expanded(child: Text(address)),
                  ],
                ),
              ),
            )),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showSnackbar('Add new address functionality'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                ),
                child: const Text('ADD NEW ADDRESS', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPaymentMethods() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentMethod('Credit Card', '**** **** **** 1234'),
            _buildPaymentMethod('UPI', 'user@upi'),
            _buildPaymentMethod('Net Banking', 'HDFC Bank'),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showSnackbar('Add new payment method'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.primaryColor,
                ),
                child: const Text('ADD PAYMENT METHOD', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(String type, String details) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppConfig.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.credit_card, color: AppConfig.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(type, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(details, style: TextStyle(color: AppConfig.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPrivacy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Security'),
        content: const Text(
          'Your privacy is important to us. We use industry-standard encryption to protect your personal information and never share your data with third parties without your consent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('UNDERSTOOD'),
          ),
        ],
      ),
    );
  }

  void _navigateToHelp() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppConfig.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildSupportOption('Contact Support', Icons.support_agent, () {
              _showSnackbar('Connecting to support...');
            }),
            _buildSupportOption('FAQs', Icons.help_outline, () {
              _showSnackbar('Opening FAQs...');
            }),
            _buildSupportOption('Report Issue', Icons.bug_report, () {
              _showSnackbar('Opening issue reporter...');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportOption(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppConfig.cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppConfig.primaryColor),
            const SizedBox(width: 16),
            Text(title, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackbar('Logged out successfully');
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              });
            },
            child: const Text('LOGOUT', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppConfig.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
