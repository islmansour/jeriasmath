import 'package:flutter/material.dart';

class ManageMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('My App'),
          ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildCard(
                      icon: Icons.person,
                      title: 'Students',
                      onTap: () {
                        // Handle students card tap
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildCard(
                      icon: Icons.group,
                      title: 'Groups',
                      onTap: () {
                        // Handle groups card tap
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildCard(
                      icon: Icons.calendar_today,
                      title: 'Upcoming Classes',
                      onTap: () {
                        // Handle upcoming classes card tap
                      },
                    ),
                  ),
                  Expanded(
                    child: _buildCard(
                      icon: Icons.insert_chart,
                      title: 'Reports',
                      onTap: () {
                        // Handle reports card tap
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({IconData? icon, String? title, Function? onTap}) {
    return GestureDetector(
      onTap: null,
      child: Card(
        shadowColor: Colors.yellow.shade700.withOpacity(0.4),
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48.0),
              SizedBox(height: 16.0),
              Text(
                title!,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
