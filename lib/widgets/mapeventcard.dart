import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapEventCard extends StatefulWidget {
  MapEventCard({super.key, required this.event, required this.onpress});
  Event event;
  final Function(double, double) onpress;

  @override
  State<MapEventCard> createState() => _MapEventCardState();
}

class _MapEventCardState extends State<MapEventCard> {
  String? eventAddress;

  @override
  void initState() {
    super.initState();
    fetchEventAddress(widget.event.lat!, widget.event.long!);
  }

  void fetchEventAddress(double latitude, double longitude) async {
    String result = await getAddressFromLatLng(latitude, longitude);
    setState(() {
      eventAddress = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screendim = MediaQuery.sizeOf(context);
    TextTheme texttheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        widget.onpress(widget.event.lat!, widget.event.long!);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: screendim.height * 0.1,
        width: screendim.width * 0.8,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primary,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/image/${widget.event.category.imageName}.png',
                width: screendim.width * 0.35,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: texttheme.labelMedium?.copyWith(
                      color: AppTheme.primary,
                    ),
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          eventAddress ?? 'Fetching address...',
                          style: texttheme.labelMedium,
                          softWrap: true,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      GeoCode geoCode = GeoCode();

      Address address = await geoCode.reverseGeocoding(
          latitude: latitude, longitude: longitude);

      return " ${address.region ?? 'unknown'} , ${address.countryName ?? 'unknown'}";
    } catch (e) {
      return "Error retrieving address: $e";
    }
  }
}
