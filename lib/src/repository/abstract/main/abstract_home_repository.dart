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

  Future<HttpResult> getMyCompany();

  Future<HttpResult> getMyCompanies();

  Future<HttpResult> deleteEmployee({required int id});

  Future<HttpResult> getResourceCategory({required int companyId});

  Future<HttpResult> createResourceCategory({
    required String name,
    String? description,
    int? parentId,
    required int companyId,
    Map<String, dynamic>? metadata,
  });

  Future<HttpResult> deleteResourceCategory({required int id});

  Future<HttpResult> uploadResourceImage({required String filePath});

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
    List<int>? employeeIds,
  });

  Future<HttpResult> getResource({required int id});

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
    required List<Map<String, dynamic>> images,
    List<int>? employeeIds,
  });

  Future<HttpResult> deleteResource({required int id});

  Future<HttpResult> getQrCode({required String url});

  Future<HttpResult> confirmBook({required int bookId});

  Future<HttpResult> saveEmployee({
    required String name,
    required String phone,
    required String password,
    required String role,
  });

  Future<HttpResult> updateEmployee({
    required String name,
    required String phone,
    required String role,
    required int id,
  });

  Future<HttpResult> uploadImage({required String filePath});

  Future<HttpResult> booking({required BookingSendModel data});

  Future<HttpResult> getStatistic({
    required DateTime date,
    required String period,
  });

  Future<HttpResult> updateUserInfo({required UserUpdateModel data});

  Future<HttpResult> checkAlicePayment({
    required String transactionId,
    required int bookingId,
  });

  Future<HttpResult> getOwnerBookings({
    required int page,
    required int limit,
    required int companyId,
  });

  Future<HttpResult> getBookingDetail({required int bookingId});

  Future<HttpResult> updateBookingStatus({
    required int bookingId,
    required String status,
    String? note,
  });

  Future<HttpResult> cancelBooking({
    required int bookingId,
    required String note,
  });

  Future<HttpResult> getDashboardSummary({
    int? companyId,
    String? date,
    String? clientDateTime,
  });

  Future<HttpResult> getDashboardRevenueSeries({
    int? companyId,
    String? period,
    String? date,
    String? clientDateTime,
  });

  Future<HttpResult> getDashboardIncomingCustomersSeries({
    int? companyId,
    String? period,
    String? date,
  });

  Future<HttpResult> getDashboardIncomingCustomers({
    int? companyId,
    String? date,
    int? page,
    int? limit,
  });

  Future<HttpResult> getDashboardPlacesBooked({
    int? companyId,
    String? date,
    String? clientDateTime,
  });

  Future<HttpResult> getDashboardPlacesEmpty({
    int? companyId,
    String? date,
    String? clientDateTime,
  });

  Future<HttpResult> getDashboardEmployeesEmpty({
    int? companyId,
    String? date,
    String? clientDateTime,
  });

  Future<HttpResult> getDashboardEmployeesBooked({
    int? companyId,
    String? date,
    String? clientDateTime,
  });

  Future<HttpResult> confirmPayment({required int id});
}
