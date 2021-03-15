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

  /// Flutter color --> CSS color
  String? cssColor(Color? color) {
    if (color == null) {
      return null;
    }
    return 'rgb(${color.red}, ${color.green}, ${color.blue})';
  }

  /// Flutter font size --> CSS font size
  String? cssFontSize(double? fontSize) {
    if (fontSize == null) {
      return null;
    }

    // A quick hack that seems to work
    if (isIOS) {
      fontSize *= 2;
    }

    return '${fontSize.round()}pt';
  }

  /// Sets CSS properties based on Flutter style.
  void cssFromBuildContext(
      html.CssStyleDeclaration cssStyle, BuildContext context) {
    // Use style information from DefaultTextStyle

    final defaultTextStyle =
        context.dependOnInheritedWidgetOfExactType<DefaultTextStyle>();
    if (defaultTextStyle != null) {
      cssFromTextStyle(cssStyle, defaultTextStyle.style);
    }

    // Use style information from Scaffold
    ScaffoldState? scaffoldState;
    try {
      scaffoldState = Scaffold.of(context);
    } catch (e) {
      // Ignore
    }
    if (scaffoldState != null) {
      if (cssStyle.backgroundColor == '') {
        cssStyle.backgroundColor = cssColor(
          scaffoldState.widget.backgroundColor,
        );
      }
    }

    // Use style information from CupertinoTheme
    final cupertinoThemeData = CupertinoTheme.of(context);
    if (!identical(cupertinoThemeData, const CupertinoThemeData())) {
      cssFromCupertinoThemeData(cssStyle, CupertinoTheme.of(context));
    }

    // Use style information from Theme
    cssFromThemeData(cssStyle, Theme.of(context));
  }

  void cssFromCupertinoThemeData(
      html.CssStyleDeclaration cssStyle, CupertinoThemeData theme) {
    final textStyle = theme.textTheme.textStyle;
    cssFromTextStyle(cssStyle, textStyle);
    if (cssStyle.backgroundColor == '') {
      cssStyle.backgroundColor = cssColor(
        theme.scaffoldBackgroundColor,
      );
    }
  }

  void cssFromTextStyle(
      html.CssStyleDeclaration cssStyle, TextStyle textStyle) {
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

  void cssFromThemeData(html.CssStyleDeclaration cssStyle, ThemeData theme) {
    final bodyText = theme.textTheme.bodyText2;
    if (bodyText != null) {
      cssFromTextStyle(cssStyle, bodyText);
    }
    if (cssStyle.backgroundColor == '') {
      cssStyle.backgroundColor = cssColor(
        theme.scaffoldBackgroundColor,
      );
    }
  }

  /// Serializes any DOM node.
  ///
  /// If the node is a document node or `<html>` node, no changes are made.
  ///
  /// Otherwise the node is wrapped inside a document that is styled by calling
  /// [cssFromBuildContext].
  String serialize({
    required BuildContext context,
    required html.Node node,
    Color? backgroundColor,
  }) {
    // A document node?
    if (node is html.Document) {
      return node.documentElement!.outerHtml!;
    }

    // <html>...</html> element?
    if (node is html.HtmlHtmlElement) {
      return node.outerHtml!;
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
    cssFromBuildContext(cssStyle, context);

    return htmlElement.outerHtml!;
  }
}
