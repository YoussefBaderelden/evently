import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreanProvider extends ChangeNotifier {
  Location location = Location();
  late GoogleMapController mapController;

  /// intial location
  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
  );
  Set<Marker> markers = {
    const Marker(
        markerId: MarkerId('0'),
        position: LatLng(37.42796133580664, -122.085749655962))
  };

  LatLng? currentLatLng;

  /// permissions
  Future<void> getLocation() async {
    bool locationPermission = await getLocationPermission();
    if (!locationPermission) {
      return;
    }

    bool serviceEnabled = await getServiceEnabled();
    if (!serviceEnabled) {
      return;
    }
    LocationData currentLocation = await location.getLocation();
    changeLocationMap(currentLocation);
  }

  Future<bool> getLocationPermission() async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }

  Future<bool> getServiceEnabled() async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  /// change location

  void changeLocationMap(LocationData currentLocation) {
    currentLatLng = LatLng(
        currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0);

    cameraPosition = CameraPosition(
      target: currentLatLng!,
      zoom: 17,
    );

    markers = {
      Marker(
        markerId: const MarkerId('0'),
        position: currentLatLng!,
      )
    };

    mapController.animateCamera(CameraUpdate.newLatLng(currentLatLng!));

    notifyListeners();
  }

  /// change location by event
  void changeLocation(double ?lat, double? lang) {
    LatLng location;
    location = LatLng(lat!, lang!);
    cameraPosition = CameraPosition(
      target: location,
      zoom: 17,
    );
    markers = {
      Marker(
        markerId: const MarkerId('0'),
        position: location,
      )
    };
    mapController.animateCamera(CameraUpdate.newLatLng(location));
    notifyListeners();
  }
}
