import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherio/blocs/settings_bloc.dart';
import 'package:weatherio/blocs/theme_bloc.dart';
import 'package:weatherio/models/weather.dart';
import 'package:weatherio/states/settings_state.dart';
import 'package:weatherio/states/theme_state.dart';

class TemperatureWidget extends StatelessWidget {
  final Weather weather;
  TemperatureWidget({Key key, @required this.weather})
      : assert(weather != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeState _themeState = BlocProvider.of<ThemeBloc>(context).state;
    // convert celsius to fahrenheit
    int _toFahrenheit(double celsius) => ((celsius * 9 / 5) + 32).round();
    String _formattedTemperatur(double temp, TemperatureUnit temperatureUnit) =>
        temperatureUnit == TemperatureUnit.fahrenheit
            ? '${_toFahrenheit(temp)} F'
            : '${temp.round()} C';
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: BlocBuilder<SettingBloc, SettingsState>(
                builder: (context, settingsStabe) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "min temp ${_formattedTemperatur(weather.minTemp, settingsStabe.temperatureUnit)}",
                        style: TextStyle(
                            fontSize: 28, color: _themeState.textColor),
                      ),
                      Text(
                        "Temp temp ${_formattedTemperatur(weather.temp, settingsStabe.temperatureUnit)}",
                        style: TextStyle(
                            fontSize: 28, color: _themeState.textColor),
                      ),
                      Text(
                        "max temp ${_formattedTemperatur(weather.maxTemp, settingsStabe.temperatureUnit)}",
                        style: TextStyle(
                            fontSize: 28, color: _themeState.textColor),
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
