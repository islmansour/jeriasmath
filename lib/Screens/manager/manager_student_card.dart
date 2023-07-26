import 'package:flutter/material.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Screens/manager/manager_student_detials.dart';

class MgrStudentCard extends StatelessWidget {
  final Person? student;

  const MgrStudentCard({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetailsPages(
              student: student,
            ),
          ),
        );
      },
      child: Card(
        shadowColor: Colors.yellow.shade700.withOpacity(0.4),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green[700],
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          title: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(
                    '${student!.firstName} ${student!.lastName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          subtitle: SizedBox(
            // width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoRow(
                        Icons.phone_iphone,
                        'Phone',
                        student!.phone,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: _buildInfoRow(
                          Icons.phone_rounded,
                          'Parent Phone 1',
                          student!.parentPhone1.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData? icon, String? label, String? value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.green,
          size: 20,
        ),
        const SizedBox(width: 1),
        Text(
          value!,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
