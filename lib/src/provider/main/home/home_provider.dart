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
  ///get company
  Future<HttpResult> getCompany() async {
    String url = ApiHelper.getMyCompany;

    return await getRequest(url);
  }

  ///save company
  Future<HttpResult> saveCompany(CreateCompanyModel data) async {
    return await postRequest(ApiHelper.saveCompany, data.toJson());
  }

  ///update company
  Future<HttpResult> updateCompany(int id, UpdateCompanyModel data) async {
    return await patchRequest("${ApiHelper.getCompany}/$id", data.toJson());
  }

  ///delete company
  Future<HttpResult> deleteCompany(int id) async {
    return await deleteRequest("${ApiHelper.getCompany}/$id");
  }

  ///get company by category
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

  ///get categories
  Future<HttpResult> getCategories() async {
    return await getRequest(ApiHelper.getCategory);
  }

  ///get company detail
  Future<HttpResult> getCompanyDetail(int companyId) async {
    return await getRequest("${ApiHelper.getCompany}/$companyId");
  }

  ///get monitoring
  Future<HttpResult> getMonitoring() async {
    return await getRequest(ApiHelper.getMonitoring);
  }

  ///get me
  Future<HttpResult> getMe() async {
    return await getRequest(ApiHelper.getMe);
  }

  ///update user info
  Future<HttpResult> updateUserInfo(UserUpdateModel data) async {
    return await patchRequest(ApiHelper.getMe, data.toJson());
  }

  ///get place
  Future<HttpResult> getPlace(int companyId) async {
    return await getRequest("${ApiHelper.getPlace}$companyId");
  }

  ///get place
  Future<HttpResult> place(int companyId) async {
    return await getRequest("${ApiHelper.getPlace}$companyId");
  }

  ///set place
  Future<HttpResult> setPlace(String name, int number) async {
    var body = {
      "companyId": HelperFunctions.getCompanyId(),
      "name": name,
      "capacity": number,
    };
    return await postRequest(ApiHelper.place, body);
  }


  ///update place
  Future<HttpResult> updatePlace(int number , int id) async {
    var body = {
      "capacity": number,
    };
    return await patchRequest("${ApiHelper.place}/$id", body);
  }


  ///delete place
  Future<HttpResult> deletePlace(int id) async {
    return await deleteRequest("${ApiHelper.place}/$id");
  }

  ///booking
  Future<HttpResult> booking(BookingSendModel data) async {
    return await postRequest(ApiHelper.booking, data.toJson());
  }

  ///get employee
  Future<HttpResult> getEmployee() async {
    return await getRequest(
      "${ApiHelper.getEmployee}?companyId=${HelperFunctions.getCompanyId()}",
    );
  }

  ///remove employee
  Future<HttpResult> deleteEmployee({required int id }) async {
    return await deleteRequest(
      "${ApiHelper.getCompany}/${HelperFunctions.getCompanyId()}/members/$id",
    );
  }

  ///get qr code
  Future<HttpResult> getQrCode(String url) async {
    return await getRequest(url);
  }

  ///get resource category
  Future<HttpResult> getResourceCategory({required int companyId}) async {
    return await getRequest("${ApiHelper.getResourceCategory}/company/$companyId");
  }

  ///create resource category
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

  ///delete resource category
  Future<HttpResult> deleteResourceCategory({required int id}) async {
    return await deleteRequest("${ApiHelper.deleteResourceCategory}$id");
  }

  ///upload resource image
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

  ///create resource
  Future<HttpResult> createResource({
    required String name,
    required int companyId,
    required int price,
    required int resourceCategoryId,
    Map<String, dynamic>? metadata,
    required bool isBookable,
    required bool isTimeSlotBased,
    required int timeSlotDurationMinutes,
    required List<Map<String, dynamic>> images,
  }) async {
    var body = {
      "name": name,
      "companyId": companyId,
      "price": price,
      "resourceCategoryId": resourceCategoryId,
      "isBookable": isBookable,
      "isTimeSlotBased": isTimeSlotBased,
      "timeSlotDurationMinutes": timeSlotDurationMinutes,
      "images": images,
    };
    if (metadata != null) {
      body["metadata"] = metadata;
    }
    return await postRequest(ApiHelper.createResource, body);
  }

  ///get resource
  Future<HttpResult> getResource({required int id}) async {
    return await getRequest("${ApiHelper.getResource}/company/$id");
  }


  ///delete resource
  Future<HttpResult> deleteResource({required int id}) async {
    return await deleteRequest("${ApiHelper.getResource}/$id");
  }

  ///confirm booking
  Future<HttpResult> confirmBook(int bookId) async {
    var body = {"status": "confirmed", "note": ""};
    return await patchRequest("${ApiHelper.confirmBook}$bookId/status", body);
  }

  ///save employee
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


  ///update employee
  Future<HttpResult> updateEmployee(
    String name,
    String phone,
    int id,
    String role,

  ) async {
    var body = {
      "fullName": name,
      "phoneNumber": phone.replaceAll(" ", ""),
      "role": role,
    };
    return await patchRequest("${ApiHelper.saveCompany}/${HelperFunctions.getCompanyId()}/members/$id", body);
  }

  ///get statistic
  Future<HttpResult> getStatistic(DateTime date, String period) async {
    var body = {
      "period": period,
      "date": "${date.year}",
      "companyId": HelperFunctions.getCompanyId(),
    };
    return await postRequest(ApiHelper.getStatistic, body);
  }

  ///media
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
}
