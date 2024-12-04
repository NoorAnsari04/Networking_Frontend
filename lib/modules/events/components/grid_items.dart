import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GridItems extends StatelessWidget {
  final String title;
  final String backgroundImagePath;
  final double width;
  final double height;
  final double top;
  final double left;
  final VoidCallback? onTap;

  const GridItems({
    Key? key,
    required this.title,
    required this.backgroundImagePath,
    required this.width,
    required this.height,
    required this.top,
    required this.left,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImagePath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 18.sp, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
