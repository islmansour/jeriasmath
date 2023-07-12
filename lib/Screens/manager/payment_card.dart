import 'package:flutter/material.dart';
import 'package:jerias_math/Model/payment.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;

  const PaymentCard({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.payment, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Payment ID:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(payment.id.toString()),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Created:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                    payment.created != null ? payment.created!.toString() : ''),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Last Updated:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(payment.lastUpdated != null
                    ? payment.lastUpdated!.toString()
                    : ''),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Student:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(payment.student?.firstName ?? ''),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.account_balance, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Account:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(payment.account?.name ?? ''),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.shopping_cart, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Purchase:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(''),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Created By:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(payment.createdBy?.firstName ?? ''),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Last Updated By:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(payment.lastUpdatedBy?.firstName ?? ''),
              ],
            ),
            // Add more rows for other fields if needed
          ],
        ),
      ),
    );
  }
}
