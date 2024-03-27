import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:geolocator/geolocator.dart';
import 'package:gas_io/utils/api_keys.dart';

Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw 'Location services are disabled.';
  }

  // Request permission to access location
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw 'Location permissions are denied.';
    }
  }

  // Get current position
  return await Geolocator.getCurrentPosition();
}


Future<List<Map<String, dynamic>>> fetchGasStationsFromCurrentLocation(int radius) async {
  try {
    Position position = await getCurrentLocation();
    double latitude = position.latitude;
    double longitude = position.longitude;

    var headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': mapsApiKey, // Replace 'YOUR_API_KEY' with your actual Google Places API key
      'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.shortFormattedAddress,places.id,places.location',
      'languageCode': 'it'
    };

    var request = http.Request(
        'POST',
        Uri.parse('https://places.googleapis.com/v1/places:searchNearby'));

    request.body = json.encode({
      "includedTypes": ["gas_station"],
      "locationRestriction": {
        "circle": {
          "center": {"latitude":latitude, "longitude":longitude},
          "radius":radius
        }
      }
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var gasStations = jsonDecode(responseData)["places"];
      return gasStations != null ? List<Map<String, dynamic>>.from(gasStations) : [];
    } else {
      throw HttpException('Failed to fetch gas stations. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error getting current location: $e');
  }
}


Future<List<Map<String, dynamic>>> fetchNearestGasStationFromCurrentLocation(int radius) async {
  try {
    Position position = await getCurrentLocation();
    double latitude = position.latitude;
    double longitude = position.longitude;

    var headers = {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': mapsApiKey, // Replace 'YOUR_API_KEY' with your actual Google Places API key
      'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.shortFormattedAddress,places.id,places.location',
      'languageCode': 'it'
    };

    var request = http.Request(
        'POST',
        Uri.parse('https://places.googleapis.com/v1/places:searchNearby'));

    request.body = json.encode({
      "includedTypes": ["gas_station"],
      "maxResultCount": 1,
      "rankPreference": "DISTANCE",
      "locationRestriction": {
        "circle": {
          "center": {"latitude":latitude, "longitude":longitude},
          "radius":radius
        }
      }
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var gasStations = jsonDecode(responseData)["places"];
      return gasStations != null ? List<Map<String, dynamic>>.from(gasStations) : [];
    } else {
      throw HttpException('Failed to fetch gas stations. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error getting current location: $e');
  }
}


Future<List<Map<String, dynamic>>> fetchGasStations(double latitude, double longitude, int radius) async {
  var headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': mapsApiKey, // Replace 'YOUR_API_KEY' with your actual Google Places API key
    'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.shortFormattedAddress,places.id,places.location',
    'languageCode': 'it'
  };

  var request = http.Request(
      'POST',
      Uri.parse('https://places.googleapis.com/v1/places:searchNearby'));

  request.body = json.encode({
    "includedTypes": ["gas_station"],
    "locationRestriction": {
      "circle": {
        "center": {"latitude": latitude, "longitude": longitude},
        "radius": radius
      }
    }
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var gasStations = jsonDecode(responseData)["places"];
    return gasStations != null ? List<Map<String, dynamic>>.from(gasStations) : [];
  } else {
    throw HttpException('Failed to fetch gas stations. Status code: ${response.statusCode}');
  }
}


Future<List<Map<String, dynamic>>> fetchNearestGasStation(double latitude, double longitude, int radius) async {
  var headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': mapsApiKey, // Replace 'YOUR_API_KEY' with your actual Google Places API key
    'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.shortFormattedAddress,places.id,places.location',
    'languageCode': 'it'
  };

  var request = http.Request(
      'POST',
      Uri.parse('https://places.googleapis.com/v1/places:searchNearby'));

  request.body = json.encode({
    "includedTypes": ["gas_station"],
    "maxResultCount": 1,
    "rankPreference": "DISTANCE",
    "locationRestriction": {
      "circle": {
        "center": {"latitude": latitude, "longitude": longitude},
        "radius": radius
      }
    }
  });

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var responseData = await response.stream.bytesToString();
    var gasStations = jsonDecode(responseData)["places"];
    return gasStations != null ? List<Map<String, dynamic>>.from(gasStations) : [];
  } else {
    throw HttpException('Failed to fetch gas stations. Status code: ${response.statusCode}');
  }
}