import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  LocationService._();

  /// Check Permission
  static Future<bool> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Current Position
  static Future<Position?> getCurrentPosition() async {
    final granted = await checkPermission();

    if (!granted) return null;

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  /// Reverse Geocoding
  static Future<Map<String, dynamic>?> getAddressFromLocation() async {
    final position = await getCurrentPosition();

    if (position == null) return null;

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isEmpty) return null;

    final place = placemarks.first;

    final address = [
      place.street,
      place.subLocality,
      place.locality,
    ].where((e) => e != null && e.isNotEmpty).join(', ');

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
      'city': place.locality ?? '',
      'state': place.administrativeArea ?? '',
      'pincode': place.postalCode ?? '',
      'country': place.country ?? '',
    };
  }
}
