import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import 'package:plants_spotify/model/utils/dimensions_resource.dart';
import 'package:plants_spotify/view/widgets/common/helper.dart';
import 'package:get/get.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key,});



  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(DimensionResource.paddingSizeDefault),
          width: HelperFunction.screenWidth(),
          child: Column(
            children: [
              Platform.isIOS ? Gap(DimensionResource.defaultIos) : Gap(DimensionResource.defaultTop),

              /// HEADER ROW
              Row(
                children: [
                  _circle(50),
                  Gap(DimensionResource.marginSizeSmall),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _line(160, 14),
                        Gap(6),
                        _pill(120, 22),
                      ],
                    ),
                  ),
                  _circle(40),
                ],
              ).paddingOnly(bottom: DimensionResource.marginSizeDefault),

              /// SEARCH BAR
              _pill(
                HelperFunction.screenWidth(),
                50,
                radius: 25,
              ).paddingOnly(bottom: DimensionResource.marginSizeDefault),

              /// ================= FEATURE CARDS =================
              SizedBox(
                height: 300,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// LEFT BIG CARD
                    Expanded(
                      child: _card(radius: 16),
                    ),

                    Gap(DimensionResource.marginSizeDefault),

                    /// RIGHT STACKED
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(child: _card(radius: 16)),
                          Gap(10),
                          Expanded(child: _card(radius: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).paddingOnly(bottom: DimensionResource.marginSizeDefault);
  }






}
/// trending
class TrendingHomeShimmer extends StatelessWidget {
  const TrendingHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ================= TRENDING =================
        _sectionTitle(),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: DimensionResource.marginSizeDefault,
            ),
            itemCount: 4,
            separatorBuilder: (_, __) =>
                Gap(DimensionResource.marginSizeDefault),
            itemBuilder: (_, __) => _trendingCard(),
          ),
        ),
        _divider(),
      ],
    );
  }
}

/// plant Index
class PlantIndexHomeShimmer extends StatelessWidget {
  const PlantIndexHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ================= PLANT INDEX =================
        _sectionTitle(),
        Padding(
          padding: EdgeInsets.all(DimensionResource.marginSizeDefault),
          child: Column(
            children: [

              /// BIG IMAGE CARD
              _imageCard(height: 120)
                  .paddingOnly(bottom: DimensionResource.marginSizeSmall),

              /// TWO SMALL CARDS
              Row(
                children: [
                  Expanded(child: _imageCard(height: 120)),
                  Gap(DimensionResource.marginSizeSmall),
                  Expanded(child: _imageCard(height: 120)),
                ],
              ),
            ],
          ),
        ),
        _divider(),
      ],
    );
  }
}

/// Articles
class ArticlesHomeShimmer extends StatelessWidget {
  const ArticlesHomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ================= ARTICLES =================
        _sectionTitle(),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
              left: DimensionResource.marginSizeDefault,
            ),
            itemCount: 3,
            separatorBuilder: (_, __) =>
                Gap(DimensionResource.marginSizeDefault),
            itemBuilder: (_, __) => _articleCard(),
          ),
        ),
        _divider(),
      ],
    );
  }
}


/// Articles
class Tips extends StatelessWidget {
  const Tips({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// ================= TIPS =================
        _sectionTitle(showAction: false),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              horizontal: DimensionResource.marginSizeSmall,
            ),
            itemCount: 3,
            separatorBuilder: (_, __) =>
                Gap(DimensionResource.marginSizeSmall),
            itemBuilder: (_, __) => _tipsCard(),
          ),
        ),
      ],
    );
  }
}



/// ================= SHIMMER HELPERS =================

Widget _shimmer(Widget child) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: child,
  );
}

Widget _card({double radius = 8}) {
  return _shimmer(
    Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

Widget _line(double width, double height) {
  return _shimmer(
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

Widget _pill(double width, double height, {double radius = 15}) {
  return _shimmer(
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

Widget _circle(double size) {
  return _shimmer(
    Container(
      height: size,
      width: size,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    ),
  );
}

Widget _sectionTitle({bool showAction = true}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: DimensionResource.marginSizeDefault,
    ),
    child: Row(
      children: [
        _line(120, 16),
        const Spacer(),
        if (showAction) _line(60, 14),
      ],
    ),
  ).paddingOnly(bottom: DimensionResource.marginSizeSmall);
}

Widget _divider() {
  return Divider(
    color: Colors.grey.withValues(alpha: 0.15),
    height: DimensionResource.marginSizeLarge,
  );
}

Widget _trendingCard() {
  return _shimmer(
    Container(
      width: 200,
      padding: EdgeInsets.all(DimensionResource.marginSizeSmall),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Container(height: 150, color: Colors.white),
          Gap(8),
          Container(height: 14, width: 120, color: Colors.white),
          Gap(4),
          Container(height: 12, width: 160, color: Colors.white),
        ],
      ),
    ),
  );
}

Widget _imageCard({required double height}) {
  return _shimmer(
    Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}

Widget _articleCard() {
  return _shimmer(
    Container(
      width: HelperFunction.screenWidth() * .5,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

Widget _tipsCard() {
  return _shimmer(
    Container(
      width: HelperFunction.screenWidth() * .9,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    ),
  );
}