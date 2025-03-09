import 'package:evently_app/providers/event_provider.dart';
import 'package:evently_app/providers/map_provider.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:evently_app/widgets/mapeventcard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapTab extends StatefulWidget {
  MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  late MapProvider mapProvider;

  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);
    EventsProvider eventsprovider = Provider.of<EventsProvider>(context);
    if (eventsprovider.events.isEmpty) {
      eventsprovider.getEventsToCategory();
    }
    mapProvider = Provider.of<MapProvider>(
      context,
    );
    return Consumer<MapProvider>(
      builder: (context, mapProvider, _) {
        return Scaffold(
          floatingActionButton: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              FloatingActionButton(
                heroTag: 'btn2',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.white,
                onPressed: () {
                  mapProvider.getEventLocation();
                },
                child: Icon(
                  Icons.my_location_rounded,
                  size: 30,
                ),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          body: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Column(
                children: [
                  Expanded(
                    child: GoogleMap(
                      initialCameraPosition: mapProvider.kGooglePlex,
                      mapType: MapType.normal,
                      markers: mapProvider.markers,
                      onMapCreated: (controller) {
                        mapProvider.mapController = controller;
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                height: screendim.height * 0.12,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (_, index) {
                    return SizedBox(
                      child: MapEventCard(
                        event: eventsprovider.events[index],
                        onpress: (lat, long) {
                          mapProvider.changeCameraPosition(
                            LatLng(
                              lat,
                              long,
                            ),
                          );
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(width: 16);
                  },
                  itemCount: eventsprovider.events.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
