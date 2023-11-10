import 'package:flutter/material.dart';
import 'package:quiz_app/utils/cached_image.dart';
import 'package:quiz_app/utils/image_preview.dart';
import 'package:quiz_app/utils/next_screen.dart';
import '../utils/icon_utils.dart';

class ImageOptionCard extends StatelessWidget {
  const ImageOptionCard({
    Key? key,
    required bool isSelected,
    required this.optionImage,
  })  : _isSelected = isSelected,
        super(key: key);

  final bool _isSelected;
  final String optionImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      constraints: const BoxConstraints(minHeight: 120, maxHeight: 150),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Stack(
            children: [
              CustomCacheImage(
                imageUrl: optionImage,
                radius: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, right: 12),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => NextScreen().nextScreenPopup(context, FullImagePreview(imageUrl: optionImage)),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                      child: Icon(
                        Icons.fullscreen,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
          const SizedBox(
            width: 10,
          ),
          Icon(
            _isSelected ? IconUtils.rightAnswerOption : IconUtils.disbbleOption,
            color: _isSelected ? Theme.of(context).primaryColor : Colors.grey,
            size: 25,
          ),
        ],
      ),
    );
  }
}
