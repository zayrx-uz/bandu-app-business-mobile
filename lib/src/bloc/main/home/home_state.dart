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
  final MonitoringData data;

  GetMonitoringSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetMeLoadingState extends HomeState {}

class GetMeSuccessState extends HomeState {
  final LoginModelData data;

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

class GetPlaceLoadingState extends HomeState {}

class SaveEmployeeLoadingState extends HomeState {}

class SaveEmployeeSuccessState extends HomeState {}

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

class ConfirmBookLoadingState extends HomeState {}
class ConfirmBookSuccessState extends HomeState {}

class GetResourceCategoryLoadingState extends HomeState {}

class GetResourceCategorySuccessState extends HomeState {
  final List<ResourceCategoryData> data;

  GetResourceCategorySuccessState({required this.data});

  @override
  List<Object?> get props => [data];
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

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
