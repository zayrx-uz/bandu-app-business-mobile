class ApiHelper {
  ApiHelper._();

  static const devUrl = "https://dev.app.bandu.uz/";
  static const prodUrl = "https://app.bandu.uz/";



  static const baseUrl = devUrl;

  static const uploadUrl = devUrl;

  static const register = "${baseUrl}api/otp-based-auth/register";
  static const login = "${baseUrl}api/otp-based-auth/login";
  static const otp = "${baseUrl}api/otp-based-auth/complete-registration";
  static const forgotPassword = "${baseUrl}api/otp-based-auth/forgot-password";
  static const verifyResetCode = "${baseUrl}api/otp-based-auth/verify-reset-code";
  static const resetPassword = "${baseUrl}api/otp-based-auth/reset-password";
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
  static const getResource = "${baseUrl}api/resource";
  static const createResource = "${baseUrl}api/resource";
  static const uploadResourceImage = "${baseUrl}api/upload/image/resource";
  static const createResourceCategory = "${baseUrl}api/resource-category";
  static const deleteResourceCategory = "${baseUrl}api/resource-category/";
  static const confirmBook = "${baseUrl}api/booking/";
}
