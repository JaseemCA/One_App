// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
// import 'package:oneappcounter/core/config/theme/theme_data.dart';
// import 'package:oneappcounter/presentation/auth/login/brach_domain.dart';
// // import 'package:oneappcounter/presentation/auth/login/brach_domain.dart';
// import 'package:oneappcounter/routes.dart';
// import 'package:path_provider/path_provider.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   HydratedBloc.storage = await HydratedStorage.build(
//     storageDirectory: kIsWeb
//         ? HydratedStorage.webStorageDirectory
//         : await getApplicationDocumentsDirectory(),
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [BlocProvider(create: (_) => ThemeCubit())],
//       child: BlocBuilder<ThemeCubit, ThemeMode>(
//         builder: (context, mode) {
//           return MaterialApp(
//             theme: AppTheme.lightTheme,
//             darkTheme: AppTheme.darkTheme,
//             themeMode: mode,
//             debugShowCheckedModeBanner: false,
//             title: 'OneAppCounter',
//             initialRoute: Routes.splashScreen.route,
//             routes: routes,
//             home: const BranchDomainPage(),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
import 'package:oneappcounter/core/config/theme/theme_data.dart';
import 'package:oneappcounter/services/networking_service.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/storage_service.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
            create: (_) => NetworkingCubit()), // Provide NetworkingCubit here
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            debugShowCheckedModeBanner: false,
            title: 'OneAppCounter',
            initialRoute: Routes.splashScreen.route,
            routes: routes,
          );
        },
      ),
    );
  }
}

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';

// import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
// import 'package:oneappcounter/core/config/theme/theme_data.dart';
// import 'package:oneappcounter/presentation/auth/login/brach_domain.dart';
// import 'package:path_provider/path_provider.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Set trusted certificates
//   try {
//     // SecurityContext.defaultContext
//         // .setTrustedCertificatesBytes(ascii.encode(kISRG_X1));
//   } catch (_) {}

//   // Initialize HydratedBloc
//   HydratedBloc.storage = await HydratedStorage.build(
//     storageDirectory: kIsWeb
//         ? HydratedStorage.webStorageDirectory
//         : await getApplicationDocumentsDirectory(),
//   );

//   // Set up localization
//   // LocalizationDelegate delegate = await LocalizationDelegate.create(
//   //   fallbackLocale: 'en',
//   //   supportedLocales: ['en', 'ar', 'fr', 'ml'],
//   // );

//   runApp(
//     MultiBlocProvider(
//       providers: [
//         // BlocProvider<AppUpdateBloc>(create: (context) => AppUpdateBloc()),
//         // BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
//         // BlocProvider<CallBloc>(create: (context) => CallBloc()),
//         // BlocProvider<TokenPageBloc>(create: (context) => TokenPageBloc()),
//         // BlocProvider<AppointmentPageBloc>(
//         //     create: (context) => AppointmentPageBloc()),
//         BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()), // Add ThemeCubit
//       ],
//       child: LocalizedApp(delegate, const MyApp()),
//     ),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     try {
//       SocketService.destorySocket();
//     } catch (_) {}
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (state == AppLifecycleState.resumed) {
//       if (GeneralDataService.getTabs().isNotEmpty) {
//         GeneralDataService.reloadData(sendEvents: true).then((value) {
//           BlocProvider.of<SettingsBloc>(context)
//               .add(HomePageSettingsChangedEvent());
//         });
//         SocketService.destorySocket().then((value) {
//           SocketService()
//               .initliseSocket()
//               .then((value) => SocketService.registerEvents(isAll: true));
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return BlocListener<AppUpdateBloc, AppUpdateState>(
//           listener: (context, state) async {
//             if ((state is AppUpdateAvailable) &&
//                 (state.appUpdateInfo.updateAvailability ==
//                     UpdateAvailability.updateAvailable)) {
//               bool _immediateUpdateAllowed =
//                   state.appUpdateInfo.immediateUpdateAllowed;

//               if (_immediateUpdateAllowed) {
//                 try {
//                   await InAppUpdate.performImmediateUpdate();
//                 } catch (e) {
//                   _immediateUpdateAllowed = false;
//                 }
//               }

//               if (!_immediateUpdateAllowed &&
//                   state.appUpdateInfo.flexibleUpdateAllowed) {
//                 try {
//                   await InAppUpdate.startFlexibleUpdate();
//                   await InAppUpdate.completeFlexibleUpdate();
//                 } catch (_) {}
//               }
//             }
//           },
//           child: LocalizationProvider(
//             state: LocalizationProvider.of(context).state,
//             child: BlocBuilder<ThemeCubit, ThemeMode>(
//               builder: (context, mode) {
//                 return MaterialApp(
//                   theme: AppTheme.lightTheme,
//                   darkTheme: AppTheme.darkTheme,
//                   themeMode: mode,
//                   debugShowCheckedModeBanner: false,
//                   title: 'OneAppCounter',
//                   localizationsDelegates: [
//                     // GlobalMaterialLocalizations.delegate,
//                     // GlobalWidgetsLocalizations.delegate,
//                     // LocalizedApp.of(context).delegate,
//                   ],
//                   supportedLocales:
//                       LocalizedApp.of(context).delegate.supportedLocales,
//                   locale: LocalizedApp.of(context).delegate.currentLocale,
//                   initialRoute: Routes.splashScreen.route,
//                   routes: routes,
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
