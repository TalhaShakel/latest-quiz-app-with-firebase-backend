import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    Key? key,
    required this.label,
    this.icon,
    required this.bgColor,
  }) : super(key: key);

  final String label;
  final IconData? icon;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: bgColor.withOpacity(0.6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: icon != null,
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          Text(
            label,
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}

class CustomChip1 extends StatelessWidget {
  const CustomChip1({
    Key? key,
    required this.label,
    required this.icon,
    required this.bgColor,
  }) : super(key: key);

  final String label;
  final IconData icon;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor.withOpacity(0.6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: Colors.white,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: Theme.of(context).primaryTextTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
