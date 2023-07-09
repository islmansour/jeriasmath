import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/person_group.dart';
import 'package:jerias_math/Screens/manager/add_group.dart';
import 'package:jerias_math/Screens/manager/add_student.dart';
import 'package:jerias_math/Screens/manager/groups_list.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/notification_msg.dart';
import 'package:jerias_math/globals.dart';
import 'package:jerias_math/Model/user.dart';
import 'package:jerias_math/api/loadtestdata.dart';
import 'package:jerias_math/auth.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:jerias_math/l10n/locale_keys.g.dart';

// flutter pub run easy_localization:generate -S assets/l10n -f keys -O lib/l10n -o locale_keys.g.dart

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

int _currentIndex = 0;

bool? _autoLogin;
User? user;
AppUser? appUser;
String? countryCode = "en";
List<Group?>? _groups;
List<GroupPerson?>? _groupPersons;
List<Person?>? _persons;
List<GroupEvent?>? _groupEvents;

Future<bool?> autologin() async {
  user = await FirebaseAuth.instance.currentUser;
  _autoLogin = user != null ? true : false;

  return (user != null ? true : false);
}

class UserData extends InheritedWidget {
  final AppUser user;
  final List<Group?>? groups;
  final List<GroupPerson?>? groupPersons;
  final List<Person?>? persons;
  final List<GroupEvent?>? groupEvents;
  final Function? setGroups;
  final Function? setPersons;
  final Function? setGroupPersons;
  final Function? upsertGroup;
  final Function? getGroupEvents;

  final Function? addGroupPerson;

  UserData(
      {super.key,
      required this.user,
      required Widget child,
      this.groups,
      this.setGroups,
      this.setPersons,
      this.setGroupPersons,
      this.upsertGroup,
      this.persons,
      this.groupEvents,
      this.addGroupPerson,
      this.getGroupEvents,
      this.groupPersons})
      : super(child: child);

  @override
  bool updateShouldNotify(UserData oldWidget) => true;

  static UserData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserData>();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await autologin();
  if (user != null) {
    countryCode = (await getUser(user!.uid))?.language;
    appUser = await getUser(user!.uid);
    if (appUser != null && appUser?.userType == "admin") {
      _persons = (await Repository().getPersonsAPI())!.cast<Person?>();
      _groups = (await Repository().getGroupsAPI())!.cast<Group?>();
      _groupPersons =
          (await Repository().getGroupPersonsAPI())!.cast<GroupPerson?>();
    }
  }

  runApp(EasyLocalization(
    startLocale: Locale(countryCode!),
    useOnlyLangCode: true,
    supportedLocales: L10n.all,
    path: 'assets/l10n',
    fallbackLocale: L10n.all[0],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PushNotification? _notificationInfo;

  void setGroups(Group newGroup) {
    setState(() {
      _groups?.add(newGroup);
    });
  }

  void upsertGroup(Group group) {
    setState(() {
      if (_groups!.where((element) => element!.id == group.id).isEmpty) {
        _groups!.add(group);
      } else {
        for (var element in _groups!) {
          if (element!.id == group.id) element = group;
        }
      }
    });
  }

  void getGroupEvents(Group group, {DateTime? fromDate, DateTime? toDate}) {
    Repository().getGroupEventsAPI(group).then((value) {
      setState(() {
        _groupEvents = value;
      });
    });
  }

  void addGroupEvent(GroupEvent ge) {
    setState(() {
      Repository().addGroupEventAPI(ge).then((value) {
        _groupEvents!.add(value);
      });
    });
  }

  void setGroupPersons(List<GroupPerson?>? newdataset) {
    setState(() {
      _groupPersons = newdataset;
    });
  }

  void addGroupPerson(GroupPerson gp) {
    setState(() {
      _groupPersons?.add(gp);
    });
  }

  void removeGroupPerson(GroupPerson gp) {
    setState(() {
      _groupPersons!.where((element) => element!.id == gp.id).first!.status = 0;
    });
  }

  void setPersons(List<Person>? persons, List<Person>? newPersons) {
    setState(() {
      persons = newPersons;
    });
  }

  void setPGroupPersons(
      List<GroupPerson>? personGroups, List<GroupPerson>? newPersonGroups) {
    setState(() {
      personGroups = newPersonGroups;
    });
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        // _totalNotifications++;
      });
    }
  }

  @override
  void initState() {
    try {
      registerNotification();
      checkForInitialMessage();
      // For handling notification when the app is in background
      // but not terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          // _totalNotifications++;
        });
      });
    } catch (e) {
      print('main initState $e');
    }
    autologin();
    super.initState();
  }

  late final FirebaseMessaging _messaging;
  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    // 2. Instantiate Firebase Messaging
    _messaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    if (!Platform.isAndroid) {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          print('message: ${message.notification?.body}');
          // Parse the message received
          PushNotification notification = PushNotification(
            title: message.notification?.title,
            body: message.notification?.body,
          );

          setState(() {
            _notificationInfo = notification;
            // _totalNotifications++;
          });
        });
      } else {
        print('User declined or has not accepted permission');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserData(
      user: appUser ?? AppUser(),
      groups: _groups,
      persons: _persons,
      groupPersons: _groupPersons,
      groupEvents: _groupEvents,
      setGroups: setGroups,
      setGroupPersons: setGroupPersons,
      upsertGroup: upsertGroup,
      addGroupPerson: addGroupPerson,
      getGroupEvents: getGroupEvents,
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) =>
              _autoLogin == true ? MyHomePage() : const PhoneAuthScreen(),
          '/groups': (context) => GroupPage(),
          '/add_group': (context) => AddGroupPage(),
          '/add_group_student': (context) => AddStudentFormPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.lightGreen[900],
            secondary: Colors.yellow.shade700,
          ),
        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // home: _autoLogin == true ? MyHomePage() : const PhoneAuthScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }

  @override
  Widget build(BuildContext context) {
    // getFCMToken();

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(LocaleKeys.AlbertName.tr()),
      // ),
      body: managerPages[_currentIndex],
      // Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Text(
      //         'You have pushed the button this many times:' +
      //             LocaleKeys.AlbertName.tr() +
      //             '  ',
      //       ),
      //       Text(
      //         '$_counter',
      //         style: Theme.of(context).textTheme.headlineMedium,
      //       ),
      //       FutureBuilder<List<GroupPerson?>?>(
      //         future: getGroupPersonsByStudent(1),
      //         builder: (BuildContext context,
      //             AsyncSnapshot<List<GroupPerson?>?> snapshot) {
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             // While waiting for the future to complete
      //             return const CircularProgressIndicator();
      //           } else if (snapshot.hasError) {
      //             // If an error occurred during the future execution
      //             return Text('Error: ${snapshot.error}');
      //           } else {
      //             // When the future has completed successfully
      //             return Text('Fetched Data: ${snapshot.data?.length}');
      //           }
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
            print("checking tab index: $index");
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: LocaleKeys.home.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.manage_accounts),
            label: LocaleKeys.manage.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(
              Icons.insert_chart,
            ),
            label: LocaleKeys.Reports.tr(),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('he'),
  ];
}
