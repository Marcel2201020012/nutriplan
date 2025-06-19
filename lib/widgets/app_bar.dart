import 'package:flutter/material.dart';
import 'package:nutriplan/widgets/text_styles.dart';

AppBar appbar(String username, BuildContext context){
  return AppBar(
      leading: GestureDetector(
        onTap: () {},
        child: const Align(
          alignment: Alignment.centerRight,
          child: CircleAvatar(
            radius: 20,
            child: Icon(Icons.account_circle_outlined, size: 24,),
          ),
        ),
      ),
      title: Text('Hai, $username', style: AppTextStyles.h5b),
    );
}