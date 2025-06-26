import 'package:event_planning_app/core/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension ProviderExtension on BuildContext {
  AppProvider get appProvider {
    return Provider.of<AppProvider>(this);
  }
}
