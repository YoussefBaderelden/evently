import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EventCard extends StatefulWidget {
  EventCard({
    super.key,
    required this.event,
    this.onFavouriteChanged,
  });
  Event event;
  final VoidCallback? onFavouriteChanged;

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isTabbed = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userprovider =
        Provider.of<UserProvider>(context, listen: false);
    bool isFavourite = userprovider.checkIfEventIsFavourite(widget.event.id);
    var screendim = MediaQuery.sizeOf(context);
    TextTheme texttheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('details', arguments: widget.event);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: screendim.height * 0.25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(
                'assets/image/${widget.event.category.imageName}.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: screendim.width * 0.1,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '${widget.event.dateTime.day}',
                    style:
                        texttheme.titleLarge?.copyWith(color: AppTheme.primary),
                  ),
                  Text(
                    DateFormat('MMM').format(widget.event.dateTime),
                    style: texttheme.labelMedium
                        ?.copyWith(color: AppTheme.primary),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      widget.event.title,
                      style: texttheme.labelMedium,
                      softWrap: true,
                      maxLines: 3,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          if (isFavourite) {
                            userprovider.removeFromFavourits(widget.event.id);
                          } else {
                            userprovider.addToFavourits(widget.event.id);
                          }
                          if (widget.onFavouriteChanged != null) {
                            widget.onFavouriteChanged!();
                          }
                        });
                      },
                      icon: isFavourite
                          ? Icon(
                              CupertinoIcons.heart_solid,
                              color: AppTheme.primary,
                            )
                          : Icon(
                              CupertinoIcons.heart,
                              color: AppTheme.primary,
                            ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
