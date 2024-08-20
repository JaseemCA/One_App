import 'dart:io';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:oneappcounter/bloc/app_update/bloc/app_update_event.dart';
import 'package:oneappcounter/bloc/app_update/bloc/app_update_state.dart';

class AppUpdateBloc extends Bloc<AppUpdateEvent, AppUpdateState> {
  AppUpdateBloc() : super(AppUpdateChecking()) {
    on<CheckForUpdate>(_mapCheckForUpdate);
  }

  Future<void> _mapCheckForUpdate(CheckForUpdate event, Emitter emit) async {
    emit(AppUpdateChecking());

    if (Platform.isAndroid) {
      try {
        final AppUpdateInfo appUpdateInfo = await InAppUpdate.checkForUpdate();

        emit(AppUpdateAvailable(appUpdateInfo));
      } catch (e) {
        emit(AppUpdateCheckFailed());
      }
    } else {
      emit(AppUpdateCheckFailed());
    }
  }
}
