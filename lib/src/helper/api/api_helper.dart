class ApiHelper {
  ApiHelper._();

  static const baseUrl = "https://app.bandu.uz/";
  static const uploadUrl = "https://app.bandu.uz";

  static const register = "${baseUrl}api/otp-based-auth/register";
  static const login = "${baseUrl}api/otp-based-auth/login";
  static const otp = "${baseUrl}api/otp-based-auth/complete-registration";
  static const media = "${baseUrl}api/upload/image/user";
  static const getCompany = "${baseUrl}api/company";
  static const getMyCompany = "${baseUrl}api/user/companies";
  static const saveCompany = "${baseUrl}api/company";
  static const getCategory = "${baseUrl}api/categories";
  static const getMonitoring = "${baseUrl}api/booking/my-bookings";
  static const getMe = "${baseUrl}api/user/me";
  static const getPlace = "${baseUrl}api/place/company/";
  static const booking = "${baseUrl}api/booking";
  static const place = "${baseUrl}api/place";
  static const getEmployee = "${baseUrl}api/employee";
  static const getStatistic = "${baseUrl}api/dashboard/statistics";
  static const getResourceCategory = "${baseUrl}api/resource-category";
  static const confirmBook = "${baseUrl}api/booking/";
}
