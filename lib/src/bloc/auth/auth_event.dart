part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetImageEvent extends AuthEvent {
  final bool isSelfie;

  GetImageEvent({required this.isSelfie});

  @override
  List<Object?> get props => [isSelfie];
}

class RegisterValidationEvent extends AuthEvent {}

class LoginValidationEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final String phone;
  final String password;
  final String role;

  LoginEvent({required this.phone, required this.password, required this.role});

  @override
  List<Object?> get props => [phone, password, role];
}

class RegisterEvent extends AuthEvent {
  final String phone;

    RegisterEvent({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class OtpEvent extends AuthEvent {
  final String otpToken;
  final String code;

  OtpEvent({required this.otpToken, required this.code});

  @override
  List<Object?> get props => [otpToken, code];
}

class SplashChangeEvent extends AuthEvent {}




class ForgotPasswordEvent extends AuthEvent {
  final String phoneNumber;

  ForgotPasswordEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class VerifyResetCodeEvent extends AuthEvent {
  final String phoneNumber;
  final String code;
  final String otpToken;

  VerifyResetCodeEvent({
    required this.phoneNumber,
    required this.code,
    required this.otpToken,
  });

  @override
  List<Object?> get props => [phoneNumber, code, otpToken];
}

class ResetPasswordEvent extends AuthEvent {
  final String resetToken;
  final String newPassword;

  ResetPasswordEvent({
    required this.resetToken,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [resetToken, newPassword];
}


class RegisterCompleteEvent extends AuthEvent {
  final String token;
  final String fullName;
  final String password;
  final String role;

  RegisterCompleteEvent({
    required this.role,
    required this.fullName,
    required this.token,
    required this.password,
  });

  @override
  List<Object?> get props => [role, fullName, token , password];
}
