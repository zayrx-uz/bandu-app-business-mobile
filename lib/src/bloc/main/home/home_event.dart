part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCompanyEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class GetCategoryEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class GetCompanyWithFilterEvent extends HomeEvent {
  final int page;
  final int? categoryId;
  final String? search;

  GetCompanyWithFilterEvent({
    required this.page,
    required this.categoryId,
    this.search,
  });

  @override
  List<Object?> get props => [page, categoryId, search];
}

class CompanyDetailChangeOpacityEvent extends HomeEvent {
  final double opacity;

  CompanyDetailChangeOpacityEvent({required this.opacity});

  @override
  List<Object?> get props => [opacity];
}

class GetCompanyDetailEvent extends HomeEvent {
  final int companyId;

  GetCompanyDetailEvent({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class ResourceCategoryChangeEvent extends HomeEvent {
  final int categoryId;

  ResourceCategoryChangeEvent({required this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class GetMonitoringEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class GetMeEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class GetImageEvent extends HomeEvent {
  final bool isSelfie;

  GetImageEvent({required this.isSelfie});

  @override
  List<Object?> get props => [isSelfie];
}

class UserUpdateEvent extends HomeEvent {
  final UserUpdateModel data;

  UserUpdateEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetPlaceEvent extends HomeEvent {
  final int companyId;

  GetPlaceEvent({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class BookingEvent extends HomeEvent {
  final BookingSendModel data;

  BookingEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetPlaceBusinessEvent extends HomeEvent {
  final int companyId;

  GetPlaceBusinessEvent({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class SetPlaceEvent extends HomeEvent {
  final String name;
  final int number;
  final List<int>? employeeIds;

  SetPlaceEvent({
    required this.name,
    required this.number,
    this.employeeIds,
  });

  @override
  List<Object?> get props => [name, number, employeeIds];
}


class UpdatePlaceEvent extends HomeEvent {
  final int number;
  final int id;
  final String? name;
  final List<int>? employeeIds;

  UpdatePlaceEvent({
    required this.number,
    required this.id,
    this.name,
    this.employeeIds,
  });

  @override
  List<Object?> get props => [number, id, name, employeeIds];
}


class DeletePlaceEvent extends HomeEvent {
  final int id;

  DeletePlaceEvent({required this.id});

  @override
  List<Object?> get props => [ id];
}

class GetStatisticEvent extends HomeEvent {
  final DateTime date;
  final String period;

  GetStatisticEvent({required this.date, required this.period});

  @override
  List<Object?> get props => [date, period];
}

class GetEmployeeEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class GetMyCompanyEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class GetMyCompaniesEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class DeleteEmployeeEvent extends HomeEvent {
  final int id;

  DeleteEmployeeEvent(this.id);

  @override
  List<Object?> get props => [];
}

class SaveCompanyEvent extends HomeEvent {
  final CreateCompanyModel data;

  SaveCompanyEvent({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateCompanyEvent extends HomeEvent {
  final int companyId;
  final UpdateCompanyModel data;

  UpdateCompanyEvent({required this.companyId, required this.data});

  @override
  List<Object?> get props => [companyId, data];
}

class DeleteCompanyEvent extends HomeEvent {
  final int companyId;

  DeleteCompanyEvent({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class SaveEmployeeEvent extends HomeEvent {
  final String name;
  final String phone;
  final String password;
  final String role;

  SaveEmployeeEvent({
    required this.name,
    required this.phone,
    required this.password,
    required this.role,
  });

  @override
  List<Object?> get props => [name, phone, password, role];
}


class UpdateEmployeeEvent extends HomeEvent {
  final String name;
  final String phone;
  final String role;
  final int id;
  final String? password;
  final List<int>? resourceIds;

  UpdateEmployeeEvent({
    required this.name,
    required this.phone,
    required this.role,
    required this.id,
    this.password,
    this.resourceIds,
  });

  @override
  List<Object?> get props => [name, phone, role, id, password, resourceIds];
}

class GetQrCodeEvent extends HomeEvent {
  final String url;

  GetQrCodeEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

class GetQrBookCodeEvent extends HomeEvent {
  final String url;

  GetQrBookCodeEvent({required this.url});

  @override
  List<Object?> get props => [url];
}

class ConfirmBookEvent extends HomeEvent {
  final int bookId;

  ConfirmBookEvent({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class GetResourceCategoryEvent extends HomeEvent {
  final int companyId;

  GetResourceCategoryEvent({required this.companyId});

  @override
  List<Object?> get props => [companyId];
}

class CreateResourceCategoryEvent extends HomeEvent {
  final String name;
  final String? description;
  final int? parentId;
  final int companyId;
  final Map<String, dynamic>? metadata;

  CreateResourceCategoryEvent({
    required this.name,
    this.description,
    this.parentId,
    required this.companyId,
    this.metadata,
  });

  @override
  List<Object?> get props => [name, description, parentId, companyId, metadata];
}

class DeleteResourceCategoryEvent extends HomeEvent {
  final int id;

  DeleteResourceCategoryEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class UploadResourceImageEvent extends HomeEvent {
  final String filePath;

  UploadResourceImageEvent({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class CreateResourceEvent extends HomeEvent {
  final String name;
  final int companyId;
  final int price;
  final int resourceCategoryId;
  final Map<String, dynamic>? metadata;
  final bool isBookable;
  final bool isTimeSlotBased;
  final int timeSlotDurationMinutes;
  final List<Map<String, dynamic>> images;
  final List<int>? employeeIds;

  CreateResourceEvent({
    required this.name,
    required this.companyId,
    required this.price,
    required this.resourceCategoryId,
    this.metadata,
    required this.isBookable,
    required this.isTimeSlotBased,
    required this.timeSlotDurationMinutes,
    required this.images,
    this.employeeIds,
  });

  @override
  List<Object?> get props => [
        name,
        companyId,
        price,
        resourceCategoryId,
        metadata,
        isBookable,
        isTimeSlotBased,
        timeSlotDurationMinutes,
        images,
        employeeIds,
      ];
}

class ResourceSearchEvent extends HomeEvent {
  final String search;

  ResourceSearchEvent({required this.search});

  @override
  List<Object?> get props => [search];
}


class GetResourceEvent extends HomeEvent {
  final int id;

  GetResourceEvent({required this.id});

  @override
  List<Object?> get props => [id];
}


class DeleteResourceEvent extends HomeEvent {
  final int id;

  DeleteResourceEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class EditResourceEvent extends HomeEvent {
  final int id;
  final String name;
  final int companyId;
  final int price;
  final int resourceCategoryId;
  final Map<String, dynamic>? metadata;
  final bool isBookable;
  final bool isTimeSlotBased;
  final int timeSlotDurationMinutes;
  final List<Map<String, dynamic>> images;
  final List<int>? employeeIds;
  final List<int>? replacedImageIds;

  EditResourceEvent({
    required this.id,
    required this.name,
    required this.companyId,
    required this.price,
    required this.resourceCategoryId,
    this.metadata,
    required this.isBookable,
    required this.isTimeSlotBased,
    required this.timeSlotDurationMinutes,
    required this.images,
    this.employeeIds,
    this.replacedImageIds,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        companyId,
        price,
        resourceCategoryId,
        metadata,
        isBookable,
        isTimeSlotBased,
        timeSlotDurationMinutes,
        images,
        employeeIds,
        replacedImageIds,
      ];
}

class CheckAlicePaymentEvent extends HomeEvent {
  final String transactionId;
  final int bookingId;

  CheckAlicePaymentEvent({
    required this.transactionId,
    required this.bookingId,
  });

  @override
  List<Object?> get props => [transactionId, bookingId];
}

class GetOwnerBookingsEvent extends HomeEvent {
  final int page;
  final int limit;
  final int companyId;

  GetOwnerBookingsEvent({
    required this.page,
    required this.limit,
    required this.companyId,
  });

  @override
  List<Object?> get props => [page, limit, companyId];
}

class GetBookingDetailEvent extends HomeEvent {
  final int bookingId;

  GetBookingDetailEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class UpdateBookingStatusEvent extends HomeEvent {
  final int bookingId;
  final String status;
  final String? note;

  UpdateBookingStatusEvent({
    required this.bookingId,
    required this.status,
    this.note,
  });

  @override
  List<Object?> get props => [bookingId, status, note];
}

class CancelBookingEvent extends HomeEvent {
  final int bookingId;
  final String note;

  CancelBookingEvent({
    required this.bookingId,
    required this.note,
  });

  @override
  List<Object?> get props => [bookingId, note];
}

class ConfirmPaymentEvent extends HomeEvent {
  final int paymentId;

  ConfirmPaymentEvent({required this.paymentId});

  @override
  List<Object?> get props => [paymentId];
}

class GetEmptyPlacesEvent extends HomeEvent {
  final int? companyId;
  final String? date;
  final String? clientDateTime;

  GetEmptyPlacesEvent({
    this.companyId,
    this.date,
    this.clientDateTime,
  });

  @override
  List<Object?> get props => [companyId, date, clientDateTime];
}

class GetBookedPlacesEvent extends HomeEvent {
  final int? companyId;
  final String? date;
  final String? clientDateTime;

  GetBookedPlacesEvent({
    this.companyId,
    this.date,
    this.clientDateTime,
  });

  @override
  List<Object?> get props => [companyId, date, clientDateTime];
}

class GetEmptyEmployeesEvent extends HomeEvent {
  final int? companyId;
  final String? date;
  final String? clientDateTime;

  GetEmptyEmployeesEvent({
    this.companyId,
    this.date,
    this.clientDateTime,
  });

  @override
  List<Object?> get props => [companyId, date, clientDateTime];
}

class GetBookedEmployeesEvent extends HomeEvent {
  final int? companyId;
  final String? date;
  final String? clientDateTime;

  GetBookedEmployeesEvent({
    this.companyId,
    this.date,
    this.clientDateTime,
  });

  @override
  List<Object?> get props => [companyId, date, clientDateTime];
}

class GetRevenueSeriesEvent extends HomeEvent {
  final int? companyId;
  final String? period;
  final String? date;
  final String? clientDateTime;

  GetRevenueSeriesEvent({
    this.companyId,
    this.period,
    this.date,
    this.clientDateTime,
  });

  @override
  List<Object?> get props => [companyId, period, date, clientDateTime];
}

class ExtendTimeEvent extends HomeEvent {
  final int bookingId;

  ExtendTimeEvent({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}

class GetIconsEvent extends HomeEvent {
  @override
  List<Object?> get props => [];
}
