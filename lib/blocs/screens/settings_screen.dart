import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherio/blocs/settings_bloc.dart';
import 'package:weatherio/events/settings_event.dart';
import 'package:weatherio/states/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Settings',
      )),
      body: ListView(
        children: <Widget>[
          BlocBuilder<SettingBloc, SettingsState>(
            builder: (context, settingsState) {
              return ListTile(
                title: Text('Temperature unit'),
                isThreeLine: true,
                subtitle: Text(
                    settingsState.temperatureUnit == TemperatureUnit.celsius
                        ? 'Celsius'
                        : 'Fahrenheit'),
                trailing: Switch(
                  value:
                      settingsState.temperatureUnit == TemperatureUnit.celsius,
                  onChanged: (_) => BlocProvider.of<SettingBloc>(context)
                      .add(SettingsEventToggleUnit()),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
