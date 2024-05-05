import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gas_io/utils/location_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Maps demo",
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _goToTheLake();
    _plotGasStations();
  }

    Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    final location = await getCurrentLocation();
    final CameraPosition cameraPos = CameraPosition(
      target: LatLng(location.latitude, location.longitude),
      zoom: 15,
    );

    await controller.animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  }

  Future<void> _plotGasStations() async {
      // var gasStations = await fetchGasStations(45.901163, 11.037508, 1000);
      var gasStations = await fetchGasStationsFromCurrentLocation(5000);


      Set<Marker> markers = {};

        for (var result in gasStations) {
          final id = result["id"];
          final lat = result["location"]["latitude"];
          final lng = result["location"]["longitude"];
          final name = result["displayName"]["text"];
          final formattedAddress= result["formattedAddress"] ?? "No Address Available";
          final shortFormattedAddress =
              result["shortFormattedAddress"] ?? "No Address Available";
          markers.add(
            Marker(
              markerId: MarkerId(id),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: name + " - " + formattedAddress,
                snippet: "Click to select",
                onTap: () {
                  _showPlaceDetails(context, name ?? '');
                },
              ),
            ),
          );
        }
      setState(() {
        _markers = markers;
      });
  }

  void _showPlaceDetails(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected Place'),
          content: Text(name),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
      ),
    );
  }
}
