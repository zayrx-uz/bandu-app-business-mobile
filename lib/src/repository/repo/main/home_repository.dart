import 'package:bandu_business/src/model/response/booking_send_model.dart';
import 'package:bandu_business/src/model/response/create_company_model.dart';
import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:bandu_business/src/model/response/user_update_model.dart';
import 'package:bandu_business/src/provider/main/home/home_provider.dart';
import 'package:bandu_business/src/repository/abstract/main/abstract_home_repository.dart';

class HomeRepository implements AbstractHomeRepository {
  final homeProvider = HomeProvider();

  @override
  Future<HttpResult> getCompany() async {
    return await homeProvider.getCompany();
  }

  @override
  Future<HttpResult> getCategory() async {
    return await homeProvider.getCategories();
  }

  @override
  Future<HttpResult> getCompanyByCategoryId({
    required int page,
    required int? categoryId,
    required String? search,
  }) async {
    return await homeProvider.getCompanyByCategory(page, categoryId, search);
  }

  @override
  Future<HttpResult> getCompanyDetail({required int companyId}) async {
    return await homeProvider.getCompanyDetail(companyId);
  }

  @override
  Future<HttpResult> getMonitoring() async {
    return await homeProvider.getMonitoring();
  }

  @override
  Future<HttpResult> getMe() async {
    return await homeProvider.getMe();
  }

  @override
  Future<HttpResult> updateUserInfo({required UserUpdateModel data}) async {
    return await homeProvider.updateUserInfo(data);
  }

  @override
  Future<HttpResult> uploadImage({required String filePath}) async {
    return await homeProvider.uploadImage(filePath);
  }

  @override
  Future<HttpResult> getPlace({required int companyId}) async {
    return await homeProvider.getPlace(companyId);
  }

  @override
  Future<HttpResult> place({required int companyId}) async {
    return await homeProvider.place(companyId);
  }

  @override
  Future<HttpResult> booking({required BookingSendModel data}) async {
    return await homeProvider.booking(data);
  }

  @override
  Future<HttpResult> setPlace({
    required String name,
    required int number,
  }) async {
    return await homeProvider.setPlace(name, number);
  }


  @override
  Future<HttpResult> updatePlace({
    required int number,
    required int id,
  }) async {
    return await homeProvider.updatePlace(number, id);
  }


  @override
  Future<HttpResult> deletePlace({
    required int id,
  }) async {
    return await homeProvider.deletePlace(id);
  }

  @override
  Future<HttpResult> getStatistic({
    required DateTime date,
    required String period,
  }) async {
    return await homeProvider.getStatistic(date, period);
  }

  @override
  Future<HttpResult> getEmployee() async {
    return await homeProvider.getEmployee();
  }


  @override
  Future<HttpResult> deleteEmployee({required int id}) async {
    return await homeProvider.deleteEmployee(id: id);
  }

  @override
  Future<HttpResult> saveCompany({required CreateCompanyModel data}) async {
    return await homeProvider.saveCompany(data);
  }

  @override
  Future<HttpResult> updateCompany({
    required int companyId,
    required UpdateCompanyModel data,
  }) async {
    return await homeProvider.updateCompany(companyId, data);
  }

  @override
  Future<HttpResult> deleteCompany({required int companyId}) async {
    return await homeProvider.deleteCompany(companyId);
  }

  @override
  Future<HttpResult> saveEmployee({
    required String name,
    required String phone,
    required String password,
    required String role,
  }) async {
    return await homeProvider.savEmploye(name, phone, password, role);
  }

  @override
  Future<HttpResult> updateEmployee({
    required String name,
    required String phone,
    required String role,
    required int id,
  }) async {
    return await homeProvider.updateEmployee(name, phone,id , role);
  }

  @override
  Future<HttpResult> getQrCode({required String url}) async {
    return await homeProvider.getQrCode(url);
  }

  @override
  Future<HttpResult> confirmBook({required int bookId}) async {
    return await homeProvider.confirmBook(bookId);
  }

  @override
  Future<HttpResult> getResourceCategory({required int companyId}) async {
    return await homeProvider.getResourceCategory(companyId: companyId);
  }

  @override
  Future<HttpResult> createResourceCategory({
    required String name,
    String? description,
    int? parentId,
    required int companyId,
    Map<String, dynamic>? metadata,
  }) async {
    return await homeProvider.createResourceCategory(
      name: name,
      description: description,
      parentId: parentId,
      companyId: companyId,
      metadata: metadata,
    );
  }

  @override
  Future<HttpResult> deleteResourceCategory({required int id}) async {
    return await homeProvider.deleteResourceCategory(id: id);
  }

  @override
  Future<HttpResult> uploadResourceImage({required String filePath}) async {
    return await homeProvider.uploadResourceImage(filePath);
  }

  @override
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
    return await homeProvider.createResource(
      name: name,
      companyId: companyId,
      price: price,
      resourceCategoryId: resourceCategoryId,
      metadata: metadata,
      isBookable: isBookable,
      isTimeSlotBased: isTimeSlotBased,
      timeSlotDurationMinutes: timeSlotDurationMinutes,
      images: images,
    );
  }

  @override
  Future<HttpResult> getResource({required int id}) async {
    return await homeProvider.getResource(id: id);
  }

  @override
  Future<HttpResult> deleteResource({required int id}) async {
    return await homeProvider.deleteResource(id: id);
  }
}
