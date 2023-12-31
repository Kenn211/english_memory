import 'package:english_memory/values/app_assets.dart';
import 'package:english_memory/values/app_colors.dart';
import 'package:english_memory/values/app_styles.dart';
import 'package:english_memory/values/share_keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key, required this.dataRefresh});

  final Function() dataRefresh;

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  double sliderValue = 5;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initDefaultValue();
  }

  initDefaultValue() async {
    prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(ShareKeys.counter) ?? 5;
    setState(() {
      sliderValue = value.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
          backgroundColor: AppColors.secondColor,
          elevation: 0,
          title: Text(
            'Your Control',
            style:
                AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
          ),
          leading: InkWell(
            onTap: () {
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Image.asset(AppAssets.leftArrow),
          )),
      body: Container(
        width: double.infinity,
        child: Column(children: [
          const Spacer(),
          Text(
            'How much a number word at once',
            style:
                AppStyles.h4.copyWith(color: AppColors.lighGrey, fontSize: 18),
          ),
          const Spacer(),
          Text(
            '${sliderValue.toInt()}', // Số đẹp
            style: AppStyles.h1.copyWith(
              color: AppColors.primaryColor,
              fontSize: 150,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
              value: sliderValue,
              min: 5,
              max: 100,
              divisions: 95, //Nhảy từng số một
              activeColor: AppColors.primaryColor,
              inactiveColor: AppColors.primaryColor,
              onChanged: (value) {
                setState(() {
                  sliderValue = value;
                });
              }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            alignment: Alignment.centerLeft,
            child: Text(
              'slide to set',
              style: AppStyles.h5.copyWith(color: AppColors.lighGrey),
            ),
          ),
          const Spacer(),
          TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () async {
                // Lưu dữ liệu đã chọn khi ấn nút này
                SharedPreferences prefs = await SharedPreferences
                    .getInstance(); //Khởi tạo sharePreferences
                await prefs.setInt(
                    ShareKeys.counter, sliderValue.toInt()); //Set dữ liệu
                // EasyLoading.showToast('Toast');
                widget.dataRefresh();

                Navigator.pop(context);
              },
              child: Text(
                'Confirm',
                style: AppStyles.h4,
              )),
          const Spacer(),
          const Spacer(),
          const Spacer(),
        ]),
      ),
    );
  }
}
