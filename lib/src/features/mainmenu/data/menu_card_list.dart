// ignore_for_file: deprecated_member_use

import 'package:flutter_svg/svg.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/features/mainmenu/domain/menu_card_class.dart';
import 'package:purus_lern_app/src/features/mainmenu/presentation/widgets/my_progress_circle.dart';

List<MenuCardClass> menuItems = [
  MenuCardClass(
    title: "Lernfortschritt",
    onTap: () {},
    child: const MyProgressCircle(),
  ),
  MenuCardClass(
    title: "Lernmenü",
    onTap: () {},
    child: SvgPicture.asset(
      "assets/icons/edu.svg",
      color: purusGreen,
    ),
  ),
  MenuCardClass(
    title: "Lexikon",
    onTap: () {},
    child: SvgPicture.asset(
      "assets/icons/lexikon_buch.svg",
      color: purusGreen,
    ),
  ),
  MenuCardClass(
    title: "Profilmenü",
    onTap: () {},
    child: SvgPicture.asset(
      "assets/icons/profil.svg",
      color: purusGreen,
    ),
  ),
];
