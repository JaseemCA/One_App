// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_translate/flutter_translate.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:in_app_update/in_app_update.dart';
// import 'package:oneappcounter/bloc/app_update/bloc/app_update_bloc.dart';
// import 'package:oneappcounter/bloc/app_update/bloc/app_update_state.dart';
// import 'package:oneappcounter/bloc/appointment_page/bloc/appointment_bloc.dart';
// import 'package:oneappcounter/bloc/call/bloc/call_bloc.dart';
// import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
// import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_bloc.dart';
// import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
// import 'package:oneappcounter/bloc/tocken_page/bloc/tocken_bloc.dart';
// import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
// import 'package:oneappcounter/core/config/theme/theme_data.dart';
// import 'package:oneappcounter/routes.dart';
// import 'package:oneappcounter/services/general_data_seevice.dart';
// import 'package:oneappcounter/services/socket_services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sizer/sizer.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   HydratedBloc.storage = await HydratedStorage.build(
//     storageDirectory: kIsWeb
//         ? HydratedStorage.webStorageDirectory
//         : await getApplicationDocumentsDirectory(),
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

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
//               .initialiseSocket()
//               .then((value) => SocketService.registerEvents(isAll: true));
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (_) => ThemeCubit()),
//         BlocProvider<BranchDomainBloc>(create: (context) => BranchDomainBloc()),
//         BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
//         BlocProvider<AppUpdateBloc>(create: (context) => AppUpdateBloc()),
//         BlocProvider<CallBloc>(create: (context) => CallBloc()),
//         BlocProvider<TokenPageBloc>(create: (context) => TokenPageBloc()),
//         BlocProvider<AppointmentPageBloc>(
//             create: (context) => AppointmentPageBloc()),
//       ],
//       child: Sizer(
//         builder: (context, orientation, deviceType) {
//           return BlocListener<AppUpdateBloc, AppUpdateState>(
//             listener: (context, state) async {
//               if ((state is AppUpdateAvailable) &&
//                   (state.appUpdateInfo.updateAvailability ==
//                       UpdateAvailability.updateAvailable)) {
//                 bool immediateUpdateAllowed =
//                     state.appUpdateInfo.immediateUpdateAllowed;

//                 if (immediateUpdateAllowed) {
//                   try {
//                     await InAppUpdate.performImmediateUpdate();
//                   } catch (e) {
//                     immediateUpdateAllowed = false;
//                   }
//                 }

//                 if (!immediateUpdateAllowed &&
//                     state.appUpdateInfo.flexibleUpdateAllowed) {
//                   try {
//                     await InAppUpdate.startFlexibleUpdate();
//                     await InAppUpdate.completeFlexibleUpdate();
//                   } catch (_) {}
//                 }
//               }
//             },
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
//                     LocalizedApp.of(context).delegate,
//                   ],
//                   supportedLocales:
//                       LocalizedApp.of(context).delegate.supportedLocales,
//                   locale: LocalizedApp.of(context).delegate.currentLocale,
//                   initialRoute: AppRoutes.splashScreen,
//                   routes: routes,
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:oneappcounter/bloc/app_update/bloc/app_update_bloc.dart';
import 'package:oneappcounter/bloc/app_update/bloc/app_update_state.dart';
import 'package:oneappcounter/bloc/appointment_page/bloc/appointment_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_bloc.dart';
import 'package:oneappcounter/bloc/call/bloc/call_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/bloc/tocken_page/bloc/tocken_bloc.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
import 'package:oneappcounter/core/config/theme/theme_data.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/socket_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalizationDelegate delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en',
    supportedLocales: ['en', 'ar', 'fr', 'ml', 'pt'],
  );

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider<BranchDomainBloc>(create: (context) => BranchDomainBloc()),
        BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
        BlocProvider<AppUpdateBloc>(create: (context) => AppUpdateBloc()),
        BlocProvider<CallBloc>(create: (context) => CallBloc()),
        BlocProvider<TokenPageBloc>(create: (context) => TokenPageBloc()),
        BlocProvider<AppointmentPageBloc>(
            create: (context) => AppointmentPageBloc()),
      ],
      child: LocalizedApp(delegate, const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      SocketService.destorySocket();
    } catch (_) {}
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (GeneralDataService.getTabs().isNotEmpty) {
        GeneralDataService.reloadData(sendEvents: true).then((value) {
          BlocProvider.of<SettingsBloc>(context)
              .add(HomePageSettingsChangedEvent());
        });
        SocketService.destorySocket().then((value) {
          SocketService()
              .initialiseSocket()
              .then((value) => SocketService.registerEvents(isAll: true));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return BlocListener<AppUpdateBloc, AppUpdateState>(
          listener: (context, state) async {
            if ((state is AppUpdateAvailable) &&
                (state.appUpdateInfo.updateAvailability ==
                    UpdateAvailability.updateAvailable)) {
              bool immediateUpdateAllowed =
                  state.appUpdateInfo.immediateUpdateAllowed;

              if (immediateUpdateAllowed) {
                try {
                  await InAppUpdate.performImmediateUpdate();
                } catch (e) {
                  immediateUpdateAllowed = false;
                }
              }

              if (!immediateUpdateAllowed &&
                  state.appUpdateInfo.flexibleUpdateAllowed) {
                try {
                  await InAppUpdate.startFlexibleUpdate();
                  await InAppUpdate.completeFlexibleUpdate();
                } catch (_) {}
              }
            }
          },
          child: LocalizationProvider(
            state: LocalizationProvider.of(context).state,
            child: BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, mode) {
                return MaterialApp(
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: mode,
                  debugShowCheckedModeBanner: false,
                  title: 'OneAppCounter',
                  localizationsDelegates: [
                    LocalizedApp.of(context).delegate, 
                  ],
                  supportedLocales:
                      LocalizedApp.of(context).delegate.supportedLocales,
                  locale: LocalizedApp.of(context).delegate.currentLocale,
                  initialRoute: AppRoutes.splashScreen,
                  routes: routes,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
