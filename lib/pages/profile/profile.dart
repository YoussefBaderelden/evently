import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/providers/event_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/services/firebaseServices.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    List<Event> events =
        Provider.of<EventsProvider>(context, listen: false).events;
    TextTheme texttheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 16,
            bottom: 16,
            right: 16,
            top: 20,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(80),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Image.asset('assets/image/route_logo.png'),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('yousef',
                          style: texttheme.displaySmall),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'yousef@gmail.com',
                        style: texttheme.labelSmall,
                        softWrap: true,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Spacer(),
        InkWell(
          onTap: () {
            FireBaseServices.logout();
            Provider.of<UserProvider>(context, listen: false)
                .updateCurrentUser(null);
            Navigator.of(context).pushReplacementNamed('login');
          },
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppTheme.red,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: AppTheme.white,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  'Logout',
                  style: texttheme.titleLarge?.copyWith(
                    color: AppTheme.white,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
