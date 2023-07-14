import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/payment.dart';

import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/Screens/manager/payment_card.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';

class PurchasePaymentsList extends StatelessWidget {
  Purchase? purchase;

  PurchasePaymentsList({super.key, this.purchase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.payments.tr()),
      ),
      body: FutureBuilder<List<Payment?>?>(
        future: Repository().getPurchasePayments(purchase),
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
