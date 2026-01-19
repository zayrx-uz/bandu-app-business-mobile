part of 'home_bloc.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class GetCompanyLoadingState extends HomeState {}

class GetCompanySuccessState extends HomeState {
  final CompanyDataList data;

  GetCompanySuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetCategoryLoadingState extends HomeState {}

class GetCategorySuccessState extends HomeState {
  final CategoryDataList data;

  GetCategorySuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetCompanyByCategoryLoadingState extends HomeState {
  final int? categoryId;

  GetCompanyByCategoryLoadingState({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class GetCompanyByCategorySuccessState extends HomeState {
  final CompanyDataList data;

  GetCompanyByCategorySuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetCompanyDetailLoadingState extends HomeState {}

class GetCompanyDetailSuccessState extends HomeState {
  final CompanyDetailData data;

  GetCompanyDetailSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class CompanyDetailOpacityChangedState extends HomeState {
  final double opacity;

  CompanyDetailOpacityChangedState({required this.opacity});

  @override
  List<Object?> get props => [opacity];
}

class ResourceCategoryChangedState extends HomeState {
  final int categoryId;

  ResourceCategoryChangedState({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class ResourceSearchState extends HomeState {
  final String search;

  ResourceSearchState({required this.search});

  @override
  List<Object?> get props => [search];
}

class GetMonitoringLoadingState extends HomeState {}

class GetMonitoringSuccessState extends HomeState {
  final List<MonitoringItemData> data;

  GetMonitoringSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetMeLoadingState extends HomeState {}

class GetMeSuccessState extends HomeState {
  final LoginModel data;

  GetMeSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetImageSuccessState extends HomeState {
  final XFile img;

  GetImageSuccessState({required this.img});

  @override
  List<Object?> get props => [img];
}

class UserUpdateLoadingState extends HomeState {}

class UserUpdateSuccessState extends HomeState {}

class SaveCompanyLoadingState extends HomeState {}

class SaveCompanySuccessState extends HomeState {}

class UpdateCompanyLoadingState extends HomeState {
  final int companyId;

  UpdateCompanyLoadingState({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class UpdateCompanySuccessState extends HomeState {
  final int companyId;

  UpdateCompanySuccessState({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class DeleteCompanyLoadingState extends HomeState {
  final int companyId;

  DeleteCompanyLoadingState({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class DeleteCompanySuccessState extends HomeState {
  final int companyId;

  DeleteCompanySuccessState({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class GetPlaceLoadingState extends HomeState {}

class SaveEmployeeLoadingState extends HomeState {}

class SaveEmployeeSuccessState extends HomeState {}


class UpdateEmployeeLoadingState extends HomeState {}

class UpdateEmployeeSuccessState extends HomeState {}

class GetQRCodeLoadingState extends HomeState {}

class GetQRCodeSuccessState extends HomeState {
  final QrPlaceModel data;

  GetQRCodeSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}
class GetQRBookCodeSuccessState extends HomeState {
  final BookingData data;

  GetQRBookCodeSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetPlaceSuccessState extends HomeState {
  final List<PlaceItemData> data;

  GetPlaceSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetPlaceBusinessLoadingState extends HomeState {}

class GetPlaceBusinessSuccessState extends HomeState {
  final List<PlaceBusinessItemData> data;

  GetPlaceBusinessSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class BookingLoadingState extends HomeState {}

class BookingSuccessState extends HomeState {}

class SetPlaceLoadingState extends HomeState {}

class SetPlaceSuccessState extends HomeState {}


class UpdatePlaceLoadingState extends HomeState {}

class UpdatePlaceSuccessState extends HomeState {}

class DeletePlaceLoadingState extends HomeState {}

class DeletePlaceSuccessState extends HomeState {}

class ConfirmBookLoadingState extends HomeState {}
class ConfirmBookSuccessState extends HomeState {}

class GetResourceCategoryLoadingState extends HomeState {}

class GetResourceCategorySuccessState extends HomeState {
  final List<resource_category.ResourceCategoryData> data;

  GetResourceCategorySuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class CreateResourceCategoryLoadingState extends HomeState {}

class CreateResourceCategorySuccessState extends HomeState {
  final resource_category.ResourceCategoryData data;

  CreateResourceCategorySuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class DeleteResourceCategoryLoadingState extends HomeState {
  final int categoryId;

  DeleteResourceCategoryLoadingState({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class DeleteResourceCategorySuccessState extends HomeState {
  final int categoryId;

  DeleteResourceCategorySuccessState({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class UploadResourceImageLoadingState extends HomeState {}

class UploadResourceImageSuccessState extends HomeState {
  final String url;
  final String filename;
  final String mimeType;
  final int size;

  UploadResourceImageSuccessState({
    required this.url,
    required this.filename,
    required this.mimeType,
    required this.size,
  });

  @override
  List<Object?> get props => [url, filename, mimeType, size];
}

class CreateResourceLoadingState extends HomeState {}

class CreateResourceSuccessState extends HomeState {}



class GetResourceLoadingState extends HomeState {}

class GetResourceSuccessState extends HomeState {
  final resource_model.ResourceModel data;

  GetResourceSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}


class DeleteResourceLoadingState extends HomeState {
  final int resourceId;

  DeleteResourceLoadingState({required this.resourceId});

  @override
  List<Object?> get props => [resourceId];
}

class DeleteResourceSuccessState extends HomeState {
  final int resourceId;

  DeleteResourceSuccessState({required this.resourceId});

  @override
  List<Object?> get props => [resourceId];
}

class CheckAlicePaymentLoadingState extends HomeState {}

class CheckAlicePaymentSuccessState extends HomeState {
  final bool isPaid;
  final String message;

  CheckAlicePaymentSuccessState({
    required this.isPaid,
    required this.message,
  });

  @override
  List<Object?> get props => [isPaid, message];
}

class GetStatisticLoadingState extends HomeState {}

class GetStatisticSuccessState extends HomeState {
  final StatisticItemData data;

  GetStatisticSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetEmployeeLoadingState extends HomeState {}

class GetEmployeeSuccessState extends HomeState {
  final List<EmployeeItemData> data;

  GetEmployeeSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}


class DeleteEmployeeLoadingState extends HomeState {}

class DeleteEmployeeSuccessState extends HomeState {}


class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetOwnerBookingsLoadingState extends HomeState {}

class GetOwnerBookingsSuccessState extends HomeState {
  final List<OwnerBookingItemData> data;
  final OwnerBookingMeta meta;
  final bool isLoadMore;

  GetOwnerBookingsSuccessState({
    required this.data,
    required this.meta,
    this.isLoadMore = false,
  });

  @override
  List<Object?> get props => [data, meta, isLoadMore];
}

class GetBookingDetailLoadingState extends HomeState {}

class GetBookingDetailSuccessState extends HomeState {
  final BookingDetailData data;

  GetBookingDetailSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateBookingStatusLoadingState extends HomeState {}

class UpdateBookingStatusSuccessState extends HomeState {
  final int bookingId;

  UpdateBookingStatusSuccessState({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class CancelBookingLoadingState extends HomeState {}

class CancelBookingSuccessState extends HomeState {
  final int bookingId;

  CancelBookingSuccessState({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class GetEmptyPlacesLoadingState extends HomeState {}

class GetEmptyPlacesSuccessState extends HomeState {
  final DashboardPlacesEmptyData data;

  GetEmptyPlacesSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetBookedPlacesLoadingState extends HomeState {}

class GetBookedPlacesSuccessState extends HomeState {
  final DashboardPlacesBookedData data;

  GetBookedPlacesSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetEmptyEmployeesLoadingState extends HomeState {}

class GetEmptyEmployeesSuccessState extends HomeState {
  final DashboardEmployeesEmptyData data;

  GetEmptyEmployeesSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetBookedEmployeesLoadingState extends HomeState {}

class GetBookedEmployeesSuccessState extends HomeState {
  final DashboardEmployeesBookedData data;

  GetBookedEmployeesSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetRevenueSeriesLoadingState extends HomeState {}

class GetRevenueSeriesSuccessState extends HomeState {
  final DashboardRevenueSeriesData data;

  GetRevenueSeriesSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}
