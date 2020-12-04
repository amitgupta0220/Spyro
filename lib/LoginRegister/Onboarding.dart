import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smackit/LoginRegister/RedirectingPage.dart';
import '../Styles.dart';
import '../models/Slide.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> with TickerProviderStateMixin {
  final List<Slide> slides = Slide.slides;
  int _currentPage = 0;
  bool _visible = true;
  PageController _pageController;
  // AnimationController _animationController;
  // Animation _animation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    // _animationController =
    //     AnimationController(vsync: this, duration: Duration(seconds: 500));
    // _animation = Tween<Offset>(begin: Offset(0, 0.4), end: Offset(0, 0))
    //     .animate(_animationController);
    Future.delayed(
        Duration(milliseconds: 200),
        () => {
              setState(() {
                _visible = false;
              }),
              // _animationController.forward().whenComplete(() {
              //   // put here the stuff you wanna do when animation completed!
              // })
            });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.primaryLight,
        bottomSheet: _currentPage == slides.length - 1
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.35,
                color: MyColors.primaryLight,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RedirectingPage())),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.width * 0.12,
                    margin: EdgeInsets.only(
                        // right: MediaQuery.of(context).size.width * 0.15,
                        left: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.width * 0.05),
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width * 0.03,
                        horizontal: MediaQuery.of(context).size.width * 0.06),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      // border: Border.all(width: 1, color: Colors.white)
                    ),
                    child: Center(
                      child: Text('Start Now',
                          style: TextStyle(
                              color: MyColors.bg,
                              fontSize: 18,
                              fontFamily: 'Lato')),
                    ),
                  ),
                ),
              )
            : null,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Center(
                  child: Column(
                children: [
                  AnimatedOpacity(
                    opacity: _visible ? 0.0 : 1.0,
                    duration: Duration(milliseconds: 500),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        margin: EdgeInsets.only(
                            bottom: 5,
                            top: MediaQuery.of(context).size.height * 0.1),
                        child:
                            SvgPicture.asset('assets/images/SplashLogo.svg')),
                  ),
                  Text(
                    "Explore your favorites\n around you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
                ],
              )),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: MyColors.primaryLight,
                ),
                margin: EdgeInsets.fromLTRB(
                    16, MediaQuery.of(context).size.height * 0.27, 16, 0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.55,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (_, index) {
                        return Column(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.width * 0.13,
                              child: Image.asset(slides[index].imagePath),
                              margin: EdgeInsets.only(
                                  top:
                                      MediaQuery.of(context).size.height * 0.1),
                            ),
                            SizedBox(height: 20),
                            Text(slides[index].title,
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Lato',
                                    color: Colors.white),
                                textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            Text(slides[index].description,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Lato',
                                    color: Colors.white),
                                textAlign: TextAlign.center),
                          ],
                        );
                      },
                      itemCount: slides.length,
                    ),
                    Positioned(
                        bottom: MediaQuery.of(context).size.height * 0.06,
                        child: _buildIndicator()),
                  ],
                ),
              ),
              if (_currentPage != slides.length - 1)
                Positioned(
                  top: 20,
                  right: 20,
                  child: SafeArea(
                    child: GestureDetector(
                      onTap: () => _pageController.animateToPage(
                          slides.length - 1,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.fastOutSlowIn),
                      child: Container(
                        // margin: EdgeInsets.only(right: 10, top: 10),
                        child: Text('Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Lato',
                            )),
                      ),
                    ),
                  ),
                ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.89),
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // if (_currentPage > 0)
                    GestureDetector(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.15,
                            bottom: MediaQuery.of(context).size.width * 0.05),
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.03,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(width: 1, color: Colors.white)),
                        child: Center(
                          child: Text(
                            'Previous',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Lato'),
                          ),
                        ),
                      ),
                      onTap: () => _pageController.previousPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      ),
                    ),
                    // Spacer(),
                    GestureDetector(
                      child: Container(
                        // alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.35,
                        margin: EdgeInsets.only(
                            // right: MediaQuery.of(context).size.width * 0.15,
                            left: MediaQuery.of(context).size.width * 0.05,
                            bottom: MediaQuery.of(context).size.width * 0.05),
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.width * 0.03,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.06),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          // border: Border.all(width: 1, color: Colors.white)
                        ),
                        child: Center(
                          child: Text(
                            'Next',
                            style: TextStyle(
                                color: MyColors.bg,
                                fontSize: 18,
                                fontFamily: 'Lato'),
                          ),
                        ),
                      ),
                      onTap: () => _pageController.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.fastOutSlowIn,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Row _buildIndicator() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
            slides.length, (index) => _pageIndicator(_currentPage == index)));
  }

  Widget _pageIndicator(bool isCurrent) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: isCurrent ? 16 : 4,
      height: isCurrent ? 4 : 4,
      decoration: BoxDecoration(
          // border: Border.all(color: MyColors.primary, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          // shape: BoxShape.circle,
          color: isCurrent
              ? MyColors.primary
              : Color.fromRGBO(255, 255, 255, 0.43)),
    );
  }
}
