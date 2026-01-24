import 'package:bandu_business/src/helper/service/rx_bus.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/auth/login_model.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/model/api/main/home/category_model.dart';
import 'package:bandu_business/src/model/api/main/home/company_detail_model.dart';
import 'package:bandu_business/src/model/api/main/home/company_model.dart';
import 'package:bandu_business/src/model/api/main/home/icon_model.dart' as icon_model;
import 'package:bandu_business/src/model/api/main/home/place_model.dart';
import 'package:bandu_business/src/model/api/main/home/resource_category_model.dart' as resource_category;
import 'package:bandu_business/src/model/api/main/monitoring/monitoring_model.dart';
import 'package:bandu_business/src/model/api/main/place/place_business_model.dart';
import 'package:bandu_business/src/model/api/main/alice/alice_checker_model.dart';
import 'package:bandu_business/src/model/api/main/qr/book_model.dart';
import 'package:bandu_business/src/model/api/main/qr/place_model.dart';
import 'package:bandu_business/src/model/api/main/resource_category_model/resource_model.dart' as resource_model;
import 'package:bandu_business/src/model/api/main/statistic/statistic_model.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_summary_model.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_places_empty_model.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_places_booked_model.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_employees_empty_model.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_employees_booked_model.dart';
import 'package:bandu_business/src/model/api/main/dashboard/dashboard_revenue_series_model.dart';
import 'package:bandu_business/src/model/api/main/booking/owner_booking_model.dart';
import 'package:bandu_business/src/model/api/main/booking/booking_detail_model.dart';
import 'package:bandu_business/src/model/response/booking_send_model.dart';
import 'package:bandu_business/src/model/response/create_company_model.dart';
import 'package:bandu_business/src/model/response/user_update_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeInitial()) {
    on<GetCompanyEvent>(_onGetCompany);
    on<GetCategoryEvent>(_onGetCategory);
    on<GetCompanyWithFilterEvent>(_onGetCompanyByCategory);
    on<GetCompanyDetailEvent>(_onGetCompanyDetail);
    on<CompanyDetailChangeOpacityEvent>(_onCompanyDetailChangeOpacity);
    on<ResourceCategoryChangeEvent>(_onResourceCategoryChange);
    on<ResourceSearchEvent>(_onResourceSearch);
    on<GetMonitoringEvent>(_getMonitoring);
    on<GetMeEvent>(_onGetMe);
    on<GetImageEvent>(_getImage);
    on<UserUpdateEvent>(_onUserUpdate);
    on<GetPlaceEvent>(_onGetPlace);
    on<GetPlaceBusinessEvent>(_onGetPlaceBusiness);
    on<BookingEvent>(_onBooking);
    on<SetPlaceEvent>(_onSetPlace);
    on<UpdatePlaceEvent>(_updatePlace);
    on<DeletePlaceEvent>(_deletePlace);
    on<GetStatisticEvent>(_onGetStatistic);
    on<GetEmployeeEvent>(_onGetEmployee);
    on<GetMyCompanyEvent>(_onGetMyCompany);
    on<GetMyCompaniesEvent>(_onGetMyCompanies);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
    on<SaveCompanyEvent>(_onSaveCompany);
    on<UpdateCompanyEvent>(_onUpdateCompany);
    on<DeleteCompanyEvent>(_onDeleteCompany);
    on<SaveEmployeeEvent>(_onSaveEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<GetQrCodeEvent>(_onGetQrCode);
    on<GetQrBookCodeEvent>(_onGetQrBookCode);
    on<ConfirmBookEvent>(_onConfirmBook);
    on<GetResourceCategoryEvent>(_onGetResourceCategory);
    on<CreateResourceCategoryEvent>(_onCreateResourceCategory);
    on<UploadResourceImageEvent>(_onUploadResourceImage);
    on<CreateResourceEvent>(_onCreateResource);
    on<EditResourceEvent>(_onEditResource);
    on<GetResourceEvent>(_onGetResourceEvent);
    on<DeleteResourceEvent>(_onDeleteResourceEvent);
    on<DeleteResourceCategoryEvent>(_onDeleteResourceCategory);
    on<CheckAlicePaymentEvent>(_onCheckAlicePayment);
    on<GetOwnerBookingsEvent>(_onGetOwnerBookings);
    on<GetBookingDetailEvent>(_onGetBookingDetail);
    on<UpdateBookingStatusEvent>(_onUpdateBookingStatus);
    on<CancelBookingEvent>(_onCancelBooking);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<GetEmptyPlacesEvent>(_onGetEmptyPlaces);
    on<GetBookedPlacesEvent>(_onGetBookedPlaces);
    on<GetEmptyEmployeesEvent>(_onGetEmptyEmployees);
    on<GetBookedEmployeesEvent>(_onGetBookedEmployees);
    on<GetRevenueSeriesEvent>(_onGetRevenueSeries);
    on<GetIconsEvent>(_onGetIcons);
    on<ExtendTimeEvent>(_onExtendTime);
  }

  void _onExtendTime(ExtendTimeEvent event, Emitter<HomeState> emit) async {
    emit(ExtendTimeLoadingState());
    try {
      final result = await homeRepository.extendTime(bookingId: event.bookingId);
      if (result.isSuccess) {
        emit(ExtendTimeSuccessState(bookingId: event.bookingId));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetCompany(GetCompanyEvent event, Emitter<HomeState> emit) async {
    emit(GetCompanyLoadingState());
    try {
      final result = await homeRepository.getCompany();
      if (result.isSuccess) {
        final companyModel = CompanyModel.fromJson(result.result);
        final companyDataList = CompanyDataList(
          data: companyModel.data,
          meta: Meta.empty(),
          message: companyModel.message,
        );
        emit(GetCompanySuccessState(data: companyDataList));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onGetCategory(GetCategoryEvent event, Emitter<HomeState> emit) async {
    emit(GetCategoryLoadingState());
    try {
      final result = await homeRepository.getCategory();
      if (result.isSuccess) {
        final categoryModel = CategoryModel.fromJson(result.result);
        final categoryDataList = CategoryDataList(
          data: categoryModel.data,
          message: categoryModel.message,
        );
        emit(GetCategorySuccessState(data: categoryDataList));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onGetCompanyByCategory(
    GetCompanyWithFilterEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetCompanyByCategoryLoadingState(categoryId: event.categoryId));
    try {
      final result = await homeRepository.getCompanyByCategoryId(
        page: event.page,
        categoryId: event.categoryId,
        search: event.search,
      );
      if (result.isSuccess) {
        final companyModel = CompanyModel.fromJson(result.result);
        final companyDataList = CompanyDataList(
          data: companyModel.data,
          meta: Meta.empty(),
          message: companyModel.message,
        );
        emit(GetCompanyByCategorySuccessState(data: companyDataList));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onGetCompanyDetail(
    GetCompanyDetailEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetCompanyDetailLoadingState());
    try {
      final result = await homeRepository.getCompanyDetail(
        companyId: event.companyId,
      );
      if (result.isSuccess) {
        final companyDetailModel = CompanyDetailModel.fromJson(result.result);
        if (companyDetailModel.data.icon != null && companyDetailModel.data.icon!.url.isNotEmpty) {
          CacheService.savePlaceIcon(companyDetailModel.data.icon!.url);
          RxBus.post(1, tag: "PLACE_ICON_UPDATED");
        } else {
          CacheService.savePlaceIcon('');
          RxBus.post(1, tag: "PLACE_ICON_UPDATED");
        }
        emit(GetCompanyDetailSuccessState(data: companyDetailModel.data));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onResourceCategoryChange(
    ResourceCategoryChangeEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeInitial());
    emit(ResourceCategoryChangedState(categoryId: event.categoryId));
  }

  void _onResourceSearch(ResourceSearchEvent event, Emitter<HomeState> emit) {
    emit(HomeInitial());
    emit(ResourceSearchState(search: event.search));
  }

  void _onCompanyDetailChangeOpacity(
    CompanyDetailChangeOpacityEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(HomeInitial());
    emit(CompanyDetailOpacityChangedState(opacity: event.opacity));
  }

  void _getMonitoring(GetMonitoringEvent event, Emitter<HomeState> emit) async {
    emit(GetMonitoringLoadingState());
    try {
      final result = await homeRepository.getMonitoring();
      if (result.isSuccess) {
        final model = MonitoringModel.fromJson(result.result);
        emit(GetMonitoringSuccessState(data: model.data));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }


  void _getImage(GetImageEvent event, Emitter<HomeState> emit) async {
    final pick = ImagePicker();

    try {
      if (event.isSelfie) {
        var status = await Permission.camera.status;

        if (status.isDenied) {
          status = await Permission.camera.request();
        }

        if (status.isPermanentlyDenied) {
          await openAppSettings();
          return;
        }

        if (status.isGranted) {
          try {
            final img = await pick.pickImage(
              source: ImageSource.camera,
              imageQuality: 70,
              maxWidth: 1920,
              maxHeight: 1920,
            );
            if (img != null) {
              emit(GetImageSuccessState(img: img));
            }
          } catch (e) {
            if (e.toString().contains('already_active')) {
              await Future.delayed(const Duration(milliseconds: 300));
              try {
                final img = await pick.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 70,
                  maxWidth: 1920,
                  maxHeight: 1920,
                );
                if (img != null) {
                  emit(GetImageSuccessState(img: img));
                }
              } catch (e2) {
                emit(HomeErrorState(message: "Kamera ochib bo'lmadi. Iltimos, qayta urinib ko'ring."));
              }
            } else {
              emit(HomeErrorState(message: e.toString()));
            }
          }
        } else {
          emit(HomeErrorState(message: "Kamera ruxsati berilmadi"));
        }
      } else {
        try {
          final img = await pick.pickImage(
            source: ImageSource.gallery,
            imageQuality: 70,
            maxWidth: 1920,
            maxHeight: 1920,
          );
          if (img != null) {
            emit(GetImageSuccessState(img: img));
          }
        } catch (e) {
          if (e.toString().contains('already_active')) {
            await Future.delayed(const Duration(milliseconds: 300));
            try {
              final img = await pick.pickImage(
                source: ImageSource.gallery,
                imageQuality: 70,
                maxWidth: 1920,
                maxHeight: 1920,
              );
              if (img != null) {
                emit(GetImageSuccessState(img: img));
              }
            } catch (e2) {
              emit(HomeErrorState(message: "Rasm tanlab bo'lmadi. Iltimos, qayta urinib ko'ring."));
            }
          } else {
            emit(HomeErrorState(message: e.toString()));
          }
        }
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onGetMe(GetMeEvent event, Emitter<HomeState> emit) async {
    emit(GetMeLoadingState());
    try {
      final result = await homeRepository.getMe();
      if (result.isSuccess) {
        final data = LoginModel.fromJson(result.result);
        emit(GetMeSuccessState(data: data));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onUserUpdate(UserUpdateEvent event, Emitter<HomeState> emit) async {
    emit(UserUpdateLoadingState());
    try {
      var data = event.data;
      if (data.profilePicture.isNotEmpty &&
          !data.profilePicture.startsWith("http")) {
        final response = await homeRepository.uploadImage(
          filePath: data.profilePicture,
        );
        if (response.isSuccess) {
          data.profilePicture = response.result['data']['url'];
        } else {
          emit(
            HomeErrorState(message: HelperFunctions.errorText(response.result)),
          );
          return;
        }
      }
      final result = await homeRepository.updateUserInfo(data: data);
      if (result.isSuccess) {
        final dt = LoginModel.fromJson(result.result);
        HelperFunctions.saveLoginData(dt);
        emit(UserUpdateSuccessState());
        final getMeResult = await homeRepository.getMe();
        if (getMeResult.isSuccess) {
          final meData = LoginModel.fromJson(getMeResult.result);
          emit(GetMeSuccessState(data: meData));
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetPlace(GetPlaceEvent event, Emitter<HomeState> emit) async {
    emit(GetPlaceLoadingState());
    try {
      final result = await homeRepository.getPlace(companyId: event.companyId);
      if (result.isSuccess) {
        final placeModel = PlaceModel.fromJson(result.result);
        final placeData = PlaceData(
          data: placeModel.data,
          message: placeModel.message,
        );
        final data = placeData.data;
        emit(GetPlaceSuccessState(data: data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetPlaceBusiness(
    GetPlaceBusinessEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetPlaceBusinessLoadingState());
    try {
      final result = await homeRepository.place(companyId: event.companyId);
      if (result.isSuccess) {
        final placeBusinessModel = PlaceBusinessModel.fromJson(result.result);
        emit(GetPlaceBusinessSuccessState(data: placeBusinessModel.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onBooking(BookingEvent event, Emitter<HomeState> emit) async {
    emit(BookingLoadingState());
    try {
      final result = await homeRepository.booking(data: event.data);
      if (result.isSuccess) {
        emit(BookingSuccessState());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onSetPlace(SetPlaceEvent event, Emitter<HomeState> emit) async {
    emit(SetPlaceLoadingState());
    try {
      final result = await homeRepository.setPlace(
        name: event.name,
        number: event.number,
        employeeIds: event.employeeIds,
      );
      if (result.isSuccess) {
        emit(SetPlaceSuccessState());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _updatePlace(UpdatePlaceEvent event, Emitter<HomeState> emit) async {
    emit(UpdatePlaceLoadingState());
    try {
      final result = await homeRepository.updatePlace(
        number: event.number,
        id: event.id,
        name: event.name,
        employeeIds: event.employeeIds,
      );
      if (result.isSuccess) {
        emit(UpdatePlaceSuccessState());
        final companyId = HelperFunctions.getCompanyId() ?? 0;
        if (companyId > 0) {
          add(GetPlaceBusinessEvent(companyId: companyId));
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _deletePlace(DeletePlaceEvent event, Emitter<HomeState> emit) async {
    emit(DeletePlaceLoadingState());
    try {
      final result = await homeRepository.deletePlace(id: event.id);
      if (result.isSuccess) {
        emit(DeletePlaceSuccessState());
        final companyId = HelperFunctions.getCompanyId() ?? 0;
        if (companyId > 0) {
          add(GetPlaceBusinessEvent(companyId: companyId));
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetStatistic(GetStatisticEvent event, Emitter<HomeState> emit) async {
    emit(GetStatisticLoadingState());
    try {
      final result = await homeRepository.getStatistic(
        date: event.date,
        period: event.period,
      );
      if (result.isSuccess) {
        final dashboardSummaryModel = DashboardSummaryModel.fromJson(result.result);
        final dashboardData = dashboardSummaryModel.data;
        final data = StatisticItemData(
          period: event.period,
          date: dashboardData.date,
          year: dashboardData.date.split("-").first,
          totalRevenue: dashboardData.dailyIncome.amount.toInt(),
          totalCustomers: dashboardData.incomingCustomers.count,
          totalPlaces: dashboardData.places.bookedNowCount,
          totalEmptyPlaces: dashboardData.places.emptyNowCount,
          newCustomers: [],
          revenuePercentageChange: dashboardData.dailyIncome.changePercent.toInt(),
          customersPercentageChange: dashboardData.incomingCustomers.changePercent.toInt(),
          placesPercentageChange: 0,
          monthlyData: null,
          employeesTotalCount: dashboardData.employees.totalCount,
          employeesBookedNowCount: dashboardData.employees.bookedNowCount,
          employeesEmptyNowCount: dashboardData.employees.emptyNowCount,
        );
        emit(GetStatisticSuccessState(data: data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetEmployee(GetEmployeeEvent event, Emitter<HomeState> emit) async {
    emit(GetEmployeeLoadingState());
    try {
      final result = await homeRepository.getEmployee();
      if (result.isSuccess) {
        final data = EmployeeModel.fromJson(result.result).data;
        emit(GetEmployeeSuccessState(data: data));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onGetMyCompany(GetMyCompanyEvent event, Emitter<HomeState> emit) async {
    emit(GetMyCompanyLoadingState());
    try {
      final result = await homeRepository.getMyCompany();
      if (result.isSuccess) {
        final companyData = CompanyData.fromJson(result.result["data"]);
        if (companyData.icon != null && companyData.icon!.url.isNotEmpty) {
          CacheService.savePlaceIcon(companyData.icon!.url);
          RxBus.post(1, tag: "PLACE_ICON_UPDATED");
        } else {
          CacheService.savePlaceIcon('');
          RxBus.post(1, tag: "PLACE_ICON_UPDATED");
        }
        emit(GetMyCompanySuccessState(data: companyData));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onGetMyCompanies(GetMyCompaniesEvent event, Emitter<HomeState> emit) async {
    emit(GetCompanyLoadingState());
    try {
      final result = await homeRepository.getMyCompanies();
      if (result.isSuccess) {
        final companyModel = CompanyModel.fromJson(result.result);
        final companyDataList = CompanyDataList(
          data: companyModel.data,
          meta: Meta.empty(),
          message: companyModel.message,
        );
        emit(GetCompanySuccessState(data: companyDataList));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(DeleteEmployeeLoadingState());
    try {
      final result = await homeRepository.deleteEmployee(id: event.id);
      if (result.isSuccess) {
        emit(DeleteEmployeeSuccessState());
        add(GetEmployeeEvent());
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onSaveCompany(SaveCompanyEvent event, Emitter<HomeState> emit) async {
    emit(SaveCompanyLoadingState());
    try {
      var data = event.data;
      
      if (data.images.isNotEmpty && !data.images[0].url.startsWith("http")) {
        var imgUrl = "";
        final response = await homeRepository.uploadImage(
          filePath: data.images[0].url,
        );
        if (response.isSuccess) {
          imgUrl = response.result['data']['url'];
          data.images = [ImageCreateModel(url: imgUrl, index: 1, isMain: true)];
        } else {
          emit(
            HomeErrorState(message: HelperFunctions.errorText(response.result)),
          );
          return;
        }
      }
      
      final result = await homeRepository.saveCompany(data: data);
      if (result.isSuccess) {
        emit(SaveCompanySuccessState());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onUpdateCompany(
    UpdateCompanyEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(UpdateCompanyLoadingState(companyId: event.companyId));
    try {
      var data = event.data;
      for (int i = 0; i < data.images.length; i++) {
        final img = data.images[i];
        if (!img.url.startsWith("http")) {
          final response = await homeRepository.uploadImage(filePath: img.url);
          if (response.isSuccess) {
            data.images[i] = ImageCreateModel(
              url: response.result['data']['url'],
              index: img.index,
              isMain: img.isMain,
            );
          } else {
            emit(
              HomeErrorState(
                message: HelperFunctions.errorText(response.result),
              ),
            );
            return;
          }
        }
      }

      final result = await homeRepository.updateCompany(
        companyId: event.companyId,
        data: data,
      );
      if (result.isSuccess) {
        emit(UpdateCompanySuccessState(companyId: event.companyId));
        add(GetCompanyEvent());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onDeleteCompany(
    DeleteCompanyEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(DeleteCompanyLoadingState(companyId: event.companyId));
    try {
      final result = await homeRepository.deleteCompany(
        companyId: event.companyId,
      );
      if (result.isSuccess) {
        emit(DeleteCompanySuccessState(companyId: event.companyId));
        add(GetCompanyEvent());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onSaveEmployee(SaveEmployeeEvent event, Emitter<HomeState> emit) async {
    emit(SaveEmployeeLoadingState());
    try {
      final result = await homeRepository.saveEmployee(
        name: event.name,
        phone: event.phone,
        password: event.password,
        role: event.role,
      );
      if (result.isSuccess) {
        emit(SaveEmployeeSuccessState());
        add(GetEmployeeEvent());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onUpdateEmployee(
    UpdateEmployeeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(UpdateEmployeeLoadingState());
    try {
      final result = await homeRepository.updateEmployee(
        name: event.name,
        phone: event.phone,
        id: event.id,
        role: event.role,
        password: event.password,
        resourceIds: event.resourceIds,
      );
      if (result.isSuccess) {
        emit(UpdateEmployeeSuccessState());
        add(GetEmployeeEvent());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetQrCode(GetQrCodeEvent event, Emitter<HomeState> emit) async {
    emit(GetQRCodeLoadingState());
    try {
      final result = await homeRepository.getQrCode(url: event.url);
      if (result.isSuccess) {
        final data = QrPlaceModel.fromJson(result.result);
        emit(GetQRCodeSuccessState(data: data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetQrBookCode(
    GetQrBookCodeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetQRCodeLoadingState());
    try {
      final result = await homeRepository.getQrCode(url: event.url);
      if (result.isSuccess) {
        final model = BookModel.fromJson(result.result);
        emit(GetQRBookCodeSuccessState(data: model.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onConfirmBook(ConfirmBookEvent event, Emitter<HomeState> emit) async {
    emit(ConfirmBookLoadingState());
    try {
      final result = await homeRepository.confirmBook(bookId: event.bookId);
      if (result.isSuccess) {
        emit(ConfirmBookSuccessState());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetResourceCategory(
    GetResourceCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    if (state is GetResourceCategoryLoadingState) {
      return;
    }
    
    emit(GetResourceCategoryLoadingState());
    try {
      final result = await homeRepository.getResourceCategory(companyId: event.companyId);
      if (result.isSuccess) {
        if (result.result is Map<String, dynamic>) {
          final model = resource_category.ResourceCategoryModel.fromJson(result.result as Map<String, dynamic>);
          emit(GetResourceCategorySuccessState(data: model.data));
        } else {
          emit(GetResourceCategorySuccessState(data: <resource_category.ResourceCategoryData>[]));
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onCreateResourceCategory(
    CreateResourceCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    List<resource_category.ResourceCategoryData>? currentCategories;
    
    if (currentState is GetResourceCategorySuccessState) {
      currentCategories = List.from(currentState.data);
    }
    
    final parentCategory = event.parentId != null
        ? resource_category.Category(
            id: event.parentId!,
            name: "",
          )
        : null;
    
    final newCategory = resource_category.ResourceCategoryData(
      id: 0,
      name: event.name,
      description: event.description,
      parent: parentCategory,
      children: [],
      metadata: event.metadata,
    );
    
    if (currentCategories != null) {
      final updatedCategories = List<resource_category.ResourceCategoryData>.from(currentCategories);
      if (event.parentId != null) {
        final parentIndex = updatedCategories.indexWhere((c) => c.id == event.parentId);
        if (parentIndex != -1) {
          final parent = updatedCategories[parentIndex];
          final parentChildren = List<resource_category.Category>.from(parent.children);
          parentChildren.add(resource_category.Category(
            id: 0,
            name: event.name,
            description: event.description,
            metadata: event.metadata,
          ));
          updatedCategories[parentIndex] = resource_category.ResourceCategoryData(
            id: parent.id,
            name: parent.name,
            description: parent.description,
            parent: parent.parent,
            children: parentChildren,
            metadata: parent.metadata,
          );
        } else {
          updatedCategories.add(newCategory);
        }
      } else {
        updatedCategories.add(newCategory);
      }
      emit(GetResourceCategorySuccessState(data: updatedCategories));
    }
    
    try {
      final result = await homeRepository.createResourceCategory(
        name: event.name,
        description: event.description,
        parentId: event.parentId,
        companyId: event.companyId,
        metadata: event.metadata,
      );
      
      if (result.isSuccess) {
        resource_category.ResourceCategoryData? createdCategory;
        if (result.result is Map<String, dynamic> && 
            result.result.containsKey('data') &&
            result.result['data'] is Map<String, dynamic>) {
          try {
            final categoryData = result.result['data'];
            createdCategory = resource_category.ResourceCategoryData(
              id: categoryData['id'] is int 
                  ? categoryData['id'] 
                  : (categoryData['id'] != null ? int.tryParse(categoryData['id'].toString()) ?? 0 : 0),
              name: categoryData['name']?.toString() ?? event.name,
              description: categoryData['description']?.toString() ?? event.description,
              parent: event.parentId != null 
                  ? resource_category.Category(id: event.parentId!, name: "")
                  : null,
              children: [],
              metadata: categoryData['metadata'] ?? event.metadata,
            );
            emit(CreateResourceCategorySuccessState(data: createdCategory));
          } catch (e) {
          }
        }
        
        final refreshResult = await homeRepository.getResourceCategory(companyId: event.companyId);
        if (refreshResult.isSuccess) {
          if (refreshResult.result is Map<String, dynamic>) {
            final model = resource_category.ResourceCategoryModel.fromJson(refreshResult.result as Map<String, dynamic>);
            emit(GetResourceCategorySuccessState(data: model.data));
          } else {
            if (currentCategories != null) {
              emit(GetResourceCategorySuccessState(data: currentCategories));
            }
          }
        } else {
          if (currentCategories != null) {
            emit(GetResourceCategorySuccessState(data: currentCategories));
          }
        }
      } else {
        if (currentCategories != null) {
          final index = currentCategories.indexWhere((c) => c.id == 0 && c.name == event.name);
          if (index != -1) {
            currentCategories.removeAt(index);
            emit(GetResourceCategorySuccessState(data: currentCategories));
          }
        }
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      if (currentCategories != null) {
        final index = currentCategories.indexWhere((c) => c.id == 0 && c.name == event.name);
        if (index != -1) {
          currentCategories.removeAt(index);
          emit(GetResourceCategorySuccessState(data: currentCategories));
        }
      }
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onUploadResourceImage(
    UploadResourceImageEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(UploadResourceImageLoadingState());
    try {
      final result = await homeRepository.uploadResourceImage(filePath: event.filePath);
      if (result.isSuccess) {
        if (result.result is Map && 
            result.result.containsKey('data') &&
            result.result['data'] is Map) {
          final data = result.result['data'];
          emit(UploadResourceImageSuccessState(
            url: data['url'] ?? '',
            filename: data['filename'] ?? '',
            mimeType: data['mimeType'] ?? '',
            size: data['size'] ?? 0,
          ));
        } else {
          emit(HomeErrorState(message: HelperFunctions.errorText("Invalid response format")));
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onCreateResource(
    CreateResourceEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(CreateResourceLoadingState());
    try {
      final result = await homeRepository.createResource(
        name: event.name,
        companyId: event.companyId,
        price: event.price,
        resourceCategoryId: event.resourceCategoryId,
        metadata: event.metadata,
        isBookable: event.isBookable,
        isTimeSlotBased: event.isTimeSlotBased,
        timeSlotDurationMinutes: event.timeSlotDurationMinutes,
        employeeIds: event.employeeIds,
      );
      if (result.isSuccess) {
        int? resourceId;
        if (result.result is Map && result.result.containsKey('data')) {
          final data = result.result['data'];
          if (data is Map && data.containsKey('id')) {
            resourceId = data['id'] is int ? data['id'] : int.tryParse(data['id'].toString());
          }
        }
        
        if (resourceId != null && event.images.isNotEmpty) {
          final imagesResult = await homeRepository.postResourceImages(
            resourceId: resourceId,
            images: event.images,
          );
          if (!imagesResult.isSuccess) {
            emit(HomeErrorState(message: HelperFunctions.errorText(imagesResult.result)));
            return;
          }
        }
        
        emit(CreateResourceSuccessState());
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onEditResource(
    EditResourceEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(EditResourceLoadingState());
    try {
      final result = await homeRepository.updateResource(
        id: event.id,
        name: event.name,
        companyId: event.companyId,
        price: event.price,
        resourceCategoryId: event.resourceCategoryId,
        metadata: event.metadata,
        isBookable: event.isBookable,
        isTimeSlotBased: event.isTimeSlotBased,
        timeSlotDurationMinutes: event.timeSlotDurationMinutes,
        employeeIds: event.employeeIds,
      );
      if (result.isSuccess) {
        List<Map<String, dynamic>> newImages = [];
        List<Map<String, dynamic>> existingImagesToUpdate = [];
        
        for (var image in event.images) {
          if (image.containsKey('id') && image['id'] != null && image['id'] != 0) {
            existingImagesToUpdate.add(image);
          } else {
            newImages.add(image);
          }
        }
        
        if (newImages.isNotEmpty) {
          List<Map<String, dynamic>> processedNewImages = [];
          for (var image in newImages) {
            var imageUrl = image['url']?.toString() ?? '';
            if (imageUrl.isNotEmpty && !imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
              final uploadResult = await homeRepository.uploadResourceImage(filePath: imageUrl);
              if (uploadResult.isSuccess) {
                if (uploadResult.result is Map && 
                    uploadResult.result.containsKey('data') &&
                    uploadResult.result['data'] is Map) {
                  final data = uploadResult.result['data'];
                  imageUrl = data['url'] ?? imageUrl;
                } else {
                  emit(HomeErrorState(message: HelperFunctions.errorText("Invalid upload response format")));
                  return;
                }
              } else {
                emit(HomeErrorState(message: HelperFunctions.errorText(uploadResult.result)));
                return;
              }
            }
            processedNewImages.add({
              ...image,
              'url': imageUrl,
            });
          }
          
          final postImagesResult = await homeRepository.postResourceImages(
            resourceId: event.id,
            images: processedNewImages,
          );
          if (!postImagesResult.isSuccess) {
            emit(HomeErrorState(message: HelperFunctions.errorText(postImagesResult.result)));
            return;
          }
        }
        
        final replacedIds = event.replacedImageIds ?? [];
        for (var image in existingImagesToUpdate) {
          final imageId = image['id'];
          var imageUrl = image['url']?.toString() ?? '';
          if (imageId == null || imageUrl.isEmpty) continue;

          final id = imageId is int ? imageId : int.tryParse(imageId.toString()) ?? 0;
          if (id <= 0 || !replacedIds.contains(id)) continue;

          if (!imageUrl.startsWith('http://') && !imageUrl.startsWith('https://')) {
            final uploadResult = await homeRepository.uploadResourceImage(filePath: imageUrl);
            if (uploadResult.isSuccess &&
                uploadResult.result is Map &&
                uploadResult.result.containsKey('data') &&
                uploadResult.result['data'] is Map) {
              final data = uploadResult.result['data'];
              imageUrl = (data['url'] ?? imageUrl).toString();
            } else {
              emit(HomeErrorState(message: HelperFunctions.errorText(
                  uploadResult.result ?? "Invalid upload response format")));
              return;
            }
          }

          final isMain = image['isMain'] == true;
          final patchResult = await homeRepository.patchResourceImage(
            resourceId: event.id,
            imageId: id,
            url: imageUrl,
            isMain: isMain,
          );
          if (!patchResult.isSuccess) {
            emit(HomeErrorState(message: HelperFunctions.errorText(patchResult.result)));
            return;
          }
        }
        
        emit(EditResourceSuccessState());
        int companyId = CacheService.getInt("select_company") ?? 0;
        if (companyId > 0) {
          final refreshResult = await homeRepository.getResource(id: companyId);
          if (refreshResult.isSuccess) {
            final data = resource_model.ResourceModel.fromJson(refreshResult.result);
            emit(GetResourceSuccessState(data: data));
          }
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetResourceEvent(
    GetResourceEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetResourceLoadingState());
    try {
      int id = CacheService.getInt("select_company") ?? 0;
      final result = await homeRepository.getResource(id: id);
      if (result.isSuccess) {
        final data = resource_model.ResourceModel.fromJson(result.result);
        emit(GetResourceSuccessState(data: data));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }

  void _onDeleteResourceCategory(
    DeleteResourceCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final currentState = state;
      List<resource_category.ResourceCategoryData>? currentCategories;
      
      if (currentState is GetResourceCategorySuccessState) {
        currentCategories = List.from(currentState.data);
        currentCategories.removeWhere((cat) => cat.id == event.id);
        
        for (var cat in List.from(currentCategories)) {
          if (cat.parent?.id == event.id) {
            currentCategories.remove(cat);
          }
        }
        
        emit(DeleteResourceCategoryLoadingState(categoryId: event.id));
        emit(GetResourceCategorySuccessState(data: currentCategories));
      } else {
        emit(DeleteResourceCategoryLoadingState(categoryId: event.id));
      }

      final result = await homeRepository.deleteResourceCategory(id: event.id);
      if (result.isSuccess) {
        final companyId = HelperFunctions.getCompanyId() ?? 0;
        if (companyId > 0) {
          final refreshResult = await homeRepository.getResourceCategory(companyId: companyId);
          if (refreshResult.isSuccess && refreshResult.result is Map<String, dynamic>) {
            final model = resource_category.ResourceCategoryModel.fromJson(refreshResult.result as Map<String, dynamic>);
            emit(GetResourceCategorySuccessState(data: model.data));
          }
        }
        emit(DeleteResourceCategorySuccessState(categoryId: event.id));
      } else {
        if (currentCategories != null) {
          final companyId = HelperFunctions.getCompanyId() ?? 0;
          if (companyId > 0) {
            final refreshResult = await homeRepository.getResourceCategory(companyId: companyId);
            if (refreshResult.isSuccess && refreshResult.result is Map<String, dynamic>) {
              final model = resource_category.ResourceCategoryModel.fromJson(refreshResult.result as Map<String, dynamic>);
              emit(GetResourceCategorySuccessState(data: model.data));
            }
          }
        }
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onDeleteResourceEvent(
    DeleteResourceEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    resource_model.ResourceModel? currentResourceData;
    
    if (currentState is GetResourceSuccessState) {
      currentResourceData = currentState.data;
    }
    
    emit(DeleteResourceLoadingState(resourceId: event.id));
    try {
      final result = await homeRepository.deleteResource(id: event.id);
      if (result.isSuccess) {
        emit(DeleteResourceSuccessState(resourceId: event.id));
        int companyId = CacheService.getInt("select_company") ?? 0;
        if (companyId > 0) {
          final refreshResult = await homeRepository.getResource(id: companyId);
          if (refreshResult.isSuccess) {
            final data = resource_model.ResourceModel.fromJson(refreshResult.result);
            emit(GetResourceSuccessState(data: data));
          }
        }
      } else {
        if (currentResourceData != null) {
          emit(GetResourceSuccessState(data: currentResourceData));
        } else {
          emit(HomeErrorState(message: result.error.toString()));
        }
      }
    } catch (e) {
      if (currentResourceData != null) {
        emit(GetResourceSuccessState(data: currentResourceData));
      } else {
        emit(HomeErrorState(message: e.toString()));
      }
    }
  }

  void _onCheckAlicePayment(
    CheckAlicePaymentEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(CheckAlicePaymentLoadingState());
    try {
      final result = await homeRepository.checkAlicePayment(
        transactionId: event.transactionId,
        bookingId: event.bookingId,
      );
      if (result.isSuccess) {
        final data = AliceCheckerModel.fromJson(result.result);
        emit(CheckAlicePaymentSuccessState(
          isPaid: data.success,
          message: data.message,
        ));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetOwnerBookings(
    GetOwnerBookingsEvent event,
    Emitter<HomeState> emit,
  ) async {
    final currentState = state;
    List<OwnerBookingItemData> currentData = [];
    OwnerBookingMeta? currentMeta;

    if (currentState is GetOwnerBookingsSuccessState && event.page > 1) {
      currentData = List.from(currentState.data);
      currentMeta = currentState.meta;
      emit(GetOwnerBookingsSuccessState(
        data: currentData,
        meta: currentMeta,
        isLoadMore: true,
      ));
    } else {
      emit(GetOwnerBookingsLoadingState());
    }

    try {
      final result = await homeRepository.getOwnerBookings(
        page: event.page,
        limit: event.limit,
        companyId: event.companyId,
      );
      if (result.isSuccess) {
        final model = OwnerBookingModel.fromJson(result.result);
        if (event.page > 1 && currentData.isNotEmpty) {
          currentData.addAll(model.data);
          emit(GetOwnerBookingsSuccessState(
            data: currentData,
            meta: model.meta,
            isLoadMore: false,
          ));
        } else {
          emit(GetOwnerBookingsSuccessState(
            data: model.data,
            meta: model.meta,
            isLoadMore: false,
          ));
        }
      } else {
        if (currentData.isNotEmpty && currentMeta != null) {
          emit(GetOwnerBookingsSuccessState(
            data: currentData,
            meta: currentMeta,
            isLoadMore: false,
          ));
        } else {
          emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
        }
      }
    } catch (e) {
      if (currentData.isNotEmpty && currentMeta != null) {
        emit(GetOwnerBookingsSuccessState(
          data: currentData,
          meta: currentMeta,
          isLoadMore: false,
        ));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(e)));
      }
    }
  }

  void _onGetBookingDetail(
    GetBookingDetailEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetBookingDetailLoadingState());
    try {
      final result = await homeRepository.getBookingDetail(bookingId: event.bookingId);
      if (result.isSuccess) {
        final model = BookingDetailModel.fromJson(result.result);
        emit(GetBookingDetailSuccessState(data: model.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onUpdateBookingStatus(
    UpdateBookingStatusEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(UpdateBookingStatusLoadingState());
    try {
      final result = await homeRepository.updateBookingStatus(
        bookingId: event.bookingId,
        status: event.status,
        note: event.note,
      );
      if (result.isSuccess) {
        emit(UpdateBookingStatusSuccessState(bookingId: event.bookingId));
        final companyId = HelperFunctions.getCompanyId() ?? 0;
        if (companyId > 0) {
          final currentState = state;
          if (currentState is GetOwnerBookingsSuccessState) {
            add(GetOwnerBookingsEvent(
              page: currentState.meta.page,
              limit: 10,
              companyId: companyId,
            ));
          } else {
            add(GetOwnerBookingsEvent(
              page: 1,
              limit: 10,
              companyId: companyId,
            ));
          }
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(ConfirmPaymentLoadingState(paymentId: event.paymentId));
    try {
      final result = await homeRepository.confirmPayment(id: event.paymentId);
      if (result.isSuccess) {
        emit(ConfirmPaymentSuccessState(paymentId: event.paymentId));
        final currentState = state;
        if (currentState is GetBookingDetailSuccessState) {
          final bookingId = currentState.data.id;
          final refreshResult = await homeRepository.getBookingDetail(bookingId: bookingId);
          if (refreshResult.isSuccess) {
            final bookingDetailModel = BookingDetailModel.fromJson(refreshResult.result);
            emit(GetBookingDetailSuccessState(data: bookingDetailModel.data));
          }
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onCancelBooking(
    CancelBookingEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(CancelBookingLoadingState());
    try {
      final result = await homeRepository.cancelBooking(
        bookingId: event.bookingId,
        note: event.note,
      );
      if (result.isSuccess) {
        emit(CancelBookingSuccessState(bookingId: event.bookingId));
        final companyId = HelperFunctions.getCompanyId() ?? 0;
        if (companyId > 0) {
          final currentState = state;
          if (currentState is GetOwnerBookingsSuccessState) {
            add(GetOwnerBookingsEvent(
              page: currentState.meta.page,
              limit: 10,
              companyId: companyId,
            ));
          } else {
            add(GetOwnerBookingsEvent(
              page: 1,
              limit: 10,
              companyId: companyId,
            ));
          }
        }
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetEmptyPlaces(
    GetEmptyPlacesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetEmptyPlacesLoadingState());
    try {
      final result = await homeRepository.getDashboardPlacesEmpty(
        companyId: event.companyId,
        date: event.date,
        clientDateTime: event.clientDateTime,
      );
      if (result.isSuccess) {
        final model = DashboardPlacesEmptyModel.fromJson(result.result);
        emit(GetEmptyPlacesSuccessState(data: model.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetBookedPlaces(
    GetBookedPlacesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetBookedPlacesLoadingState());
    try {
      final result = await homeRepository.getDashboardPlacesBooked(
        companyId: event.companyId,
        date: event.date,
        clientDateTime: event.clientDateTime,
      );
      if (result.isSuccess) {
        final model = DashboardPlacesBookedModel.fromJson(result.result);
        emit(GetBookedPlacesSuccessState(data: model.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetEmptyEmployees(
    GetEmptyEmployeesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetEmptyEmployeesLoadingState());
    try {
      final result = await homeRepository.getDashboardEmployeesEmpty(
        companyId: event.companyId,
        date: event.date,
        clientDateTime: event.clientDateTime,
      );
      if (result.isSuccess) {
        final model = DashboardEmployeesEmptyModel.fromJson(result.result);
        emit(GetEmptyEmployeesSuccessState(data: model.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetBookedEmployees(
    GetBookedEmployeesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetBookedEmployeesLoadingState());
    try {
      final result = await homeRepository.getDashboardEmployeesBooked(
        companyId: event.companyId,
        date: event.date,
        clientDateTime: event.clientDateTime,
      );
      if (result.isSuccess) {
        final model = DashboardEmployeesBookedModel.fromJson(result.result);
        emit(GetBookedEmployeesSuccessState(data: model.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetRevenueSeries(
    GetRevenueSeriesEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(GetRevenueSeriesLoadingState());
    try {
      final result = await homeRepository.getDashboardRevenueSeries(
        companyId: event.companyId,
        period: event.period,
        date: event.date,
        clientDateTime: event.clientDateTime,
      );
      if (result.isSuccess) {
        final model = DashboardRevenueSeriesModel.fromJson(result.result);
        emit(GetRevenueSeriesSuccessState(data: model.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }

  void _onGetIcons(GetIconsEvent event, Emitter<HomeState> emit) async {
    emit(GetIconsLoadingState());
    try {
      final result = await homeRepository.getIcons();
      if (result.isSuccess) {
        final iconModel = icon_model.IconModel.fromJson(result.result);
        emit(GetIconsSuccessState(data: iconModel.data));
      } else {
        emit(HomeErrorState(message: HelperFunctions.errorText(result.result)));
      }
    } catch (e) {
      emit(HomeErrorState(message: HelperFunctions.errorText(e)));
    }
  }
}
