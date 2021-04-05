import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'home_view.dart';
import 'location_service.dart';
import 'user_location.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserLocation>(
      create: (context) => locationService.locationStream,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeView(),
      ),
    );
  }
}
