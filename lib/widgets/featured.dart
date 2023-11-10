import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/category.dart';
import 'package:quiz_app/widgets/loading_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../cards/feature_card.dart';
import '../services/firebase_service.dart';

class FeaturedCategories extends StatefulWidget {
  const FeaturedCategories({Key? key}) : super(key: key);

  @override
  State<FeaturedCategories> createState() => _FeaturedCategoriesState();
}

class _FeaturedCategoriesState extends State<FeaturedCategories> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final String collectionName = 'categories';
  late Future _future;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _future = FirebaseService().getFeaturedCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      width: double.infinity,
      child: FutureBuilder(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.hasData && snapshot.data.length == 0) {
            return Center(child: const Text('no-content').tr());
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      Category category = snapshot.data[index];
                      return FeatureCard(category: category);
                    }
                  ),
                ),
                Visibility(
                    visible: snapshot.data.length != 0 ? true : false,
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: snapshot.data.length,
                      effect: const WormEffect(
                          dotHeight: 3, dotWidth: 15, spacing: 5),
                    ))
              ],
            );
          }
          return const LoadingIndicatorWidget();
        },
      ),
    );
  }
}
