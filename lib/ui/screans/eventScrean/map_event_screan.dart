import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/event_map_screan_provider.dart';
import '../../../core/providers/map_screan_provider.dart';

class MapEventScrean extends StatefulWidget {
  MapEventScrean({super.key});

  @override
  State<MapEventScrean> createState() => _MapEventScreanState();
}

class _MapEventScreanState extends State<MapEventScrean> {
  late EventMapScreanProvider mapScreanProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapScreanProvider = Provider.of<EventMapScreanProvider>(context,listen: false);
    mapScreanProvider.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    mapScreanProvider = Provider.of<EventMapScreanProvider>(context);
    return Scaffold(
      body: Consumer<EventMapScreanProvider>(
          builder: (context, mapScreanProvider, child) {
        return Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: mapScreanProvider.cameraPosition,
                onMapCreated: (controller) {
                  mapScreanProvider.mapController = controller;
                },
                markers: mapScreanProvider.markers,
                onTap: (latlng) {
                  mapScreanProvider.changeLocation(latlng);
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              color: AppColors.primaryPurple,
              child: const Text(
                'Tap on Location To Select',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.bgwhite),
              ),
            )
          ],
        );
      }),
    );
  }
}
