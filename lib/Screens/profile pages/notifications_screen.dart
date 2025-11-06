import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  
  bool _generalNotification = true;
  bool _sound = true;
  bool _vibrate = false;
  bool _specialOffers = true;
  bool _promoDiscount = false;
  bool _payments = true;
  bool _cashback = false;
  bool _appUpdates = true;
  bool _newServiceAvailable = false;
  bool _newTipsAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 20,
          ),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // General Notification
          _buildNotificationItem(
            title: 'General Notification',
            value: _generalNotification,
            onChanged: (value) {
              setState(() {
                _generalNotification = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Sound
          _buildNotificationItem(
            title: 'Sound',
            value: _sound,
            onChanged: (value) {
              setState(() {
                _sound = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Vibrate
          _buildNotificationItem(
            title: 'Vibrate',
            value: _vibrate,
            onChanged: (value) {
              setState(() {
                _vibrate = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Special Offers
          _buildNotificationItem(
            title: 'Special Offers',
            value: _specialOffers,
            onChanged: (value) {
              setState(() {
                _specialOffers = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Promo & Discount
          _buildNotificationItem(
            title: 'Promo & Discount',
            value: _promoDiscount,
            onChanged: (value) {
              setState(() {
                _promoDiscount = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Payments
          _buildNotificationItem(
            title: 'Payments',
            value: _payments,
            onChanged: (value) {
              setState(() {
                _payments = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Cashback
          _buildNotificationItem(
            title: 'Cashback',
            value: _cashback,
            onChanged: (value) {
              setState(() {
                _cashback = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // App Updates
          _buildNotificationItem(
            title: 'App Updates',
            value: _appUpdates,
            onChanged: (value) {
              setState(() {
                _appUpdates = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // New Service Available
          _buildNotificationItem(
            title: 'New Service Available',
            value: _newServiceAvailable,
            onChanged: (value) {
              setState(() {
                _newServiceAvailable = value;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // New Tips Available
          _buildNotificationItem(
            title: 'New Tips Available',
            value: _newTipsAvailable,
            onChanged: (value) {
              setState(() {
                _newTipsAvailable = value;
              });
            },
          ),
          
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          
          // Toggle Switch
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.black,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[300],
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
