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
            //  builder: (context) => StudentPurchasesList(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green[200]!,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${student!.firstName} ${student!.lastName}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // if (student!.email != null && student!.email != "")
                    //   _buildInfoRow(Icons.email, 'Email', student!.email),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green[200]!,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: _buildInfoRow(
                              Icons.phone_iphone,
                              'Phone',
                              student!.phone,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        // if (student!.parentPhone1 != null &&
                        //     student!.parentPhone1 != "")
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.green[200]!,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: _buildInfoRow(
                              Icons.phone_rounded,
                              'Parent Phone 1',
                              student!.parentPhone1.toString(),
                            ),
                          ),
                        ),
                        // if (student!.parentPhone1 == null ||
                        //     student!.parentPhone1!.isEmpty)
                        //   SizedBox(
                        //     width:
                        //         200, // Set the desired width for the empty container
                        //   ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData? icon, String? label, String? value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.green,
        ),
        const SizedBox(width: 8),
        Text(
          value!,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
