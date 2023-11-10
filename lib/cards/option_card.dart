import 'package:flutter/material.dart';
import 'package:quiz_app/utils/icon_utils.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    Key? key,
    required bool isSelected,
    required this.optionTitle,
  })  : _isSelected = isSelected,
        super(key: key);

  final bool _isSelected;
  final String optionTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 10),
      constraints: const BoxConstraints(minHeight: 60),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: _isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
            optionTitle,
            textAlign: TextAlign.start,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: _isSelected ? Colors.white : Colors.blueGrey.shade600),
          )),
          const SizedBox(
            width: 5,
          ),
          Icon(
              _isSelected
                  ? IconUtils.rightAnswerOption
                  : IconUtils.disbbleOption,
              color: _isSelected ? Colors.white : Colors.grey,
              size: 22,
            ),
        ],
      ),
    );
  }
}
