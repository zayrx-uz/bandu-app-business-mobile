import 'dart:io';

import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:bandu_business/src/helper/firebase/firebase.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/ui/splash/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  await FirebaseHelper.initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SafeArea(
          left: false,
          right: false,
          top: false,
          bottom: Platform.isIOS ? false : true,
          child: MaterialApp(
            title: 'Bandu Business',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              platform: TargetPlatform.iOS,
              fontFamily: GoogleFonts.inter().fontFamily,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
              appBarTheme: AppBarTheme(surfaceTintColor: Colors.transparent),
            ),
            home: BlocProvider(
              create: (_) => AuthBloc(authRepository: AuthRepository()),
              child: const SplashScreen(),
            ),
          ),
        );
      },
    );
  }
}
