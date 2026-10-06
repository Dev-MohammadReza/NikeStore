import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nick/common/scroll_physics.dart';
import 'package:nick/data/banner.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'image.dart';

class BannerSlider extends StatelessWidget {
  final PageController _controller = PageController();
  final List<BannerEntity> banners;

  BannerSlider({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8,left: 8),
            child: PageView.builder(
              controller: _controller,
              physics: defultScrollPhysics,
              itemCount: banners.length,
              itemBuilder: (context, index) {
                return ImageLoadingService(imageUrl: banners[index].imageUrl,borderRadius: BorderRadius.circular(8),);
              },
            ),
          ),
          Positioned(
            bottom: 8,
            right: 0,
            left: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                axisDirection: Axis.horizontal,
                effect: WormEffect(
                  spacing: 6.0,
                  radius: 4.0,
                  dotWidth: 20.0,
                  dotHeight: 2.0,
                  paintStyle: PaintingStyle.stroke,
                  dotColor: Colors.grey.shade400,
                  activeDotColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
