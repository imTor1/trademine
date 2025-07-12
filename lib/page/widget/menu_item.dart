import 'package:flutter/material.dart';
import 'package:trademine/theme/app_styles.dart';

Widget MenuItem({
  required BuildContext context,
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  double width = MediaQuery.of(context).size.width;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 60,
      padding: EdgeInsets.symmetric(horizontal: width * 0.025),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 26, color: AppColor.textColor),
              const SizedBox(width: 16),
              Text(text, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: width * 0.04,
            color: AppColor.textColor,
          ),
        ],
      ),
    ),
  );
}
