import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oneappcounter/bloc/app_update/bloc/app_update_bloc.dart';
import 'package:oneappcounter/bloc/appointment_page/bloc/appointment_bloc.dart';
import 'package:oneappcounter/bloc/call/bloc/call_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_bloc.dart';
import 'package:oneappcounter/bloc/settings_bloc/settings_bloc_event.dart';
import 'package:oneappcounter/bloc/tocken_page/bloc/tocken_bloc.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
import 'package:oneappcounter/core/config/theme/theme_data.dart';
import 'package:oneappcounter/routes.dart';
import 'package:oneappcounter/services/general_data_seevice.dart';
import 'package:oneappcounter/services/socket_services.dart';
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
              .initliseSocket()
              .then((value) => SocketService.registerEvents(isAll: true));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider<BranchDomainBloc>(create: (context) => BranchDomainBloc()),
        BlocProvider<SettingsBloc>(create: (context) => SettingsBloc()),
         BlocProvider<AppUpdateBloc>(create: (context) => AppUpdateBloc()),
    
        BlocProvider<CallBloc>(create: (context) => CallBloc()),
        BlocProvider<TokenPageBloc>(create: (context) => TokenPageBloc()),
        BlocProvider<AppointmentPageBloc>(
            create: (context) => AppointmentPageBloc()),

        // Provide NetworkingCubit here
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            debugShowCheckedModeBanner: false,
            title: 'OneAppCounter',
            initialRoute: AppRoutes.splashScreen,
            routes: routes,
          );
        },
      ),
    );
  }
}
