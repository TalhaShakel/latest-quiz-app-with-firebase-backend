import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:quiz_app/widgets/video_player_widget.dart';

import '../services/app_service.dart';
import '../utils/image_preview.dart';
import '../utils/next_screen.dart';
import 'loading_widget.dart';

class HtmlBody extends StatelessWidget {
  const HtmlBody({
    Key? key,
    required this.description,
  }) : super(key: key);

  final String description;

  @override
  Widget build(BuildContext context) {
    final FontSize fontSize = FontSize.large;
    return Html(
      data: description,
      shrinkWrap: true,
      onLinkTap: (url, _, __) {
        AppService().openLinkWithCustomTab(context, url!);
      },
      style: {
        "body": Style(
          //padding: const EdgeInsets.all(20),
          padding: const EdgeInsets.only(top: 10, bottom: 60, left: 0, right: 0),
          margin: Margins.zero,
          lineHeight: const LineHeight(1.7),
          whiteSpace: WhiteSpace.normal,
          fontFamily: 'Open Sans',
          fontSize: fontSize,
          //color: Colors.grey.shade800,
          fontWeight: FontWeight.w500,
        ),
        "figure, video, div, img": Style(margin: Margins.zero, padding: EdgeInsets.zero),
        "p": Style(padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5)),
        "h1,h2,h3,h4,h5,h6": Style(padding: const EdgeInsets.only(left: 20, right: 20))
      },
      extensions: [
        TagExtension(
            tagsToExtend: {"iframe"},
            builder: (ExtensionContext eContext) {
              final String videoSource = eContext.attributes['src'].toString();
              if (videoSource.contains('youtu')) {
                return VideoPlayerWidget(videoUrl: videoSource, videoType: 'youtube');
              } else if (videoSource.contains('vimeo')) {
                return VideoPlayerWidget(videoUrl: videoSource, videoType: 'vimeo');
              }
              return Container();
            }),
        TagExtension(
            tagsToExtend: {"video"},
            builder: (ExtensionContext eContext) {
              final String videoSource = eContext.attributes['src'].toString();
              return VideoPlayerWidget(videoUrl: videoSource, videoType: 'network');
            }),
        TagExtension(
            tagsToExtend: {"img"},
            builder: (ExtensionContext eContext) {
              String imageUrl = eContext.attributes['src'].toString();
              return InkWell(
                  onTap: () => NextScreen.nextScreenNormal(context, FullImagePreview(imageUrl: imageUrl)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, url) => const LoadingIndicatorWidget(),
                  ));
            }),
      ],
    );
  }
}
