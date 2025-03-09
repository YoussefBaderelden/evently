import 'package:evently_app/providers/map_provider.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class ChooseLocation extends StatefulWidget {
  ChooseLocation({
    super.key,
  });

  @override
  State<ChooseLocation> createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MapProvider>(context, listen: false).getEventLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, _) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: GoogleMap(
                  onTap: (latLng) {
                    print("User selected location: $latLng");
                    mapProvider.setChoosedLocation(latLng);
                    Navigator.of(context).pop();
                  },
                  initialCameraPosition: mapProvider.kGooglePlex,
                  mapType: MapType.normal,
                  markers: mapProvider.markers,
                  onMapCreated: (controller) {
                    mapProvider.mapController = controller;
                  },
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                ),
                child: Center(
                  child: Text(
                    'Tab On Location To Select',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppTheme.white,
                        ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
