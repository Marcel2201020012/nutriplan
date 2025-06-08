import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutriplan/widgets/text_styles.dart';

AppBar appbar(String username){
  return AppBar(
      leading: GestureDetector(
        onTap: () {},
        child: Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/img/danyi_profile.png'),
          ),
        ),
      ),
      title: Text('Hai, $username', style: AppTextStyles.h5b),
      actions: [
        GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: 60,
            child: SvgPicture.asset(
              'assets/icons/notif.svg',
              height: 35,
              width: 35,
            ),
          ),
        ),
      ],
    );
}