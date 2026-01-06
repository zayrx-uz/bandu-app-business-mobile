import 'package:bandu_business/src/model/response/booking_send_model.dart';
import 'package:bandu_business/src/model/response/create_company_model.dart';
import 'package:bandu_business/src/model/response/http_result.dart';
import 'package:bandu_business/src/model/response/user_update_model.dart';

abstract class AbstractHomeRepository {
  Future<HttpResult> getCompany();

  Future<HttpResult> saveCompany({required CreateCompanyModel data});

  Future<HttpResult> updateCompany({
    required int companyId,
    required UpdateCompanyModel data,
  });

  Future<HttpResult> deleteCompany({required int companyId});

  Future<HttpResult> getCompanyByCategoryId({
    required int page,
    required int categoryId,
    required String? search,
  });

  Future<HttpResult> getCompanyDetail({required int companyId});

  Future<HttpResult> getPlace({required int companyId});

  Future<HttpResult> setPlace({required String name, required int number});

  Future<HttpResult> updatePlace({
    required int number,
    required int id,
  });

  Future<HttpResult> deletePlace({
    required int id,
  });

  Future<HttpResult> place({required int companyId});

  Future<HttpResult> getCategory();

  Future<HttpResult> getMonitoring();

  Future<HttpResult> getMe();

  Future<HttpResult> getEmployee();

  Future<HttpResult> getResourceCategory();

  Future<HttpResult> getQrCode({required String url});

  Future<HttpResult> confirmBook({required int bookId});

  Future<HttpResult> saveEmployee({
    required String name,
    required String phone,
    required String password,
    required String role,
  });

  Future<HttpResult> uploadImage({required String filePath});

  Future<HttpResult> booking({required BookingSendModel data});

  Future<HttpResult> getStatistic({
    required DateTime date,
    required String period,
  });

  Future<HttpResult> updateUserInfo({required UserUpdateModel data});
}
