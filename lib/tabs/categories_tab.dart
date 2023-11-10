import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:quiz_app/cards/category_card.dart';
import 'package:quiz_app/services/firebase_service.dart';
import 'package:quiz_app/utils/empty_animation.dart';
import 'package:quiz_app/widgets/loading_widget.dart';
import '../configs/app_config.dart';
import '../models/category.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({Key? key}) : super(key: key);

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab>
    with AutomaticKeepAliveClientMixin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = FirebaseService().getCategories();
  }

  Future _onRefresh() async {
    _future = FirebaseService().getCategories();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _onRefresh(),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            SliverAppBar.medium(
              stretch: true,
              elevation: 0,
              expandedHeight: 120,
              toolbarHeight: kToolbarHeight,
              title: const Text(
                'all-categories',
                style: TextStyle(
                  color: Colors.white,
                ),
              ).tr(),
              titleSpacing: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
            ),
            SliverToBoxAdapter(
              child: FutureBuilder(
                future: _future,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.30),
                        const LoadingIndicatorWidget(),
                      ],
                    );
                  } else if (snapshot.hasData && snapshot.data.length != 0) {
                    return AnimationLimiter(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 3.0,
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Category d = snapshot.data[index];
                          return AnimationConfiguration.staggeredGrid(
                            columnCount: 2,
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              child: FadeInAnimation(child: CategoryCard(d: d)),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return EmptyAnimation(
                        animationString: Config.emptyAnimation,
                        title: 'no-content'.tr());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
