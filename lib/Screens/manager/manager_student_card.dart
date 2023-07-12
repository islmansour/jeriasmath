import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Screens/manager/student_purchases_list.dart';

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
            builder: (context) => StudentPurchasesList(
              student: student,
            ),
          ),
        );
      },
      child: Card(
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
                    SizedBox(
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
                          const SizedBox(height: 8),
                          Divider(
                            color: Colors.grey.withOpacity(0.2),
                            height: 1,
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // if (student!.email != null && student!.email != "")
                    //   _buildInfoRow(Icons.email, 'Email', student!.email),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoRow(
                            Icons.phone_iphone, 'Phone', student!.phone),
                        if (student!.parentPhone1 != null &&
                            student!.parentPhone1 != "")
                          Container(
                            width: 1.0, // Set the width of the vertical line
                            height: 24.0, // Set the height of the vertical line
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                  0.2), // Set the color with low opacity
                            ),
                          ),
                        if (student!.parentPhone1 != null &&
                            student!.parentPhone1 != "")
                          _buildInfoRow(
                            Icons.phone_rounded,
                            'Parent Phone 1',
                            student!.parentPhone1.toString(),
                          ),
                      ],
                    )

                    // if ((student!.parentPhone1 != null &&
                    //         student!.parentPhone1 != "") &&
                    //     (student!.parentPhone2 != null &&
                    //         student!.parentPhone2 != ""))
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     // // if (student!.parentPhone1 != null &&
                    //     // //     student!.parentPhone1 != "")
                    //     // _buildInfoRow(
                    //     //   Icons.phone_rounded,
                    //     //   'Parent Phone 1',
                    //     //   student!.parentPhone1.toString(),
                    //     // ),
                    //     // if (student!.parentPhone2 != null)
                    //     // Row(
                    //     //   children: [
                    //     //     _buildInfoRow(Icons.phone_rounded, 'Parent Phone 2',
                    //     //         student!.parentPhone2.toString()),
                    //     //     SizedBox(
                    //     //       width: (220 -
                    //     //               student!.parentPhone2.toString().length)
                    //     //           .toDouble(),
                    //     //     )
                    //     //   ],
                    //     // ),
                    //   ],
                    // )
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
