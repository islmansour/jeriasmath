import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/payment.dart';

import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/Screens/manager/add_payment.dart';
import 'package:jerias_math/Screens/manager/payment_card.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';

// ignore: must_be_immutable
class PurchasePaymentsList extends StatefulWidget {
  Purchase? purchase;

  PurchasePaymentsList({super.key, this.purchase});

  @override
  State<PurchasePaymentsList> createState() => _PurchasePaymentsListState();
}

class _PurchasePaymentsListState extends State<PurchasePaymentsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Navigator.pushNamed(context, '/add_student');
          final results = await Navigator.push(
            context,
            MaterialPageRoute(
              //  builder: (context) => StudentPurchasesList(
              builder: (context) => AddPaymentPage(
                purchase: widget.purchase!,
                student: widget.purchase!.student!,
              ),
            ),
          );
          if (results == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(LocaleKeys.payments.tr()),
      ),
      body: FutureBuilder<List<Payment?>?>(
        future: Repository().getPurchasePayments(widget.purchase),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final payments = snapshot.data!;
            return ListView.builder(
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return PaymentCard(payment: payment!);
              },
            );
          } else {
            return Center(
                child: Text(
              LocaleKeys.nodata.tr(),
            ));
          }
        },
      ),
    );
  }
}
