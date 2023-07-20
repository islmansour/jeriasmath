import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jerias_math/Model/payment.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;

  const PaymentCard({Key? key, required this.payment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var userData = UserData.of(context);
    String paymentType = userData!.lookupTable!
        .where((element) =>
            element!.type == "PAYMENT_METHOD" &&
            element.active == true &&
            element.lang == userData.user.language &&
            element.code == payment.paymentType)
        .first!
        .value
        .toString();
    return Card(
      shadowColor: Colors.yellow.shade700.withOpacity(0.4),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding:
            const EdgeInsets.only(top: 16, right: 32, bottom: 16, left: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRow(
                  title: LocaleKeys.actualPayment.tr(),
                  value: '${payment.amount}',
                ),
                // const SizedBox(
                //   width: 8,
                // ),
                // // Container(
                // //   width: 1.0, // Set the width of the vertical line
                // //   height: 48.0, // Set the height of the vertical line
                // //   decoration: BoxDecoration(
                // //     color: Colors.black
                // //         .withOpacity(0.2), // Set the color with low opacity
                // //   ),
                // // ),
                // const SizedBox(
                //   width: 8,
                // ),
                buildRow(
                  title: LocaleKeys.paymentMethod.tr(),
                  value: paymentType,
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHorizantalRow(
                  title: LocaleKeys.create.tr(),
                  value: payment.created != null
                      ? DateFormat('dd/MM/yy HH:mm').format(payment.created!)
                      : '',
                ),
                buildHorizantalRow(
                  title: LocaleKeys.createdBy.tr(),
                  value:
                      '${payment.createdBy?.firstName} ${payment.createdBy?.firstName}',
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),

            // Add more buildRow widgets as needed
          ],
        ),
      ),
    );
  }

  Widget buildRow({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          value,
        ),
      ],
    );
  }

  Widget buildHorizantalRow({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Text(
          value,
        ),
      ],
    );
  }
}
