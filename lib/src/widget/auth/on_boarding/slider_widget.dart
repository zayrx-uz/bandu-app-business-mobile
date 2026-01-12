import 'package:bandu_business/src/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({
    super.key,
    required this.title,
    required this.image,
    required this.imageHeight,
    required this.imageWidth,
    required this.subTitle,
    this.sizedBoxHeight = 150,
  });

  final String title;
  final String subTitle;
  final String image;
  final double imageHeight;
  final double imageWidth;
  final double sizedBoxHeight;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageAnimation;
  late Animation<double> _titleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _imageAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
    );

    _titleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: widget.sizedBoxHeight.h),
        ScaleTransition(
          scale: _imageAnimation,
          child: FadeTransition(
            opacity: _imageAnimation,
            child: Image.asset(
              widget.image,
              height: widget.imageHeight.h,
              width: widget.imageWidth.w,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              FadeTransition(
                opacity: _titleAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(_titleAnimation),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TypewriterAnimatedText(
                    widget.subTitle,
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.c585B57,
                    ),
                    speed: const Duration(milliseconds: 40),
                    cursor: "..."
                  ),

                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}