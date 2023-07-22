import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/lookup_table.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';

class CreatePurchasePage extends StatefulWidget {
  final Person student;

  const CreatePurchasePage({required this.student});

  @override
  _CreatePurchasePageState createState() => _CreatePurchasePageState();
}

class _CreatePurchasePageState extends State<CreatePurchasePage> {
  int currentStep = 0;
  Purchase purchase = Purchase();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<LookupTable>> purchaseStatusDropdown = [];
  List<LookupTable?>? lookupTableData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchLookupTableData();
  }

  Future<void> fetchLookupTableData() async {
    try {
      var userData = UserData.of(context);

      lookupTableData = await Repository().getLookupTableAPI();
      lookupTableData = lookupTableData!
          .where((element) => (element?.active == true &&
              element?.type == 'PURCHASE_STATUS' &&
              element!.lang == userData!.user.language))
          .toList();

      setState(() {
        purchaseStatusDropdown = lookupTableData!
            .map(
              (lookupTable) => DropdownMenuItem<LookupTable>(
                value: lookupTable,
                child: Text(lookupTable?.value ?? ''),
              ),
            )
            .toList();
      });
    } catch (e) {
      // Handle the error or show an error message
      //   print('Error fetching lookup table data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.addNewPurchase.tr()),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepContinue: () {
          final form = formKey.currentState;
          if (form != null && form.validate()) {
            form.save();
            if (currentStep < 1) {
              setState(() {
                currentStep += 1;
              });
            } else {
              createPurchaseForStudent();
              Navigator.pop(context, true);
            }
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          } else {
            Navigator.pop(context, true);
          }
        },
        steps: [
          Step(
            title: Text(LocaleKeys.purchaseDetails.tr()),
            content: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: LocaleKeys.cost.tr(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.costIsRequired.tr();
                      }
                      return null;
                    },
                    onSaved: (value) {
                      purchase.amount = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: LocaleKeys.meetings.tr(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return LocaleKeys.meetingsIsRequired.tr();
                      }
                      return null;
                    },
                    onSaved: (value) {
                      purchase.maxAttendances = int.parse(value!);
                    },
                  ),
                ],
              ),
            ),
            isActive: currentStep == 0,
          ),
          Step(
            title: Text(LocaleKeys.purchaseDetails.tr()),
            content: Form(
              child: Column(
                children: [
                  DropdownButtonFormField<LookupTable>(
                    decoration: InputDecoration(
                      labelText: LocaleKeys.status.tr(),
                    ),
                    value: lookupTableData != null && purchase.status != null
                        ? lookupTableData!
                            .where(
                                (element) => element?.code == purchase.status)
                            .firstOrNull
                        : null,
                    items: purchaseStatusDropdown,
                    onChanged: (value) {
                      setState(() {
                        purchase.status = value!.code;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return LocaleKeys.thisIsRequired.tr();
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: currentStep == 1,
          ),
        ],
      ),
    );
  }

  void createPurchaseForStudent() {
    var userData = UserData.of(context);
    purchase.student = widget.student;
    purchase.createdBy = userData!.user.person;
    purchase.lastUpdatedBy = userData.user.person;

    Repository().addStudentsPurchaseAPI(purchase.toJson());
  }
}
