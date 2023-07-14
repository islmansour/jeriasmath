import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/Screens/manager/purchase_payment_list.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';

class PurchaseCard extends StatefulWidget {
  final Purchase? purchase;

  const PurchaseCard({Key? key, required this.purchase}) : super(key: key);

  @override
  State<PurchaseCard> createState() => _PurchaseCardState();
}

class _PurchaseCardState extends State<PurchaseCard> {
  @override
  Widget build(BuildContext context) {
    final userData = UserData.of(context);
    var purchaseStatus = userData!.lookupTable!
        .where((element) => (element!.type == "PURCHASE_STATUS" &&
            element.active == true &&
            element.lang == userData.user.language &&
            element.code == widget.purchase!.status))
        .first;
    int convertedAmount = int.parse(widget.purchase!.amount.split('.')[0]);
    double sum = 0;
    widget.purchase!.payments!.forEach(
      (element) {
        sum += double.parse(element!.amount);
      },
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PurchasePaymentsList(
              purchase: widget.purchase,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.purchase!.autoGenerate! == true)
                            const Icon(
                              Icons.autorenew_rounded,
                              size: 16,
                              color: Colors.red,
                            ),
                          FieldWidget(
                            fieldName: LocaleKeys.paid.tr(),
                            fieldValue: '$convertedAmount₪ / $sum₪',
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 1.0, // Set the width of the vertical line
                    height: 48.0, // Set the height of the vertical line
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.2), // Set the color with low opacity
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldWidget(
                          fieldName: LocaleKeys.maxAttendance.tr(),
                          fieldValue:
                              '${widget.purchase!.maxAttendances!} / ${widget.purchase!.payments!.length}'),
                      // FutureBuilder<List<Payment?>?>(
                      //     future:
                      //         Repository().getPurchasePayments(widget.purchase),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return const Center(
                      //             child: CircularProgressIndicator());
                      //       } else if (snapshot.hasError) {
                      //         return Center(
                      //             child: FieldWidget(
                      //           fieldName: LocaleKeys.maxAttendance.tr(),
                      //           fieldValue:
                      //               '${widget.purchase!.maxAttendances!} / ? ',
                      //         ));
                      //       } else if (snapshot.hasData) {
                      //         for (var element in snapshot.data!) {
                      //           print(
                      //               'here sum= $sum\r\n ${element!.amount.toString()} ${double.parse(element!.amount.toString())}');
                      //           sum += double.parse(element!.amount.toString());
                      //         }

                      //         return FieldWidget(
                      //           fieldName: LocaleKeys.maxAttendance.tr(),
                      //           fieldValue:
                      //               '${widget.purchase!.maxAttendances!} / ${snapshot.data!.length}',
                      //         );
                      //       } else {
                      //         return FieldWidget(
                      //           fieldName: LocaleKeys.maxAttendance.tr(),
                      //           fieldValue:
                      //               '${widget.purchase!.maxAttendances!} / ? ',
                      //         );
                      //       }
                      //     }),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    width: 1.0, // Set the width of the vertical line
                    height: 48.0, // Set the height of the vertical line
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withOpacity(0.2), // Set the color with low opacity
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldWidget(
                        fieldName: LocaleKeys.status.tr(),
                        fieldValue: '${purchaseStatus!.value}',
                      ),
                    ],
                  ),
                  // if (purchase!.autoGenerate! == true)
                  //   const SizedBox(
                  //     width: 8,
                  //   ),
                  // if (purchase!.autoGenerate!)
                  //   Container(
                  //     width: 1.0, // Set the width of the vertical line
                  //     height: 48.0, // Set the height of the vertical line
                  //     decoration: BoxDecoration(
                  //       color: Colors.black
                  //           .withOpacity(0.2), // Set the color with low opacity
                  //     ),
                  //   ),
                  // if (purchase!.autoGenerate! == true)
                  //   const SizedBox(
                  //     width: 8,
                  //   ),
                  // if (purchase!.autoGenerate! == true)
                  //   const Column(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [Icon(Icons.autorenew_rounded)],
                  //   ),
                ],
              ),
              Divider(
                color: Colors.black
                    .withOpacity(0.2), // Set the color with low opacity
                thickness: 1.0, // Set the thickness of the line
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldHorizatalWidget(
                        fieldName: LocaleKeys.create.tr(),
                        fieldValue: DateFormat('dd/MM/yy HH:mm')
                            .format(widget.purchase!.created!),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FieldHorizatalWidget(
                        fieldName: LocaleKeys.lastUpdated.tr(),
                        fieldValue: DateFormat('dd/MM/yy HH:mm')
                            .format(widget.purchase!.lastUpdated!),
                      ),
                    ],
                  ),
                  const Column(
                    children: [],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FieldWidget extends StatelessWidget {
  final String fieldName;
  final String fieldValue;

  const FieldWidget(
      {Key? key, required this.fieldName, required this.fieldValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          fieldName,
          style: const TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          fieldValue,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class FieldHorizatalWidget extends StatelessWidget {
  final String fieldName;
  final String fieldValue;

  const FieldHorizatalWidget(
      {Key? key, required this.fieldName, required this.fieldValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          fieldName,
          style: const TextStyle(
              color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Text(
          fieldValue,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
