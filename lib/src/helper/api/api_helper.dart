class ApiHelper {
  ApiHelper._();

  static const devUrl = "https://dev.app.bandu.uz/";
  static const prodUrl = "https://app.bandu.uz/";



  static const baseUrl = prodUrl;

  static const uploadUrl = prodUrl;

  static const register = "${baseUrl}api/otp-based-auth/register";
  static const login = "${baseUrl}api/otp-based-auth/login";
  static const otp = "${baseUrl}api/otp-based-auth/verify-otp";
  static const forgotPassword = "${baseUrl}api/otp-based-auth/forgot-password";
  static const verifyResetCode = "${baseUrl}api/otp-based-auth/verify-reset-code";
  static const resetPassword = "${baseUrl}api/otp-based-auth/reset-password";
  static const registerComplete = "${baseUrl}api/otp-based-auth/complete-registration";
  static const media = "${baseUrl}api/upload/image/user";
  static const getCompany = "${baseUrl}api/company";
  static const getMyCompany = "${baseUrl}api/user/companies";
  static const getMyCompanies = "${baseUrl}api/company/my-companies";
  static const saveCompany = "${baseUrl}api/company";
  static const getCategory = "${baseUrl}api/categories";
  static const getMonitoring = "${baseUrl}api/booking/my-bookings";
  static const getMe = "${baseUrl}api/user/me";
  static const deleteAccount = "${baseUrl}api/user/me";
  static const getPlace = "${baseUrl}api/place/company/";
  static const booking = "${baseUrl}api/booking";
  static const place = "${baseUrl}api/place";
  static const getEmployee = "${baseUrl}api/employee";
  static const getEmployeeMyCompany = "${baseUrl}api/employee/my-company";
  static const getStatistic = "${baseUrl}api/dashboard/statistics";
  static const getResourceCategory = "${baseUrl}api/resource-category";
  static const getResource = "${baseUrl}api/resource";
  static const createResource = "${baseUrl}api/resource";
  static const uploadResourceImage = "${baseUrl}api/upload/image/resource";
  static const createResourceCategory = "${baseUrl}api/resource-category";
  static const deleteResourceCategory = "${baseUrl}api/resource-category/";
  static const confirmBook = "${baseUrl}api/booking/";
  static const aliceChecker = "${baseUrl}api/payment/alice/check";
  static const getOwnerBookings = "${baseUrl}api/booking/owner-bookings";
  static const getBookingDetail = "${baseUrl}api/booking/";
  static const updateBookingStatus = "${baseUrl}api/booking/";
  static const dashboardSummary = "${baseUrl}api/dashboard/summary";
  static const dashboardRevenueSeries = "${baseUrl}api/dashboard/revenue/series";
  static const dashboardIncomingCustomersSeries = "${baseUrl}api/dashboard/incoming-customers/series";
  static const dashboardIncomingCustomers = "${baseUrl}api/dashboard/incoming-customers";
  static const dashboardPlacesBooked = "${baseUrl}api/dashboard/places/booked";
  static const dashboardPlacesEmpty = "${baseUrl}api/dashboard/places/empty";
  static const dashboardEmployeesEmpty = "${baseUrl}api/dashboard/employees/empty";
  static const dashboardEmployeesBooked = "${baseUrl}api/dashboard/employees/booked";
  static const confirmPayment = "${baseUrl}api/payments/";
  static const getNotifications = "${baseUrl}api/notification/my";
  static const markNotificationRead = "${baseUrl}api/notification/";
}
