import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:english_memory/model/english_today.dart';
import 'package:english_memory/pages/all_words_page.dart';
import 'package:english_memory/pages/control_page.dart';
import 'package:english_memory/pages/home_pages/body/show_more.dart';
import 'package:english_memory/pakages/quote/qoute_model.dart';
import 'package:english_memory/pakages/quote/quote.dart';
import 'package:english_memory/values/app_colors.dart';
import 'package:english_memory/values/app_styles.dart';
import 'package:english_memory/values/share_keys.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<EnglishToday> words = [];

  String quoteHeaderRan = Quotes().getRandom().content!;

  List<int> fixedListRandom({int len = 1, int max = 120, int min = 1}) {
    if (len > max || len < min) {
      return [];
    }
    List<int> newList = [];

    Random random = Random();
    int count = 1;
    while (count <= len) {
      int val = random.nextInt(max);
      if (newList.contains(val)) {
        continue;
      } else {
        newList.add(val);
        count++;
      }
    }

    return newList;
  }

  EnglishToday getQuote(String noun) {
    Quote? quote;
    quote = Quotes().getByWord(noun);
    return EnglishToday(noun: noun, quote: quote?.content, id: quote?.id);
  }

  getEnglishToday() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int counterLen = prefs.getInt(ShareKeys.counter) ?? 5;

    List<String> newList = [];
    List<int> rans = fixedListRandom(len: counterLen, max: nouns.length);

    rans.forEach((index) {
      newList.add(nouns[index]);
    });

    setState(() {
      words = newList.map((e) => getQuote(e)).toList();
    });
  }

  @override
  void initState() {
    _pageController = PageController(viewportFraction: 0.9);
    super.initState();
    getEnglishToday(); //Khi sử dụng bất đồng bộ phải bỏ xuống dưới initState mới hoạt động được vì initState không có bất đồng bộ
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: AppColors.primaryColor,
      action: SnackBarAction(
        label: 'Show more...',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AllWordsPage(
                        allWords: this.words,
                      )));
        },
      ),
      content: Text(
        'New Words ${words.length}',
        style: AppStyles.h5.copyWith(color: AppColors.textColor),
      ),
      duration: const Duration(milliseconds: 2500),
      width: 280.0, // Width of the SnackBar.
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0, // Inner padding for SnackBar content.
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    void showSnackBar() {
      setState(() {
        getEnglishToday().whenComplete(() {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      });
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.secondColor,
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        title: Text(
          'English Today',
          style:
              AppStyles.h3.copyWith(color: AppColors.textColor, fontSize: 36),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Image.asset('assets/images/3x/menu.png'),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(children: [
            Container(
              height: size.height * 1 / 10,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: Text(
                '"$quoteHeaderRan"',
                style: AppStyles.h5
                    .copyWith(fontSize: 12, color: AppColors.textColor),
              ),
            ),
            Container(
              height: size.height * 2 / 3,
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: words.length > 5 ? 6 : words.length,
                  itemBuilder: (context, index) {
                    String firstLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    firstLetter = firstLetter.substring(0, 1);

                    String leftLetter =
                        words[index].noun != null ? words[index].noun! : '';
                    leftLetter = leftLetter.substring(1, leftLetter.length);

                    String quoteDefault =
                        "Think of all the beauty still left arround you and be happy.";

                    String quote = words[index].quote != null
                        ? words[index].quote!
                        : quoteDefault;

                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24)),
                        color: AppColors.primaryColor,
                        elevation: 4,
                        child: InkWell(
                          onDoubleTap: () {
                            setState(() {
                              words[index].isFavorite =
                                  !words[index].isFavorite;
                            });
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                          splashColor: Colors.transparent,
                          child: index >= 5
                              ? InkWell(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24)),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AllWordsPage(
                                                allWords: this.words)));
                                  },
                                  child: const ShowMoreContainer())
                              : Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        LikeButton(
                                          onTap: (bool isLiked) async {
                                            setState(() {
                                              words[index].isFavorite =
                                                  !words[index].isFavorite;
                                            });
                                            return words[index].isFavorite;
                                          },
                                          isLiked: words[index].isFavorite,
                                          padding: const EdgeInsets.only(
                                              right: 10, top: 10),
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          size: 42,
                                          circleColor: const CircleColor(
                                              start: Color(0xff00ddff),
                                              end: Color(0xff0099cc)),
                                          bubblesColor: const BubblesColor(
                                            dotPrimaryColor: Color(0xff33b5e5),
                                            dotSecondaryColor:
                                                Color(0xff0099cc),
                                          ),
                                          likeBuilder: (bool isLiked) {
                                            return ImageIcon(
                                              const AssetImage(
                                                  'assets/images/3x/heart.png'),
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.white,
                                              size: 42,
                                            );
                                          },
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6),
                                          child: RichText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              text: TextSpan(
                                                  text: firstLetter,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          FontFamily.sen,
                                                      fontSize: 89,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      shadows: const [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black38,
                                                            offset:
                                                                Offset(3, 6),
                                                            blurRadius: 6)
                                                      ]),
                                                  children: [
                                                    TextSpan(
                                                        text: leftLetter,
                                                        style: TextStyle(
                                                            fontFamily:
                                                                FontFamily.sen,
                                                            fontSize: 56,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            shadows: const [
                                                              BoxShadow(
                                                                  color: Colors
                                                                      .black38,
                                                                  offset:
                                                                      Offset(
                                                                          3, 6),
                                                                  blurRadius: 6)
                                                            ]))
                                                  ])),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 24, left: 14),
                                            child: AutoSizeText(
                                              '"$quote"',
                                              maxFontSize: 26,
                                              minFontSize: 12,
                                              style: AppStyles.h4.copyWith(
                                                  letterSpacing: 1,
                                                  color: AppColors.textColor),
                                              overflow: TextOverflow.fade,
                                            ))
                                      ]),
                                ),
                        ),
                      ),
                    );
                  }),
            ),

            /* Indicator */
            Container(
              height: 12,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.only(left: 30),
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return buildIndicator(index == _currentIndex, size);
                  }),
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryColor,
        onPressed: () {
          setState(() {
            getEnglishToday().whenComplete(() {
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          });
        },
        child: Image.asset('assets/images/3x/loading.png'),
      ),
      drawer: Drawer(
        child: Container(
            color: AppColors.lighBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
                  child: Text(
                    'Your mind',
                    style: AppStyles.h3.copyWith(color: AppColors.textColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                offset: Offset(3, 6),
                                blurRadius: 6)
                          ]),
                      child: Text(
                        'Favourites',
                        style:
                            AppStyles.h5.copyWith(color: AppColors.textColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              ControlPage(dataRefresh: showSnackBar)));
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black38,
                                offset: Offset(3, 6),
                                blurRadius: 6)
                          ]),
                      child: Text(
                        'Your Control',
                        style:
                            AppStyles.h5.copyWith(color: AppColors.textColor),
                      ),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: const Duration(microseconds: 300),
      curve: Curves.easeIn,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      width: isActive ? size.width * 1 / 5 : 24,
      decoration: BoxDecoration(
          color: isActive ? AppColors.lighBlue : AppColors.blackGrey,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: const [
            BoxShadow(
                color: Colors.black38, offset: Offset(2, 3), blurRadius: 3)
          ]),
    );
  }
}
