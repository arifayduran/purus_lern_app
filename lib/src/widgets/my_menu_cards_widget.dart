import 'package:flutter/material.dart';
import 'package:purus_lern_app/src/config/palette.dart';

class MyMenuCardsWidget extends StatelessWidget {
  const MyMenuCardsWidget({
    super.key,
    required this.title,
    required this.child,
    this.width = 129,
    this.height = 129,
    this.padding = 20,
    this.onTap,
  });

  final String title;
  final Widget child;
  final double width;

  final double height;
  final double padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  blurRadius: 15,
                  spreadRadius: 0,
                  color: Color.fromARGB(64, 0, 0, 0),
                  offset: Offset(-6, 6))
            ],
            border: Border.all(width: 0.7, color: borderStrokeGrey),
            color: Colors.white,
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Material(
                  child: InkWell(
                highlightColor: purusUltralightGreen,
                splashColor: purusUltralightGreen,
                onTap: onTap,
                child: Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: purusDarkGrey,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                    ),
                    const Divider(
                      height: 0,
                      thickness: 1,
                      color: borderStrokeGrey,
                    ),
                    SizedBox(
                        height: height,
                        width: width,
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: child,
                        ))
                  ],
                ),
              ))),
        ));
  }
}
