import 'package:flutter/material.dart';
import 'package:jerias_math/Model/person.dart';

class mgrStudentCard extends StatelessWidget {
  final Person? student;

  const mgrStudentCard({super.key, required this.student});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle card click event
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${student!.firstName} ${student!.lastName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${student!.id}'),
                        Text('Start Date: ${student!.startDate.toString()}'),
                        Text('Status: ${student!.status}'),
                        Text('Email: ${student!.email}'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone: ${student!.phone}'),
                        Text('Parent Phone 1: ${student!.parentPhone1}'),
                        Text('Parent Phone 2: ${student!.parentPhone2}'),
                        Text('Date of Birth: ${student!.dob.toString()}'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
