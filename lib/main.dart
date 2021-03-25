import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherio/blocs/screens/weather_screen.dart';
import 'package:weatherio/blocs/settings_bloc.dart';
import 'package:weatherio/blocs/theme_bloc.dart';
import 'package:weatherio/blocs/weather_bloc.dart';
import 'package:weatherio/blocs/weather_bloc_observer.dart';
import 'package:weatherio/repositories/weather_repository.dart';
import 'package:http/http.dart' as http;

void main() {
  Bloc.observer = WeatherBlocObserver();
  final WeatherRepository weatherRepository =
      WeatherRepository(httpClient: http.Client());

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeBloc>(create: (context) => ThemeBloc()),
      BlocProvider<SettingBloc>(create: (context) => SettingBloc()),
    ],
    child: MyApp(
      weatherRepository: weatherRepository,
    ),
  ));
}

class MyApp extends StatelessWidget {
  final WeatherRepository weatherRepository;
  MyApp({Key key, @required this.weatherRepository})
      : assert(weatherRepository != null),
        super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => WeatherBloc(weatherRepository: weatherRepository),
        child: WeatherScreen(),
      ),
    );
  }
}
