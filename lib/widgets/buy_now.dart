import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/services/app_service.dart';
import 'package:quiz_app/utils/icon_utils.dart';

class BuyNowWIdget extends StatelessWidget {
  const BuyNowWIdget({Key? key, required this.textStyle}) : super(key: key);

  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      IconUtils.buy,
                    ),
                    title: Text('buy-app', style: textStyle,).tr(),
                    subtitle: const Text('buy-app-subtitle').tr(),
                    trailing: const Icon(Icons.arrow_right),
                    onTap: ()=> AppService().openLinkWithCustomTab(context, 'https://1.envato.market/quizhour'),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
