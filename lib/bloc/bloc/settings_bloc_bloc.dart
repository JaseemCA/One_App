
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oneappcounter/bloc/bloc/settings_bloc_event.dart';
import 'package:oneappcounter/bloc/bloc/settings_bloc_state.dart';


class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsStateInit()) {
    on<SettingsEventUpdated>(_mapSettingsUpdated);
    on<HomePageSettingsChangedEvent>(_mapHomePageSettingsEvent);
    on<SwitchToHomePageEvent>(_mapSwitchToHomePageEvent);
  }
  _mapSettingsUpdated(SettingsEventUpdated event, Emitter emit) {
    emit(SettingsStateInit());
    emit(SettingsStateUpdating());
    emit(SettingsStateUpdated(isServiceTabPage: event.isCurrentPageIsTab));
  }

  _mapHomePageSettingsEvent(HomePageSettingsChangedEvent event, Emitter emit) {
    emit(SettingsStateInit());
    emit(SettingsStateUpdating());
    emit(HomePageSettingsState());
  }

  _mapSwitchToHomePageEvent(SwitchToHomePageEvent event, Emitter emit) {
    emit(SettingsStateInit());
    emit(SwitchToHomePageState());
  }
}
