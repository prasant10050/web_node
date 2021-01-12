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

import 'package:flutter/widgets.dart' hide Element;
import 'package:universal_html/html.dart' as html;
import 'package:universal_html/html.dart' show Node;
import 'package:web_node/web_node.dart';

import 'web_node_impl_not_browser.dart'
    if (dart.library.html) 'web_node_impl_browser.dart' as impl;

export 'web_node_impl_not_browser.dart'
    if (dart.library.html) 'web_node_impl_browser.dart' hide WebNodeState;

/// A widget for rendering any _dart:html_ [Node].
///
/// # Behavior
/// ## In browsers
///   * Uses real DOM nodes.
///   * You can study the source code:
///     * [web_node_impl_browser.dart](https://github.com/dint-dev/web_node/blob/master/lib/src/web_node_impl_browser.dart)
///
/// ### In Android and iOS
///   * Serializes the DOM tree to HTML source code. Passes some of the
///     surrounding style (background color, font family, etc.) DOM tree.
///   * Uses [webview_flutter](https://pub.dev/packages/webview_flutter), a
///     package maintained by Google, for showing the serialized DOM tree.
///   * You can study the source code:
///     * [dom_tree_serializer.dart](https://github.com/dint-dev/web_node/blob/master/lib/src/dom_tree_serializer.dart)
///     * [web_node_impl_not_browser.dart](https://github.com/dint-dev/web_node/blob/master/lib/src/web_node_impl_not_browser.dart)
///
/// ## Example
/// ```
/// import 'package:universal_html/html.dart';
/// import 'package:web_node/web_node.dart';
///
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     final iframe = IFrameElement();
///     iframe.src = 'https://dart.dev/';
///     return WebNode(node: iframe);
///   }
/// }
/// ```
class WebNode extends StatefulWidget {
  /// Rendered DOM node.
  final html.Node node;

  /// Optional background color.
  final Color backgroundColor;

  /// Optional DOM tree serializer.
  final DomTreeSerializer domTreeSerializer;

  /// Optional user agent string.
  final String userAgent;

  /// Enables/disables gesture navigation in non-browser platforms.
  /// Default is true.
  final bool gestureNavigationEnabled;

  final void Function(WebResourceError error) onWebResourceError;

  const WebNode({
    @required this.node,
    Key key,
    this.backgroundColor,
    this.domTreeSerializer,
    this.userAgent,
    this.gestureNavigationEnabled = true,
    this.onWebResourceError,
  })  : assert(node != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return impl.WebNodeState();
  }
}
