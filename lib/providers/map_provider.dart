import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapProvider with ChangeNotifier {
  Location location = Location();

  String locationMessage = '';

  LatLng? choosedlocation;

  late GoogleMapController mapController;

  CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 17,
  );

  Set<Marker> markers = {
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(37.42796133580664, -122.085749655962),
    )
  };

  Future<bool> getLocationPermission() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
    }
    return permissionStatus == PermissionStatus.granted;
  }

  Future<void> getEventLocation() async {
    bool locationPermissionGranted = await getLocationPermission();
    if (!locationPermissionGranted) {
      return;
    }
    bool locationServiceIsEnabled = await locationServiceEnabled();
    if (!locationServiceIsEnabled) {
      return;
    }

    LocationData locationData = await location.getLocation();

    changeLocationOnMap(locationData);
  }

  Future<bool> locationServiceEnabled() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  void setLocationListener() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      changeLocationOnMap(currentLocation);
    });
  }

  void changeLocationOnMap(LocationData locationData) {
    markers = {
      Marker(
        markerId: MarkerId('1'),
        position:
            LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
      )
    };
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target:
              LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
          zoom: 17,
        ),
      ),
    );
    notifyListeners();
  }

  void setChoosedLocation(LatLng location) {
    choosedlocation = location;
    print("Saved chosen location: $choosedlocation");
    markers = {
      Marker(
        markerId: MarkerId('selected_location'),
        position: location,
      ),
    };
    notifyListeners();
    print("New marker set at: ${location.latitude}, ${location.longitude}");
  }

  void changeCameraPosition(LatLng location) {
    markers = {
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(location.latitude, location.longitude),
      )
    };

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: 12,
        ),
      ),
    );
    notifyListeners();
  }
}
