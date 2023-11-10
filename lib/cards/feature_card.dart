import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/models/category.dart';
import 'package:quiz_app/pages/quizzes.dart';
import 'package:quiz_app/utils/cached_image_filter.dart';
import '../utils/next_screen.dart';
import '../widgets/custom_chip.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () => NextScreen.nextScreenNormal(
              context, Quizzes(category: category)),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: CustomCacheImageWithDarkFilterBottom(
              imageUrl: category.thumbnailUrl.toString(),
              radius: 8,
            ),
          ),
        ),
        IgnorePointer(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 35, right: 35),
              child: CustomChip(
                label: 'featured'.tr(),
                icon: null,
                bgColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 35, right: 30, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name!,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Text('quiz-count',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.grey[300])).tr(args: [category.quizCount.toString()]),
                      const SizedBox(
                        width: 10,
                      ),
                      
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white60,
                        )),
                    child: Text(
                      'explore',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.white),
                    ).tr(),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
