import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherio/events/settings_event.dart';
import 'package:weatherio/states/settings_state.dart';

class SettingBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingBloc()
      : super(SettingsState(temperatureUnit: TemperatureUnit.celsius));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    // TODO: implement mapEventToState
    if (event is SettingsEventToggleUnit) {
      yield SettingsState(
          temperatureUnit: state.temperatureUnit == TemperatureUnit.celsius
              ? TemperatureUnit.fahrenheit
              : TemperatureUnit.celsius);
    }
  }
}
