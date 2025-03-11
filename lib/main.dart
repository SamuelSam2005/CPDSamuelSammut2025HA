import 'package:geolocator/geolocator.dart';

Future<void> requestLocationPermission() async {
  LocationPermission permission = await Geolocator.requestPermission();
}
