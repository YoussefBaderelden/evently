import 'package:event_planning_app/core/providers/map_screan_provider.dart';
import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/App_assets/image_assets.dart';
import '../../../core/firebasehulpers/store/firestore_hulpers.dart';
import '../../../core/models/categoryDm.dart';
import '../../../core/models/eventDM.dart';
import '../../../core/providers/theme_provider.dart';
import '../eventScrean/event_ditels.dart';

class MapScrean extends StatefulWidget {
  const MapScrean({super.key});

  @override
  State<MapScrean> createState() => _MapScreanState();
}

class _MapScreanState extends State<MapScrean> {
  late MapScreanProvider mapScreanProvider;
  late ThemeProvider themeProvider;

  @override
  Widget build(BuildContext context) {
    mapScreanProvider = Provider.of<MapScreanProvider>(context);
    themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          GoogleMap(
            initialCameraPosition: mapScreanProvider.cameraPosition,
            onMapCreated: (controller) {
              mapScreanProvider.mapController = controller;
            },
            markers: mapScreanProvider.markers,
            onTap: (latlng) {},
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.07,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: AppColors.primaryPurple,
              onPressed: () {
                mapScreanProvider.getLocation();
              },
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          // كروت الأحداث
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.15,
            child: StreamBuilder<List<EventDM>>(
              stream: getEventsByCategory('All'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final events = snapshot.data!;
                  return events.isEmpty
                      ? const Center(child: Text('No Events'))
                      : buildEventList(themeProvider, events, context);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEventList(
      ThemeProvider themeProvider, List<EventDM> events, BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final event = events[index];
        final category = Categorydm.fromName(event.category);

        return GestureDetector(
          onTap: () {
            mapScreanProvider.changeLocation(event.lat, event.long);
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(color: AppColors.primaryPurple.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.14,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          category.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primaryPurple,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${event.lat?.round()} , ${event.long?.round()}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
