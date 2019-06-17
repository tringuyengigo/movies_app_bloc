import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'scoped_models/AppModel.dart';
import 'screens/HomeScreen.dart';

void main() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(ScopedModel<AppModel>(
      model: AppModel(sharedPreferences),
      child: MaterialApp(
          title: 'Movies',
          theme: ThemeData.dark(),
          home: HomeScreen(),
        ),
  ));
}


