import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tourism_currency_converter/core/constants/country_currency_map.dart';

class LocationService {
  Future<String?> getCurrencyCodeFromLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the 
        // App to enable the location services.
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return null;
      } 

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final countryCode = placemarks.first.isoCountryCode;
        if (countryCode != null && countryCurrencyMap.containsKey(countryCode)) {
          return countryCurrencyMap[countryCode];
        }
      }
    } catch (e) {
      // Handle exceptions
      print('Error getting location or currency: $e');
    }
    return null;
  }
} 