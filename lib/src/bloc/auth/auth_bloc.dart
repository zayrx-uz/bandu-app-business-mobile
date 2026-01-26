import 'package:bandu_business/src/helper/firebase/firebase.dart';
import 'package:bandu_business/src/helper/helper_functions.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/model/api/auth/login_model.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/ui/auth/select_language_screen.dart';
import 'package:bandu_business/src/ui/main/company/screen/select_company_screen.dart';
import 'package:bandu_business/src/ui/main/main_screen.dart';
import 'package:bandu_business/src/ui/onboard/on_borading.dart';
import 'package:bandu_business/src/ui/onboard/onboard_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    ///splash change event
    on<SplashChangeEvent>(_splashChange);

    ///get image event
    on<GetImageEvent>(_getImage);

    ///login event
    on<LoginEvent>(_login);

    ///register event
    on<RegisterEvent>(_register);

    ///otp event
    on<OtpEvent>(_otp);

    ///RegisterCompleteEvent
    on<RegisterCompleteEvent>(_registerComplete);

    ///forgot password event
    on<ForgotPasswordEvent>(_forgotPassword);

    ///verify reset code event
    on<VerifyResetCodeEvent>(_verifyResetCode);

    ///reset password event
    on<ResetPasswordEvent>(_resetPassword);

    ///logout event
    on<LogoutEvent>(_logout);
  }

  void _splashChange(SplashChangeEvent event, Emitter<AuthState> emit) async {
    await Future.delayed(const Duration(seconds: 2));
    if(CacheService.getBool("select_lan") == true){
      if(CacheService.getBool("onboarding_view")){
        if (CacheService.getToken() != '') {
          if (HelperFunctions.getCompanyId() == -1 || HelperFunctions.getCompanyId() == null) {
            emit(SplashChangeState(page: SelectCompanyScreen()));
          } else {

            emit(SplashChangeState(page: SelectLanguageScreen()));
          }
        } else {
          emit(SplashChangeState(page: OnboardScreen()));
        }
      }
      else{
        emit(SplashChangeState(page: Onboarding()));
      }
    }
    else{
      emit(SplashChangeState(page: SelectLanguageScreen()));
    }

  }

  void _getImage(GetImageEvent event, Emitter<AuthState> emit) async {
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
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void _login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      final result = await authRepository.login(
        phone: event.phone,
        password: event.password,
        role: event.role
      );
      if (result.isSuccess) {
        LoginModel data = LoginModel.fromJson(result.result);
        HelperFunctions.saveLoginData(data);
        emit(LoginSuccessState());
      } else {
        emit(AuthErrorState(message: result.result['message']));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }



  void _otp(OtpEvent event, Emitter<AuthState> emit) async {
    emit(OtpLoadingState());
    try {
      final result = await authRepository.otp(
        otpToken: event.otpToken,
        code: event.code,
      );
      if (result.isSuccess) {
        final data = result.result["data"];
        final registrationToken = data["registrationToken"] ?? data["data"]?["registrationToken"];
        emit(OtpSuccessState(token: registrationToken));
      } else {
        emit(AuthErrorState(message: result.result['message']));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void _registerComplete(
      RegisterCompleteEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(RegisterCompleteLoadingState());
    try {
      // Get FCM token - will fetch from Firebase if not in cache
      String? fcmToken = await FirebaseHelper.getFcmToken();

      final result = await authRepository.registerComplete(
        role: event.role,
        fullName: event.fullName,
        token: event.token,
        password: event.password,
        fcmToken: fcmToken ?? "",
      );
      if (result.isSuccess) {
        final responseData = result.result;
        if (responseData is Map<String, dynamic>) {
          LoginModel data = LoginModel.fromJson(responseData);
          if (data.tokens.accessToken.isNotEmpty) {
            HelperFunctions.saveLoginData(data);
            emit(RegisterCompleteSuccessState(userModel: data));
          } else {
            emit(AuthErrorState(message: "Token not found in response"));
          }
        } else {
          emit(AuthErrorState(message: "Invalid response format"));
        }
      } else {
        final errorMessage = result.result is Map 
            ? (result.result['message'] ?? result.result.toString())
            : result.result.toString();
        emit(AuthErrorState(message: errorMessage));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }



  void _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(RegisterLoadingState());
    try {
      // String? imageUrl;

      // Only upload image if provided
      // if (event.img != null && event.img!.isNotEmpty) {
      //   final imgResult = await authRepository.uploadImage(filePath: event.img!);
      //   if (imgResult.isSuccess) {
      //     imageUrl = imgResult.result['data']['data']['url'];
      //   } else {
      //     emit(AuthErrorState(message: imgResult.result['message']));
      //     return;
      //   }
      // }

      final result = await authRepository.register(phone: event.phone);

      if (result.isSuccess) {
        print("Mana u mana ${result.result["otpToken"]}");
        emit(RegisterSuccessState(otpToken: result.result['otpToken']));
      } else {
        emit(AuthErrorState(message: result.result['message']));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }



  void _forgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ForgotPasswordLoadingState());
    try {
      final result = await authRepository.forgotPassword(phoneNumber: event.phoneNumber);
      if (result.isSuccess) {
        final otpToken = result.result["data"]["otpToken"];
        emit(ForgotPasswordSuccessState(otpToken: otpToken));
      } else {
        emit(AuthErrorState(message: result.result['message']));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void _verifyResetCode(VerifyResetCodeEvent event, Emitter<AuthState> emit) async {
    emit(VerifyResetCodeLoadingState());
    try {
      final result = await authRepository.verifyResetCode(
        phoneNumber: event.phoneNumber,
        code: event.code,
        otpToken: event.otpToken,
      );
      if (result.isSuccess) {
        final resetToken = result.result["data"]["resetToken"];
        emit(VerifyResetCodeSuccessState(resetToken: resetToken));
      } else {
        emit(AuthErrorState(message: result.result['message']));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void _resetPassword(ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(ResetPasswordLoadingState());
    try {
      final result = await authRepository.resetPassword(
        resetToken: event.resetToken,
        newPassword: event.newPassword,
      );
      if (result.isSuccess) {
        emit(ResetPasswordSuccessState());
      } else {
        emit(AuthErrorState(message: result.result['message']));
      }
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void _logout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(LogoutLoadingState());
    try {
      final result = await authRepository.logout();
      if (result.isSuccess) {
        CacheService.clear();
        emit(LogoutSuccessState());
      } else {
        CacheService.clear();
        emit(LogoutSuccessState());
      }
    } catch (e) {
      CacheService.clear();
      emit(LogoutSuccessState());
    }
  }
}
