import 'package:bandu_business/src/helper/api/api_helper.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/response/booking_send_model.dart';
import 'package:bandu_business/src/model/response/create_company_model.dart';
import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:bandu_business/src/model/response/user_update_model.dart';
import 'package:bandu_business/src/provider/api_provider.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class HomeProvider extends ApiProvider {
  Future<HttpResult> getCompany() async {
    String url = ApiHelper.getMyCompany;

    return await getRequest(url);
  }

  Future<HttpResult> saveCompany(CreateCompanyModel data) async {
    return await postRequest(ApiHelper.saveCompany, data.toJson());
  }

  Future<HttpResult> updateCompany(int id, UpdateCompanyModel data) async {
    return await patchRequest("${ApiHelper.getCompany}/$id", data.toJson());
  }

  Future<HttpResult> deleteCompany(int id) async {
    return await deleteRequest("${ApiHelper.getCompany}/$id");
  }

  Future<HttpResult> getCompanyByCategory(
    int page,
    int? categoryId,
    String? search,
  ) async {
    String path = "?page=$page&limit=10";
    if (categoryId != null) {
      path += "&categoryId=$categoryId";
    }
    if (search != null) {
      path += "&search=$search";
    }
    return await getRequest("${ApiHelper.getCompany}$path");
  }

  Future<HttpResult> getCategories() async {
    return await getRequest(ApiHelper.getCategory);
  }

  Future<HttpResult> getCompanyDetail(int companyId) async {
    return await getRequest("${ApiHelper.getCompany}/$companyId");
  }

  Future<HttpResult> getMonitoring() async {
    return await getRequest(ApiHelper.getMonitoring);
  }

  Future<HttpResult> getMe() async {
    return await getRequest(ApiHelper.getMe);
  }

  Future<HttpResult> updateUserInfo(UserUpdateModel data) async {
    return await patchRequest(ApiHelper.getMe, data.toJson());
  }

  Future<HttpResult> getPlace(int companyId) async {
    return await getRequest("${ApiHelper.getPlace}$companyId");
  }

  Future<HttpResult> place(int companyId) async {
    return await getRequest("${ApiHelper.getPlace}$companyId");
  }

  Future<HttpResult> setPlace(String name, int number, List<int>? employeeIds) async {
    var body = {
      "name": name,
      "companyId": HelperFunctions.getCompanyId(),
      "capacity": number,
      "positionX": 0,
      "positionY": 0,
      "visualMetadata": {},
      "employeeIds": employeeIds ?? [],
    };
    return await postRequest(ApiHelper.place, body);
  }


  Future<HttpResult> updatePlace({
    required int number,
    required int id,
    String? name,
    List<int>? employeeIds,
  }) async {
    var body = {
      "name": name,
      "capacity": number,
      "positionX": 0,
      "positionY": 0,
      "visualMetadata": {},
      "employeeIds": employeeIds ?? [],
    };
    return await patchRequest("${ApiHelper.place}/$id", body);
  }


  Future<HttpResult> deletePlace(int id) async {
    return await deleteRequest("${ApiHelper.place}/$id");
  }

  Future<HttpResult> booking(BookingSendModel data) async {
    return await postRequest(ApiHelper.booking, data.toJson());
  }

  Future<HttpResult> getEmployee() async {
    return await getRequest(
      "${ApiHelper.getEmployee}?companyId=${HelperFunctions.getCompanyId()}",
    );
  }

  Future<HttpResult> getMyCompany() async {
    return await getRequest(ApiHelper.getEmployeeMyCompany);
  }

  Future<HttpResult> getMyCompanies() async {
    return await getRequest(ApiHelper.getMyCompanies);
  }

  Future<HttpResult> deleteEmployee({required int id }) async {
    return await deleteRequest(
      "${ApiHelper.getEmployee}/$id",
    );
  }

  Future<HttpResult> getQrCode(String url) async {
    return await getRequest(url);
  }

  Future<HttpResult> getResourceCategory({required int companyId}) async {
    return await getRequest("${ApiHelper.getResourceCategory}/company/$companyId");
  }

  Future<HttpResult> createResourceCategory({
    required String name,
    String? description,
    int? parentId,
    required int companyId,
    Map<String, dynamic>? metadata,
  }) async {
    var body = {
      "name": name,
      "companyId": companyId,
    };
    if (description != null && description.isNotEmpty) {
      body["description"] = description;
    }
    if (parentId != null) {
      body["parentId"] = parentId;
    }
    if (metadata != null) {
      body["metadata"] = metadata;
    }
    return await postRequest(ApiHelper.createResourceCategory, body);
  }

  Future<HttpResult> deleteResourceCategory({required int id}) async {
    return await deleteRequest("${ApiHelper.deleteResourceCategory}$id");
  }

  Future<HttpResult> uploadResourceImage(String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiHelper.uploadResourceImage));

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        filePath,
        contentType: MediaType('image', filePath.split(".").last),
      ),
    );

    return await postMultiRequest(request);
  }

  Future<HttpResult> createResource({
    required String name,
    required int companyId,
    required int price,
    required int resourceCategoryId,
    Map<String, dynamic>? metadata,
    required bool isBookable,
    required bool isTimeSlotBased,
    required int timeSlotDurationMinutes,
    List<int>? employeeIds,
  }) async {
    var body = {
      "name": name,
      "companyId": companyId,
      "price": price,
      "resourceCategoryId": resourceCategoryId,
      "isBookable": isBookable,
      "isTimeSlotBased": isTimeSlotBased,
    };
    if (metadata != null) {
      body["metadata"] = metadata;
    }

    if (isTimeSlotBased) {
      body["timeSlotDurationMinutes"] = timeSlotDurationMinutes;
    }
    if (employeeIds != null && employeeIds.isNotEmpty) {
      body["employeeIds"] = employeeIds;
    }
    return await postRequest(ApiHelper.createResource, body);
  }

  Future<HttpResult> postResourceImages({
    required int resourceId,
    required List<Map<String, dynamic>> images,
  }) async {
    var body = {
      "images": images,
    };
    return await postRequest(ApiHelper.postResourceImages(resourceId), body);
  }

  Future<HttpResult> patchResourceImage({
    required int resourceId,
    required int imageId,
    required String url,
    bool isMain = true,
  }) async {
    var body = {
      "url": url,
      "isMain": isMain,
    };
    return await patchRequest(ApiHelper.patchResourceImage(resourceId, imageId), body);
  }

  Future<HttpResult> getResource({required int id}) async {
    return await getRequest("${ApiHelper.getResource}/company/$id");
  }


  Future<HttpResult> deleteResource({required int id}) async {
    return await deleteRequest("${ApiHelper.getResource}/$id");
  }

  Future<HttpResult> updateResource({
    required int id,
    required String name,
    required int companyId,
    required int price,
    required int resourceCategoryId,
    Map<String, dynamic>? metadata,
    required bool isBookable,
    required bool isTimeSlotBased,
    required int timeSlotDurationMinutes,
    List<int>? employeeIds,
  }) async {
    var body = {
      "name": name,
      "companyId": companyId,
      "price": price,
      "resourceCategoryId": resourceCategoryId,
      "isBookable": isBookable,
      "isTimeSlotBased": isTimeSlotBased,
    };
    if (metadata != null) {
      body["metadata"] = metadata;
    }
    if (isTimeSlotBased) {
      body["timeSlotDurationMinutes"] = timeSlotDurationMinutes;
    }
    if (employeeIds != null && employeeIds.isNotEmpty) {
      body["employeeIds"] = employeeIds;
    }
    return await patchRequest("${ApiHelper.getResource}/$id", body);
  }

  Future<HttpResult> confirmBook(int bookId) async {
    var body = {"status": "confirmed", "note": ""};
    return await patchRequest("${ApiHelper.confirmBook}$bookId/status", body);
  }

  Future<HttpResult> savEmploye(
    String name,
    String phone,
    String password,
    String role,
  ) async {
    var body = {
      "fullName": name,
      "phoneNumber": phone.replaceAll(" ", ""),
      "password": password,
      "role": role,
      "companyId": HelperFunctions.getCompanyId(),
    };
    return await postRequest(ApiHelper.getEmployee, body);
  }


  Future<HttpResult> updateEmployee({
    required String name,
    required String phone,
    required int id,
    required String role,
    String? password,
    List<int>? resourceIds,
  }) async {
    var body = {
      "fullName": name,
      "phoneNumber": phone.replaceAll(" ", ""),
      "role": role,
      "companyId": HelperFunctions.getCompanyId(),
    };
    if (password != null && password.isNotEmpty) {
      body["password"] = password;
    }
    if (resourceIds != null && resourceIds.isNotEmpty) {
      body["resourceIds"] = resourceIds;
    }
    return await patchRequest("${ApiHelper.getEmployee}/$id", body);
  }

  Future<HttpResult> getStatistic(DateTime date, String period) async {
    String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    String clientDateTime = DateTime.now().toIso8601String();
    int? companyId = HelperFunctions.getCompanyId();
    if (companyId != null && companyId > 0) {
      return await getDashboardSummary(
        companyId: companyId,
        date: formattedDate,
        clientDateTime: clientDateTime,
      );
    } else {
      return await getDashboardSummary(
        date: formattedDate,
        clientDateTime: clientDateTime,
      );
    }
  }

  Future<HttpResult> uploadImage(String filePath) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiHelper.media));

    request.files.add(
      await http.MultipartFile.fromPath(
        "file",
        filePath,
        contentType: MediaType('image', filePath.split(".").last),
      ),
    );

    return await postMultiRequest(request);
  }

  Future<HttpResult> checkAlicePayment({
    required String transactionId,
    required int bookingId,
  }) async {
    var body = {
      "transactionId": transactionId,
      "bookingId": bookingId,
    };
    return await postRequest(ApiHelper.aliceChecker, body);
  }

  Future<HttpResult> getOwnerBookings({
    required int page,
    required int limit,
    required int companyId,
  }) async {
    String path = "?page=$page&limit=$limit&companyId=$companyId";
    return await getRequest("${ApiHelper.getOwnerBookings}$path");
  }

  Future<HttpResult> getBookingDetail({required int bookingId}) async {
    return await getRequest("${ApiHelper.getBookingDetail}$bookingId");
  }

  Future<HttpResult> extendTime(int bookingId) async {
    return await patchRequest("${ApiHelper.extendTime}$bookingId/extend-time", {
      "note": ""
    });
  }

  Future<HttpResult> updateBookingStatus({
    required int bookingId,
    required String status,
    String? note,
  }) async {
    var body = {
      "status": status,
    };
    if (note != null && note.isNotEmpty) {
      body["note"] = note;
    }
    return await patchRequest("${ApiHelper.updateBookingStatus}$bookingId/status", body);
  }

  Future<HttpResult> cancelBooking({
    required int bookingId,
    required String note,
  }) async {
    var body = {
      "status": "canceled",
      "note": note,
    };
    return await patchRequest("${ApiHelper.updateBookingStatus}$bookingId/status", body);
  }

  Future<HttpResult> getDashboardSummary({
    int? companyId,
    String? date,
    String? clientDateTime,
  }) async {
    String path = "?";
    if (companyId != null) {
      path += "companyId=$companyId&";
    }
    if (date != null) {
      path += "date=${Uri.encodeComponent(date)}&";
    }
    if (clientDateTime != null) {
      path += "clientDateTime=${Uri.encodeComponent(clientDateTime)}&";
    }
    if (path.endsWith("&")) {
      path = path.substring(0, path.length - 1);
    }
    if (path == "?") {
      path = "";
    }
    return await getRequest("${ApiHelper.dashboardSummary}$path");
  }

  Future<HttpResult> getDashboardRevenueSeries({
    int? companyId,
    String? period,
    String? date,
    String? clientDateTime,
  }) async {
    String path = "?";
    if (companyId != null) {
      path += "companyId=$companyId&";
    }
    if (period != null) {
      path += "period=${Uri.encodeComponent(period)}&";
    }
    if (date != null) {
      path += "date=${Uri.encodeComponent(date)}&";
    }
    if (clientDateTime != null) {
      path += "clientDateTime=${Uri.encodeComponent(clientDateTime)}&";
    }
    if (path.endsWith("&")) {
      path = path.substring(0, path.length - 1);
    }
    if (path == "?") {
      path = "";
    }
    return await getRequest("${ApiHelper.dashboardRevenueSeries}$path");
  }

  Future<HttpResult> getDashboardIncomingCustomersSeries({
    int? companyId,
    String? period,
    String? date,
  }) async {
    String path = "?";
    if (companyId != null) {
      path += "companyId=$companyId&";
    }
    if (period != null) {
      path += "period=$period&";
    }
    if (date != null) {
      path += "date=$date&";
    }
    if (path.endsWith("&")) {
      path = path.substring(0, path.length - 1);
    }
    if (path == "?") {
      path = "";
    }
    return await getRequest("${ApiHelper.dashboardIncomingCustomersSeries}$path");
  }

  Future<HttpResult> getDashboardIncomingCustomers({
    int? companyId,
    String? date,
    int? page,
    int? limit,
  }) async {
    String path = "?";
    if (companyId != null) {
      path += "companyId=$companyId&";
    }
    if (date != null) {
      path += "date=$date&";
    }
    if (page != null) {
      path += "page=$page&";
    }
    if (limit != null) {
      path += "limit=$limit&";
    }
    if (path.endsWith("&")) {
      path = path.substring(0, path.length - 1);
    }
    if (path == "?") {
      path = "";
    }
    return await getRequest("${ApiHelper.dashboardIncomingCustomers}$path");
  }

  Future<HttpResult> getDashboardPlacesBooked({
    int? companyId,
    String? date,
    String? clientDateTime,
  }) async {
    String path = "?";
    if (companyId != null) {
      path += "companyId=$companyId&";
    }
    if (date != null) {
      path += "date=${Uri.encodeComponent(date)}&";
    }
    if (clientDateTime != null) {
      path += "clientDateTime=${Uri.encodeComponent(clientDateTime)}&";
    }
    if (path.endsWith("&")) {
      path = path.substring(0, path.length - 1);
    }
    if (path == "?") {
      path = "";
    }
    return await getRequest("${ApiHelper.dashboardPlacesBooked}$path");
  }

  Future<HttpResult> getDashboardPlacesEmpty({
    int? companyId,
    String? date,
    String? clientDateTime,
  }) async {
    String path = "?";
    if (companyId != null) {
      path += "companyId=$companyId&";
    }
    if (date != null) {
      path += "date=${Uri.encodeComponent(date)}&";
    }
    if (clientDateTime != null) {
      path += "clientDateTime=${Uri.encodeComponent(clientDateTime)}&";
    }
    if (path.endsWith("&")) {
      path = path.substring(0, path.length - 1);
    }
    if (path == "?") {
      path = "";
    }
    return await getRequest("${ApiHelper.dashboardPlacesEmpty}$path");
  }

  Future<HttpResult> getDashboardEmployeesEmpty({
    int? companyId,
    String? date,
    String? clientDateTime,
  }) async {
    String path = "?";
    if (companyId != null) {
      path += "companyId=$companyId&";
    }
    if (date != null) {
      path += "date=${Uri.encodeComponent(date)}&";
    }
    if (clientDateTime != null) {
      path += "clientDateTime=${Uri.encodeComponent(clientDateTime)}&";
    }
    if (path.endsWith("&")) {
      path = path.substring(0, path.length - 1);
    }
    if (path == "?") {
      path = "";
    }
    return await getRequest("${ApiHelper.dashboardEmployeesEmpty}$path");
  }

  Future<HttpResult> getDashboardEmployeesBooked({
    int? companyId,
    String? date,
    String? clientDateTime,
  }) async {
    String path = "?";
    if (companyId != null) {
      path += "companyId=$companyId&";
    }
    if (date != null) {
      path += "date=${Uri.encodeComponent(date)}&";
    }
    if (clientDateTime != null) {
      path += "clientDateTime=${Uri.encodeComponent(clientDateTime)}&";
    }
    if (path.endsWith("&")) {
      path = path.substring(0, path.length - 1);
    }
    if (path == "?") {
      path = "";
    }
    return await getRequest("${ApiHelper.dashboardEmployeesBooked}$path");
  }

  Future<HttpResult> confirmPayment({required int id}) async {
    return await postRequest("${ApiHelper.confirmPayment}$id/confirm", {});
  }

  Future<HttpResult> getNotifications({
    required int page,
    required int limit,
  }) async {
    String path = "?page=$page&limit=$limit";
    return await getRequest("${ApiHelper.getNotifications}$path");
  }

  Future<HttpResult> markNotificationAsRead({required int notificationId}) async {
    return await patchRequest("${ApiHelper.markNotificationRead}$notificationId/read", {});
  }

  Future<HttpResult> getIcons() async {
    return await getRequest(ApiHelper.getIcons);
  }
}
