import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:quiz_app/utils/icon_utils.dart';
import '../configs/color_config.dart';
import '../configs/language_config.dart';

class LanguagePopup extends StatefulWidget {
  const LanguagePopup({Key? key}) : super(key: key);

  @override
  LanguagePopupState createState() => LanguagePopupState();
}

class LanguagePopupState extends State<LanguagePopup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.bgColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('select-language', style: TextStyle(color: Colors.white),).tr(),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: LanguageConfig.languages.length,
        itemBuilder: (BuildContext context, int index) {
          return _itemList(LanguageConfig.languages[index], index);
        },
      ),
    );
  }

  Widget _itemList(d, index) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                IconUtils.language1,
                size: 25,
                color: Theme.of(context).primaryColor,
              )),
          horizontalTitleGap: 10,
          title: Text(d,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500, color: Colors.grey.shade900, fontSize: 18)),
          onTap: () async {
            final languageCode = LanguageConfig.supportedLocals[index];
            final engine = WidgetsFlutterBinding.ensureInitialized();
            await context.setLocale(languageCode);
            await engine.performReassemble().then((value)=> Navigator.pop(context));
          },
        ),
        Divider(
          height: 15,
          indent: 20,
          color: Colors.grey[300],
        )
      ],
    );
  }
}
