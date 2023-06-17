import 'package:english_memory/model/english_today.dart';
import 'package:english_memory/values/app_assets.dart';
import 'package:english_memory/values/app_colors.dart';
import 'package:english_memory/values/app_styles.dart';
import 'package:flutter/material.dart';

class AllWordsPage extends StatelessWidget {
  final List<EnglishToday> allWords;

  const AllWordsPage({super.key, required this.allWords});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.secondColor,
        appBar: AppBar(
          backgroundColor: AppColors.secondColor,
          elevation: 0,
          title: Text(
            'Show More',
            style:
                AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(AppAssets.leftArrow),
          ),
        ),
        body: ListView.builder(
          itemCount: allWords.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                //Khi làm việc với decoration thì đưa color vào bên trong
                color: index % 2 == 0
                    ? AppColors.primaryColor
                    : AppColors.secondColor,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  allWords[index].noun!,
                  style: index % 2 == 0
                      ? AppStyles.h4
                      : AppStyles.h4.copyWith(color: AppColors.textColor),
                ),
                subtitle: Text(allWords[index].quote ??
                    'Think of all the beauty still left arround you and be happy.'),
                leading: Icon(Icons.favorite,
                    color:
                        allWords[index].isFavorite ? Colors.red : Colors.grey),
              ),
            );
          },
        ));
  }
}
