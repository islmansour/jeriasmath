import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Model/lookup_table.dart';
import 'package:jerias_math/Model/payment.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/person_group.dart';
import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/Model/student_attendance.dart';
import 'package:jerias_math/services/stream_groups.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class ApiBaseHelper {
  late String? _baseUrl;
  Map<String, String> headers = {
    'content-type': 'application/json',
  };

//http://143-42-54-17.ip.linodeusercontent.com:8000
  String get apiURL => "http://127.0.0.1:8000";

  //String ipaddress = '139.162.139.161';
  //final String _baseUrl = 'http://127.0.0.1:8000';
  //final String _baseUrl = 'http://139.162.139.161:8000';

  Future<dynamic> get(String url, {var queryParams}) async {
    var _pref = await SharedPreferences.getInstance();
    _baseUrl = 'http://127.0.0.1:8000'; //_pref.get('ipAddress').toString();

    try {
      if (!url.contains('get_user_by_uid')) {
        final String? userId = _pref.getString('username');
        if (userId != null) headers['UID'] = userId;
      } else {}
    } catch (e) {
      //print('API 001 error: $e');
    }
    var responseJson;

    //print('api [get]: ' + _baseUrl! + url);

    try {
      if (_baseUrl != null) {
        var newUrl;
        final baseUrl = Uri.parse(_baseUrl! + url);
        if (queryParams != null) {
          newUrl = baseUrl.replace(queryParameters: queryParams);
        }

        final response = await http
            .get(Uri.parse((newUrl ?? baseUrl).toString()), headers: headers);
        responseJson = _returnResponse(response);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getUserOperations(String url) async {
    var _pref = await SharedPreferences.getInstance();
    _baseUrl = "http://arabapps.biz:8000";

    try {
      if (!url.contains('get_user_by_uid')) {
        final String? userId = _pref.getString('username');
        headers['UID'] = userId!;
      } else {}
    } catch (e) {
      //print('API 001 error: $e');
    }
    var responseJson;
    try {
      final response =
          await http.get(Uri.parse(_baseUrl! + url), headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, {Object? body}) async {
// Make a POST request with the CSRF token
    var responseJson;

    try {
      final response = await http.post(Uri.parse('http://127.0.0.1:8000/$url/'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body));
      // final response = await http.get(Uri.parse(_baseUrl + url));
      try {
        responseJson = _returnResponse(response);
      } catch (e) {
        throw FetchDataException('$e');
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postUserOperations(String url, {Object? body}) async {
    _baseUrl = "http://arabapps.biz:8000";
    // _baseUrl = 'http://127.0.0.1:8000';
    var responseJson;

    try {
      final response = await http.post(Uri.parse(_baseUrl! + url),
          headers: headers, body: jsonEncode(body));
      // final response = await http.get(Uri.parse(_baseUrl + url));
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 201:
      case 200:
        var responseJson = utf8.decode(response.body.runes.toList());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode} [${response.request!.url.toString()}]');
    }
  }
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class ApiResponse<T> {
  Status? status;
  T? data;
  String? message;

  ApiResponse.loading(this.message) : status = Status.LOADING;
  ApiResponse.completed(this.data) : status = Status.COMPLETED;
  ApiResponse.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR } // TO BE USED IN BLOC

class Repository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<List<Group?>?> getGroupsAPI() async {
    final response = await _helper.get("/groups");

    return groupFromJson(response);
  }

  Future<List<Person?>?> getPersonsAPI() async {
    final response = await _helper.get("/people");
    return personFromJson(response);
  }

  Future<List<LookupTable?>?> getLookupTableAPI() async {
    final response = await _helper.get("/lookup-table-data");
    return lookupTableFromJson(response);
  }

  Future<List<GroupPerson?>?> getGroupPersonsAPI() async {
    final response = await _helper.get("/group_people");
    return groupPersonFromJson(response);
  }

  Future<Group?> upsertGroupsAPI(var record) async {
    var response = await _helper.post(
      "group/upsert",
      body: record,
    );
    var responseData = jsonDecode(response);

    var groupData = responseData['upsert_group'];
    forceUpdateGroupData();
    return Group.fromJson(groupData);
  }

  Future<int?> createPersonsAPI(var record) async {
    var response = await _helper.post(
      "add-person",
      body: record,
    );
    var responseData = jsonDecode(response);
    var newPersonId = responseData['id'];
    forceUpdatePersonsData();
    return newPersonId;
  }

  Future<GroupPerson?> createGroupPersonAPI(var record) async {
    var response = await _helper.post(
      "create-group-person",
      body: record,
    );

    var responseData = jsonDecode(response);

    var groupPersonData = responseData['group_person'];
    forceUpdategroupPersonsData();
    return GroupPerson.fromJson(groupPersonData);
  }

  Future<GroupPerson?> createPaymentAPI(Payment record) async {
    var response = await _helper.post(
      "create_payment",
      body: record.toJson(),
    );

    var responseData = jsonDecode(response);

    return GroupPerson.fromJson(responseData);
  }

  Future<List<GroupEvent?>?> getGroupEventsAPI(Group? group,
      {DateTime? from, DateTime? to}) async {
    Map<String, dynamic> queryParams = {
      'group_id': group!.id.toString(),
    };
    if (from != null) {
      final fromDate = '${from.year}-${from.month}-${from.day}';
      queryParams['from_date'] = fromDate;
    }
    if (to != null) {
      final toDate = '${to.year}-${to.month}-${to.day}';
      queryParams['to_date'] = toDate;
    }
    final response =
        await _helper.get("/group-event/search/", queryParams: queryParams);

    return groupEventFromJson(response);
  }

  Future<List<Purchase?>?> getStudentPurchasesAPI(Person? student,
      {DateTime? from, DateTime? to}) async {
    Map<String, dynamic> queryParams = {
      'student_id': student!.id.toString(),
    };

    final response =
        await _helper.get("/purchases/search/", queryParams: queryParams);

    return purchaseFromJson(response);
  }

  Future<List<Payment?>?> getPurchasePayments(Purchase? purchase,
      {DateTime? from, DateTime? to}) async {
    final response =
        await _helper.get("/purchase/${purchase!.id.toString()}/payments/");

    return paymentFromJson(response);
  }

  Future<GroupEvent?> addGroupEventAPI(var record) async {
    var response = await _helper.post(
      "group-event/add",
      body: record,
    );

    var responseData = jsonDecode(response);
    var groupEventData = responseData['group_event'];

    return GroupEvent.fromJson(groupEventData);
  }

  Future<StudentAttendance?> addStudentsAttendanceAPI(var record) async {
    var response = await _helper.post(
      "create-student-attendance",
      body: record,
    );

    var responseData = jsonDecode(response);
    var studentsAttance = responseData['student_attendance'];

    return StudentAttendance.fromJson(studentsAttance);
  }

  Future<List<StudentAttendance?>?> getEventStudentsAttanceAPI(
      GroupEvent groupevent) async {
    Map<String, dynamic> queryParams = {
      'groupEvent_id': groupevent.id.toString(),
    };
    var response = await _helper.get("/get-student-attendance-by-group-event/",
        queryParams: queryParams);

    return studentAttendanceFromJson(response);
  }

  Future<List<StudentAttendance?>?> getStudentsAttendanceAPI(
      Person record) async {
    Map<String, dynamic> queryParams = {
      'student_id': record.id.toString(),
    };
    var response = await _helper.get("/search_student_attendance_by_student/",
        queryParams: queryParams);

    return studentAttendanceFromJson(response);
  }

  Future<Purchase?> addStudentsPurchaseAPI(var record) async {
    var response = await _helper.post(
      "purchase/upsert",
      body: record,
    );

    var responseData = jsonDecode(response);
    // var studentsAttance = responseData['student_attendance'];

    return Purchase.fromJson(responseData);
  }
}
