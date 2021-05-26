import 'dart:math';
import 'dart:ui' as ui;
import 'package:dart_board_theme/theme_feature.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:http/http.dart' as http;

// Show a Haiku and some code
class HaikuAndCode extends StatefulWidget {
  final String haiku;
  final String url;

  const HaikuAndCode({Key? key, required this.haiku, required this.url})
      : super(key: key);

  @override
  _HaikuAndCodeState createState() => _HaikuAndCodeState();
}

class _HaikuAndCodeState extends State<HaikuAndCode> {
  String fileContents = '';
  String lastLoaded = '';

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() {
    if (lastLoaded == widget.url) return;

    lastLoaded = widget.url;
    http
        .get(Uri.parse(widget.url))
        .then((value) => setState(() => fileContents = value.body));
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.scheduleFrameCallback((timeStamp) {
      //Trigger a data load (if necessary)
      loadData();
    });

    return LayoutBuilder(builder: (ctx, size) {
      final theme = Theme.of(context);
      final codeWidget;
      codeWidget = AnimatedContainer(
          width: size.maxWidth,
          height: fileContents.isEmpty ? 0 : size.maxHeight,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInExpo,
          child: fileContents.isNotEmpty
              ? Material(
                  elevation: 5,
                  child: SyntaxView(
                    fontSize: 14,
                    expanded: true,
                    withZoom: false,
                    code: fileContents,
                    syntax: Syntax.DART,
                    syntaxTheme: (ThemeFeature.isLight
                        ? SyntaxTheme.gravityLight()
                        : SyntaxTheme.gravityDark())
                      ..commentStyle = Theme.of(context)
                          .textTheme
                          .bodyText2
                          ?.copyWith(
                              fontWeight: FontWeight.bold,
                              shadows: [
                                BoxShadow(
                                    offset: Offset(2, 2),
                                    color: theme.colorScheme.primaryVariant,
                                    blurRadius: 4,
                                    spreadRadius: 2),
                                BoxShadow(
                                    offset: Offset(2, 2),
                                    color: theme.colorScheme.primary,
                                    blurRadius: 8,
                                    spreadRadius: 4)
                              ],
                              background: Paint()
                                ..shader = ui.Gradient.linear(
                                    Offset(0, 0), Offset(50, 0), [
                                  theme.colorScheme.primaryVariant,
                                  theme.colorScheme.secondary.withOpacity(0.2)
                                ])),
                  ))
              : Center(child: CircularProgressIndicator()));

      return Align(alignment: Alignment.center, child: codeWidget);
    });
  }
}
