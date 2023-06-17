import 'package:english_memory/values/app_styles.dart';
import 'package:flutter/material.dart';

class ShowMoreContainer extends StatelessWidget {
  const ShowMoreContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Show more...',
        style: AppStyles.h3.copyWith(shadows: [
          const BoxShadow(
              color: Colors.black38, offset: Offset(3, 6), blurRadius: 6)
        ]),
      ),
    );
  }
}
