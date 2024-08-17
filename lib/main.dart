import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:oneappcounter/bloc/branch_domain/bloc/branc_domain_bloc.dart';
import 'package:oneappcounter/core/config/theme/bloc/theme_cubit.dart';
import 'package:oneappcounter/core/config/theme/theme_data.dart';
import 'package:oneappcounter/routes.dart';
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
        BlocProvider<BranchDomainBloc>(create: (context) => BranchDomainBloc()),

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
