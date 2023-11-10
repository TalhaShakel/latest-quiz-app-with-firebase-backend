import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/pages/quizzes.dart';
import 'package:quiz_app/utils/cached_image.dart';
import 'package:quiz_app/utils/next_screen.dart';
import 'package:quiz_app/widgets/loading_widget.dart';
import '../blocs/tab_controller.dart';
import '../models/category.dart';
import '../services/firebase_service.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'categories',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[900], fontWeight: FontWeight.w600),
                ).tr(),
                TextButton(onPressed: () => context.read<TabControllerBloc>().controlTab(1), child: const Text('explore-all').tr())
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 5),
            child: FutureBuilder(
              future: FirebaseService().getHomeCategories(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                debugPrint('snapshot: ${snapshot.hasData}');
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.hasData && snapshot.data.length == 0) {
                  return Center(child: const Text('no-content').tr());
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  List<Category> categories = snapshot.data;
                  return Row(
                    children: categories.map((category) {
                      return Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: ()=> NextScreen.nextScreenNormal(context, Quizzes(category: category)),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 90, child: CustomCacheImage(imageUrl: category.thumbnailUrl, radius: 5)),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                    height: 50,
                                    child: Text(category.name.toString(),
                                        maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          fontWeight: FontWeight.w600
                                        )))
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return const LoadingIndicatorWidget();
              },
            ),
          )
        ],
      ),
    );
  }
}
