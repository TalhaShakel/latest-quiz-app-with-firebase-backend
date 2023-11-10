import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/utils/cached_image_filter.dart';
import '../models/category.dart';
import '../pages/quizzes.dart';
import '../utils/next_screen.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.d,
  }) : super(key: key);

  final Category d;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: ()=> NextScreen.nextScreenNormal(context, Quizzes(category: d)),
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5)),
            child: CustomCacheImageWithDarkFilterFull(
                imageUrl: d.thumbnailUrl!, radius: 5),
          ),
        ),
        IgnorePointer(
          child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 20, 20, 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.name.toString(),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,),
                    ),
                    const SizedBox(height: 3,),
                    Text(
                      'quiz-count',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey.shade300),
                    ).tr(args: [d.quizCount.toString()])
                  ],
                ),
              )),
        )
      ],
    );
  }
}