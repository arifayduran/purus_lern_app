import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:purus_lern_app/src/config/palette.dart';
import 'package:purus_lern_app/src/data/app_info.dart';
import 'package:purus_lern_app/src/widgets/my_menu_cards_widget.dart';
import 'package:purus_lern_app/src/features/mainmenu/data/menu_card_list.dart';
import 'package:purus_lern_app/src/features/mainmenu/presentation/widgets/preview_video_widget.dart';

class MainmenuScreen extends StatelessWidget {
  const MainmenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12, right: 12),
            child: MyMenuCardsWidget(
              onTap: () {},
              width: double.infinity,
              padding: 5,
              title: "Lernvideo fortsetzen / nächstes Lernvideo",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 15.0, right: 8, top: 8, bottom: 8),
                      child: SizedBox(
                        height: double.infinity,
                        width: 94,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kapitel",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: purusDarkGrey,
                                height: 0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                            ),
                            Text(
                              "sdanlöaj kflkjas djfhaö skjd ahjkdhash asdhas haosidh aohdoi hfas",
                              overflow: TextOverflow.fade,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 8.5,
                                color: purusDarkGrey,
                                height: 0,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Thema",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                height: 0,
                                color: purusDarkGrey,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0,
                              ),
                            ),
                            Text(
                              "asDÖ LAHSDÖ JKahs dköh aodihasoid haosidhoad ssk HKJAS",
                              overflow: TextOverflow.fade,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 8.5,
                                height: 0,
                                color: purusDarkGrey,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          width: 1,
                          color: borderStrokeGrey,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Material(
                          child: InkWell(
                            highlightColor: purusLightGreen,
                            splashColor: purusLightGreen,
                            onTap: () {},
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                currentPlatform == "Windows" ||
                                        currentPlatform == "Unknown"
                                    ? Padding(
                                        padding: const EdgeInsets.all(9.0),
                                        child: Center(
                                            child: Text(
                                          "Videovorschau wird in dieser Platform leider nicht unterstüzt.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10),
                                        )),
                                      )
                                    : const Opacity(
                                        opacity: 0.5,
                                        child: PreviewVideoWidget()),
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    color: purusLightGreen,
                                  ),
                                ),
                                currentPlatform == "Windows" ||
                                        currentPlatform == "Unknown"
                                    ? SizedBox()
                                    : const Center(
                                        child: SFIcon(
                                          SFIcons.sf_play_fill,
                                          // SFIcons.sf_play_circle_fill,
                                          fontSize: 50,
                                          color: purusGreen,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, left: 12, right: 12),
            child: SizedBox(
              // height: double.infinity,
              // width: double.infinity,
              child: GridView.builder(
                  itemCount: menuItems.length,
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return MyMenuCardsWidget(
                      onTap: () {},
                      title: menuItems[index].title,
                      child: menuItems[index].child,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
