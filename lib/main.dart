import 'dart:io';
import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:bandu_business/src/bloc/auth/auth_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:bandu_business/src/helper/firebase/firebase.dart';
import 'package:bandu_business/src/helper/service/cache_service.dart';
import 'package:bandu_business/src/provider/api_provider.dart';
import 'package:bandu_business/src/repository/repo/auth/auth_repository.dart';
import 'package:bandu_business/src/ui/splash/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();
  
  if (kDebugMode) {
    ApiProvider.alice = Alice(
      configuration: AliceConfiguration(
        showNotification: true,
        showInspectorOnShake: true,
        navigatorKey: navigatorKey,
      ),
    );
    ApiProvider.alice?.setNavigatorKey(navigatorKey);
  }
  
  String savedLang = CacheService.getString('language');
  Locale startLocale = const Locale('ru', 'RU');
  
  if (savedLang.isEmpty) {
    CacheService.saveString('language', 'ru');
    startLocale = const Locale('ru', 'RU');
  } else {
    if (savedLang.toLowerCase() == 'en') {
      startLocale = const Locale('en', 'EN');
    } else if (savedLang.toLowerCase() == 'ru') {
      startLocale = const Locale('ru', 'RU');
    } else if (savedLang.toLowerCase() == 'uz') {
      startLocale = const Locale('uz', 'UZ');
    } else {
      CacheService.saveString('language', 'ru');
      startLocale = const Locale('ru', 'RU');
    }
  }
  
  await EasyLocalization.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  await FirebaseHelper.initNotification();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'EN'),
        Locale('ru', 'RU'),
        Locale('uz', 'UZ'),
      ],
      path: 'assets/translations',
      startLocale: startLocale,
      fallbackLocale: const Locale('ru', 'RU'),
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return SafeArea(
            left: false,
            right: false,
            top: false,
            bottom: Platform.isIOS ? false : true,
            child: SafeArea(
              bottom: false,
              top : false,
              child: MaterialApp(
                title: 'Bandu Business',
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: ThemeData(
                  fontFamily: GoogleFonts.inter().fontFamily,
                  colorScheme: ColorScheme.fromSeed(seedColor: Colors.transparent),
                  appBarTheme: AppBarTheme(surfaceTintColor: Colors.transparent),
                ),
                home: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) => AuthBloc(authRepository: AuthRepository()),
                    ),
                  ],
                  child: const SplashScreen(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
