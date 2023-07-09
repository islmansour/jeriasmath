import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/person_group.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/flash_bar.dart';
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
        title: const Text('Step 1'),
        content: Column(
          children: [
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: startDateController,
              decoration: const InputDecoration(labelText: 'Start Date'),
            ),
            TextFormField(
              controller: statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
          ],
        ),
        isActive: true,
      ),
      Step(
        title: const Text('Step 2'),
        content: Column(
          children: [
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: parentPhone1Controller,
              decoration: const InputDecoration(labelText: 'Parent Phone 1'),
            ),
            TextFormField(
              controller: parentPhone2Controller,
              decoration: const InputDecoration(labelText: 'Parent Phone 2'),
            ),
            TextFormField(
              controller: dobController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
            ),
            TextFormField(
              controller: userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
          ],
        ),
        isActive: false,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Form'),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepContinue: () {
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
