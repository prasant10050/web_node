// Copyright 2020 Gohilla Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:universal_html/html.dart' as html;

class DomTreeSerializer {
  final bool isIOS;

  const DomTreeSerializer({this.isIOS = false});

  /// Serializes any DOM node.
  ///
  /// If the node is a document node or `<html>` node, no changes are made.
  ///
  /// Otherwise the node is wrapped inside a document that is styled by calling
  /// [cssStyleDeclaration].
  String serialize({
    @required BuildContext context,
    @required html.Node node,
    Color backgroundColor,
  }) {
    // A document node?
    if (node is html.Document) {
      return node.documentElement.outerHtml;
    }

    // <html>...</html> element?
    if (node is html.HtmlHtmlElement) {
      return node.outerHtml;
    }

    // Wrap the node inside <body>:
    //     <html>
    //       <body>
    //         NODE
    //       </body>
    //     </html>
    final bodyElement = html.BodyElement();
    bodyElement.append(node);

    final htmlElement = html.HtmlHtmlElement();
    htmlElement.append(bodyElement);

    // Get CSS style
    final cssStyle = bodyElement.style;

    // Set background color
    if (backgroundColor != null) {
      cssStyle.backgroundColor = cssColor(backgroundColor);
    }

    // Transfer style
    cssStyleDeclaration(
      context: context,
      cssStyle: cssStyle,
    );

    return htmlElement.outerHtml;
  }

  /// Sets CSS properties based on Flutter style.
  void cssStyleDeclaration({
    @required BuildContext context,
    @required html.CssStyleDeclaration cssStyle,
  }) {
    // Use style information from DefaultTextStyle
    final defaultTextStyle =
        context.dependOnInheritedWidgetOfExactType<DefaultTextStyle>();
    if (defaultTextStyle != null) {
      final flutterStyle = defaultTextStyle.style;
      if (cssStyle.fontFamily == '') {
        cssStyle.fontFamily = flutterStyle.fontFamily;
      }
      if (cssStyle.fontSize == '') {
        cssStyle.fontSize = cssFontSize(flutterStyle.fontSize);
      }
      if (cssStyle.color == '') {
        cssStyle.color = cssColor(flutterStyle.color);
      }
    }

    // Use style information from Scaffold
    final scaffoldState = Scaffold.maybeOf(context);
    if (scaffoldState != null) {
      if (cssStyle.backgroundColor == '') {
        cssStyle.backgroundColor = cssColor(
          scaffoldState.widget.backgroundColor,
        );
      }
    }

    // Use style information from CupertinoTheme
    final cupertinoTheme = CupertinoTheme.of(context);
    {
      final textStyle = cupertinoTheme.textTheme?.textStyle;
      if (textStyle != null) {
        if (cssStyle.fontFamily == '') {
          cssStyle.fontFamily = textStyle.fontFamily;
        }
        if (cssStyle.fontSize == '') {
          cssStyle.fontSize = cssFontSize(textStyle.fontSize);
        }
        if (cssStyle.color == '') {
          cssStyle.color = cssColor(textStyle.color);
        }
      }
      if (cssStyle.backgroundColor == '') {
        cssStyle.backgroundColor = cssColor(
          cupertinoTheme.scaffoldBackgroundColor,
        );
      }
    }

    // Use style information from Theme
    final theme = Theme.of(context);
    {
      final bodyText = theme.textTheme?.bodyText2;
      if (bodyText != null) {
        if (cssStyle.fontFamily == '') {
          cssStyle.fontFamily = bodyText.fontFamily;
        }
        if (cssStyle.fontSize == '') {
          cssStyle.fontSize = cssFontSize(bodyText.fontSize);
        }
        if (cssStyle.color == '') {
          cssStyle.color = cssColor(bodyText.color);
        }
      }
      if (cssStyle.backgroundColor == '') {
        cssStyle.backgroundColor = cssColor(
          theme.scaffoldBackgroundColor,
        );
      }
    }
  }

  /// Flutter color --> CSS color
  String cssColor(Color color) {
    if (color == null) {
      return null;
    }
    return 'rgb(${color.red}, ${color.green}, ${color.blue})';
  }

  /// Flutter font size --> CSS font size
  String cssFontSize(double fontSize) {
    if (fontSize == null) {
      return null;
    }

    // A quick hack that seems to work
    if (isIOS) {
      fontSize *= 2;
    }

    return '${fontSize.round()}pt';
  }
}
