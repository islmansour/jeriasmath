import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/Screens/manager/add_purchase.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/Screens/purchase_card.dart';

class StudentPurchasesList extends StatefulWidget {
  Person? student;

  StudentPurchasesList({super.key, this.student});

  @override
  State<StudentPurchasesList> createState() => _StudentPurchasesListState();
}

class _StudentPurchasesListState extends State<StudentPurchasesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreatePurchasePage(student: widget.student!),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      // appBar: AppBar(
      //   title: Column(
      //     children: [
      //       Text(LocaleKeys.purchases.tr()),
      //       Text(
      //         "${widget.student!.firstName} ${widget.student!.lastName}",
      //         style: const TextStyle(fontSize: 14),
      //       )
      //     ],
      //   ),
      // ),
      body: FutureBuilder<List<Purchase?>?>(
        future: Repository().getStudentPurchasesAPI(widget.student),
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
            return Center(child: Text(LocaleKeys.nodata.tr()));
          }
        },
      ),
    );
  }
}
