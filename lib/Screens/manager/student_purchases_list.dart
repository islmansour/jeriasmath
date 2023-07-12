import 'package:flutter/material.dart';

import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/purchase_card.dart';

class StudentPurchasesList extends StatelessWidget {
  Person? student;

  StudentPurchasesList({super.key, this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchases'),
      ),
      body: FutureBuilder<List<Purchase?>?>(
        future: Repository().getStudentPurchasesAPI(student),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final purchases = snapshot.data!;
            return ListView.builder(
              itemCount: purchases.length,
              itemBuilder: (context, index) {
                final purchase = purchases[index];
                return PurchaseCard(purchase: purchase!);
              },
            );
          } else {
            return Center(child: Text('No purchases available'));
          }
        },
      ),
    );
  }
}
