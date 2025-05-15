import 'package:flutter/material.dart';

import '../App_assets/image_assets.dart';

class Categorydm {
  String name;
  String image;
  IconData icon;

  Categorydm({required this.name, required this.image, required this.icon});

  factory Categorydm.fromName(String name) {
    switch (name) {
      case 'Sports':
        return sports;
      case 'birthday':
        return birthday;
      case 'meeting':
        return meeting;
      case 'eating':
        return eating;
      case 'holidays':
        return holidays;
      case 'exhibition':
        return exhibition;
      case 'workshop':
        return workshop;
      case 'bookClub':
        return bookClub;
      default:
        return sports;
    }
  }

  static Categorydm all =
      Categorydm(name: 'All', image: '', icon: Icons.all_inclusive);
  static Categorydm sports = Categorydm(
      name: 'Sports',
      image: ImageAssets.sport,
      icon: Icons.directions_bike_sharp);
  static Categorydm birthday = Categorydm(
      name: 'birthday', image: ImageAssets.birthday, icon: Icons.cake);
  static Categorydm meeting = Categorydm(
      name: 'meeting', image: ImageAssets.meating, icon: Icons.laptop);
  static Categorydm eating = Categorydm(
      name: 'eating', image: ImageAssets.eating, icon: Icons.fastfood_rounded);
  static Categorydm holidays = Categorydm(
      name: 'holidays',
      image: ImageAssets.holiday,
      icon: Icons.holiday_village);
  static Categorydm exhibition = Categorydm(
      name: 'exhibition',
      image: ImageAssets.exhaping,
      icon: Icons.browse_gallery);
  static Categorydm workshop = Categorydm(
      name: 'workshop', image: ImageAssets.workShop, icon: Icons.work);
  static Categorydm bookClub = Categorydm(
      name: 'bookClub',
      image: ImageAssets.book,
      icon: Icons.chrome_reader_mode_rounded);

  static List<Categorydm> categorieswithAll = [
    all,
    sports,
    birthday,
    meeting,
    eating,
    holidays,
    exhibition,
    workshop,
    bookClub
  ];
  static List<Categorydm> categorieswithOutAll = [
    sports,
    birthday,
    meeting,
    eating,
    holidays,
    exhibition,
    workshop,
    bookClub
  ];
}
