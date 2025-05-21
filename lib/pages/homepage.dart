import 'package:flutter/material.dart';
import 'package:nutriplan/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('5 januari 2025'),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('data'), Text('data')],
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, 
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(),
              ],)
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
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
      title: Text('Hai, User', style: AppTextStyles.h5b),
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
}
