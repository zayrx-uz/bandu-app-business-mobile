import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/model/api/auth/login_model.dart';
import 'package:bandu_business/src/model/api/main/employee/employee_model.dart';
import 'package:bandu_business/src/model/api/main/home/category_model.dart';
import 'package:bandu_business/src/model/api/main/home/company_detail_model.dart';
import 'package:bandu_business/src/model/api/main/home/company_model.dart';
import 'package:bandu_business/src/model/api/main/home/place_model.dart';
import 'package:bandu_business/src/model/api/main/home/resource_category_model.dart';
import 'package:bandu_business/src/model/api/main/monitoring/monitoring_model.dart';
import 'package:bandu_business/src/model/api/main/place/place_business_model.dart';
import 'package:bandu_business/src/model/api/main/qr/book_model.dart';
import 'package:bandu_business/src/model/api/main/qr/place_model.dart';
import 'package:bandu_business/src/model/api/main/statistic/statistic_model.dart';
import 'package:bandu_business/src/model/response/booking_send_model.dart';
import 'package:bandu_business/src/model/response/create_company_model.dart';
import 'package:bandu_business/src/model/response/user_update_model.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
    on<GetStatisticEvent>(_onGetStatistic);
    on<GetEmployeeEvent>(_onGetEmployee);
    on<SaveCompanyEvent>(_onSaveCompany);
    on<SaveEmployeeEvent>(_onSaveEmployee);
    on<GetQrCodeEvent>(_onGetQrCode);
    on<GetQrBookCodeEvent>(_onGetQrBookCode);
    on<ConfirmBookEvent>(_onConfirmBook);
    on<GetResourceCategoryEvent>(_onGetResourceCategory);
  }

  void _onGetCompany(GetCompanyEvent event, Emitter<HomeState> emit) async {
    emit(GetCompanyLoadingState());
    try {
      final result = await homeRepository.getCompany();
      if (result.isSuccess) {
        final data = CompanyModel.fromJson(result.result).data;
        emit(GetCompanySuccessState(data: data));
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
        final data = CategoryModel.fromJson(result.result).data;
        emit(GetCategorySuccessState(data: data));
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
        final data = CompanyModel.fromJson(result.result).data;
        emit(GetCompanyByCategorySuccessState(data: data));
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
        final data = CompanyDetailModel.fromJson(result.result).data;
        emit(GetCompanyDetailSuccessState(data: data.data));
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
        final data = MonitoringModel.fromJson(result.result).data;
        emit(GetMonitoringSuccessState(data: data));
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
        final img = await pick.pickImage(source: ImageSource.camera);
        if (img != null) {
          emit(GetImageSuccessState(img: img));
        }
      } else {
        final img = await pick.pickImage(source: ImageSource.gallery);
        if (img != null) {
          emit(GetImageSuccessState(img: img));
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
        emit(GetMeSuccessState(data: data.data));
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
      if (data.profilePicture[0] != "h") {
        final response = await homeRepository.uploadImage(
          filePath: data.profilePicture,
        );
        if (response.isSuccess) {
          data.profilePicture = response.result['data']['data']['url'];
        } else {
          emit(
            HomeErrorState(message: HelperFunctions.errorText(response.result)),
          );
          return;
        }
      }
      final result = await homeRepository.updateUserInfo(data: event.data);
      if (result.isSuccess) {
        final dt = LoginModel.fromJson(result.result);
        HelperFunctions.saveLoginData(dt);
        emit(UserUpdateSuccessState());
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
        final data = PlaceModel.fromJson(result.result).data.data;
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
        final data = PlaceBusinessModel.fromJson(result.result).data.data;
        emit(GetPlaceBusinessSuccessState(data: data));
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

  void _onGetStatistic(GetStatisticEvent event, Emitter<HomeState> emit) async {
    emit(GetStatisticLoadingState());
    try {
      final result = await homeRepository.getStatistic(
        date: event.date,
        period: event.period,
      );
      if (result.isSuccess) {
        final data = StatisticModel.fromJson(result.result).data.data;
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
        final data = EmployeeModel.fromJson(result.result).data.data;
        emit(GetEmployeeSuccessState(data: data));
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
      var imgUrl = "";
      final response = await homeRepository.uploadImage(
        filePath: event.data.images[0].url,
      );
      if (response.isSuccess) {
        imgUrl = response.result['data']['data']['url'];
      } else {
        emit(
          HomeErrorState(message: HelperFunctions.errorText(response.result)),
        );
        return;
      }

      var data = event.data;
      data.images = [ImageCreateModel(url: imgUrl, index: 1, isMain: true)];
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
        final data = BookModel.fromJson(result.result);
        emit(GetQRBookCodeSuccessState(data: data.data.data));
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
    emit(GetResourceCategoryLoadingState());
    try {
      final result = await homeRepository.getResourceCategory();
      if (result.isSuccess) {
        final data = ResourceCategoryModel.fromJson(result.result).data;
        emit(GetResourceCategorySuccessState(data: data.data));
      } else {
        emit(HomeErrorState(message: result.error.toString()));
      }
    } catch (e) {
      emit(HomeErrorState(message: e.toString()));
    }
  }
}
