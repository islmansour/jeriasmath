import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/person_group.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/flash_bar.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';

class AddStudentFormPage extends StatefulWidget {
  final Group? group;
  const AddStudentFormPage({
    super.key,
    this.group,
  });
  @override
  _AddStudentFormPageState createState() => _AddStudentFormPageState();
}

class _AddStudentFormPageState extends State<AddStudentFormPage> {
  int currentStep = 0;
  String errorPhone = "";
  String errorLastName = "";
  String errorFirstName = "";
  bool studentExists = false;
  List<GroupPerson?> relatedGroups = [];
  late TextEditingController lastNameController;
  late TextEditingController firstNameController;
  late TextEditingController startDateController;
  late TextEditingController statusController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController parentPhone1Controller;
  late TextEditingController parentPhone2Controller;
  late TextEditingController dobController;
  late TextEditingController userIdController;

  @override
  void initState() {
    super.initState();
    lastNameController = TextEditingController();
    firstNameController = TextEditingController();
    startDateController = TextEditingController();
    statusController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    parentPhone1Controller = TextEditingController();
    parentPhone2Controller = TextEditingController();
    dobController = TextEditingController();
    userIdController = TextEditingController();
  }

  @override
  void dispose() {
    lastNameController.dispose();
    firstNameController.dispose();
    startDateController.dispose();
    statusController.dispose();
    phoneController.dispose();
    emailController.dispose();
    parentPhone1Controller.dispose();
    parentPhone2Controller.dispose();
    dobController.dispose();
    userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = UserData.of(context);

    List<Step> steps = [
      Step(
        title: Text(LocaleKeys.add.tr()),
        content: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                errorText: errorPhone == "" ? null : errorPhone,
                hintStyle: const TextStyle(fontSize: 12),
                hintText: LocaleKeys.phoneTooltip.tr(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
                //  FilteringTextInputFormatter.allow(RegExp(r'^05\d{0,8}')),
              ],
              onChanged: (value) {
                try {
                  if (value.length == 2) {
                    setState(() {
                      value.substring(0, 2) == "05"
                          ? errorPhone = ""
                          : errorPhone = LocaleKeys.errorPhone.tr();
                    });
                  }
                  if (value.length == 10) {
                    setState(() {
                      value.substring(0, 2) == "05"
                          ? errorPhone = ""
                          : errorPhone = LocaleKeys.errorPhone.tr();
                    });
                    Person? tmp = userData!.persons!
                        .where((element) => element!.phone == value)
                        .first;
                    if (tmp != null) {
                      setState(() {
                        studentExists = true;
                        lastNameController.text = tmp.lastName!;
                        firstNameController.text = tmp.firstName!;
                        parentPhone1Controller.text = tmp.parentPhone1!;
                        parentPhone2Controller.text = tmp.parentPhone2!;
                        relatedGroups = userData.groupPersons!
                            .where(
                                (element) => element!.student!.phone == value)
                            .toList();
                      });
                    } else {
                      studentExists = false;
                    }
                  }
                } catch (e) {}
              },
              controller: phoneController,
              //   decoration: InputDecoration(labelText: LocaleKeys.phone.tr()),
            ),
          ],
        ),
        isActive: true,
      ),
      Step(
        title: Text(
          studentExists == true
              ? LocaleKeys.studentExists.tr()
              : LocaleKeys.newStudent.tr(),
          style: TextStyle(
              color: studentExists == true ? Colors.red : Colors.blue),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (studentExists == true)
              Text(
                LocaleKeys.existsInGroups.tr(),
                style: TextStyle(color: Colors.red.shade400),
              ),
            if (studentExists == true)
              Text(relatedGroups
                  .toString()
                  .replaceAll("[", "")
                  .replaceAll("]", "")),
            TextFormField(
              controller: lastNameController,
              decoration: InputDecoration(
                labelText: LocaleKeys.lastName.tr(),
                errorText: errorLastName == "" ? null : errorLastName,
                hintStyle: const TextStyle(fontSize: 12),
                hintText: LocaleKeys.lastName.tr(),
              ),
            ),
            TextFormField(
              controller: firstNameController,
              decoration: InputDecoration(
                labelText: LocaleKeys.firstName.tr(),
                errorText: errorFirstName == "" ? null : errorFirstName,
                hintStyle: const TextStyle(fontSize: 12),
                hintText: LocaleKeys.firstName.tr(),
              ),
            ),
            // TextFormField(
            //   controller: emailController,
            //   decoration: const InputDecoration(labelText: 'Email'),
            // ),
            if (studentExists == false)
              TextFormField(
                controller: parentPhone1Controller,
                decoration:
                    InputDecoration(labelText: LocaleKeys.parentPhone.tr()),
              ),
            if (studentExists == false)
              TextFormField(
                controller: parentPhone2Controller,
                decoration:
                    InputDecoration(labelText: LocaleKeys.parentPhone.tr()),
              ),
            // TextFormField(
            //   controller: dobController,
            //   decoration: const InputDecoration(labelText: 'Date of Birth'),
            // ),
            // TextFormField(
            //   controller: userIdController,
            //   decoration: const InputDecoration(labelText: 'User ID'),
            // ),
          ],
        ),
        isActive: false,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.addStudent.tr()),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepContinue: () {
          if (currentStep == 0) {
            if (phoneController.text.length != 10) {
              setState(() {
                errorPhone = LocaleKeys.errorPhone.tr();
              });
              return;
            }
          }
          if (currentStep == 1 && lastNameController.text.isEmpty) {
            setState(() {
              errorLastName = LocaleKeys.lastNameRequired.tr();
            });

            return;
          }
          if (currentStep == 1 && firstNameController.text.isEmpty) {
            setState(() {
              errorFirstName = LocaleKeys.firstRequired.tr();
            });

            return;
          }

          setState(() {
            if (currentStep < steps.length - 1) {
              currentStep += 1;
            } else {
              // All steps completed, create the student object
              Person student = Person(
                lastName: lastNameController.text,
                firstName: firstNameController.text,
                startDate: startDateController.text == ""
                    ? null
                    : DateTime.parse(startDateController.text),
                status: statusController.text == ""
                    ? 1
                    : int.parse(statusController.text),
                phone: phoneController.text,
                email: emailController.text,
                parentPhone1: parentPhone1Controller.text,
                parentPhone2: parentPhone2Controller.text,
                dob: dobController.text == ""
                    ? null
                    : DateTime.parse(dobController.text),
                userId: userIdController.text,
              );

              int? studentId = -1;
              final userData = UserData.of(context);

              if (userData!.persons!
                  .where((element) => element!.phone == student.phone)
                  .isEmpty) {
                userData.persons!.add(student);
                Repository().createPersonsAPI(student.toJson()).then((value) {
                  studentId = value;
                  if (widget.group != null) {
                    final List<GroupPerson?> groupStudents =
                        userData.groupPersons != null
                            ? userData.groupPersons!
                                .where((element) =>
                                    element?.group?.id == widget.group!.id &&
                                    element!.student!.phone == student.phone)
                                .toList()
                            : List.empty();
                    if (groupStudents.isEmpty) {
                      GroupPerson gp = GroupPerson(
                        DateTime.now(),
                        userData.user.contactId,
                        widget.group!.id,
                        DateTime.now(),
                        userData.user.contactId,
                        -1,
                        studentId!,
                        1,
                      );
                      Repository().createGroupPersonAPI(gp.toJson());
                    }
                  } else {}
                });
              } else {
                studentId = userData.persons!
                    .where((element) => element!.phone == student.phone)
                    .first!
                    .id;

                if (widget.group != null) {
                  final List<GroupPerson?> groupStudents =
                      userData.groupPersons != null
                          ? userData.groupPersons!
                              .where((element) =>
                                  element?.group?.id == widget.group!.id &&
                                  element!.student!.phone == student.phone)
                              .toList()
                          : List.empty();
                  if (groupStudents.isEmpty) {
                    GroupPerson gp = GroupPerson(
                      DateTime.now(),
                      userData.user.contactId,
                      widget.group!.id,
                      DateTime.now(),
                      userData.user.contactId,
                      -1,
                      studentId!,
                      1,
                    );

                    try {
                      setState(() {
                        //  userData.addGroupPerson!(gp);

                        Repository()
                            .createGroupPersonAPI(gp.toJson())
                            .then((value) {
                          userData.addGroupPerson!(value);
                          Navigator.pop(context);
                        });
                      });
                    } catch (e) {
                      raiseFlashbard(context);
                    }
                    raiseFlashbard(context, msg: "added...");
                  }
                } else {
                  print('no group avaiable...');
                }
              }
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (currentStep > 0) {
              currentStep -= 1;
            } else {
              currentStep = 0;
            }
          });
        },
        steps: steps,
      ),
    );
  }
}
