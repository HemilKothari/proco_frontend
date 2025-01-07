/*import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationTile(
            context,
            title: 'New Message',
            subtitle: 'You have received a new message.',
            icon: Icons.message,
            time: '2 mins ago',
          ),
          _buildNotificationTile(
            context,
            title: 'Update Available',
            subtitle: 'A new update is ready to install.',
            icon: Icons.system_update,
            time: '10 mins ago',
          ),
          _buildNotificationTile(
            context,
            title: 'Payment Successful',
            subtitle: 'Your payment of \$25.00 was successful.',
            icon: Icons.payment,
            time: '1 hour ago',
          ),
          _buildNotificationTile(
            context,
            title: 'Friend Request',
            subtitle: 'John Doe sent you a friend request.',
            icon: Icons.person_add,
            time: '3 hours ago',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String time,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Icon(icon, color: Colors.teal),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Text(time, style: const TextStyle(color: Colors.grey)),
        onTap: () {
          // Handle notification click if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped!')),
          );
        },
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF08959D), // Set the text color here
          ),
        ),
        backgroundColor: const Color(0xFF040326),
      ),
      body: const Center(
        child: Text('This is the Notification Page'),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF08959D), // Set the text color here
          ),
        ),
        backgroundColor: const Color(0xFF040326),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF08959D), // Set the back button color here
          ),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: const Center(
        child: Text('This is the Notification Page'),
      ),
    );
  }
}
