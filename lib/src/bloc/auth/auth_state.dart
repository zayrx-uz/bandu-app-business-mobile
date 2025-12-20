part of 'auth_bloc.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class SplashChangeState extends AuthState {
  final Widget page;

  SplashChangeState({required this.page});

  @override
  List<Object?> get props => [page];
}

class AuthErrorState extends AuthState {
  final String message;

  AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetImageSuccessState extends AuthState {
  final XFile img;

  GetImageSuccessState({required this.img});

  @override
  List<Object?> get props => [img];
}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {}

class RegisterLoadingState extends AuthState {}

class RegisterSuccessState extends AuthState {
  final String otpToken;

  RegisterSuccessState({required this.otpToken});

  @override
  List<Object?> get props => [otpToken];
}

class OtpLoadingState extends AuthState {}

class OtpSuccessState extends AuthState {}
