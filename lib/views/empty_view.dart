import 'package:care_giver/utils/colors.dart';
import 'package:care_giver/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

Widget getEmptryView(bool isFirst,
    {String? message, String? title, bool isAnimate = false}) {
  if (isFirst) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          SizedBox(
            height: 0,
          )
        ]);
  } else {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          (isAnimate != null && isAnimate)
              ? Container(
                  child: Lottie.asset('assets/images/empty-box.json',
                      width: 100,
                      height: 100,
                      animate: true,
                      repeat: true,
                      fit: BoxFit.fill),
                )
              : SvgPicture.asset(
                  "assets/images/ic_empty.svg",
                  matchTextDirection: true,
                  width: 100,
                  height: 100,
                ),
          const SizedBox(
            height: 10,
          ),
          Text(
            (title != null && title.isNotEmpty) ? title : STRINGS.empty_data,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: COLORS.menu_color),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            (message == null || message == "")
                ? STRINGS.nothing_to_show
                : message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, color: COLORS.menu_color),
          )
        ],
      ),
    );
  }
}
