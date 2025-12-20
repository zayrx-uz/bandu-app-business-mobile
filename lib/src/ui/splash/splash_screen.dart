import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/bloc/main/home/home_bloc.dart';
import 'package:bandu_business/src/helper/constants/app_icons.dart';
import 'package:bandu_business/src/helper/constants/app_images.dart';
import 'package:bandu_business/src/helper/service/app_service.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/repository/repo/main/home_repository.dart';
import 'package:bandu_business/src/widget/app/app_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        _authBloc = context.read<AuthBloc>();
        _authBloc.add(SplashChangeEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is SplashChangeState) {
          if (CacheService.getToken() != "") {
            AppService.replacePage(
              context,
              BlocProvider(
                create: (_) => HomeBloc(homeRepository: HomeRepository()),
                child: state.page,
              ),
            );
          } else {
            AppService.replacePage(context, state.page);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.splashBack),
                fit: BoxFit.fill,
              ),
            ),
            child: Center(child: AppSvgAsset(AppIcons.logo)),
          ),
        );
      },
    );
  }
}
