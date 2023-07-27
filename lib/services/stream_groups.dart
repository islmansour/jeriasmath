import 'dart:async';

import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/person_group.dart';
import 'package:jerias_math/api/django_server_api.dart';

// Create a stream controller to handle events
StreamController<List<Group?>?> groupsStreamController =
    StreamController<List<Group?>?>.broadcast();

StreamController<List<Person?>?> personsStreamController =
    StreamController<List<Person?>?>();

StreamController<List<GroupPerson?>?> groupPersonsStreamController =
    StreamController<List<GroupPerson?>?>();

void fetchDataPeriodically() {
  Timer.periodic(const Duration(seconds: 10), (timer) async {
    personsStreamController.add(await Repository().getPersonsAPI());
    groupPersonsStreamController.add(await Repository().getGroupPersonsAPI());
    groupsStreamController.add(await Repository().getGroupsAPI());
  });
}

void forceUpdateGroupData() {
  Repository().getGroupsAPI().then((value) {
    groupsStreamController.add(value);
    //preloadedGroups = value;
  });
}

void forceUpdatePersonsData() {
  Repository().getPersonsAPI().then((value) {
    personsStreamController.add(value);
  });
}

void forceUpdategroupPersonsData() {
  Repository().getGroupPersonsAPI().then((value) {
    groupPersonsStreamController.add(value);
  });
}
