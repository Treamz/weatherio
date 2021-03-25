import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherio/blocs/screens/city_search_screen.dart';
import 'package:weatherio/blocs/screens/settings_screen.dart';
import 'package:weatherio/blocs/screens/temperature_widget.dart';
import 'package:weatherio/blocs/theme_bloc.dart';
import 'package:weatherio/blocs/weather_bloc.dart';
import 'package:weatherio/events/theme_event.dart';
import 'package:weatherio/events/weather_event.dart';
import 'package:weatherio/states/theme_state.dart';
import 'package:weatherio/states/weather_state.dart';

class WeatherScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Completer<void> _completer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _completer = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Weatherio"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
                // Navigate to settings
              }),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                final typedCity = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CitySearchScreen()));
                // Navigate to search
                if (typedCity != null) {
                  print("${typedCity}");
                  BlocProvider.of<WeatherBloc>(context)
                      .add(WeatherEventRequested(city: typedCity.text));
                }
              }),
        ],
      ),
      body: Center(
        child: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, weatherState) {
            if (weatherState is WeatherStateSuccess) {
              BlocProvider.of<ThemeBloc>(context).add(ThemeEventWeatherChanged(
                  weatherCondition: weatherState.weather.weatherCondition));
              _completer?.complete();
              _completer = Completer();
            }
          },
          builder: (context, weatherState) {
            if (weatherState is WeatherStateLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (weatherState is WeatherStateSuccess) {
              final weather = weatherState.weather;
              return BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  return RefreshIndicator(
                      child: Container(
                        color: themeState.backgroundColor,
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: ListView(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    weather.location,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: themeState.textColor),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.symmetric(vertical: 2)),
                                  Center(
                                    child: Text(
                                      'Updated ${TimeOfDay.fromDateTime(weather.lastUpdated).format(context)}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: themeState.textColor),
                                    ),
                                  ),
                                  TemperatureWidget(
                                    weather: weather,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      onRefresh: () {
                        BlocProvider.of<WeatherBloc>(context)
                            .add(WeatherEventRefresh(city: weather.location));
                        return _completer.future;
                      });
                },
              );
            }
            if (weatherState is WeatherStateFailure) {
              return Text("Something went wron",
                  style: TextStyle(color: Colors.redAccent, fontSize: 16));
            }
            return Text("Select a location first");
          },
        ),
      ),
    );
  }
}
