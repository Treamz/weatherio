import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherio/events/weather_event.dart';
import 'package:weatherio/models/weather.dart';
import 'package:weatherio/repositories/weather_repository.dart';
import 'package:weatherio/states/weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc({@required this.weatherRepository})
      : assert(weatherRepository != null),
        super(WeatherStateInital());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    // TODO: implement mapEventToState
    if (event is WeatherEventRequested) {
      yield WeatherStateLoading();
      try {
        final Weather weather =
            await weatherRepository.getWeatherFromCity(event.city);
        yield WeatherStateSuccess(weather: weather);
      } catch (exception) {
        yield WeatherStateFailure();
      }
    } else if (event is WeatherEventRefresh) {
      yield WeatherStateLoading();
      try {
        final Weather weather =
            await weatherRepository.getWeatherFromCity(event.city);
        yield WeatherStateSuccess(weather: weather);
      } catch (exception) {
        yield WeatherStateFailure();
      }
    }
  }
}
