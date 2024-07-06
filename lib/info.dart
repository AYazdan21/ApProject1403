import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'theme.dart'; // Import the theme file

class InfoPage extends StatelessWidget {
  static const Color backGroundTheme = Color(0xFF2F1E9D);
  static const Color contextThemeColor = Color(0xfff9f8fe);

  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    double heightOfScreen = MediaQuery.of(context).size.height;
    double widthOfScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backGroundTheme,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: viewportConstraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: widthOfScreen,
                      height: heightOfScreen * 28 / 80,
                      child: Column(
                        children: [
                          SizedBox(height: heightOfScreen * 0.1),
                          _buildProfileImage(),
                          const SizedBox(height: 15),
                          const Text(
                            "Amirreza Yazdanpanah",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: widthOfScreen,
                        padding: const EdgeInsets.all(30),
                        decoration: const BoxDecoration(
                          color: contextThemeColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildInfoCard(widthOfScreen, heightOfScreen),
                            const SizedBox(height: 32),
                            _buildActionsCard(context, widthOfScreen, heightOfScreen),
                            SizedBox(height: heightOfScreen * 0.11),
                            Container(
                              width: widthOfScreen * 0.83,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: backGroundTheme,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: const Center(
                                child: Text(
                                  "Delete Account",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      height: 148,
      width: 145,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: contextThemeColor,
      ),
      child: Image.asset(
        'images/Default_pfp.png',
        height: 148,
        width: 145,
      ),
    );
  }

  Widget _buildInfoCard(double widthOfScreen, double heightOfScreen) {
    return Container(
      width: widthOfScreen * 0.83,
      height: heightOfScreen * 0.19,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(27)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 23),
          _buildInfoRow("Student Number", "402243113", 95),
          const SizedBox(height: 10),
          _buildDivider(),
          const SizedBox(height: 10),
          _buildInfoRow("Units", "16", 235),
          const SizedBox(height: 10),
          _buildDivider(),
          const SizedBox(height: 10),
          _buildInfoRow("Grade", "18.61", 210),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, double spacing) {
    return Row(
      children: [
        const SizedBox(width: 22),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: spacing),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black45,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.5,
      width: 280,
      color: Colors.black12,
    );
  }

  Widget _buildActionsCard(BuildContext context, double widthOfScreen, double heightOfScreen) {
    return Container(
      width: widthOfScreen * 0.83,
      height: heightOfScreen * 0.14,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(27)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 23),
          InkWell(
            onTap: () => _showAlertDialog(context),
            child: _buildActionRow(Icons.edit, Colors.deepPurple, "Edit Credentials"),
          ),
          const SizedBox(height: 10),
          _buildDivider(),
          const SizedBox(height: 10),
          InkWell(
            onTap: () => _showChangePasswordDialog(context),
            child: _buildActionRow(Icons.change_circle, Colors.greenAccent, "Change Password"),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(IconData icon, Color iconColor, String title) {
    return Row(
      children: [
        const SizedBox(width: 18),
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: iconColor,
          ),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            'Edit Credentials',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, color: Colors.redAccent),
          ),
          content: const Text(
            'To edit your credentials, please visit the Site Admin.',
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: const Text('Got It!'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController currentPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            'Change Password',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, color: Colors.blueAccent),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                ),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                // Handle password change logic here
                String currentPassword = currentPasswordController.text;
                String newPassword = newPasswordController.text;

                // Add your password change logic here

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
