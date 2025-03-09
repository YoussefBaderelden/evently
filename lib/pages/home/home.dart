import 'package:evently_app/models/category.dart';
import 'package:evently_app/pages/home/tabItem.dart';
import 'package:evently_app/providers/event_provider.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:evently_app/widgets/eventCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currrentindex = 0;
  @override
  Widget build(BuildContext context) {
    EventsProvider eventsprovider = Provider.of<EventsProvider>(context);
    if (eventsprovider.events.isEmpty) {
      eventsprovider.getEventsToCategory();
    }
    return DefaultTabController(
      length: Categoryy.categories.length + 1,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 16,
              bottom: 16,
              top: 10,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back ✨',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.white,
                        ),
                  ),
                  Text(
                    'yousef',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: AppTheme.white,
                        ),
                  ),
                  SizedBox(height: 16),
                  TabBar(
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.transparent,
                      labelPadding: EdgeInsets.only(right: 10),
                      isScrollable: true,
                      onTap: (index) {
                        if (currrentindex == index) return;
                        currrentindex = index;
                        eventsprovider.changeSelectedCategory(
                          index == 0 ? null : Categoryy.categories[index - 1],
                        );
                      },
                      tabs: [
                        TabItem(
                            selectedcolor: AppTheme.white,
                            unselectedcolor: AppTheme.primary,
                            text: 'All',
                            icon: Icons.explore_outlined,
                            isSelected: currrentindex == 0),
                        ...Categoryy.categories.map(
                          (category) => TabItem(
                            selectedcolor: AppTheme.white,
                            unselectedcolor: AppTheme.primary,
                            icon: category.icon,
                            text: category.text,
                            isSelected: currrentindex ==
                                    Categoryy.categories.indexOf(category) + 1
                                ? true
                                : false,
                          ),
                        )
                      ])
                ],
              ),
            ),
          ),
          eventsprovider.events.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primary,
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: ListView.separated(
                        itemBuilder: (_, index) {
                          return index == eventsprovider.events.length - 1
                              ? Column(
                                  children: [
                                    EventCard(
                                      event: eventsprovider.events[index],
                                    ),
                                    SizedBox(
                                      height: 16,
                                    )
                                  ],
                                )
                              : EventCard(
                                  event: eventsprovider.events[index],
                                );
                        },
                        separatorBuilder: (_, index) {
                          return SizedBox(
                            height: 16,
                          );
                        },
                        itemCount: eventsprovider.events.length),
                  ),
                )
        ],
      ),
    );
  }
}
