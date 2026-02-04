import 'package:flutter/material.dart';
import 'package:flutter_architecture_blueprint/features/auth/presentation/screens/login_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/restaurantHome':
        // final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          //   builder: (_) => RestaurantHomePage(
          //   user: args['user'],
          //   restaurantId: args['restaurantId'],
          // ),
        );
      // Add more cases here
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
